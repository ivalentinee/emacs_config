(load "time-tracker-time")
(load "time-tracker-report-collect")
(load "time-tracker-report-day")

(defun time-tracker/calculate-report-week-time-total (week-report-entries)
  (apply '+
         (mapcar
          (lambda (day-report-entries) (time-tracker/calculate-report-day-time-total (cdr day-report-entries)))
          week-report-entries)))

(defun time-tracker/put-jira-week-report-data (week-report-entries)
  (insert "* Days\n")
  (mapcar 'time-tracker/put-jira-day-report-data week-report-entries)
  (let ((total (time-tracker/calculate-report-week-time-total week-report-entries)))
    (insert "* Week total\n" (time-tracker/format-time-jira total))))

(defun time-tracker/build-jira-week-report ()
  (let ((week-report-entries (time-tracker/collect-jira-week-report-entries))
        (buffer (get-buffer-create "time-tracker-jira-report.org")))
    (with-current-buffer buffer
      (org-mode)
      (erase-buffer)
      (time-tracker/put-jira-week-report-data week-report-entries)
      (beginning-of-buffer))
    (pop-to-buffer buffer)))
