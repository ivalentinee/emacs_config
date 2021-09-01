;;; projectile-addons.el --- packages settings
;;; Commentary:

;;; Code:

(defun projectile-get-file-name ()
  (if (and
       (fboundp 'projectile-project-root)
       (string-prefix-p (projectile-project-root) (buffer-file-name)))
      (substring (buffer-file-name)
                 (length (projectile-project-root))
                 (length (buffer-file-name)))))

(defun projectile-insert-file-name ()
  "Insert current buffer project filename"
  (interactive)
  (let ((projectile-file-name (projectile-get-file-name)))
    (if projectile-file-name
        (insert projectile-file-name))))

(defun projectile-copy-file-name ()
  "Insert current buffer project filename"
  (interactive)
  (let ((projectile-file-name (projectile-get-file-name)))
    (if projectile-file-name
        (kill-new projectile-file-name))))

(defvar *projectile-format-fun* nil)
(make-local-variable '*projectile-format-fun*)

(defun projectile-format-file ()
  "Performs automatic formatting for current buffer file"
  (interactive)
  (if *projectile-format-fun*
      (let ((projectile-file-name (projectile-get-file-name)))
        (if projectile-file-name
            (projectile-with-default-dir (projectile-acquire-root)
              (apply 'start-process
                     (append '("projectile-format" nil) (apply *projectile-format-fun* (list projectile-file-name)))))))))

(provide 'projectile-addons)
;;; package-settings.el ends here
