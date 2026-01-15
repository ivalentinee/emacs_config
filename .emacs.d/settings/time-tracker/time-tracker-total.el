(load "time-tracker-time")

(defun time-tracker/update-entry-total ()
  "Update time-tracker entry total"
  (if (time-tracker/is-work-entry)
      (let ((time-diff (time-tracker/time-range-diff (org-entry-get nil "TIME"))))
        (org-set-property "TOTAL" (time-tracker/format-time time-diff))
        (org-set-property "TOTAL-JIRA" (time-tracker/format-time-jira time-diff))
        (message (format "Time updated: %s (%s)" (time-tracker/format-time time-diff) (org-get-heading t t t t))))))

(defun time-tracker/update-day-total ()
  "Update each time-tracker entry total for day"
  (when (time-tracker/is-day-entry)
    (org-map-entries 'time-tracker/update-entry-total nil 'tree)
    (message (format "Time updated: %s" (org-get-heading t t t t)))))

(defun time-tracker/update-week-total ()
  "Update each time-tracker entry total for day"
  (when (time-tracker/is-week-entry)
    (org-map-entries 'time-tracker/update-entry-total nil 'tree)
    (message (format "Time updated: %s" (org-get-heading t t t t)))))

(defun time-tracker/update-total ()
  "Update time-tracker total"
  (interactive)
  (cond ((time-tracker/is-work-entry) (time-tracker/update-entry-total))
        ((time-tracker/is-day-entry) (time-tracker/update-day-total))
        ((time-tracker/is-week-entry) (time-tracker/update-week-total))))
