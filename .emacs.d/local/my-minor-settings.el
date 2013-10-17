;; my-minor-settings.el

;; My almost-single-line settings.

;; no startup msg
(setq inhibit-startup-message t)

;; Disable cursor blinking
(blink-cursor-mode nil)

;; copy-paste to x-buffer
(setq x-select-enable-clipboard t)

;; Delete the selection area with a keypress
(delete-selection-mode t)

;; delete trailing whitespaces before save
(add-hook 'ruby-mode-hook (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

;;ruby-fix
(add-hook 'ruby-mode-hook (lambda () (setq ruby-insert-encoding-magic-comment nil)))

(provide 'my-minor-settings)