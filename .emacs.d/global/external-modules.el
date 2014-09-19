;; external-modules.el

(require 'haml-mode)
(require 'coffee-mode)

;; Disable linum-mode for some modes
(require 'linum-off)

;; 80-character line
;; (require 'fill-column-indicator)
;; (add-hook 'emacs-lisp-mode-hook 'fci-mode)
;; (add-hook 'c-mode-hook 'fci-mode)
;; (add-hook 'ruby-mode-hook 'fci-mode)
;; (add-hook 'tuareg-mode-hook 'fci-mode)
;; (add-hook 'haskell-mode-hook 'fci-mode)

;; ruby-block
(require 'ruby-block)
(ruby-block-mode t)

;; expand-region
(global-set-key (kbd "C-=") 'er/expand-region)

;; dired-details
(require 'dired-details)
(dired-details-install)
(setq dired-details-hidden-string "[...] ")

;; SCSS
(setq scss-compile-at-save nil)

;; javascript
(add-hook 'js-mode-hook 'js2-minor-mode)

;; Cua-mode
(cua-selection-mode t)

;; Multi-term
(require 'multi-term)
(setq multi-term-program "/bin/bash")

;; Auto complete
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(require 'auto-complete-config)
(ac-config-default)
(require 'auto-complete-exuberant-ctags)
(ac-exuberant-ctags-setup)
(auto-complete-mode t)

;; ace-jump
(define-key global-map (kbd "C-c C-SPC") 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; Parentheses mode
(require 'highlight-parentheses)
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

;; Autopair
(add-to-list 'load-path "~/.emacs.d/autopair")
(require 'autopair)
(autopair-global-mode)
(setq autopair-autowrap t)

;; string-inflection (Camelcase)
(require 'string-inflection)
(define-key global-map (kbd "C-c i u") 'string-inflection-underscore)
(define-key global-map (kbd "C-c i c") 'string-inflection-camelcase)
(define-key global-map (kbd "C-c i U") 'string-inflection-upcase)

;; Projectile
(projectile-global-mode)
(global-set-key "\C-c\C-f" 'projectile-find-file)
(setq projectile-tags-command "exuberant-ctags -Re -f %s %s")
;; projectile-rails
(add-hook 'projectile-mode-hook 'projectile-rails-on)

;; IDO
(ido-mode t)
(ido-vertical-mode t)

;; flx-ido
(flx-ido-mode 1)
(setq flx-ido-use-faces nil)

;; SMEX (IDO M-x)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key "\C-c\C-m" 'smex)

;; ibuffer-vc
(add-hook 'ibuffer-hook
  (lambda ()
    (ibuffer-vc-set-filter-groups-by-vc-root)
      (unless (eq ibuffer-sorting-mode 'alphabetic)
        (ibuffer-do-sort-by-alphabetic))))

;; Direx-project
(require 'direx-project)
(global-set-key (kbd "C-x C-j") 'direx-project:jump-to-project-root)
(global-set-key (kbd "C-x C-d") 'direx:find-directory)

;; Org-mode
(add-hook 'org-mode-hook (lambda () (setq truncate-lines t)))
(setq org-startup-indented 1)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-ca" 'org-agenda)

;; google-translate
(require 'google-translate)
(global-set-key "\C-ct" 'google-translate-at-point)
(global-set-key "\C-cT" 'google-translate-query-translate)

;; w3m
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(setq w3m-use-cookies t)

;; List Registers
(require 'list-register)
(global-set-key (kbd "C-x r v") 'list-register)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

;; Goto last change
(global-set-key "\C-x\C-\\" 'goto-last-change)

;; macro-math
(global-set-key "\C-x=" 'macro-math-eval-region)

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(require 'git-bindings)
(require 'yas-settings)

(provide 'external-modules)
