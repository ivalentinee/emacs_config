(defun insert-file-name ()
  "Inserts current buffer filename"
  (interactive)
  (insert (buffer-file-name)))

(defun insert-buffer-name ()
  "Inserts current buffer name"
  (interactive)
  (insert (buffer-name)))

(provide 'insert-name)
