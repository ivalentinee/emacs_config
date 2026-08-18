(load "adventurer-wiki-macro-lists")

(defun adventurer/wiki/macro-apply (denote-files settings filename)
  "Macro-replaces custom wiki tags"
  (adventurer/wiki/macro-apply-lists denote-files settings)
  (adventurer/wiki/macro-apply-secret-headings filename)
  (adventurer/wiki/macro-apply-back-link denote-files filename))

(defun adventurer/wiki/macro-apply-secret-headings (filename)
  "Prefix all first-level headings with [тайна] if the file has the \"secret\" denote tag."
  (when (adventurer/wiki/is-a-secret-denote-file filename)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^\\* " nil t)
        (replace-match "* [тайна] " t t)))))

(defun adventurer/wiki/macro-apply-back-link (denote-files filename)
  "Insert a back link before the first heading. Wiki-tagged pages link to index, other pages link to wiki."
  (let* ((is-index (string-equal (denote-retrieve-filename-title filename) "index"))
         (is-wiki (seq-find
                   #'(lambda (kw) (string-equal kw "wiki"))
                   (denote-extract-keywords-from-path filename)))
         (target-title (if is-wiki "index" "wiki"))
         (target-file (seq-find
                       #'(lambda (f)
                           (string-equal (denote-retrieve-filename-title f) target-title))
                       denote-files))
         (target-id (when target-file
                      (denote-retrieve-filename-identifier target-file))))
    (when (and target-id (not is-index))
      (save-excursion
        (goto-char (point-min))
        (while (looking-at "^#\\+")
          (forward-line 1))
        (insert (format "[[denote:%s][←]]\n\n" target-id))))))
