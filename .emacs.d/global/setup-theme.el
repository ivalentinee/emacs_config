(require 'helm-custom-themes)

(defvar dark-client-theme 'deeper-blue)
(defvar dark-theme 'tango-dark)
(defvar light-theme 'flatui)

(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (load-theme dark-client-theme)))
  (if window-system (load-theme dark-theme)))

(defun go-to-dark ()
  "setup light-on-dark colors"
  (interactive)
  (disable-theme light-theme)
  (if (daemonp)
      (load-theme dark-client-theme)
    (if window-system (load-theme dark-theme)))
  (helm-apply-dark-theme))

(defun go-to-light ()
  "setup dark-on-light colors"
  (interactive)
  (disable-theme dark-theme)
  (disable-theme dark-client-theme)
  (load-theme light-theme)
  (helm-apply-light-theme))


(defun go-to-terminal ()
  "setup colors for white-on-black terminal"
  (interactive)
  (disable-theme dark-theme)
  (disable-theme dark-client-theme)
  (disable-theme light-theme)
  (sml/apply-theme "respectful")
  (helm-apply-terminal-theme))


(go-to-dark)

(provide 'setup-theme)
