(load "time-tracker-report")
(load "time-tracker-total")

(defun time-tracker/line-is-empty ()
  (save-excursion
    (beginning-of-line)
    (looking-at-p "[[:blank:]]*$")))

(defun time-tracker/insert-current-date ()
  "Insert the current date as an inactive Org mode timestamp."
  (interactive)
  (insert (format-time-string "<%Y-%m-%d %a>")))

(defun time-tracker/insert-today ()
  "Insert time-tracker entry for current day at the end of file"
  (interactive)
  (end-of-buffer)
  (if (not (time-tracker/line-is-empty)) (insert "\n"))
  (insert "** ")
  (time-tracker/insert-current-date))

(defun time-tracker/insert-entry ()
  "Insert time-tracker entry"
  (interactive)
  (if (not (time-tracker/line-is-empty)) (insert "\n"))
  (insert "*** ")
  (org-set-property "TIME" (format "%s-%s" (format-time-string "%H:%m") (format-time-string "%H:%m")))
  (org-set-property "ID" "NONE")
  (org-set-property "TRACK-ID" "NONE")
  (org-set-property "TYPE" "TASK")
  (org-set-property "TOTAL" "0")
  (org-set-property "TOTAL-JIRA" "0m"))

(defun time-tracker/copy-entry ()
  "Copy current entry"
  (interactive)
  (let ((title (org-get-heading t t t t)))
    (message (format "Entry copied: %s" title))
    (org-copy-subtree)))

(defun time-tracker/copy-title ()
  "Copy current entry title"
  (interactive)
  (let ((title (org-get-heading t t t t)))
    (kill-new title)
    (message (format "Title copied: %s" title))))

(defun time-tracker/copy-total ()
  "Copy current entry total"
  (interactive)
  (let ((total (org-entry-get nil "TOTAL")))
    (kill-new total)
    (message (format "Total copied: %s" total))))

(defun time-tracker/copy-total-jira ()
  "Copy current entry total (jira)"
  (interactive)
  (let ((total (org-entry-get nil "TOTAL-JIRA")))
    (kill-new total)
    (message (format "Jira total copied: %s" total))))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c t i t") #'time-tracker/insert-today)
  (define-key org-mode-map (kbd "C-c t i e") #'time-tracker/insert-entry)
  (define-key org-mode-map (kbd "C-c t u") #'time-tracker/update-total)
  (define-key org-mode-map (kbd "C-c t c e") #'time-tracker/copy-entry)
  (define-key org-mode-map (kbd "C-c t c t") #'time-tracker/copy-title)
  (define-key org-mode-map (kbd "C-c t c j") #'time-tracker/copy-total-jira)
  (define-key org-mode-map (kbd "C-c t r") #'time-tracker/build-jira-report))

(provide 'time-tracker)
