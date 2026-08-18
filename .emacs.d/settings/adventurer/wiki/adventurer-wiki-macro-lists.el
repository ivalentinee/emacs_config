(defun adventurer/wiki/macro-apply-lists (denote-files settings)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "#\\+adventurer-wiki-list: \\(.+\\)$" nil t)
      (let* ((keyword (match-string 1))
             (denote-keyword-files (save-match-data (adventurer/wiki/get-denote-files-by-keyword denote-files keyword)))
             (org-list (adventurer/wiki/denote-files-to-org-list denote-keyword-files)))
        (replace-match org-list t t)))))

(defun adventurer/wiki/get-denote-files-by-keyword (denote-files keyword)
  (seq-filter
   #'(lambda (filename)
       (seq-find
        #'(lambda (item-keyword) (string-equal item-keyword keyword))
        (denote-extract-keywords-from-path filename)))
   denote-files))

(defun adventurer/wiki/get-public-denote-files (denote-files)
  (seq-filter
   #'(lambda (filename) (not (adventurer/wiki/is-a-secret-denote-file filename)))
   denote-files))

(defun adventurer/wiki/get-secret-denote-files (denote-files)
  (seq-filter 'adventurer/wiki/is-a-secret-denote-file denote-files))

(defun adventurer/wiki/is-a-secret-denote-file (filename)
  (seq-find
   #'(lambda (item-keyword) (string-equal item-keyword "secret"))
   (denote-extract-keywords-from-path filename)))

(defun adventurer/wiki/denote-files-to-org-list (denote-files)
  (let ((public-files (save-match-data (adventurer/wiki/get-public-denote-files denote-files)))
        (secret-files (save-match-data (adventurer/wiki/get-secret-denote-files denote-files)))
        (outline-level (save-match-data (org-outline-level))))
    (concat
     (mapconcat 'adventurer/wiki/denote-file-to-org-list-item public-files "\n")
     (when (not (null secret-files)) (adventurer/wiki/build-subtitle outline-level "Информация для мастера" t))
     (when (not (null secret-files)) (mapconcat 'adventurer/wiki/denote-file-to-org-list-item secret-files "\n")))))

(defun adventurer/wiki/denote-file-to-org-list-item (filename)
  (let* ((file-type (denote-filetype-heuristics filename))
         (full-title (save-match-data (denote-retrieve-front-matter-title-value filename file-type)))
         (id (save-match-data (denote-retrieve-filename-identifier filename))))
    (format "- [[denote:%s][%s]]" id full-title)))

(defun adventurer/wiki/build-subtitle (outline-level text &optional secret)
  (let* ((outline-sublevel (+ outline-level 1))
         (outline-prefix (make-string outline-sublevel ?*))
         (title (if secret (format "[тайна] %s" text) text)))
    (concat "\n" outline-prefix " " title "\n")))
