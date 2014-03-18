;; allow dired to be able to delete or copy a whole dir.
(setq dired-recursive-copies (quote always))
(setq dired-recursive-deletes (quote top))

;; copy to other dired buffer
(setq dired-dwim-target t)

(provide 'dired-settings)
