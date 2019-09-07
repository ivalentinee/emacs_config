
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/settings")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#ecf0f1" "#e74c3c" "#2ecc71" "#f1c40f" "#2492db" "#9b59b6" "#1abc9c" "#2c3e50"])
 '(auto-save-default nil)
 '(coffee-tab-width 2)
 '(comint-process-echoes nil)
 '(css-indent-offset 2)
 '(current-language-environment "Russian")
 '(custom-safe-themes
   (quote
    ("392395ee6e6844aec5a76ca4f5c820b97119ddc5290f4e0f58b38c9748181e8d" "15348febfa2266c4def59a08ef2846f6032c0797f001d7b9148f30ace0d08bcf" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3b24f986084001ae46aa29ca791d2bc7f005c5c939646d2b800143526ab4d323" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "516029471adacb3a933acb16589efa2efa9886ad86a4dc0a503da94695c19a4e" default)))
 '(fci-rule-color "#f1c40f")
 '(font-latex-fontify-script t)
 '(global-auto-revert-mode t)
 '(global-auto-revert-non-file-buffers t)
 '(global-highline-mode nil)
 '(global-linum-mode nil)
 '(hl-paren-background-colors (quote ("#2492db" "#95a5a6" nil)))
 '(hl-paren-colors (quote ("#ecf0f1" "#ecf0f1" "#c0392b")))
 '(indent-tabs-mode nil)
 '(js2-basic-offset 2)
 '(jsx-indent-level 2)
 '(left-margin 0)
 '(magit-auto-revert-mode t)
 '(magit-completing-read-function (quote helm--completing-read-default))
 '(magit-visit-ref-behavior (quote (checkout-any)))
 '(org-agenda-files (quote ("~/todo.org")))
 '(org-export-html-toplevel-hlevel 1 t)
 '(package-selected-packages
   (quote
    (haskell-mode haskell-snippets yasnippet-snippets cmake-mode disable-mouse magit helm helm-ag helm-projectile erlang typescript-mode flycheck alchemist company avy elixir-mode elixir-yasnippets 2048-game ace-window ag aggressive-indent anzu autopair coffee-mode direx expand-region fill-column-indicator fireplace flatui-theme gitconfig-mode goto-last-change haml-mode highlight-parentheses ibuffer-vc js2-mode js2-refactor json-mode json-reformat json-snatcher less-css-mode lua-mode macro-math markdown-mode markdown-mode+ mo-git-blame multi-term multiple-cursors nginx-mode paredit php-mode projectile projectile-rails rails-log-mode rake restclient rspec-mode ruby-compilation ruby-end sass-mode scss-mode slim-mode slime smart-mode-line string-inflection urlenc web-mode yaml-mode yasnippet)))
 '(preview-default-option-list
   (quote
    ("displaymath" "floats" "graphics" "textmath" "sections" "footnotes")))
 '(preview-fast-conversion t)
 '(ruby-indent-tabs-mode nil)
 '(safe-local-variable-values
   (quote
    ((encoding . utf-8)
     (ruby-compilation-executable . "ruby")
     (ruby-compilation-executable . "ruby1.8")
     (ruby-compilation-executable . "ruby1.9")
     (ruby-compilation-executable . "rbx")
     (ruby-compilation-executable . "jruby"))))
 '(sml/active-background-color "#34495e")
 '(sml/active-foreground-color "#ecf0f1")
 '(sml/inactive-background-color "#dfe4ea")
 '(sml/inactive-foreground-color "#34495e")
 '(sml/show-file-name nil)
 '(speedbar-default-position (quote left))
 '(speedbar-use-images nil)
 '(tab-always-indent nil)
 '(tab-width 4)
 '(tex-fontify-script t)
 '(tool-bar-mode nil)
 '(typescript-indent-level 2)
 '(vc-annotate-background "#ecf0f1")
 '(vc-annotate-color-map
   (quote
    ((30 . "#e74c3c")
     (60 . "#c0392b")
     (90 . "#e67e22")
     (120 . "#d35400")
     (150 . "#f1c40f")
     (180 . "#d98c10")
     (210 . "#2ecc71")
     (240 . "#27ae60")
     (270 . "#1abc9c")
     (300 . "#16a085")
     (330 . "#2492db")
     (360 . "#0a74b9"))))
 '(vc-annotate-very-old-color "#0a74b9")
 '(web-mode-attr-indent-offset 2)
 '(web-mode-attr-value-indent-offset 2)
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-enable-auto-closing nil)
 '(web-mode-enable-auto-indentation nil)
 '(web-mode-enable-auto-opening nil)
 '(web-mode-enable-auto-pairing nil)
 '(web-mode-enable-auto-quoting nil)
 '(web-mode-enable-css-colorization nil)
 '(web-mode-markup-indent-offset 2)
 '(winner-dont-bind-my-keys t)
 '(winner-mode t nil (winner)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Liberation Mono" :foundry "xos4" :slant normal :weight normal :height 139 :width normal))))
 '(column-marker-1 ((t (:background "dark violet"))) t)
 '(font-latex-sectioning-0-face ((t (:background "grey43" :underline "cyan" :weight ultra-bold))) t)
 '(font-latex-sectioning-1-face ((t (:background "grey43" :underline "yellow3" :weight ultra-bold))) t)
 '(font-latex-sectioning-2-face ((t (:underline "cyan" :weight ultra-bold))) t)
 '(font-latex-sectioning-3-face ((t (:underline "yellow3" :weight ultra-bold))) t)
 '(font-latex-sectioning-4-face ((t (:underline t :weight bold))) t)
 '(font-latex-sectioning-5-face ((((class color) (background dark)) (:underline t :weight normal))) t)
 '(helm-ff-directory ((t (:background "DodgerBlue4" :foreground "gainsboro"))))
 '(helm-ff-file ((t (:foreground "gainsboro"))))
 '(helm-selection ((t (:background "black" :underline t)))))
;;(require 'column-marker)
(put 'dired-find-alternate-file 'disabled nil)

;; Local modules
(require 'my-encoding-settings)
(require 'package-settings)
(require 'external-modules)
(require 'dired-settings)
(require 'set-title)
(require 'calendar-settings)
;; (require 'unbind-arrows)
(require 'my-key-bindings)
(require 'my-indentation)
(require 'set-backup-dir)
(require 'set-uniquify)
(require 'comment-current-line)
(require 'kill-save-current-line)
(require 'smart-line-beginning)
(require 'remove-completition-buffer)
(require 'my-file-associations)
(require 'my-minor-settings)
(require 'org-mode-settings)
(require 'gpg-settings)
(require 'setup-theme)
(require 'insert-name)
(require 'safe-local-variables)
(require 'helm-custom-themes)
(require 'switch-font-size)

(require 'flycheck-setups)

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
