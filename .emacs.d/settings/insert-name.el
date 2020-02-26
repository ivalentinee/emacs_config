;;; insert-name.el --- packages settings
;;; Commentary:

;;; Code:
(defun insert-file-name ()
  "Insert current buffer filename."
  (interactive)
  (insert (buffer-file-name)))

(defun insert-project-file-name ()
  "Insert current buffer project filename."
  (interactive)
  (if (and
       (fboundp 'projectile-project-p)
       (string-prefix-p (projectile-project-p) (buffer-file-name)))
      (insert (substring (buffer-file-name)
                         (length (projectile-project-p))
                         (length (buffer-file-name))))))

(defun copy-project-file-name ()
  "Copy current buffer project filename to killring."
  (interactive)
  (if (and
       (fboundp 'projectile-project-p)
       (string-prefix-p (projectile-project-p) (buffer-file-name)))
      (kill-new (substring (buffer-file-name)
                           (length (projectile-project-p))
                           (length (buffer-file-name))))))

(defun insert-buffer-name ()
  "Insert current buffer name."
  (interactive)
  (insert (buffer-name)))

(provide 'insert-name)
