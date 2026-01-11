(load "adventurer-collect")
(load "adventurer-graph")

(defun adventurer-build ()
  "Builds .org adventurer buffer"
  (interactive)
  (unless (eq major-mode 'org-mode)
    (error "Not an org-mode buffer"))
  (let ((scene-data (adventurer--collect-scene-data)))
    (adventurer--build-graph scene-data)))

(provide 'adventurer)
