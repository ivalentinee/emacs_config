;;; projectile-addons.el --- packages settings
;;; Commentary:

;;; Code:

(require 'projectile)
(require 'cl-lib)

(defun projectile-get-file-name ()
  (if (and
       (fboundp 'projectile-project-root)
       (string-prefix-p (projectile-project-root) (buffer-file-name)))
      (substring (buffer-file-name)
                 (length (projectile-project-root))
                 (length (buffer-file-name)))))

(defun projectile-insert-file-name ()
  "Insert current buffer project filename"
  (interactive)
  (let ((projectile-file-name (projectile-get-file-name)))
    (if projectile-file-name
        (insert projectile-file-name))))

(defun projectile-copy-file-name ()
  "Insert current buffer project filename"
  (interactive)
  (let ((projectile-file-name (projectile-get-file-name)))
    (if projectile-file-name
        (kill-new projectile-file-name))))

(defvar *projectile-format-fun* nil)
(make-local-variable '*projectile-format-fun*)

(defun projectile-format-file ()
  "Performs automatic formatting for current buffer file"
  (interactive)
  (if *projectile-format-fun*
      (let ((projectile-file-name (projectile-get-file-name)))
        (if projectile-file-name
            (projectile-with-default-dir (projectile-acquire-root)
              (apply 'start-process
                     (append '("projectile-format" nil) (apply *projectile-format-fun* (list projectile-file-name)))))))))

(defun projectile-do-ag ()
  "Perform interactive ag search in the project"
  (interactive)
  (if (projectile-project-root)
      (counsel-ag (thing-at-point 'symbol t) (projectile-project-root))
    (error "Not in a project")))

;; NOTE: this is written by Claude, I hope it works
(defun projectile-replace-non-interactive ()
  "Replace all occurrences in projectile project files without confirmation.

Prompts for string vs regex mode, a search pattern, and a replacement.
Only files returned by `projectile-project-files' are touched.
Already-open buffers are reused and left open; other files are opened
temporarily and killed after replacement."
  (interactive)
  (unless (projectile-project-p)
    (user-error "Not in a projectile project"))
  (let* ((use-regex (y-or-n-p "Use regex? "))
         (search (read-string (if use-regex "Regex to replace: " "String to replace: ")))
         (_ (when (string-empty-p search)
              (user-error "Search pattern cannot be empty")))
         (replacement (read-string (format "Replace \"%s\" with: " search)))
         (project-root (projectile-project-root))
         (files (projectile-project-files project-root))
         (modified-count 0)
         (match-count 0))
    (dolist (rel-path files)
      (let* ((full-path (expand-file-name rel-path project-root))
             (existing-buffer (find-buffer-visiting full-path)))
        (when (file-regular-p full-path)
          (if existing-buffer
              ;; Already open — replace in the live buffer.
              (with-current-buffer existing-buffer
                (save-excursion
                  (goto-char (point-min))
                  (let ((file-matches 0))
                    (if use-regex
                        (while (re-search-forward search nil t)
                          (replace-match replacement nil nil)
                          (cl-incf file-matches))
                      (while (search-forward search nil t)
                        (replace-match replacement t t)
                        (cl-incf file-matches)))
                    (when (> file-matches 0)
                      (cl-incf modified-count)
                      (cl-incf match-count file-matches)
                      (save-buffer)))))
            ;; Not open — use a temp buffer; no visiting, no hooks, no modes.
            (with-temp-buffer
              (insert-file-contents full-path)
              (goto-char (point-min))
              (let ((file-matches 0))
                (if use-regex
                    (while (re-search-forward search nil t)
                      (replace-match replacement nil nil)
                      (cl-incf file-matches))
                  (while (search-forward search nil t)
                    (replace-match replacement t t)
                    (cl-incf file-matches)))
                (when (> file-matches 0)
                  (cl-incf modified-count)
                  (cl-incf match-count file-matches)
                  (write-region (point-min) (point-max) full-path nil 'silent))))))))
    (message "Replaced %d occurrence(s) in %d file(s)" match-count modified-count)))

(provide 'projectile-addons)
;;; package-settings.el ends here
