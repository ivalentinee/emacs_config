;; package-settings.el

(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(custom-set-variables
 '(package-selected-packages
   (quote
    (2048-game ace-jump-mode ace-window ag aggressive-indent anzu autopair coffee-mode dired-details direx expand-region fill-column-indicator fireplace flatui-theme gitconfig-mode goto-last-change haml-mode helm helm-ag helm-core helm-projectile highlight-parentheses ibuffer-vc js2-mode js2-refactor json-mode json-reformat json-snatcher less-css-mode lua-mode macro-math magit magit-popup markdown-mode markdown-mode+ mo-git-blame multi-term multiple-cursors nginx-mode paredit php-mode projectile projectile-rails rails-log-mode rake restclient rspec-mode ruby-block ruby-compilation ruby-end sass-mode scss-mode slim-mode slime smart-mode-line string-inflection urlenc web-mode yaml-mode yasnippet))))

(package-initialize)

(provide 'package-settings)
