(defun helm-apply-light-theme ()
  "applies light theme to helm buffers"
  (interactive)
  (set-face-attribute 'helm-selection nil
                      :background "gainsboro"
                      :foreground "black")
  (set-face-attribute 'helm-ff-file nil
                      :background nil
                      :foreground "black")
  (set-face-attribute 'helm-visible-mark nil
                      :background nil
                      :foreground "deep sky blue")
  (set-face-attribute 'helm-match nil
                      :background "powder blue"
                      :foreground "black"))

(provide 'helm-custom-themes)
