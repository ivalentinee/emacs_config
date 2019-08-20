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

(defun helm-apply-dark-theme ()
  "applies dark theme to helm buffers"
  (interactive)
  (set-face-attribute 'helm-match nil
                      :background nil
                      :foreground "gold1"))

(defun helm-apply-terminal-theme ()
  "applies dark theme to helm buffers"
  (interactive)
  (set-face-attribute 'helm-match nil
                      :background nil
                      :foreground "gold1")
  (set-face-attribute 'helm-selection nil
                      :background "dark blue"
                      :foreground "grey")
  (set-face-attribute 'helm-ff-file nil
                      :background nil
                      :foreground "grey")
  (set-face-attribute 'helm-ff-dotted-directory nil
                      :background "brown"
                      :foreground "grey")
  (set-face-attribute 'helm-visible-mark nil
                      :background nil
                      :foreground "deep sky blue"))

(provide 'helm-custom-themes)
