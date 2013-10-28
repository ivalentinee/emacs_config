;; my-file-associations.el

;; No comment

;; Setup markdown-mode for *.md
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Setup ruby-mode for all ruby files
(add-to-list 'auto-mode-alist
               '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
(add-to-list 'auto-mode-alist
               '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))

(provide 'my-file-associations)
