;; safe-local-variables.el

;;;; TAGS

;; Ruby/Rails
(add-to-list 'safe-local-variable-values '(projectile-tags-command . "ctags-exuberant -Re --languages=ruby -f %s %s"))
(add-to-list 'safe-local-variable-values '(projectile-tags-command . "ripper-tags -R -f %s %s --exclude vendor/bundle"))
(add-to-list 'safe-local-variable-values '(projectile-tags-command . "ripper-tags -R -f %s %s --exclude vendor/bundle && cat GEM_TAGS >> TAGS"))

(provide 'safe-local-variables)
