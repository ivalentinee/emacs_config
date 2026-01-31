(defun time-tracker/line-is-empty ()
  (save-excursion
    (beginning-of-line)
    (looking-at-p "[[:blank:]]*$")))

(defun time-tracker/insert-current-date ()
  "Insert the current date as an inactive Org mode timestamp."
  (interactive)
  (insert (format-time-string "<%Y-%m-%d %a>")))

(defun time-tracker/insert-today ()
  "Insert time-tracker entry for current day at the end of file"
  (interactive)
  (end-of-buffer)
  (if (not (time-tracker/line-is-empty)) (insert "\n"))
  (insert "** ")
  (time-tracker/insert-current-date))

(defun time-tracker/insert-entry ()
  "Insert time-tracker entry"
  (interactive)
  (if (not (time-tracker/line-is-empty)) (insert "\n"))
  (insert "*** ")
  (org-set-property "TIME" (format "%s-%s" (format-time-string "%H:%m") (format-time-string "%H:%m")))
  (org-set-property "ZONE" (format-time-string "%:z" (current-time) nil))
  (org-set-property "ID" "NONE")
  (org-set-property "TRACK-ID" "NONE")
  (org-set-property "TYPE" "TASK"))

(defun time-tracker/copy-entry ()
  "Copy current entry"
  (interactive)
  (let ((title (org-get-heading t t t t)))
    (message (format "Entry copied: %s" title))
    (org-copy-subtree)))
