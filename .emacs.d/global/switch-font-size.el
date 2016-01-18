;;; shoult get it from current face
(defvar *normal-font-size* 139)
(defvar *enlarged-font-size* 200)
(defvar *current-font-size-mode* "normal")

(defun set-enlarged-font ()
  (setf *current-font-size-mode* "enlarged")
  (set-face-attribute 'default nil :height *enlarged-font-size*))

(defun set-normal-font ()
  (setf *current-font-size-mode* "normal")
  (set-face-attribute 'default nil :height *normal-font-size*))

(defun switch-font-size ()
  "switch between normal and large font sizes"
  (interactive)
  (if (equalp *current-font-size-mode* "normal")
      (set-enlarged-font)
    (set-normal-font)))

(provide 'switch-font-size)
