;; my-minor-settings.el

;; My almost-single-line settings.

;; no startup msg
(setq inhibit-startup-message t)

;; disable menu
(menu-bar-mode -1)

;; y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Disable cursor blinking
(blink-cursor-mode 0)

;; copy-paste to x-buffer
(setq x-select-enable-clipboard t)

;; Delete the selection area with a keypress
(delete-selection-mode t)

;; delete trailing whitespaces before save
(add-hook 'prog-mode-hook (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

;; ruby-fix
(add-hook 'ruby-mode-hook (lambda () (setq ruby-insert-encoding-magic-comment nil)))

;; highlight current line
(global-hl-line-mode t)

;; which-function-mode
(add-hook 'prog-mode-hook
          '(lambda ()
             (which-function-mode)))

(setq comint-prompt-read-only t)

(provide 'my-minor-settings)
