;;; package-settings --- subject
;;; Commentary:

;;; Code:
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(provide 'package-settings)
;;; package-settings.el ends here
