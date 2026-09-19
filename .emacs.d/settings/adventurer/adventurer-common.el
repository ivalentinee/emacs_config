(setq adventurer/script-path (file-name-directory load-file-name))

(defun adventurer/present-string-p (value)
  (and (stringp value) (not (string-empty-p value))))

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

(defun adventurer/replace-matches-in-region (regexp function)
  (when (region-active-p)
    (save-excursion
      (let ((end (copy-marker (region-end))))
        (goto-char (region-beginning))
        (while (re-search-forward regexp end t)
          ;; FUNCTION searches strings of its own, which clobbers the match data
          ;; this replace-match depends on — so compute first, replace after
          (let ((replacement (save-match-data (funcall function (match-string 1)))))
            (replace-match replacement t t)))))))

(defun adventurer/split-toml-fields (body)
  "Splits BODY on the commas that sit outside double quotes."
  (let ((fields ()) (start 0) (index 0) (quoted nil))
    (while (< index (length body))
      (let ((character (aref body index)))
        (cond ((and quoted (eq character ?\\)) (setq index (1+ index)))
              ((eq character ?\") (setq quoted (not quoted)))
              ((and (eq character ?,) (not quoted))
               (push (substring body start index) fields)
               (setq start (1+ index)))))
      (setq index (1+ index)))
    (push (substring body start) fields)
    (mapcar 'string-trim (nreverse fields))))

(defun adventurer/parse-toml-field (field)
  "\"key = value\" -> (\"key\" . \"value\"), surrounding quotes removed.
An escaped quote inside a value survives as itself."
  (when (string-match "\\`\\([a-z_][a-z0-9_]*\\) *= *\\(.*\\)\\'" field)
    (let ((key (match-string 1 field))
          (value (string-trim (match-string 2 field))))
      (cons key (if (string-match "\\`\"\\(.*\\)\"\\'" value)
                    (string-replace "\\\"" "\"" (match-string 1 value))
                  value)))))

(defun adventurer/place-token-link (body)
  "Builds the org link for one exported place_tokens entry.
Four slots are positional and the name is the caption; every other field
becomes a tagged slot, so a field this code has never heard of still arrives.
The game_id travels whole — the build keeps a suffix it is given."
  (let* ((fields (remq nil (mapcar 'adventurer/parse-toml-field
                                   (adventurer/split-toml-fields body))))
         (named (lambda (key) (cdr (assoc key fields))))
         (positional '("game_id" "state" "x" "y" "name"))
         (tagged (seq-remove (lambda (field) (member (car field) positional)) fields))
         (slots (append (list (or (funcall named "game_id") "")
                              (or (funcall named "state") "")
                              (or (funcall named "x") "")
                              (or (funcall named "y") ""))
                        (mapcar (lambda (field) (format "%s: %s" (car field) (cdr field))) tagged))))
    (format "[[%s][%s]]" (string-join slots " | ") (or (funcall named "name") ""))))

(defun adventurer/convert-place-tokens ()
  "Converts a PathMapper place_tokens export in the region into org links."
  (interactive)
  (adventurer/replace-in-region "place_tokens = \\[\n" "")
  (adventurer/replace-in-region "\n\\]$" "")
  (adventurer/replace-matches-in-region "^ *{ \\(.*\\) }" 'adventurer/place-token-link)
  (adventurer/replace-in-region ",\n" " "))
