;;; flycheck-tslint-setup.el --- flycheck per-project executable setup
;;; Commentary:

;;; Code:
(defvar *tslint-relative-path* "node_modules/.bin/tslint")

(defun tslint-node-modules-path (project-path)
  "Builds tslint executable path based on project path: (tslint-node-modules-path PROJECT-PATH)."
  (concat project-path *tslint-relative-path*))

(defun setup-local-flycheck-tslint ()
  "Setups FLYCHECK-JAVASCRIPT-TSLINT-EXECUTABLE for projectile-served projects."
  (if (fboundp 'projectile-project-p)
      (progn
        (make-local-variable 'flycheck-javascript-tslint-executable)
        (make-local-variable 'flycheck-tslint-rules-directories)
        (let* ((base-path (projectile-project-p)) (tslint-executable-path (tslint-node-modules-path base-path)))
          (if (and base-path (file-exists-p tslint-executable-path))
              (progn
                (setq flycheck-javascript-tslint-executable tslint-executable-path)
                (setq flycheck-tslint-rules-directories (list base-path)))
            (progn
              (setq flycheck-javascript-tslint-executable nil)
              (setq flycheck-tslint-rules-directories '())))))))

(add-hook 'js2-mode-hook 'setup-local-flycheck-tslint)

(provide 'flycheck-tslint-setup)
;;; flycheck-tslint-setup.el ends here
