(load "time-tracker-common")
(load "time-tracker-time")
(load "time-tracker-jira")

(defun time-tracker/goto-day-entry ()
  "Moves cursor to day entry for the current element"
  (let ((title (org-get-heading t t t t)))
    (if (time-tracker/is-day-entry)
        (message (format "Moved to %s" title))
      (progn (org-up-element) (time-tracker/goto-day-entry)))))

(defun time-tracker/get-jira-day-report-entry-start-time ()
  (let ((time (org-entry-get nil "TIME"))
        (day-entry-time-regex "\\([0-9]+\\:[0-9]+\\)-\\([0-9]+\\:[0-9]+\\)"))
    (if (and time (string-match day-entry-time-regex time))
        (match-string 1 time)
      nil)))

(defun time-tracker/get-jira-day-report-entry-date (date)
  (let* ((datetime (parse-time-string date))
         (year (decoded-time-year datetime))
         (month (decoded-time-month datetime))
         (day (decoded-time-day datetime)))
    (format "%04d-%02d-%02d" year month day)))

(defun time-tracker/get-jira-day-report-entry-datetime (date)
  (cons (time-tracker/get-jira-day-report-entry-date date)
        (time-tracker/get-jira-day-report-entry-start-time)))

(defun time-tracker/get-jira-day-remote-data (jira-creds date)
  (let ((datetime (time-tracker/get-jira-day-report-entry-datetime date))
        (issue-id (org-entry-get nil "TRACK-ID"))
        (zone (time-tracker/parse-zone (org-entry-get nil "ZONE"))))
    (when (and jira-creds issue-id) (time-tracker/jira/get-worklog jira-creds issue-id datetime zone))))

(defun time-tracker/build-jira-day-report-entry (date &optional get-remote-data jira-creds)
  `((time . ,(org-entry-get nil "TIME"))
    (zone . ,(time-tracker/parse-zone (org-entry-get nil "ZONE")))
    (datetime . ,(time-tracker/get-jira-day-report-entry-datetime date))
    (track-id . ,(org-entry-get nil "TRACK-ID"))
    (total-jira . ,(time-tracker/entry-total-jira))
    (total . ,(time-tracker/entry-total))
    (title . ,(string-trim (org-get-heading t t t t)))
    (no-report . ,(org-entry-get nil "NO-REPORT"))
    (jira-worklog . ,(if get-remote-data (time-tracker/get-jira-day-remote-data jira-creds date)))))

(defun time-tracker/collect-jira-day-report-entries (&optional get-remote-data jira-creds)
  (save-excursion
    (time-tracker/goto-day-entry)
    (let* ((date (org-get-heading t t t t))
           (jira-creds (or jira-creds (time-tracker/jira/get-credentials)))
           (entries (cdr (org-map-entries (lambda () (time-tracker/build-jira-day-report-entry date get-remote-data jira-creds)) nil 'tree))))
      (cons date entries))))

(defun time-tracker/collect-jira-week-report-entries (&optional get-remote-data)
  (save-excursion
    (let ((jira-creds (time-tracker/jira/get-credentials)))
      (seq-filter (lambda (item) item)
                  (cdr (org-map-entries
                        (lambda () (when (time-tracker/is-day-entry) (time-tracker/collect-jira-day-report-entries get-remote-data jira-creds))) nil 'tree))))))
