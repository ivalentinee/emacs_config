;; Current git-workflow base on mo-git-blame-file && magit

(global-set-key (kbd "C-c g b") 'mo-git-blame-current)
(global-set-key (kbd "C-c g q") 'mo-git-blame-quit)

(provide 'git-bindings)
