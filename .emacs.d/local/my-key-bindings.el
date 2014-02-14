;; my-key-bindings.el

;; This module provides my personal global general (module-independent) bindings

(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "<C-tab>") 'other-window)

;; Previous && Next buffer
(global-set-key (kbd "M-[") 'previous-buffer)
(global-set-key (kbd "M-]") 'next-buffer)

;; iBuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; backward-kill-word
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

;; paragraphs forward & baskward
(global-set-key "\M-p" 'backward-paragraph)
(global-set-key "\M-n" 'forward-paragraph)

;; Replace M-x
(global-set-key "\C-c\C-m" 'execute-extended-command)


(provide 'my-key-bindings)
