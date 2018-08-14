;;; external-modules.el --- packages settings
;;; Commentary:

;;; Code
(require 'haml-mode)
(require 'coffee-mode)

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

;; Aggressive indent
(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
(add-hook 'lisp-mode-hook #'aggressive-indent-mode)
(add-hook 'slime-mode-hook #'aggressive-indent-mode)

;; company-mode
(add-hook 'prog-mode-hook (lambda () (company-mode)))
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

;; avy
(define-key global-map (kbd "C-c C-SPC") 'avy-goto-word-1)
(define-key global-map (kbd "C-c SPC") 'avy-goto-char)

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
(global-set-key (kbd "C-x b") 'helm-buffers-list)

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
(add-hook 'org-mode-hook (lambda () (setq word-wrap t)))
(setq org-startup-indented 1)
(setq org-startup-truncated nil)
(setq org-src-fontify-natively t)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-ca" 'org-agenda)

;; Goto last change
(global-set-key "\C-x\C-\\" 'goto-last-change)

;; macro-math
(global-set-key "\C-x=" 'macro-math-eval-region)

;; Anzu
(global-anzu-mode +1)

;; web-mode
(require 'web-mode)
(add-hook 'web-mode-hook
          (lambda ()
            ;; short circuit js mode and just do everything in jsx-mode
            (if (equal web-mode-content-type "javascript")
                (web-mode-set-content-type "jsx")
              (message "now set to: %s" web-mode-content-type))))

;; flycheck
(require 'flycheck)
(flycheck-add-mode 'typescript-tslint 'web-mode)

;; js-mode
(setq js-indent-level 2)

;; js2-mode
(setq js2-strict-trailing-comma-warning nil)

(require 'git-bindings)
(require 'yas-settings)

(provide 'external-modules)

;; alchemist
(setq alchemist-mix-command "/usr/local/bin/docker-compose run --rm web mix")
(setq alchemist-iex-program-name "/usr/local/bin/docker-compose run --rm web iex")
(setq alchemist-execute-command "/usr/local/bin/docker-compose run --rm web elixir")
(setq alchemist-compile-command "/usr/local/bin/docker-compose run --rm web elixirc")

;; magit
(require 'magit-process nil t)
(add-hook
 'magit-mode-hook
 (lambda ()
   (magit-add-section-hook 'magit-status-sections-hook
                        'magit-insert-unpushed-to-upstream
                        'magit-insert-unpushed-to-upstream-or-recent
                        'replace)))

;;; external-modules.el ends here
