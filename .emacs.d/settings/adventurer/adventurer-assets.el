(load "adventurer-common")
(load "adventurer-id")

(defun adventurer/assets/document-directory ()
  (if (buffer-file-name) (file-name-directory (buffer-file-name)) default-directory))

(defun adventurer/assets/local-directory ()
  (expand-file-name "assets" (adventurer/assets/document-directory)))

(defun adventurer/assets/library-directory ()
  ;; #+LIBRARY:, resolved against the document, nil when the document declares none
  (when-let* ((property (org-collect-keywords '("LIBRARY")))
              (value (cadar property)))
    (when (adventurer/present-string-p value)
      (expand-file-name (string-trim value) (adventurer/assets/document-directory)))))

(defun adventurer/assets/files-under (directory id)
  ;; every file below DIRECTORY whose name begins with ID, to any depth
  (when (and directory (file-directory-p directory))
    (directory-files-recursively directory (format "\\`%s" (regexp-quote id)))))

(defun adventurer/assets/files (id)
  ;; the document's own assets answer first; the library is read only if they do not
  (when (adventurer/present-string-p id)
    (or (adventurer/assets/files-under (adventurer/assets/local-directory) id)
        (adventurer/assets/files-under (adventurer/assets/library-directory) id))))

(defun adventurer/assets/problem (id)
  ;; -> a description of why ID names no single asset, or nil
  (let* ((files (adventurer/assets/files id))
         (names (seq-uniq (mapcar 'file-name-base files))))
    (cond ((null files) (format "no file carries the id %s" id))
          ((length> names 1)
           (format "the id %s is carried by %d assets: %s"
                   id (length names) (string-join (sort names 'string<) ", "))))))

(defun adventurer/assets/asset (id)
  ;; every file of the one asset ID names; nil where it names none or several
  (unless (adventurer/assets/problem id)
    (adventurer/assets/files id)))

(defun adventurer/assets/packed-extensions (kind)
  (if (eq kind 'map) '("ora") '("png" "webp" "jpg" "jpeg")))

(defun adventurer/assets/with-extension (files extension)
  (seq-find (lambda (file) (equal (file-name-extension file) extension)) files))

(defun adventurer/assets/packed-file (files kind)
  ;; the one file of an asset that the package carries
  (seq-some (lambda (extension) (adventurer/assets/with-extension files extension))
            (adventurer/assets/packed-extensions kind)))

(defun adventurer/assets/packed-path (file)
  (concat "assets/" (file-name-nondirectory file)))

(defun adventurer/assets/document-local-p (file)
  (string-prefix-p (expand-file-name (adventurer/assets/document-directory))
                   (expand-file-name file)))

(defun adventurer/assets/document-relative (file)
  (file-relative-name file (adventurer/assets/document-directory)))

(defun adventurer/assets/local-files (files)
  ;; what a source archive carries: the document's own, named as it names them
  (mapcar 'adventurer/assets/document-relative
          (seq-filter 'adventurer/assets/document-local-p (remq nil files))))

(defun adventurer/assets/stage (files directory)
  ;; a flat assets/ directory to zip from: zip stores an out-of-tree path
  ;; verbatim, and unzip then drops the "../" and lands the file elsewhere
  (let ((staged (expand-file-name "assets" directory)))
    (when (file-directory-p directory) (delete-directory directory t))
    (make-directory staged t)
    (dolist (file files)
      (copy-file file (expand-file-name (file-name-nondirectory file) staged) t))
    staged))
