;;; flycheck-setups.el --- flycheck executable setups
;;; Commentary:

;;; Code:
;; (defun flycheck-display-error-notice (errors)
;;   (when (and errors (flycheck-may-use-echo-area-p))
;;     (message "flycheck encountered errors")))

;; (setq flycheck-display-errors-function 'flycheck-display-error-notice)

(add-to-list 'load-path "~/.emacs.d/settings/flycheck-setups")

(require 'flycheck-eslint-setup)

;; (add-hook 'elixir-mode-hook 'flycheck-mode)
(setq flycheck-elixir-credo-strict t)

(provide 'flycheck-setups)
;;; flycheck-setups.el ends here
