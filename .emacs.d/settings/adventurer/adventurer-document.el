(load "adventurer-common")
(load "adventurer-collect")

(defun adventurer/build-document/demote-headings (md-document)
  (string-replace "# " "## " md-document))

(defun adventurer/build-document/export-to-md (insert-data)
  (let ((org-export-show-temporary-export-buffer nil))
    (with-temp-buffer
      (org-mode)
      (erase-buffer)
      (beginning-of-buffer)
      (insert "#+OPTIONS: toc:nil\n")
      (funcall insert-data)
      (org-md-export-as-markdown)
      (with-current-buffer "*Org MD Export*" (buffer-string)))))

(defun adventurer/build-document/insert-page-break ()
  (insert "\n<div style=\"page-break-after: always;\"></div>\n"))

(defun adventurer/build-document/insert-nobreak-start ()
  (insert "\n\n<div class=\"nobreak\">\n"))

(defun adventurer/build-document/insert-nobreak-end ()
  (insert "\n\n</div>\n"))

(defun adventurer/build-document/build-description (description)
  (adventurer/build-document/export-to-md
   (lambda ()
     (adventurer/build-document/insert-nobreak-start)
     (insert "\n* Короткое описание\n")
     (insert description)
     (adventurer/build-document/insert-nobreak-end))))

(defun adventurer/build-document/build-prepare (prepare)
  (let ((raw-md (adventurer/build-document/export-to-md
                 (lambda ()
                   (adventurer/build-document/insert-nobreak-start)
                   (insert "\n* Подготовить\n")
                   (insert (string-replace "***" "*****" prepare))
                   (adventurer/build-document/insert-nobreak-end)))))
    (string-replace "\n\n" "\n" raw-md)))

(defun adventurer/build-document/insert-scene-xp (scene)
  (when (and (listp (alist-get 'xp scene)) (length> (alist-get 'xp scene) 0))
    (insert (format "\n*** %s\n" (alist-get 'title scene)))
    (mapcar
     #'(lambda (xp-entry) (insert (format "- □ *%s* %s\n" (alist-get 'xp-string xp-entry) (alist-get 'description xp-entry))))
     (alist-get 'xp scene))))

(defun adventurer/build-document/build-xp (scene-entries)
  (adventurer/build-document/export-to-md
   (lambda ()
     (adventurer/build-document/insert-nobreak-start)
     (insert "\n* Опыт\n")
     (mapcar 'adventurer/build-document/insert-scene-xp scene-entries)
     (adventurer/build-document/insert-nobreak-end))))

(defun adventurer/build-document/without-properties (body)
  (replace-regexp-in-string ":PROPERTIES:\\(.\\|\n\\)+:END:" "" body))

(defun adventurer/build-document/insert-scene (scene)
  (adventurer/build-document/insert-nobreak-start)
  (insert (format "\n** %s\n" (alist-get 'title scene)))
  (when (alist-get 'music scene) (insert (format "\n\n/Музыка: %s/\n" (alist-get 'music scene))))
  (insert (adventurer/build-document/without-properties (alist-get 'body scene)))
  (adventurer/build-document/insert-nobreak-end))

(defun adventurer/build-document/build-scenes (scene-entries)
  (adventurer/build-document/export-to-md
   (lambda ()
     (adventurer/build-document/insert-page-break)
     (insert "\n* Сцены\n")
     (mapcar 'adventurer/build-document/insert-scene scene-entries))))

(defun adventurer/build-document/build-pdf (title)
  (let ((input-path (adventurer/compose-filename "md"))
        (output-path (adventurer/compose-filename "pdf"))
        (css-path (concat (adventurer/get-script-path) "/" "adventurer-weasyprint.css")))
    (shell-command (format "/usr/bin/pandoc --metadata title=\"%s\" --from=markdown --to=pdf '%s' --output '%s' --pdf-engine=weasyprint --css '%s' %s" title input-path output-path css-path (adventurer/ignore-shell-output)))))

(defun adventurer/build-document/clear ()
  (delete-file (adventurer/compose-filename "md"))
  (delete-file (adventurer/compose-filename "pdf")))

(defun adventurer/build-document (scenes)
  (let* ((description (adventurer/collect-description))
         (prepare (adventurer/collect-prepare))
         (md-description (adventurer/build-document/build-description description))
         (md-prepare (adventurer/build-document/build-prepare prepare))
         (md-xp (adventurer/build-document/build-xp scenes))
         (md-scenes (adventurer/build-document/build-scenes scenes))
         (md-image (format "<img class=\"graph\" src=\"./%s\" />" (adventurer/compose-filename "png")))
         (md-document (string-join `(,md-description ,md-prepare ,md-image ,md-xp ,md-scenes) "\n\n"))
         (md-document-with-proper-headings (adventurer/build-document/demote-headings md-document)))
    (message (format "current file: %s" (adventurer/get-script-path)))
    (write-region md-document-with-proper-headings nil (adventurer/compose-filename "md"))
    (adventurer/build-document/build-pdf (org-get-title))))
