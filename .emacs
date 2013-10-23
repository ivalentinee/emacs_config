(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/local")

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(current-language-environment "Russian")
 '(fill-column 80)
 '(font-latex-fontify-script t)
 '(global-auto-revert-mode t)
 '(global-auto-revert-non-file-buffers t)
 '(global-highline-mode nil)
 '(global-linum-mode nil)
 '(indent-tabs-mode nil)
 '(left-margin 0)
 '(preview-default-option-list (quote ("displaymath" "floats" "graphics" "textmath" "sections" "footnotes")))
 '(preview-fast-conversion t)
 '(ruby-indent-tabs-mode nil)
 '(speedbar-default-position (quote left))
 '(speedbar-use-images nil)
 '(tab-always-indent nil)
 '(tab-width 4)
 '(tex-fontify-script t)
 '(tool-bar-mode nil)
 '(winner-dont-bind-my-keys t)
 '(winner-mode t nil (winner)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:family "Terminus" :foundry "xos4" :slant normal :weight normal :height 139 :width normal))))
 '(column-marker-1 ((t (:background "dark violet"))))
 '(font-latex-sectioning-0-face ((t (:background "grey43" :underline "cyan" :weight ultra-bold))))
 '(font-latex-sectioning-1-face ((t (:background "grey43" :underline "yellow3" :weight ultra-bold))))
 '(font-latex-sectioning-2-face ((t (:underline "cyan" :weight ultra-bold))))
 '(font-latex-sectioning-3-face ((t (:underline "yellow3" :weight ultra-bold))))
 '(font-latex-sectioning-4-face ((t (:underline t :weight bold))))
 '(font-latex-sectioning-5-face ((((class color) (background dark)) (:underline t :weight normal)))))
;;(require 'column-marker)

;; Set theme
(if window-system (load-theme (quote misterioso)))

;; 80-character line
(require 'fill-column-indicator)
(add-hook 'c-mode-hook 'fci-mode)
(add-hook 'ruby-mode-hook 'fci-mode)
(add-hook 'tuareg-mode-hook 'fci-mode)
(add-hook 'haskell-mode-hook 'fci-mode)

;; Local modules
(require 'my-encoding-settings)
(require 'external-modules)
(require 'calendar-settings)
(require 'unbind-arrows)
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
(require 'undev-settings)