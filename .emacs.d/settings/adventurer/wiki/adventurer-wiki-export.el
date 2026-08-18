(require 'denote)
(load "adventurer-wiki-index")
(load "adventurer-wiki-html")

(defun adventurer/wiki/export ()
  "Exports TTRPG wiki web pages from denote files"
  (interactive)
  (let* ((denote-files (denote-directory-files))
         (settings (adventurer/wiki/get-settings denote-files))
         (exported-files (adventurer/wiki/get-exported-files denote-files settings)))
    (delete-directory (adventurer/wiki/output-path settings) t)
    (make-directory (adventurer/wiki/output-path settings))
    (adventurer/wiki/write-css settings)
    (adventurer/wiki/export-files denote-files settings exported-files)
    (adventurer/wiki/run-upload-cmd settings)))

(defun adventurer/wiki/output-path (settings &optional filename)
  (let* ((output-path (adventurer/wiki/get-settings-item settings "OUTPUT-PATH"))
         (output-dir (file-name-concat denote-directory output-path)))
    (if filename
        (file-name-concat output-dir filename)
      output-dir)))

(defun adventurer/wiki/run-upload-cmd (settings)
  "Run UPLOAD-CMD setting as a shell command in the output directory, if present."
  (let ((upload-cmd (adventurer/wiki/get-settings-item settings "UPLOAD-CMD")))
    (when upload-cmd
      (let ((default-directory (adventurer/wiki/output-path settings)))
        (shell-command upload-cmd)))))

(defun adventurer/wiki/export-files (denote-files settings exported-files)
  (seq-map #'(lambda (exported-file)
               (let* ((denote-filename-out (concat (denote-retrieve-filename-title exported-file) ".html"))
                      (filename-out (adventurer/wiki/output-path settings denote-filename-out)))
                 (adventurer/wiki/export-to-html denote-files settings exported-file filename-out)))
           exported-files))

(defun adventurer/wiki/get-exported-files (denote-files settings)
  "Gets TTRPG wiki files to export"
  (let* ((excluded-tags-value (adventurer/wiki/get-settings-item settings "EXCLUDE-TAGS"))
         (excluded-tags (split-string excluded-tags-value ":" t)))
    (seq-filter
     #'(lambda (filename) (not (seq-set-equal-p (denote-extract-keywords-from-path filename) excluded-tags)))
     denote-files)))
