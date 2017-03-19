;; my-key-bindings.el

;; This module provides my personal global general (module-independent) bindings

(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "<C-tab>") 'other-window)

;; iBuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; backward-kill-word
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

;; paragraphs forward & backward
(global-set-key "\M-p" 'backward-paragraph)
(global-set-key "\M-n" 'forward-paragraph)
;; and for slime
(add-hook 'slime-mode-hook
          (cond
           ((boundp 'slime-mod-map) (lambda ()
                                      (define-key slime-mode-map "\M-p" 'backward-paragraph)
                                      (define-key slime-mode-map "\M-n" 'forward-paragraph)))))


(provide 'my-key-bindings)
