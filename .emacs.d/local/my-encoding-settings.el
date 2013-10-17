;; my-encoding-settings.el

;; No comment

(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq-default coding-system-for-write 'utf-8)
(setq-default coding-system-for-read 'utf-8)
(setq file-name-coding-system 'utf-8)

(provide 'my-encoding-settings)