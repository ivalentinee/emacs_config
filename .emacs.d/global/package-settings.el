;;; package-settings --- subject
;;; Commentary:

;;; Code:
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)

(provide 'package-settings)
;;; package-settings.el ends here
