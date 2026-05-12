(load "adventurer-common")
(load "adventurer-collect")

(defun adventurer/build-document/demote-headings (md-document)
  (string-replace "# " "## " md-document))

(defun adventurer/build-document/export-to-md (insert-data)
  (let ((org-export-show-temporary-export-buffer nil))
    (with-temp-buffer
      (let ((org-inhibit-startup t)) (org-mode))
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

(defun adventurer/build-document/strip-drawer (name body)
  (let ((result body)
        (regexp (format ":%s:\n\\(?:.*\n\\)*?:END:\n?" name)))
    (while (string-match regexp result)
      (setq result (replace-match "" t t result)))
    result))

(defun adventurer/build-document/extract-drawer (name body)
  (let ((regexp (format ":%s:\n\\(\\(?:.*\n\\)*?\\):END:\n?" name))
        (contents nil))
    (while (string-match regexp body)
      (push (match-string 1 body) contents)
      (setq body (substring body (match-end 0))))
    (string-join (nreverse contents) "\n")))

(defun adventurer/build-document/find-extra-heading-end (body start)
  "Find the end position of an [EXTRA] section starting at START."
  (let ((pos (string-match "\n\\*\\{1,3\\} [^[]" body (1+ start))))
    (or pos (length body))))

(defun adventurer/build-document/strip-extra-headings (body)
  (let ((result body))
    (while (string-match "\\*\\*\\* \\[EXTRA\\][^\n]*\n" result)
      (let* ((section-start (match-beginning 0))
             (section-end (adventurer/build-document/find-extra-heading-end result section-start)))
        (setq result (concat (substring result 0 section-start) (substring result section-end)))))
    result))

(defun adventurer/build-document/clean-extra-tags (text)
  (replace-regexp-in-string "\\*\\*\\* \\[EXTRA\\] ?" "*** " text))

(defun adventurer/build-document/extract-extra-headings (body)
  (let ((contents nil)
        (search-from 0))
    (while (string-match "\\*\\*\\* \\[EXTRA\\] ?\\([^\n]*\\)\n" body search-from)
      (let* ((heading (match-string 1 body))
             (content-start (match-end 0))
             (section-end (adventurer/build-document/find-extra-heading-end body (match-beginning 0)))
             (content (substring body content-start section-end))
             (section (if (string-empty-p (string-trim heading))
                          content
                        (concat "*** " heading "\n" content))))
        (push section contents)
        (setq search-from section-end)))
    (adventurer/build-document/clean-extra-tags
     (string-join (nreverse contents) "\n"))))

(defun adventurer/build-document/without-properties (body)
  (adventurer/build-document/strip-drawer "PROPERTIES" body))

(defun adventurer/build-document/without-extra (body)
  (adventurer/build-document/strip-extra-headings
   (adventurer/build-document/strip-drawer "EXTRA" body)))

(defun adventurer/build-document/extract-all-extra (body)
  (let ((drawer-extra (adventurer/build-document/extract-drawer "EXTRA" body))
        (heading-extra (adventurer/build-document/extract-extra-headings body)))
    (string-join (seq-filter (lambda (s) (not (string-empty-p (string-trim s))))
                             (list drawer-extra heading-extra)) "\n")))

(defun adventurer/build-document/has-extra-p (body)
  (let ((extra (adventurer/build-document/extract-all-extra body)))
    (and extra (not (string-empty-p (string-trim extra))))))

(defun adventurer/build-document/insert-scene-meta (scene body)
  (let* ((id (alist-get 'id scene))
         (music (alist-get 'music scene))
         (has-music (and music (not (string-empty-p (string-trim music)))))
         (has-extra (adventurer/build-document/has-extra-p body))
         (parts (seq-filter #'identity
                  (list (when has-music (format "Музыка: %s" music))
                        (when has-extra (format "<a class=\"ref-extra\" href=\"#extra-%s\">→ Прил.</a>" id))))))
    (when parts
      (insert (format "\n\n/%s/\n" (string-join parts " | "))))))

(defun adventurer/build-document/insert-scene (scene)
  (let ((id (alist-get 'id scene)))
    (adventurer/build-document/insert-nobreak-start)
    (insert (format "\n<a id=\"scene-%s\"></a>\n" id))
    (insert (format "\n** %s\n" (alist-get 'title scene)))
    (let ((body (adventurer/build-document/without-properties (alist-get 'body scene))))
      (adventurer/build-document/insert-scene-meta scene body)
      (insert (adventurer/build-document/without-extra body)))
    (adventurer/build-document/insert-nobreak-end)))

(defun adventurer/build-document/build-scenes (scene-entries)
  (adventurer/build-document/export-to-md
   (lambda ()
     (adventurer/build-document/insert-page-break)
     (insert "\n* Сцены\n")
     (mapcar 'adventurer/build-document/insert-scene scene-entries))))

(defun adventurer/build-document/build-statblocks (statblocks-text)
  (when (and statblocks-text (not (string-empty-p (string-trim statblocks-text))))
    (adventurer/build-document/export-to-md
     (lambda ()
       (adventurer/build-document/insert-page-break)
       (insert "\n* Статблоки\n")
       (let* ((cleaned (adventurer/build-document/without-properties statblocks-text))
              (promoted (string-replace "***" "*****" cleaned))
              (with-nobreaks (replace-regexp-in-string
                              "\n\\*\\* "
                              "\n\n</div>\n\n<div class=\"nobreak\">\n\n** "
                              promoted)))
         (insert "\n<div class=\"nobreak\">\n")
         (insert with-nobreaks)
         (insert "\n\n</div>\n"))))))

(defun adventurer/build-document/insert-appendix-scene (scene)
  (let* ((id (alist-get 'id scene))
         (body (adventurer/build-document/without-properties (alist-get 'body scene)))
         (extra (adventurer/build-document/extract-all-extra body)))
    (when (and extra (not (string-empty-p (string-trim extra))))
      (adventurer/build-document/insert-nobreak-start)
      (insert (format "\n<a id=\"extra-%s\"></a>\n" id))
      (insert (format "\n** %s\n" (alist-get 'title scene)))
      (insert (format "\n/<a class=\"ref-scene\" href=\"#scene-%s\">← Сцена</a>/\n\n" id))
      (insert extra)
      (adventurer/build-document/insert-nobreak-end))))

(defun adventurer/build-document/build-appendix (scene-entries)
  (let ((md (adventurer/build-document/export-to-md
             (lambda ()
               (adventurer/build-document/insert-page-break)
               (insert "\n* Приложение\n")
               (mapcar 'adventurer/build-document/insert-appendix-scene scene-entries)))))
    (if (string-match-p "\\*\\*" md) md "")))

(defun adventurer/build-document/build-pdf (title)
  (let ((input-path (adventurer/compose-filename "md"))
        (output-path (adventurer/compose-filename "pdf"))
        (css-path (concat (adventurer/get-script-path) "/" "adventurer-weasyprint.css")))
    (shell-command (format "/usr/bin/pandoc --metadata title=\"%s\" --from=markdown --to=pdf '%s' --output '%s' --pdf-engine=weasyprint --css '%s' %s" title input-path output-path css-path (adventurer/ignore-shell-output)))))

(defun adventurer/build-document/clear ()
  (when (file-exists-p (adventurer/compose-filename "md"))
    (delete-file (adventurer/compose-filename "md")))
  (when (file-exists-p (adventurer/compose-filename "pdf"))
    (delete-file (adventurer/compose-filename "pdf"))))

(defun adventurer/build-document (scenes)
  (let* ((title (org-get-title))
         (description (adventurer/collect-description))
         (prepare (adventurer/collect-prepare))
         (statblocks (adventurer/collect-statblocks))
         (md-description (adventurer/build-document/build-description description))
         (md-prepare (adventurer/build-document/build-prepare prepare))
         (md-xp (adventurer/build-document/build-xp scenes))
         (md-scenes (adventurer/build-document/build-scenes scenes))
         (md-statblocks (adventurer/build-document/build-statblocks statblocks))
         (md-appendix (adventurer/build-document/build-appendix scenes))
         (md-image (format "<img class=\"graph\" src=\"./%s\" />" (adventurer/compose-filename "png")))
         (md-parts (seq-filter (lambda (s) (and s (not (string-empty-p s))))
                               (list md-description md-prepare md-image md-xp md-scenes md-statblocks md-appendix)))
         (md-document (adventurer/build-document/demote-headings (string-join md-parts "\n\n"))))
    (write-region md-document nil (adventurer/compose-filename "md"))
    (adventurer/build-document/build-pdf title)))
