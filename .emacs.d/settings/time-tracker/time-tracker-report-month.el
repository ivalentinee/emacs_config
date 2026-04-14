(load "time-tracker-common")
(load "time-tracker-time")
(load "time-tracker-report-collect")
(load "time-tracker-report-day")
(load "time-tracker-report-week")

(defun time-tracker/get-first-day-in-week ()
  "Gets the date of the first day entry under the current week entry"
  (save-excursion
    (let ((subtree-end (save-excursion (org-end-of-subtree t) (point)))
          (result nil))
      (while (and (not result) (outline-next-heading) (<= (point) subtree-end))
        (when (time-tracker/is-day-entry)
          (setq result (org-get-heading t t t t))))
      result)))

(defun time-tracker/get-date-at-point ()
  "Gets a date string from the entry at point"
  (save-excursion
    (cond
     ((time-tracker/is-work-entry)
      (time-tracker/goto-day-entry)
      (org-get-heading t t t t))
     ((time-tracker/is-day-entry)
      (org-get-heading t t t t))
     ((time-tracker/is-week-entry)
      (time-tracker/get-first-day-in-week)))))

(defun time-tracker/parse-month-year (date-string)
  "Returns (month . year) from a date string"
  (let ((parsed (parse-time-string date-string)))
    (cons (decoded-time-month parsed) (decoded-time-year parsed))))

(defun time-tracker/collect-jira-month-week-entries (get-remote-data jira-creds)
  "Collects week report entries from the week at point"
  (seq-filter (lambda (item) item)
              (cdr (org-map-entries
                    (lambda ()
                      (when (time-tracker/is-day-entry)
                        (time-tracker/collect-jira-day-report-entries get-remote-data jira-creds)))
                    nil 'tree))))

(defun time-tracker/day-in-month-p (day-report-entry target-year target-month)
  "Returns t if the day report entry date is in the target month"
  (let* ((date-string (car day-report-entry))
         (parsed (parse-time-string date-string))
         (month (decoded-time-month parsed))
         (year (decoded-time-year parsed)))
    (and (= month target-month) (= year target-year))))

(defun time-tracker/collect-jira-month-report-entries (target-year target-month &optional get-remote-data)
  "Collects all week report entries that have days in the target month"
  (save-excursion
    (let ((jira-creds (time-tracker/jira/get-credentials))
          (result nil))
      (org-map-entries
       (lambda ()
         (when (time-tracker/is-week-entry)
           (let* ((week-title (org-get-heading t t t t))
                  (week-entries (time-tracker/collect-jira-month-week-entries get-remote-data jira-creds))
                  (filtered-entries (seq-filter
                                    (lambda (day-entry) (time-tracker/day-in-month-p day-entry target-year target-month))
                                    week-entries)))
             (when filtered-entries
               (push (cons week-title filtered-entries) result)))))
       nil 'file)
      (nreverse result))))

(defun time-tracker/calculate-report-month-time-total (month-report-entries)
  "Calculates total time for all weeks in the month report"
  (apply '+
         (mapcar
          (lambda (week-data)
            (time-tracker/calculate-report-week-time-total (cdr week-data)))
          month-report-entries)))

(defun time-tracker/put-jira-month-report-data (month-report-entries &optional get-remote-data)
  "Inserts month report data into the current buffer"
  (mapcar
   (lambda (week-data)
     (let ((week-title (car week-data))
           (week-entries (cdr week-data)))
       (insert "* " week-title "\n")
       (mapcar (lambda (entry) (time-tracker/put-jira-day-report-data entry get-remote-data)) week-entries)
       (let ((week-total (time-tracker/calculate-report-week-time-total week-entries)))
         (insert "** " week-title " total\n" (time-tracker/format-time week-total) "\n\n"))))
   month-report-entries)
  (let ((total (time-tracker/calculate-report-month-time-total month-report-entries)))
    (insert "* Month total\n" (time-tracker/format-time total))))

(defun time-tracker/build-jira-month-report (&optional get-remote-data)
  "Builds a monthly report for the month of the date under cursor"
  (interactive)
  (let* ((date-string (time-tracker/get-date-at-point))
         (month-year (time-tracker/parse-month-year date-string))
         (target-month (car month-year))
         (target-year (cdr month-year))
         (month-report-entries (time-tracker/collect-jira-month-report-entries target-year target-month get-remote-data))
         (buffer (get-buffer-create "time-tracker-jira-report.org")))
    (with-current-buffer buffer
      (org-mode)
      (erase-buffer)
      (time-tracker/put-jira-month-report-data month-report-entries get-remote-data)
      (beginning-of-buffer))
    (pop-to-buffer buffer)))
