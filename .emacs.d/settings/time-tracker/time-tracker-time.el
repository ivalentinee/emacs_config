(defun time-tracker/entry-total ()
  (if (time-tracker/is-work-entry)
      (let ((time-diff (time-tracker/time-range-diff (org-entry-get nil "TIME"))))
        (time-tracker/format-time time-diff))))

(defun time-tracker/entry-total-jira ()
  (if (time-tracker/is-work-entry)
      (let ((time-diff (time-tracker/time-range-diff (org-entry-get nil "TIME"))))
        (time-tracker/format-time-jira time-diff))))

(defun time-tracker/parse-time-range (time-range)
  (let* ((time-range-entries (split-string time-range "-"))
         (from (nth 0 time-range-entries))
         (to (nth 1 time-range-entries)))
    (if (and from to) (cons from to) (error "Invalid time range"))))

(defun time-tracker/time-to-seconds (time-string)
  "Converts time string to seconds a number of seconds"
  (let* ((time (parse-time-string time-string))
         (seconds (decoded-time-second time))
         (minutes (decoded-time-minute time))
         (hours (decoded-time-hour time)))
    (+ seconds (* minutes 60) (* hours 60 60))))

(defun time-tracker/time-diff (time1 time2)
  "Calculates time diff between time1 and time2 (seconds)"
  (if (< time2 time1) (- (+ time2 24 * 60 * 60) time2) (- time2 time1)))

(defun time-tracker/time-range-diff (time-range-string)
  (let* ((time-range (time-tracker/parse-time-range time-range-string))
         (from (time-tracker/time-to-seconds (car time-range)))
         (to (time-tracker/time-to-seconds (cdr time-range))))
    (time-tracker/time-diff from to)))

(defun time-tracker/datetime-iso8601-utc (datetime &optional zone)
  (let* ((datetime-string (concat (car datetime) " " (cdr datetime)))
         (parsed (parse-time-string datetime-string))
         (zone (or zone 0)))
    (format-time-string "%Y-%m-%dT%H:%M:%S" (encode-time parsed) zone)))

(defun time-tracker/parse-zone (zone-string)
  (if (and (stringp zone-string) (> (length zone-string) 1))
      (let* ((unsigned-zone (string-trim-left zone-string "[+-]"))
             (sign-character (aref zone-string 0)))
        (cond ((equal sign-character ?+) (time-tracker/time-to-seconds unsigned-zone))
              ((equal sign-character ?-) (- (time-tracker/time-to-seconds unsigned-zone)))
              (t 0)))
    0))

(defun time-tracker/format-time (seconds)
  (format-seconds "%.2h:%.2m" seconds))

(defun time-tracker/format-time-jira (seconds)
  (format-seconds "%hh %mm" seconds))
