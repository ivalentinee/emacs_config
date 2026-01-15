(defun time-tracker/parse-time-range (time-range)
  (let ((time-range-entries (split-string time-range "-")))
    (let ((from (nth 0 time-range-entries))
          (to (nth 1 time-range-entries)))
      (if (and from to) (cons from to) (error "Invalid time range")))))

(defun time-tracker/time-to-seconds (time-string)
  "Converts time string to seconds a number of seconds"
  (let ((seconds (decoded-time-second (parse-time-string time-string)))
        (minutes (decoded-time-minute (parse-time-string time-string)))
        (hours (decoded-time-hour (parse-time-string time-string))))
    (+ seconds (* minutes 60) (* hours 60 60))))

(defun time-tracker/time-diff (time1 time2)
  "Calculates time diff between time1 and time2 (seconds)"
  (if (< time2 time1) (- (+ time2 24 * 60 * 60) time2) (- time2 time1)))

(defun time-tracker/time-range-diff (time-range-string)
  (let ((time-range (time-tracker/parse-time-range time-range-string)))
    (let ((from (time-tracker/time-to-seconds (car time-range)))
          (to (time-tracker/time-to-seconds (cdr time-range))))
      (time-tracker/time-diff from to))))

(defun time-tracker/format-time (seconds)
  (format-seconds "%.2h:%.2m" seconds))

(defun time-tracker/format-time-jira (seconds)
  (format-seconds "%hh %mm" seconds))
