;;; flycheck-setups.el --- flycheck executable setups
;;; Commentary:

;;; Code:
(add-to-list 'load-path "~/.emacs.d/global/flycheck-setups")
(add-hook 'after-init-hook #'global-flycheck-mode)
(require 'flycheck-eslint-setup)

(provide 'flycheck-setups)
;;; flycheck-setups.el ends here
