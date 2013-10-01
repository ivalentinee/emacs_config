(add-to-list 'load-path "~/.emacs.d/")
(setq load-path (cons (expand-file-name "~/.emacs.d/rails-reloaded") load-path))
(require 'rails-autoload)
(require 'haml-mode)
(require 'pair-mode)
(require 'textmate)
(require 'ruby-end)
(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq-default coding-system-for-write 'utf-8)
(setq-default coding-system-for-read 'utf-8)
(setq file-name-coding-system 'utf-8)

;; Set backup directory
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

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
 '(global-linum-mode t)
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

;; no startup msg
(setq inhibit-startup-message t)

;; Set theme
(if window-system (load-theme (quote misterioso)))

;; copy-paste to x-buffer
(setq x-select-enable-clipboard t)

;; workgroups-mode (save-restore windows)
(require 'workgroups)
(setq wg-prefix-key (kbd "C-c w"))
(workgroups-mode 1)
(setq wg-morph-on nil)
(global-set-key (kbd "C-1") '(lambda () (interactive) (wg-load "~/.emacs.d/wgrp/dev-2")))

;; Remove completion buffer when done
(add-hook 'minibuffer-exit-hook
      '(lambda ()
         (let ((buffer "*Completions*"))
           (and (get-buffer buffer)
            (kill-buffer buffer)))))

;; Disable linum mode for DocView
(require 'linum-off)

;; Setup markdown-mode for *.md
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Setup ruby-mode for Gemfile
(add-to-list 'auto-mode-alist '("\\Gemfile*\\'" . ruby-mode))

;; Switch between first-ident & beginning of line
(defun smart-line-beginning ()
  "Move point to the beginning of text on the current line; if that is already
the current position of point, then move it to the beginning of the line."
  (interactive)
  (let ((pt (point)))
    (beginning-of-line-text)
    (when (eq pt (point))
      (beginning-of-line))))

;; Comment current line
(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))
(global-set-key (kbd "M-;") 'comment-or-uncomment-region-or-line)

;; 80-character line
(require 'fill-column-indicator)
(add-hook 'c-mode-hook 'fci-mode)
(add-hook 'ruby-mode-hook 'fci-mode)
(add-hook 'tuareg-mode-hook 'fci-mode)
(add-hook 'haskell-mode-hook 'fci-mode)
;;(require 'ruby-electric)
;;(add-hook 'ruby-mode-hook (lambda () (ruby-electric-mode t)))

;; Indentation settings
(add-hook 'c-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent)))
(setq c-default-style "linux" c-basic-offset 4)
(add-hook 'ruby-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent)))
(add-hook 'tuareg-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent)))
(add-hook 'haskell-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent)))
(setq haskell-ident-offset 2)

;; delete trailing whitespaces before save
(add-hook 'ruby-mode-hook (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

;;ruby-fix
(add-hook 'ruby-mode-hook (lambda () (setq ruby-insert-encoding-magic-comment nil)))

;; ruby-block
(require 'ruby-block)
(ruby-block-mode t)

;; Auto-complete
(require 'auto-complete-config)
(ac-config-default)
(add-hook 'emacs-lisp-mode-hook 'auto-complete-mode)
(add-hook 'c-mode-hook 'auto-complete-mode)
(add-hook 'ruby-mode-hook 'auto-complete-mode)
(add-hook 'tuareg-mode-hook 'auto-complete-mode)
(add-hook 'haskell-mode-hook 'auto-complete-mode)
(add-hook 'markdown-mode-hook 'auto-complete-mode)
(add-hook 'haml-mode-hook 'auto-complete-mode)


;; Parentheses mode
(require 'highlight-parentheses)
(add-hook 'emacs-lisp-mode-hook 'highlight-parentheses-mode)
(add-hook 'c-mode-hook 'highlight-parentheses-mode)
(add-hook 'ruby-mode-hook 'highlight-parentheses-mode)
(add-hook 'tuareg-mode-hook 'highlight-parentheses-mode)
(add-hook 'haskell-mode-hook 'highlight-parentheses-mode)
(add-hook 'markdown-mode-hook 'highlight-parentheses-mode)

;; Parenthesis
(setq blink-matching-delay 0.2)
(add-hook 'emacs-lisp-mode-hook 'pair-mode)
(add-hook 'c-mode-hook 'pair-mode)
(add-hook 'ruby-mode-hook 'pair-mode)
(add-hook 'tuareg-mode-hook 'pair-mode)
(add-hook 'haskell-mode-hook 'pair-mode)
(add-hook 'markdown-mode-hook 'pair-mode)

;; Textmate
(textmate-mode)

;; Org-mode
; (add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-ca" 'org-agenda)

;; set keys
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-a") 'smart-line-beginning)
;;(global-set-key (kbd "C-c") 'kill-ring-save)
;;(global-set-key (kbd "C-v") 'yank)
(global-set-key (kbd "C-r") 'universal-argument)
(global-set-key (kbd "<C-tab>") 'other-window)
(global-set-key (kbd "<s-tab>") 'next-buffer)

;; Unbind arrow keys
(global-set-key (kbd "<left>") nil)
(global-set-key (kbd "<right>") nil)
(global-set-key (kbd "<up>") nil)
(global-set-key (kbd "<down>") nil)