;; safe-local-variables.el

;;;; TAGS
(defun setup-tags-variables ()
  ;; Ruby / Rails
  (add-to-list 'safe-local-variable-values '(projectile-tags-command . "ctags-exuberant -Re --languages=ruby -f %s %s"))
  (add-to-list 'safe-local-variable-values '(projectile-tags-command . "echo 'ripper-tags -R -f TAGS --exclude vendor/bundle && cat GEM_TAGS >> TAGS' | /bin/bash --login")))

(defun setup-safe-variables ()
  (setup-tags-variables))

(setup-safe-variables)

(provide 'safe-local-variables)
