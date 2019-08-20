;; unbind-arrows.el

;; This module provides unbinding arrow keys for basic file-navigation
;; It really helps to get used to FBPN-based navigation

(global-set-key (kbd "<left>") nil)
(global-set-key (kbd "<right>") nil)
(global-set-key (kbd "<up>") nil)
(global-set-key (kbd "<down>") nil)
(global-set-key (kbd "<C-left>") nil)
(global-set-key (kbd "<C-right>") nil)
(global-set-key (kbd "<C-up>") nil)
(global-set-key (kbd "<C-down>") nil)
(global-set-key (kbd "<M-left>") nil)
(global-set-key (kbd "<M-right>") nil)
(global-set-key (kbd "<M-up>") nil)
(global-set-key (kbd "<M-down>") nil)

(provide 'unbind-arrows)