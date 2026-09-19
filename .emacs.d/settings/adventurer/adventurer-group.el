(load "adventurer-common")
(load "adventurer-collect")
(load "adventurer-assets")
(load "adventurer-validate")

(defun adventurer/group/build-character ()
  (if (equal (org-outline-level) 2)
      (let* ((token-link (org-entry-get nil "TOKEN"))
             (token (when token-link (alist-get 'url (adventurer/parse-link token-link))))
             (extra-string (org-entry-get nil "EXTRA"))
             (extra-links (when extra-string (adventurer/collect-links extra-string)))
             (extra (mapcar 'adventurer/parse-link extra-links))
             (source-files-string (org-entry-get nil "SOURCE_FILES"))
             (source-files-links (when source-files-string (adventurer/collect-links source-files-string)))
             (source-files (mapcar (lambda (l) (alist-get 'url (adventurer/parse-link l))) source-files-links)))
        `((id . ,(org-entry-get nil "ID"))
          (name . ,(org-get-heading t t t t))
          (todo . ,(equal (nth 2 (org-heading-components)) "TODO"))
          (class . ,(org-entry-get nil "CLASS"))
          (player . ,(org-entry-get nil "PLAYER"))
          (color . ,(org-entry-get nil "COLOR"))
          (charkeeper-id . ,(org-entry-get nil "CHARKEEPER_ID"))
          (token . ,token)
          (extra . ,extra)
          (source-files . ,source-files)))
    nil))

(defun adventurer/group/map-characters (function)
  (save-excursion
    (beginning-of-buffer)
    (search-forward ":ID: characters")
    (seq-filter (lambda (entry) entry) (org-map-entries function nil 'tree))))

(defun adventurer/group/collect-character-data ()
  (adventurer/group/map-characters 'adventurer/group/build-character))

(defun adventurer/group/token-file (id)
  (adventurer/assets/packed-file (adventurer/assets/asset id) 'token))

(defun adventurer/group/token-path (id)
  (adventurer/assets/packed-path (adventurer/group/token-file id)))

(defun adventurer/group/render-extra-token (extra-token)
  (format "    { image = \"%s\", name = \"%s\" }"
          (adventurer/group/token-path (alist-get 'url extra-token))
          (alist-get 'name extra-token)))

(defun adventurer/group/render-extra-tokens (extra)
  (if (length> extra 0)
      (format "extra_tokens = [\n%s\n]"
              (string-join (mapcar 'adventurer/group/render-extra-token extra) ",\n"))
    "extra_tokens = []"))

(defun adventurer/group/render-character (character)
  (let* ((charkeeper-id (alist-get 'charkeeper-id character))
         (lines (seq-filter 'identity
                  (list "[[players]]"
                        (format "id = \"%s\"" (alist-get 'id character))
                        (format "character_name = \"%s\"" (alist-get 'name character))
                        (format "class = \"%s\"" (alist-get 'class character))
                        (format "player_name = \"%s\"" (alist-get 'player character))
                        (format "color = \"%s\"" (alist-get 'color character))
                        (format "token = \"%s\"" (adventurer/group/token-path
                                                  (alist-get 'token character)))
                        (when charkeeper-id (format "charkeeper_id = \"%s\"" charkeeper-id))
                        (adventurer/group/render-extra-tokens (alist-get 'extra character))))))
    (string-join lines "\n")))

(defun adventurer/group/render-header ()
  (let* ((title (org-get-title))
         (charkeeper-id-prop (org-collect-keywords '("CHARKEEPER_ID")))
         (charkeeper-id (when charkeeper-id-prop (cadar charkeeper-id-prop)))
         (lines (seq-filter 'identity
                  (list (format "title = \"%s\"" title)
                        (when charkeeper-id (format "charkeeper_id = \"%s\"" charkeeper-id))))))
    (string-join lines "\n")))

(defun adventurer/group/collect-character-files (character)
  ;; the one file per token the package carries
  (mapcar 'adventurer/group/token-file
          (cons (alist-get 'token character)
                (mapcar (lambda (extra-token) (alist-get 'url extra-token))
                        (alist-get 'extra character)))))

(defun adventurer/group/collect-files (characters)
  (let ((files (flatten-tree (mapcar 'adventurer/group/collect-character-files characters))))
    (seq-uniq (seq-filter 'identity files))))

(defun adventurer/group/collect-character-source-files (character)
  ;; every file of every token, plus :SOURCE_FILES: as the paths they are
  (append (flatten-tree
           (mapcar 'adventurer/assets/asset
                   (cons (alist-get 'token character)
                         (mapcar (lambda (extra-token) (alist-get 'url extra-token))
                                 (alist-get 'extra character)))))
          (alist-get 'source-files character)))

(defun adventurer/group/collect-all-source-files (characters)
  (let ((files (flatten-tree (mapcar 'adventurer/group/collect-character-source-files characters))))
    (seq-uniq (seq-filter 'identity files))))

(defun adventurer/group/build-pack (files)
  (let* ((staging (expand-file-name "package" (adventurer/build-path)))
         (output-filename (expand-file-name (adventurer/compose-filename "pmgroup"))))
    (adventurer/assets/stage (seq-filter 'file-exists-p (remq nil files)) staging)
    (copy-file (adventurer/compose-filename "toml")
               (expand-file-name "manifest.toml" staging) t)
    (when (file-exists-p output-filename)
      (delete-file output-filename))
    (shell-command (format "cd \"%s\" && /usr/bin/zip -r \"%s\" assets manifest.toml %s"
                           staging output-filename (adventurer/ignore-shell-output)))
    (delete-directory staging t)))

(defun adventurer/group/build ()
  "Builds group .org buffer into manifest + zip"
  (interactive)
  (unless (eq major-mode 'org-mode)
    (error "Not an org-mode buffer"))
  (let* ((characters (adventurer/group/collect-character-data))
         (non-todo (seq-remove 'adventurer/todo-entry-p characters))
         (header (adventurer/group/render-header))
         (rendered-chars (mapcar 'adventurer/group/render-character non-todo))
         (output (string-join (cons header rendered-chars) "\n\n"))
         (files (adventurer/group/collect-files non-todo)))
    (adventurer/validate/group characters)
    (adventurer/make-build-path)
    (write-region output nil (adventurer/compose-filename "toml"))
    (adventurer/group/build-pack files)))

(defun adventurer/group/clear ()
  "Removes group-built files"
  (interactive)
  (unless (eq major-mode 'org-mode)
    (error "Not an org-mode buffer"))
  (when (file-exists-p (adventurer/compose-filename "toml"))
    (delete-file (adventurer/compose-filename "toml")))
  (when (file-exists-p "manifest.toml")
    (delete-file "manifest.toml"))
  (when (file-exists-p (adventurer/compose-filename "pmgroup"))
    (delete-file (adventurer/compose-filename "pmgroup")))
  (adventurer/remove-build-path))

(defun adventurer/group/pack ()
  "Packs group source files (.org + assets + source files) into a zip archive"
  (interactive)
  (unless (eq major-mode 'org-mode)
    (error "Not an org-mode buffer"))
  (let* ((characters (adventurer/group/collect-character-data))
         (org-file (file-name-nondirectory (buffer-file-name)))
         (asset-files (adventurer/assets/local-files
                       (adventurer/group/collect-all-source-files characters)))
         (all-files (cons org-file asset-files))
         (unique-files (seq-uniq (seq-filter #'file-exists-p all-files)))
         (output-filename (adventurer/compose-filename "src.zip"))
         (file-list (string-join (mapcar (lambda (f) (format "\"%s\"" f)) unique-files) " ")))
    (adventurer/make-build-path)
    (when (file-exists-p output-filename)
      (delete-file output-filename))
    (shell-command (format "/usr/bin/zip \"%s\" %s %s" output-filename file-list (adventurer/ignore-shell-output)))
    (message "Packed %d files into %s" (length unique-files) output-filename)))
