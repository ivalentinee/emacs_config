;; highlight-changes-settings.el

;; Some settings for highlight-changes-mode. Taken from emacs-fu:
;;   http://emacs-fu.blogspot.ru/

(global-highlight-changes-mode t)
(setq highlight-changes-visibility-initial-state nil) ;; initially hide
(global-set-key (kbd "<f6>") 'highlight-changes-visible-mode) ;; changes
(set-face-foreground 'highlight-changes nil)
(set-face-background 'highlight-changes "#382f2f")
(set-face-foreground 'highlight-changes-delete nil)
(set-face-background 'highlight-changes-delete "#916868")

(provide 'highlight-changes-settings)