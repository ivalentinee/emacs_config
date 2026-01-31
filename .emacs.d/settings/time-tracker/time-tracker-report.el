(load "time-tracker-common")
(load "time-tracker-report-day")
(load "time-tracker-report-week")

(defun time-tracker/build-jira-report ()
  "Builds a report for simple JIRA copy-paste"
  (interactive)
  (cond ((time-tracker/is-work-entry) (time-tracker/build-jira-day-report))
        ((time-tracker/is-day-entry) (time-tracker/build-jira-day-report))
        ((time-tracker/is-week-entry) (time-tracker/build-jira-week-report))))

(defun time-tracker/build-jira-report-with-remote-data ()
  "Builds a report for simple JIRA copy-paste (also gets data from JIRA)"
  (interactive)
  (cond ((time-tracker/is-work-entry) (time-tracker/build-jira-day-report t))
        ((time-tracker/is-day-entry) (time-tracker/build-jira-day-report t))
        ((time-tracker/is-week-entry) (time-tracker/build-jira-week-report t))))
