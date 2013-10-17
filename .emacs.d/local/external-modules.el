;; external-modules.el

(add-to-list 'load-path "~/.emacs.d/rinari")

(require 'haml-mode)
(require 'ruby-end)
(require 'coffee-mode)

;; Disable linum-mode for some modes
(require 'linum-off)

;; ruby-block
(require 'ruby-block)
(ruby-block-mode t)

;; rinari
(require 'rinari)
(global-rinari-mode)

;; Cua-mode
(cua-selection-mode t)

;; Multi-term
(require 'multi-term)
(setq multi-term-program "/bin/bash")

;; Auto complete
(require 'auto-complete-config)
(ac-config-default)
(auto-complete-mode)

;; Parentheses mode
(require 'highlight-parentheses)
(highlight-parentheses-mode)

;; Autopair
(add-to-list 'load-path "~/.emacs.d/autopair")
(require 'autopair)
(autopair-global-mode)
(setq autopair-autowrap t)

;; Textmate
(require 'textmate)
(textmate-mode)

;; Direx-project
(require 'direx-project)
(global-set-key (kbd "C-x C-j") 'direx-project:jump-to-project-root)
(global-set-key (kbd "C-x C-d") 'direx:find-directory)

;; Org-mode
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-ca" 'org-agenda)

;; w3m
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(setq w3m-use-cookies t)

;; List Registers
(require 'list-register)
(global-set-key (kbd "C-x r v") 'list-register)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(provide 'external-modules)