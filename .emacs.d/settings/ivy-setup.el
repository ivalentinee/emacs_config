;;; ivy-setup.el --- packages settings
;;; Commentary:

;;; Code:

(ivy-mode)
(setopt ivy-use-virtual-buffers t)
(setopt enable-recursive-minibuffers t)

;; Swiper
(keymap-global-set "C-s" #'swiper-isearch)
(keymap-global-set "M-x" #'counsel-M-x)
(keymap-global-set "C-x C-f" #'counsel-find-file)

;; Swiper Line Face

(defun ivy-apply-dark-theme ()
  "applies dark theme to ivy buffers"
  (interactive)
  (set-face-attribute 'ivy-current-match nil
                      :background "grey12"
                      :foreground nil)
  (set-face-attribute 'ivy-minibuffer-match-face-2 nil
                      :background "#ce5c00"
                      :foreground nil)
  (set-face-attribute 'ivy-minibuffer-match-face-3 nil
                      :background "#ce5c00"
                      :foreground nil)
  (set-face-attribute 'ivy-minibuffer-match-face-4 nil
                      :background "#ce5c00"
                      :foreground nil))

(defun ivy-apply-light-theme ()
  "applies dark theme to ivy buffers"
  (interactive)
  (set-face-attribute 'ivy-current-match nil
                      :background "grey"
                      :foreground nil)
  (set-face-attribute 'ivy-minibuffer-match-face-2 nil
                      :background "#77A4DD"
                      :foreground nil)
  (set-face-attribute 'ivy-minibuffer-match-face-3 nil
                      :background "#77A4DD"
                      :foreground nil)
  (set-face-attribute 'ivy-minibuffer-match-face-4 nil
                      :background "#77A4DD"
                      :foreground nil))

(provide 'ivy-setup)
;;; ivy-setup.el ends here
