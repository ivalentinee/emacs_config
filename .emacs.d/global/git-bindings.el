;; Current git-workflow base on mo-git-blame-file && magit

(global-set-key (kbd "C-c g b") 'mo-git-blame-current)
(global-set-key (kbd "C-c g q") 'mo-git-blame-quit)

(global-set-key (kbd "C-c g s") 'magit-status)
(global-set-key (kbd "C-c g c") 'magit-commit)
(global-set-key (kbd "C-c g l") 'magit-log)
(global-set-key (kbd "C-c g m") 'magit-checkout)

(provide 'git-bindings)
