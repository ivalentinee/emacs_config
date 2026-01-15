(defun time-tracker/is-work-entry ()
  "Returns true if time tracker entry is a work entry"
  (let ((entry-time (org-entry-get nil "TIME")))
    (not (not entry-time))))

(defun time-tracker/is-day-entry ()
  "Returns true if time tracker entry is a day entry"
  (let ((title (org-get-heading t t t t)))
    (and
     (not (time-tracker/is-week-entry))
     (string-match "\\<[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}" (or title "")))))

(defun time-tracker/is-week-entry ()
  "Returns true if time tracker entry is a week entry"
  (let ((title (org-get-heading t t t t)))
    (string-match "Week [0-9]+" (or title ""))))
