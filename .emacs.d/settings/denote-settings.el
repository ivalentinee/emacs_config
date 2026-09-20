;;; denote-settings.el --- settings for denote
;;; Commentary:

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c d n") 'denote)
  (define-key org-mode-map (kbd "C-c d f") 'denote-open-or-create)
  (define-key org-mode-map (kbd "C-c d k") 'denote-rename-file-keywords)
  (define-key org-mode-map (kbd "C-c d i") 'denote-rename-file-identifier)
  (define-key org-mode-map (kbd "C-c d l l") 'denote-link)
  (define-key org-mode-map (kbd "C-c d l h") 'denote-org-link-to-heading)
  (define-key org-mode-map (kbd "C-c d l b") 'denote-backlinks)
  (define-key org-mode-map (kbd "C-c d g") 'denote-graph/build))

(defvar-local denote-id-type nil)
(put 'denote-id-type 'safe-local-variable
     (lambda (val) (memq val '(uuid numeric nil t))))

(defun denote-20-digit-numeric-id ()
  (let ((num-str ""))
    (dotimes (_ 20)
      (setq num-str (concat num-str (number-to-string (random 10)))))
    num-str))

(defun denote-custom-identifier (initial-identifier date)
  "Generate custom identifiers based on `my-denote-identifier-type'."
  (cond
   ((eq denote-id-type 'uuid)
    (if (fboundp 'uuidgen-4)
        (concat "@@" (uuidgen-4))
      (concat "@@" (string-trim (shell-command-to-string "uuidgen")))))

   ((eq denote-id-type 'numeric)
    (concat "@@" (denote-20-digit-numeric-id)))

   (t
    (denote-get-identifier date))))

(setq denote-get-identifier-function #'denote-custom-identifier)

(provide 'denote-settings)
;;; denote-settings.el ends here
