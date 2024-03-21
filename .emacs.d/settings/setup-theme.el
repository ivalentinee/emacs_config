(require 'helm-custom-themes)

(defvar custom-default-font "Liberation Mono 13")

(defvar dark-client-theme 'deeper-blue)
(defvar dark-theme 'tango-dark)
(defvar light-client-theme 'adwaita)
(defvar light-theme 'flatui)

(defun set-custom-font (custom-font)
  (add-to-list 'default-frame-alist (cons 'font custom-font))
  (set-frame-font custom-font))

(defun go-to-dark ()
  "setup light-on-dark colors"
  (interactive)
  (disable-theme light-theme)
  (disable-theme light-client-theme)
  (set-face-foreground 'highlight nil)
  (set-face-background 'hl-line "black")
  (if (daemonp)
      (load-theme dark-client-theme)
    (if window-system (load-theme dark-theme)))
  (sml/apply-theme "dark")
  (helm-apply-dark-theme))

(defun go-to-light ()
  "setup dark-on-light colors"
  (interactive)
  (disable-theme dark-theme)
  (disable-theme dark-client-theme)
  (set-face-foreground 'highlight nil)
  (set-face-background 'hl-line "gainsboro")
  (if (daemonp)
      (load-theme light-client-theme)
    (if window-system (load-theme light-theme)))
  (sml/apply-theme "light")
  (helm-apply-light-theme))

(defun go-to-terminal-magit ()
  "setup colors for white-on-black terminal for magit"
  (add-hook 'magit-mode-hook (lambda () (progn (set-face-background 'magit-diff-context-highlight "#222")
                                               (set-face-background 'magit-section-highlight "#333")
                                               (set-face-background 'magit-diff-hunk-heading-highlight "#555")
                                               (set-face-foreground 'magit-diff-hunk-heading-highlight "#fff")
                                               (set-face-background 'magit-diff-hunk-heading "#555")
                                               (set-face-foreground 'magit-diff-hunk-heading "#fff")
                                               (set-face-background 'magit-diff-removed "#111")
                                               (set-face-background 'magit-diff-removed-highlight "#111")
                                               (set-face-background 'magit-diff-added "#111")
                                               (set-face-background 'magit-diff-added-highlight "#111")))))

(defun go-to-terminal-highlight ()
  "setup colors for white-on-black terminal highlighting"
  (set-face-foreground 'highlight nil)
  (set-face-background 'hl-line "#111")
  (set-face-background 'region "#333")
  (set-face-attribute 'region nil :background "#222"))

(defun go-to-terminal-keys ()
  "(re)setup keys for terminal"
  (global-set-key (kbd "C-v") 'scroll-up)
  (global-set-key (kbd "M-v") 'scroll-down)
  (global-unset-key (kbd "C-h")))

(defun go-to-terminal ()
  "setup colors for white-on-black terminal"
  (interactive)
  (disable-theme dark-theme)
  (disable-theme dark-client-theme)
  (disable-theme light-theme)
  (disable-theme light-client-theme)
  (go-to-terminal-highlight)
  (go-to-terminal-magit)
  (go-to-terminal-keys)
  (sml/apply-theme "respectful")
  (helm-apply-terminal-theme))

(set-custom-font custom-default-font)

(if window-system (go-to-dark) (go-to-terminal))

(provide 'setup-theme)
