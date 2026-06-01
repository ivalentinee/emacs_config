;;; flycheck-setups.el --- flycheck executable setups
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :commands lsp)

;; (use-package helm-lsp :commands helm-lsp-workspace-symbol)

(setq lsp-enable-symbol-highlighting nil)

;; (define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol)

;; To enable lsp for a project
;; create a `.dir-locals.el` file
;; with something like this:
;; ((typescript-mode . ((lsp-enabled-clients . (ts-ls eslint))
;;                      (eval lsp)))
;;  (yaml-mode . ((lsp-enabled-clients . (yamlls))
;;                (eval lsp)
;;                (eval prettier-js-mode))))



(provide 'use-lsp)
;;; flycheck-setups.el ends here
