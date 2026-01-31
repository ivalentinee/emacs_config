(defun time-tracker/jira/adjust-worklog-time-zone (time zone)
  (let* ((worklog-zone (decoded-time-zone (iso8601-parse time)))
         (zone-offset (- zone worklog-zone)))
    (decoded-time-add (iso8601-parse time) (make-decoded-time :second zone-offset))))

(defun time-tracker/jira/parse-worklog-start (worklog-time zone)
  (let* ((datetime (time-tracker/jira/adjust-worklog-time-zone worklog-time zone))
         (year (decoded-time-year datetime))
         (month (decoded-time-month datetime))
         (day (decoded-time-day datetime))
         (hour (decoded-time-hour datetime))
         (minute (decoded-time-minute datetime)))
    (cons
     (format "%04d-%02d-%02d" year month day)
     (format "%02d:%02d" hour minute))))

(defun time-tracker/jira/find-worklog (worklogs datetime zone)
  (seq-find
   (lambda (worklog) (equal (time-tracker/jira/parse-worklog-start (gethash "started" worklog) zone) datetime))
   worklogs))

(defun time-tracker/jira/get-worklogs (json-string)
  (let ((document (json-parse-string json-string)))
    (gethash "worklogs" document)))

(defun time-tracker/jira/read-http-response-body (response-buffer)
  (with-current-buffer response-buffer
    (goto-char (point-min))
    (re-search-forward "\n\n")
    (buffer-substring-no-properties (point) (point-max))))

(defun time-tracker/jira/request-headers (creds)
  (let* ((login (alist-get 'login creds))
         (password (alist-get 'password creds))
         (auth-header (concat "Basic " (base64-encode-string (concat login ":" password) t))))
    `(("Content-Type" . "application/json")
      ("Authorization" . ,auth-header))))

(defun time-tracker/jira/get-issue-data (creds issue-id datetime)
  (let* ((from (time-tracker/jira/datetime-to-timestamp datetime "00:00"))
         (to (time-tracker/jira/datetime-to-timestamp datetime "23:59"))
         (url-query (format "startedAfter=%s&startBefore=%s" from to))
         (base-url (alist-get 'base-url creds))
         (full-url (concat base-url "rest/api/3/issue/" issue-id "/worklog" "?" url-query))
         (url-request-extra-headers (time-tracker/jira/request-headers creds)))
    (message "Loading \"%s\" ..." full-url)
    (url-retrieve-synchronously full-url t)))

(defun time-tracker/jira/get-worklog (creds issue-id datetime zone)
  (let* ((issue-data-buffer (time-tracker/jira/get-issue-data creds issue-id datetime))
         (issue-data (time-tracker/jira/read-http-response-body issue-data-buffer))
         (worklogs (time-tracker/jira/get-worklogs issue-data)))
    (time-tracker/jira/find-worklog worklogs datetime zone)))

(defun time-tracker/jira/worklog-status (worklog expected-time)
  (let ((normalized-expected-time (time-tracker/jira/worklog-normalize-jira-total expected-time)))
    (if worklog
        (if (equal (gethash "timeSpent" worklog) normalized-expected-time) "✓" "⏲")
      "✕")))

(defun time-tracker/jira/get-credentials ()
  (save-excursion
    (goto-char (org-find-exact-headline-in-buffer "JIRA"))
    (let ((base-url (org-entry-get nil "BASE-URL"))
          (login (org-entry-get nil "LOGIN"))
          (password (org-entry-get nil "PASSWORD")))
      (if (and base-url login password)
          `((base-url . ,base-url)
            (login . ,login)
            (password . ,password))))))

(defun time-tracker/jira/datetime-to-timestamp (datetime &optional time)
  (let* ((date (car datetime))
         (time (or time (cdr datetime)))
         (datetime-string (concat date " " time)))
    (format "%d" (time-to-seconds (encode-time (parse-time-string datetime-string))))))

(defun time-tracker/jira/worklog-normalize-jira-total (jira-total)
  (string-trim (string-replace "8h" "1d" (replace-regexp-in-string "\\(0h \\)\\|\\( 0m\\)" "" expected-time))))
