(load "adventurer-collect")
(load "adventurer-graph")
(load "adventurer-path-mapper")
(load "adventurer-document")

(defun adventurer/build ()
  "Builds .org adventurer buffer"
  (interactive)
  (unless (eq major-mode 'org-mode)
    (error "Not an org-mode buffer"))
  (let ((scene-data (adventurer/collect-scene-data)))
    (adventurer/make-build-path)
    (adventurer/build-graph scene-data)
    (adventurer/build-path-mapper scene-data)
    (adventurer/build-document scene-data)))

(defun adventurer/clear ()
  "Removes adventurer-built files"
  (interactive)
  (unless (eq major-mode 'org-mode)
    (error "Not an org-mode buffer"))
  (adventurer/build-graph/clear)
  (adventurer/build-path-mapper/clear)
  (adventurer/build-document/clear)
  (adventurer/remove-build-path))

(defun adventurer/initialize ()
  "Creates a new adventure buffer"
  (interactive)
  (let ((adventure-sample-path (concat (adventurer/get-script-path) "/" "adventurer-new.org"))
        (buffer (get-buffer-create "new-adventure.org")))
    (with-current-buffer buffer
      (org-mode)
      (erase-buffer)
      (insert-file-contents adventure-sample-path)
      (beginning-of-buffer))
    (switch-to-buffer buffer)
    (org-cycle-global)))

(provide 'adventurer)
