;;; flycheck-eslint-setup.el --- flycheck per-project executable setup
;;; Commentary:

;;; Code:
(defvar *eslint-relative-path* "node_modules/.bin/eslint")

(defun eslint-node-modules-path (project-path)
  "Builds eslint executable path based on project path: (eslint-node-modules-path PROJECT-PATH)."
  (concat project-path *eslint-relative-path*))

(defun setup-local-flycheck-eslint ()
  "Setups FLYCHECK-JAVASCRIPT-ESLINT-EXECUTABLE for projectile-served projects."
  (if (fboundp 'projectile-project-p)
      (progn
        (make-local-variable 'flycheck-javascript-eslint-executable)
        (make-local-variable 'flycheck-eslint-rules-directories)
        (let* ((base-path (projectile-project-p)) (eslint-executable-path (eslint-node-modules-path base-path)))
          (if (and base-path (file-exists-p eslint-executable-path))
              (progn
                (setq flycheck-javascript-eslint-executable eslint-executable-path)
                (setq flycheck-eslint-rules-directories (list base-path)))
            (progn
              (setq flycheck-javascript-eslint-executable nil)
              (setq flycheck-eslint-rules-directories '())))))))

(add-hook 'js2-mode-hook 'setup-local-flycheck-eslint)

(provide 'flycheck-eslint-setup)
;;; flycheck-eslint-setup.el ends here
