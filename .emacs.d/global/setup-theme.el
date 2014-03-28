(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (load-theme 'deeper-blue)))
  (if window-system (load-theme 'tango-dark)))

(provide 'setup-theme)
