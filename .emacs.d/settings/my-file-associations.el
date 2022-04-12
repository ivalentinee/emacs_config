;; my-file-associations.el

;; No comment

;; Setup markdown-mode for *.md
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.apib\\'" . markdown-mode))

;; Setup ruby-mode for all ruby files
(add-to-list 'auto-mode-alist
             '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
(add-to-list 'auto-mode-alist
               '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))

(add-to-list 'auto-mode-alist '("\\.sibilant\\'" . lisp-mode))

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tsx$" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.cts$" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.mts$" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html.eex\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html.leex\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html.heex\\'" . web-mode))

(add-to-list 'auto-mode-alist '("Dockerfile" . conf-space-mode))
(add-to-list 'auto-mode-alist '("\\..*ignore" . conf-space-mode))

(add-to-list 'auto-mode-alist '("\\.restclient$" . restclient-mode))

(add-to-list 'auto-mode-alist '("\\.po$" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.pot$" . conf-mode))


(provide 'my-file-associations)
