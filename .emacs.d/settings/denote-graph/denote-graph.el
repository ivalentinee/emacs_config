;;; denote-graph.el --- denote link graph render
;;; Commentary:

(require 'denote)
(require 'dash)
(load "denote-graph-html")

(defvar-local denote-graph-excluded-tags '())
(put 'denote-graph-excluded-tags 'safe-local-variable
     (lambda (val) (and (listp val) (seq-every-p #'stringp val))))

(defvar-local denote-graph-build-dir nil)
(put 'denote-graph-build-dir 'safe-local-variable 'stringp)

(defvar-local denote-graph-url-prefix "")
(put 'denote-graph-url-prefix 'safe-local-variable 'stringp)

(defvar-local denote-graph-palette ())
(put 'denote-graph-palette 'safe-local-variable
     (lambda (val) (and (listp val) (seq-every-p #'(lambda (item) (and (stringp (car item)) (stringp (cdr item)))) val))))

(defun denote-graph/build ()
  "Build denote graph"
  (interactive)
  (when (stringp denote-graph-build-dir)
    (let* ((denote-graph-dot-path (file-name-concat denote-graph-build-dir "graph.dot"))
           (denote-graph-svg-path (file-name-concat denote-graph-build-dir "graph.svg"))
           (denote-files (denote-graph/get-files denote-graph-excluded-tags))
           (denote-links (denote-graph/collect-links denote-files)))
      (make-directory denote-graph-build-dir t)
      (write-region
       (format "graph DetectiveBoard {\n%s\n\n%s\n\n%s\n}"
               (denote-graph/graphviz-setup)
               (denote-graph/graphviz-nodes denote-files denote-graph-url-prefix denote-graph-palette)
               (denote-graph/graphviz-links denote-links))
       nil
       denote-graph-dot-path)
      (shell-command (format "%s -Tsvg '%s' -o '%s'" "/usr/bin/neato" denote-graph-dot-path denote-graph-svg-path))
      (denote-graph/html/export (denote-directory-files) denote-graph-build-dir denote-graph-url-prefix))))

(defun denote-graph/get-files (excluded-tags)
  (seq-filter
   #'(lambda (filename)
       (not (seq-intersection (denote-extract-keywords-from-path filename) excluded-tags)))
   (denote-directory-files)))

(defun denote-graph/collect-links (denote-files)
  (let ((denote-ids (mapcar 'denote-retrieve-filename-identifier denote-files))
        (denote-backlinks (mapcar 'denote-graph/get-file-backlinks denote-files)))
    (denote-graph/deduplicate-links (-flatten-n 1 (mapcar #'(lambda (denote-file-backlinks) (denote-graph/collect-item-links denote-file-backlinks denote-ids)) denote-backlinks)))))

(defun denote-graph/deduplicate-links (denote-links)
  (-reduce
   #'(lambda (filtered-links link)
       (if (denote-graph/link-exists filtered-links link) filtered-links (cons link filtered-links)))
   (cons '() denote-links)))

(defun denote-graph/link-exists (links link)
  (let ((reverse-link (cons (cdr link) (car link))))
    (seq-find
     #'(lambda (link-item) (or (equal link-item link) (equal link-item reverse-link)))
     links)))

(defun denote-graph/collect-item-links (denote-file-backlinks denote-ids)
  (let* ((linked-ids (hash-table-keys (cdr denote-file-backlinks)))
         (non-excluded-linked-ids (denote-graph/drop-excluded-linked-nodes linked-ids denote-ids))
         (filename (car denote-file-backlinks))
         (id (denote-retrieve-filename-identifier filename)))
    (mapcar #'(lambda (linked-id) (cons id linked-id)) non-excluded-linked-ids)))

(defun denote-graph/drop-excluded-linked-nodes (linked-ids denote-ids)
  (seq-filter #'(lambda (linked-id) (member linked-id denote-ids)) linked-ids))

(defun denote-graph/get-file-backlinks (file)
  (cons file (denote--get-all-backlinks (list file))))

(defun denote-graph/graphviz-nodes (denote-files url-prefix palette)
  (string-join
   (denote-graph/graphviz-pad-all
    (mapcar #'(lambda (denote-file) (denote-graph/graphviz-node denote-file url-prefix palette)) denote-files))
   "\n"))

(defun denote-graph/graphviz-node (filename url-prefix palette)
  (let* ((file-type (denote-filetype-heuristics filename))
         (id (denote-retrieve-filename-identifier filename))
         (title (denote-retrieve-front-matter-title-value filename file-type))
         (color (denote-graph/graphviz-node-color filename palette)))
    (format "\"%s\" [label=\"%s\", fillcolor=\"%s\", URL=\"%s/%s.html\", target=\"_blank\"];" id title color url-prefix id)))

(defun denote-graph/graphviz-node-color (filename palette)
  (let* ((keywords (denote-extract-keywords-from-path filename))
         (default (cons nil "none"))
         (palette-item (seq-find #'(lambda (item) (member (car item) keywords)) palette default)))
    (cdr palette-item)))

(defun denote-graph/graphviz-links (denote-links)
  (string-join
   (mapcar #'(lambda (link) (denote-graph/graphviz-pad (format "\"%s\" -- \"%s\";" (car link) (cdr link)))) denote-links)
   "\n"))

(defun denote-graph/graphviz-setup ()
  (string-join
   (denote-graph/graphviz-pad-all
    '("layout=neato;"
      "overlap=false;"
      "splines=true;"
      "node [shape=box, style=filled];"))
   "\n"))

(defun denote-graph/graphviz-pad-all (strings)
  (mapcar #'(lambda (string) (denote-graph/graphviz-pad string)) strings))

(defun denote-graph/graphviz-pad (string)
  (concat "    " string))

(provide 'denote-graph)
;;; denote-graph.el ends here
