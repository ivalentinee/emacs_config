(load "time-tracker-time")
(load "time-tracker-report-collect")
(load "time-tracker-report-day")

(defun time-tracker/calculate-report-week-time-total (week-report-entries)
  (apply '+
         (mapcar
          (lambda (day-report-entries) (time-tracker/calculate-report-day-time-total (cdr day-report-entries)))
          week-report-entries)))

(defun time-tracker/put-jira-week-report-data (week-report-entries &optional get-remote-data)
  (insert "* Days\n")
  (mapcar (lambda (entry) (time-tracker/put-jira-day-report-data entry get-remote-data)) week-report-entries)
  (let ((total (time-tracker/calculate-report-week-time-total week-report-entries)))
    (insert "* Week total\n" (time-tracker/format-time-jira total))))

(defun time-tracker/build-jira-week-report (&optional get-remote-data)
  (let ((week-report-entries (time-tracker/collect-jira-week-report-entries get-remote-data))
        (buffer (get-buffer-create "time-tracker-jira-report.org")))
    (with-current-buffer buffer
      (org-mode)
      (erase-buffer)
      (time-tracker/put-jira-week-report-data week-report-entries get-remote-data)
      (beginning-of-buffer))
    (pop-to-buffer buffer)))
