;; package-settings.el

(require 'cask "~/.local/apps/cask/cask.el")
(cask-initialize)

(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(provide 'package-settings)
