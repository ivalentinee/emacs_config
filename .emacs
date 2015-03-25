(add-to-list 'load-path "~/.emacs.d/global")
(add-to-list 'load-path "~/.emacs.d/local")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(current-language-environment "Russian")
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "516029471adacb3a933acb16589efa2efa9886ad86a4dc0a503da94695c19a4e" default)))
 '(font-latex-fontify-script t)
 '(global-auto-revert-mode t)
 '(global-auto-revert-non-file-buffers t)
 '(global-highline-mode nil)
 '(global-linum-mode nil)
 '(indent-tabs-mode nil)
 '(js2-basic-offset 2)
 '(jsx-indent-level 2)
 '(left-margin 0)
 '(org-export-html-toplevel-hlevel 1 t)
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
 '(sml/show-file-name nil)
 '(speedbar-default-position (quote left))
 '(speedbar-use-images nil)
 '(tab-always-indent nil)
 '(tab-width 4)
 '(tex-fontify-script t)
 '(tool-bar-mode nil)
 '(web-mode-code-indent-offset 2)
 '(web-mode-enable-auto-closing nil)
 '(web-mode-enable-auto-indentation nil)
 '(web-mode-enable-auto-opening nil)
 '(web-mode-enable-auto-pairing nil)
 '(web-mode-enable-auto-quoting nil)
 '(web-mode-enable-css-colorization nil)
 '(winner-dont-bind-my-keys t)
 '(winner-mode t nil (winner)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Terminus" :foundry "xos4" :slant normal :weight normal :height 139 :width normal))))
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
(require 'cask-settings)
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
(require 'highlight-changes-settings)
(require 'my-file-associations)
(require 'my-minor-settings)
(require 'org-mode-settings)
(require 'setup-theme)
(require 'insert-name)
(require 'safe-local-variables)

(require 'customized-org-html)

;; (require 'require-local)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
