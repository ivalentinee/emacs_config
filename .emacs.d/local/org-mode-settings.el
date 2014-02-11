;; To save the clock history across Emacs
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;; Keys

(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key "C-c [" 'org-do-promote)
            (local-set-key "C-c ]" 'org-do-demote)
            (local-set-key "C-c {" 'org-promote-subtree)
            (local-set-key "C-c }" 'org-demote-subtree)
            (local-set-key "C-c h" 'org-insert-heading)))

(provide 'org-mode-settings)
