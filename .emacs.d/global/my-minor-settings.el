;; my-minor-settings.el

;; My almost-single-line settings.

;; no startup msg
(setq inhibit-startup-message t)

;; y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Disable cursor blinking
(blink-cursor-mode 0)

;; copy-paste to x-buffer
(setq x-select-enable-clipboard t)

;; Delete the selection area with a keypress
(delete-selection-mode t)

;; delete trailing whitespaces before save
(add-hook 'ruby-mode-hook (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

;; ruby-fix
(add-hook 'ruby-mode-hook (lambda () (setq ruby-insert-encoding-magic-comment nil)))

;; highlight current line
(defface hl-line '((t (:background "#000000")))
  "Face to use for `hl-line-face'." :group 'hl-line)
(setq hl-line-face 'hl-line)
(global-hl-line-mode t)

(provide 'my-minor-settings)
