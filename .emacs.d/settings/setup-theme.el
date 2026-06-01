(defvar custom-default-font "Liberation Mono 13")

(defvar dark-theme 'tango-dark)
(defvar light-theme 'adwaita)

(defun set-custom-font (custom-font)
  (add-to-list 'default-frame-alist (cons 'font custom-font))
  (set-frame-font custom-font))

(defun go-to-dark ()
  "setup light-on-dark colors"
  (interactive)
  (disable-theme light-theme)
  (set-face-foreground 'highlight nil)
  (set-face-background 'highlight "grey12")
  (set-face-foreground 'hl-line nil)
  (set-face-background 'hl-line "black")
  (load-theme dark-theme)
  ;; (set-face-background 'isearch "#ce5c00")
  ;; (set-face-foreground 'isearch "#eeeeec")
  (sml/apply-theme "dark")
  (ivy-apply-dark-theme))

(defun go-to-light ()
  "setup dark-on-light colors"
  (interactive)
  (disable-theme dark-theme)
  (set-face-foreground 'highlight nil)
  (set-face-background 'highlight "grey")
  (set-face-foreground 'hl-line nil)
  (set-face-background 'hl-line "gainsboro")
  (load-theme light-theme)
  ;; (set-face-background 'isearch "yellow")
  ;; (set-face-foreground 'isearch nil)
  (sml/apply-theme "light")
  (ivy-apply-light-theme))

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
  (sml/apply-theme "respectful"))

(set-custom-font custom-default-font)

(if window-system (go-to-dark) (go-to-terminal))

(provide 'setup-theme)
