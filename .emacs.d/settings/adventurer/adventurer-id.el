(defun adventurer/id/regex ()
  "\\([a-z]\\{2\\}[0-9]\\{4\\}\\)-\\([0-9]\\{10\\}\\)")

(defun adventurer/id/exact-regex ()
  (format "\\`%s\\'" (adventurer/id/regex)))

(defun adventurer/id/filename-prefix-regex ()
  (format "\\`%s\\(?:-\\|\\'\\)" (adventurer/id/regex)))

(defun adventurer/id/fallback-prefix () "aa0000")

(defun adventurer/id/max-suffix () 9999999999)

(defun adventurer/id/parse (id-string)
  ;; case-fold-search defaults to t, which would let an uppercase prefix through
  (let ((case-fold-search nil))
    (when (and id-string (string-match (adventurer/id/exact-regex) id-string))
      `((prefix . ,(match-string 1 id-string))
        (suffix . ,(string-to-number (match-string 2 id-string)))))))

(defun adventurer/id/parse-filename (file-base-name)
  (let ((case-fold-search nil))
    (when (and file-base-name (string-match (adventurer/id/filename-prefix-regex) file-base-name))
      `((prefix . ,(match-string 1 file-base-name))
        (suffix . ,(string-to-number (match-string 2 file-base-name)))))))

(defun adventurer/id/from-path (path)
  (when-let* ((parsed (and path (adventurer/id/parse-filename (file-name-base path)))))
    (adventurer/id/compose (alist-get 'prefix parsed) (alist-get 'suffix parsed))))

(defun adventurer/id/placement-token (game-id)
  ;; a game_id is <token id>-<suffix>; only the prefix is parsed
  (when-let* ((parsed (adventurer/id/parse-filename game-id)))
    (adventurer/id/compose (alist-get 'prefix parsed) (alist-get 'suffix parsed))))

(defun adventurer/id/buffer-prefix ()
  (let ((file-name (buffer-file-name)))
    (or (when (and file-name (equal (file-name-extension file-name) "org"))
          (alist-get 'prefix (adventurer/id/parse-filename (file-name-base file-name))))
        (adventurer/id/fallback-prefix))))

(defun adventurer/id/prefixed-regex (prefix)
  ;; the trailing guard keeps an over-long run of digits from reading as an ID
  (format "\\_<%s-\\([0-9]\\{10\\}\\)\\(?:[^0-9]\\|$\\)" (regexp-quote prefix)))

(defun adventurer/id/document-suffixes (prefix)
  ;; every entity number in the buffer text, not only the ones in :ID: properties:
  ;; an asset filename carries an ID too, and minting must clear it
  (let ((case-fold-search nil)
        (regex (adventurer/id/prefixed-regex prefix))
        (suffixes ())
        (position 0)
        (text (buffer-substring-no-properties (point-min) (point-max))))
    (while (string-match regex text position)
      (push (string-to-number (match-string 1 text)) suffixes)
      (setq position (match-end 0)))
    suffixes))

(defun adventurer/id/next-suffix (prefix)
  (let* ((suffixes (adventurer/id/document-suffixes prefix))
         (next-suffix (if suffixes (1+ (apply #'max suffixes)) 1)))
    (when (> next-suffix (adventurer/id/max-suffix))
      (error "Document has exhausted the ten-digit ID sequence for prefix %s" prefix))
    next-suffix))

(defun adventurer/id/compose (prefix suffix)
  (format "%s-%010d" prefix suffix))

(defun adventurer/id ()
  "Inserts a new document-scoped entity ID at point"
  (interactive)
  (let ((prefix (adventurer/id/buffer-prefix)))
    (insert (adventurer/id/compose prefix (adventurer/id/next-suffix prefix)))))
