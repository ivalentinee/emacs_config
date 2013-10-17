;; my-indentation.el

;; Just my indentation settings. Nothing special.

(add-hook 'c-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent)))
(setq c-default-style "linux" c-basic-offset 4)
(add-hook 'ruby-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent)))
(add-hook 'tuareg-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent)))
(add-hook 'haskell-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent)))
(setq haskell-ident-offset 2)

(provide 'my-indentation)