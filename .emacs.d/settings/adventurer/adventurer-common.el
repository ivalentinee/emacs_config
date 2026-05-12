(setq adventurer/script-path (file-name-directory load-file-name))

(defun adventurer/ignore-shell-output () ">/dev/null 2>&1")

(defun adventurer/build-path () "build")

(defun adventurer/make-build-path ()
  (mkdir (string-join `("./" ,(adventurer/build-path))) t))

(defun adventurer/remove-build-path ()
  (let ((path (string-join `("./" ,(adventurer/build-path)))))
    (when (file-directory-p path)
      (delete-directory path t))))

(defun adventurer/compose-filename (extension &optional suffix)
  (let* ((base-file-name (if (buffer-file-name) (file-name-nondirectory (buffer-file-name)) (buffer-name)))
         (name-without-ext (file-name-sans-extension base-file-name))
         (full-name (if suffix (concat name-without-ext suffix) name-without-ext))
         (filename (file-name-with-extension full-name extension)))
    (string-join `(,(adventurer/build-path) ,filename) "/")))

(defun adventurer/get-script-path ()
  adventurer/script-path)

(defun adventurer/replace-in-region (regexp replacement)
  (when (region-active-p)
    (save-excursion
      (replace-regexp-in-region regexp replacement (region-beginning) (region-end)))))

(defun adventurer/convert-place-tokens ()
  (interactive)
  (adventurer/replace-in-region "place_tokens = \\[\n" "")
  (adventurer/replace-in-region "\n\\]$" "")
  (adventurer/replace-in-region " +{ name = \"\\([^\"]+\\)\", x = \\([0-9]+\\), y = \\([0-9]+\\), state = \"\\([^\"]+\\)\", subpixel = \\([0-9]+\\) }" "[[\\1 | \\4 | point | \\2 | \\3 | \\5][\\1]]")
  (adventurer/replace-in-region " +{ name = \"\\([^\"]+\\)\", x = \\([0-9]+\\), y = \\([0-9]+\\), state = \"\\([^\"]+\\)\" }" "[[\\1 | \\4 | point | \\2 | \\3][\\1]]")
  (adventurer/replace-in-region ",\n" " "))
