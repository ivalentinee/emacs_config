(load "time-tracker-common")
(load "time-tracker-time")
(load "time-tracker-jira")

(defun time-tracker/jira/build-worklog-payload (entry)
  (let ((comment (string-replace "\"" "\\\""(alist-get 'title entry)))
        (started (time-tracker/datetime-iso8601 (alist-get 'datetime entry) (alist-get 'zone entry)))
        (time-spent (time-tracker/time-to-seconds (alist-get 'total entry))))
    (format "{
  \"comment\": {
    \"content\": [
      {
        \"content\": [
          {
            \"text\": \"%s\",
            \"type\": \"text\"
          }
        ],
        \"type\": \"paragraph\"
      }
    ],
    \"type\": \"doc\",
    \"version\": 1
  },
  \"started\": \"%s\",
  \"timeSpentSeconds\": %s
}" comment started time-spent)))

(defun time-tracker/jira/put-worklog-data (creds issue-id datetime)
  (let* ((base-url (alist-get 'base-url creds))
         (full-url (concat base-url "rest/api/3/issue/" issue-id "/worklog"))
         (url-request-extra-headers (time-tracker/jira/request-headers creds))
         (url-request-data payload)
         (url-request-method "POST"))
    (message "Modifying \"%s\" ..." full-url)
    (kill-new payload)
    (kill-new (format "%s" (time-tracker/jira/read-http-response-body (url-retrieve-synchronously full-url t))))))

(defun time-tracker/jira/push-entry (entry jira-creds)
  (let* ((issue-id (alist-get 'track-id entry))
         (datetime (alist-get 'datetime entry))
         (time (alist-get 'time entry))
         (title (alist-get 'title entry))
         (zone (alist-get 'zone entry))
         (existing-worklog (time-tracker/jira/get-worklog jira-creds issue-id datetime zone))
         (payload (time-tracker/jira/build-worklog-payload entry)))
    (if existing-worklog
        (message (format "'%s' (%s) already exists, skipping" title time))
      (progn
        (time-tracker/jira/put-worklog-data jira-creds issue-id payload)
        (message (format "'%s' (%s) entry created" title time))))))

(defun time-tracker/jira/push-day (&optional jira-creds)
  (let ((jira-creds (or jira-creds (time-tracker/jira/get-credentials)))
        (entries (cdr (time-tracker/collect-jira-day-report-entries))))
    (mapcar (lambda (entry) (time-tracker/jira/push-entry entry jira-creds)) entries)))

(defun time-tracker/jira/push-week ()
  (save-excursion
    (let ((jira-creds (time-tracker/jira/get-credentials)))
      (seq-filter (lambda (item) item)
                  (cdr (org-map-entries
                        (lambda () (when (time-tracker/is-day-entry) (time-tracker/jira/push-day jira-creds))) nil 'tree))))))

(defun time-tracker/jira/push ()
  "Pushes data to JIRA"
  (interactive)
  (cond ((time-tracker/is-work-entry) (time-tracker/jira/push-day))
        ((time-tracker/is-day-entry) (time-tracker/jira/push-day))
        ((time-tracker/is-week-entry) (time-tracker/jira/push-week))))
