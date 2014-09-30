;; safe-local-variables.el

(add-to-list 'safe-local-variable-values '(projectile-tags-command . "ctags-exuberant -Re --languages=ruby -f %s %s"))

(provide 'safe-local-variables)
