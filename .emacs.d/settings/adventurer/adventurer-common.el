(setq adventurer/script-path (file-name-directory load-file-name))

(defun adventurer/ignore-shell-output () ">/dev/null 2>&1")

(defun adventurer/build-path () "build")

(defun adventurer/make-build-path ()
  (mkdir (string-join `("./" ,(adventurer/build-path))) t))

(defun adventurer/remove-build-path ()
  (delete-directory (string-join `("./" ,(adventurer/build-path)))))

(defun adventurer/compose-filename (extension)
  (let* ((base-file-name (or (file-name-nondirectory (buffer-file-name)) (buffer-name)))
         (filename (file-name-with-extension base-file-name extension)))
    (string-join `(,(adventurer/build-path) ,filename) "/")))

(defun adventurer/get-script-path ()
  adventurer/script-path)
