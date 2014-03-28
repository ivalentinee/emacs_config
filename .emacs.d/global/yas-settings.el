(require 'yasnippet)

(add-hook 'prog-mode-hook
          '(lambda ()
             (yas-minor-mode)))

(yas-reload-all)

(provide 'yas-settings)
