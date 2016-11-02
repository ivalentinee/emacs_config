;; external-modules.el

(require 'haml-mode)
(require 'coffee-mode)

;; 80-character line
(require 'fill-column-indicator)
(add-hook 'emacs-lisp-mode-hook 'fci-mode)
(add-hook 'c-mode-hook 'fci-mode)
(add-hook 'ruby-mode-hook 'fci-mode)
(add-hook 'tuareg-mode-hook 'fci-mode)
(add-hook 'haskell-mode-hook 'fci-mode)
(add-hook 'js2-mode-hook 'fci-mode)

;; ruby-block
(require 'ruby-block)
(ruby-block-mode t)

;; rubocop-mode for ruby
(add-hook 'ruby-mode-hook #'rubocop-mode)

;; expand-region
(global-set-key (kbd "C-=") 'er/expand-region)

;; dired-details
(require 'dired-details)
(dired-details-install)
(setq dired-details-hidden-string "[...] ")

;; Smart Mode Line
(sml/setup)
(sml/apply-theme 'dark)

;; SCSS
(setq scss-compile-at-save nil)

;; Cua-mode
(cua-selection-mode t)

;; Auto complete
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(require 'auto-complete-config)
(ac-config-default)
(auto-complete-mode t)

;; Aggressive indent
(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
(add-hook 'lisp-mode-hook #'aggressive-indent-mode)
(add-hook 'slime-mode-hook #'aggressive-indent-mode)

;; ace-jump
(define-key global-map (kbd "C-c C-SPC") 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; dumb-jump
(dumb-jump-mode)

;; Parentheses mode
(require 'highlight-parentheses)
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

;; slime
(require 'slime-autoloads)
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq slime-contribs '(slime-fancy))

;; Autopair
(add-to-list 'load-path "~/.emacs.d/autopair")
(require 'autopair)
(autopair-global-mode)
(setq autopair-autowrap t)

;; Paredit
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(global-set-key (kbd "C-x p f") 'paredit-forward-slurp-sexp)
(global-set-key (kbd "C-x p b") 'paredit-backward-slurp-sexp)

;; Disable autopair for paredit
(require 'paredit)
(defadvice paredit-mode (around disable-autopairs-around (arg))
  "Disable autopairs mode if paredit-mode is turned on"
  ad-do-it
  (if (null ad-return-value)
      (autopair-mode 1)
    (autopair-mode 0)
    ))
(ad-activate 'paredit-mode)

;; string-inflection (Camelcase)
(require 'string-inflection)
(define-key global-map (kbd "C-c i s") 'string-inflection-lower-camelcase)
(define-key global-map (kbd "C-c i u") 'string-inflection-underscore)
(define-key global-map (kbd "C-c i c") 'string-inflection-camelcase)
(define-key global-map (kbd "C-c i U") 'string-inflection-upcase)

;; Helm
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

;; multiple-cursors
(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-+") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Projectile
(projectile-global-mode)
(require 'helm-projectile)
(helm-projectile-on)
;; projectile-rails
(add-hook 'projectile-mode-hook 'projectile-rails-on)
(add-hook 'ruby-mode-hook 'projectile-rails-on)

;; Sr-Speedbar
(define-key global-map (kbd "C-c i u") 'string-inflection-underscore)
(setq sr-speedbar-right-side nil)
(setq speedbar-show-unknown-files t)
(global-set-key (kbd "C-c s") 'sr-speedbar-toggle)

;; IDO
;; (ido-mode t)
(ido-vertical-mode t)

;; flx-ido
(flx-ido-mode 1)
(setq flx-ido-use-faces nil)

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
(add-hook 'org-mode-hook (lambda () (setq word-wrap t)))
(setq org-startup-indented 1)
(setq org-src-fontify-natively t)
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

;; Anzu
(global-anzu-mode +1)

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            ;; short circuit js mode and just do everything in jsx-mode
            (if (equal web-mode-content-type "javascript")
                (web-mode-set-content-type "jsx")
              (message "now set to: %s" web-mode-content-type))))

;; js-mode
(setq js-indent-level 2)

(require 'git-bindings)
(require 'yas-settings)

(provide 'external-modules)
