;; set-uniquify.el

;; Uniquify settings. Nothing special.

(require 'uniquify)
(setq
  uniquify-buffer-name-style 'post-forward
  uniquify-separator "|")

(provide 'set-uniquify)