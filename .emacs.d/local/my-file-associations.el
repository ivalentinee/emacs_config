;; my-file-associations.el

;; No comment

;; Setup markdown-mode for *.md
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Setup ruby-mode for Gemfile
(add-to-list 'auto-mode-alist '("\\Gemfile*\\'" . ruby-mode))

;; Setup ruby-mode for .jbuilder
(add-to-list 'auto-mode-alist '("\\.jbuilder\\'" . ruby-mode))

(provide 'my-file-associations)