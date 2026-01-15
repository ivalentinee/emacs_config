(load "time-tracker-common")

(defun time-tracker/goto-day-entry ()
  "Moves cursor to day entry for the current element"
  (let ((title (org-get-heading t t t t)))
    (if (time-tracker/is-day-entry)
        (message (format "Moved to %s" title))
      (progn (org-up-element) (time-tracker/goto-day-entry)))))

(defun time-tracker/build-jira-report-entry ()
  (list (org-entry-get nil "TIME")
        (org-entry-get nil "TRACK-ID")
        (org-entry-get nil "TOTAL-JIRA")
        (org-entry-get nil "TOTAL")
        (string-trim (org-get-heading t t t t))
        (org-entry-get nil "NO-REPORT")))

(defun time-tracker/collect-jira-day-report-entries ()
  (save-excursion
    (time-tracker/goto-day-entry)
    (cons (org-get-heading t t t t) (cdr (org-map-entries 'time-tracker/build-jira-report-entry nil 'tree)))))

(defun time-tracker/collect-jira-week-report-entries ()
  (save-excursion
    (seq-filter (lambda (item) item)
                (cdr (org-map-entries
                      (lambda () (when (time-tracker/is-day-entry) (time-tracker/collect-jira-day-report-entries))) nil 'tree)))))
