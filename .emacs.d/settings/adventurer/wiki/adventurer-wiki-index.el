(defun adventurer/wiki/get-settings (denote-files)
  "Gets TTRPG wiki export settings"
  (let* ((wiki-files (adventurer/wiki/get-index-wiki-files denote-files))
         (index-file (adventurer/wiki/get-wiki-index wiki-files)))
    (with-temp-buffer
      (insert-file-contents index-file)
      (org-collect-keywords '("OUTPUT-PATH" "HTML-PATH" "EXCLUDE-TAGS" "UPLOAD-CMD")))))

(defun adventurer/wiki/get-index-wiki-files (denote-files)
  "Gets TTRPG wiki files"
  (seq-filter
   #'(lambda (filename)
       (seq-find
        #'(lambda (keyword) (string-equal keyword "wiki"))
        (denote-extract-keywords-from-path filename)))
   denote-files))

(defun adventurer/wiki/get-wiki-index (wiki-files)
  "Gets TTRPG setting wiki index file"
  (seq-find
   #'(lambda (filename)
       (string-equal (denote-retrieve-filename-title filename) "index"))
   denote-files))

(defun adventurer/wiki/get-settings-item (export-settings key)
  (car (alist-get key export-settings nil nil 'string-equal)))
