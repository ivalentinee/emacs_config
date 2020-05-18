;;; flycheck-setups.el --- flycheck executable setups
;;; Commentary:

;;; Code:
(add-to-list 'load-path "~/.emacs.d/settings/flycheck-setups")
(require 'flycheck-eslint-setup)
(require 'flycheck-tslint-setup)

(provide 'flycheck-setups)
;;; flycheck-setups.el ends here
