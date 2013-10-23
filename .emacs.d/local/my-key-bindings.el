;; my-key-bindings.el

;; This module provides my personal global general (module-independent) bindings

(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "<C-tab>") 'other-window)

;; Previous && Next buffer
(global-set-key (kbd "M-]") 'previous-buffer)
(global-set-key (kbd "M-[") 'next-buffer)

;; iBuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

(provide 'my-key-bindings)
