;;; insert-name.el --- packages settings
;;; Commentary:

;;; Code:
(defun insert-file-name ()
  "Insert current buffer filename."
  (interactive)
  (insert (buffer-file-name)))

(defun insert-buffer-name ()
  "Insert current buffer name."
  (interactive)
  (insert (buffer-name)))

(provide 'insert-name)
