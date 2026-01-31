(load "time-tracker-report")
(load "time-tracker-utils")

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c t i t") #'time-tracker/insert-today)
  (define-key org-mode-map (kbd "C-c t i e") #'time-tracker/insert-entry)
  (define-key org-mode-map (kbd "C-c t c e") #'time-tracker/copy-entry)
  (define-key org-mode-map (kbd "C-c t r r") #'time-tracker/build-jira-report)
  (define-key org-mode-map (kbd "C-c t r j") #'time-tracker/build-jira-report-with-remote-data)
  (define-key org-mode-map (kbd "C-c t r p") #'time-tracker/push-and-report-with-data)
  (define-key org-mode-map (kbd "C-c t p") #'time-tracker/jira/push))

(provide 'time-tracker)
