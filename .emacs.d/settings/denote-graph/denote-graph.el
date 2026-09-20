;;; denote-graph.el --- denote link graph render
;;; Commentary:

(require 'denote)
(load "denote-graph-variables")
(load "denote-graph-collect-links")
(load "denote-graph-collect-nodes")
(load "denote-graph-graphviz")
(load "denote-graph-html")
(load "denote-graph-group")

(defun denote-graph/build ()
  "Build denote graph"
  (interactive)
  (when (stringp denote-graph-build-dir)
    (let* ((denote-graph-dot-path (file-name-concat denote-graph-build-dir "graph.dot"))
           (denote-graph-svg-path (file-name-concat denote-graph-build-dir "graph.svg"))
           (denote-graph-group-dot-path (file-name-concat denote-graph-build-dir "graph-group.dot"))
           (denote-graph-group-svg-path (file-name-concat denote-graph-build-dir "graph-group.svg"))
           (denote-files (denote-graph/get-files denote-graph-excluded-tags))
           (denote-groups (denote-graph/collect-nodes denote-files denote-graph-groups denote-graph-palette denote-graph-strikethrough))
           (denote-nodes (denote-graph/collect-nodes denote-files '() denote-graph-palette denote-graph-strikethrough))
           (denote-links (denote-graph/collect-links (alist-get nil denote-nodes))))
      (make-directory denote-graph-build-dir t)

      (denote-graph/export denote-nodes denote-links '() "graph")
      (denote-graph/export denote-groups denote-links denote-graph-groups "graph-group" "fdp")
      (denote-graph/export-groups denote-groups denote-links denote-graph-groups "graph-group")
      (denote-graph/html/export (denote-directory-files) denote-graph-build-dir denote-graph-url-prefix))))

(defun denote-graph/export (nodes links groups filename &optional engine)
  (let ((dot-path (file-name-concat denote-graph-build-dir (format "%s.dot" filename)))
        (svg-path (file-name-concat denote-graph-build-dir (format "%s.svg" filename))))
    (denote-graph/graphviz nodes links groups denote-graph-url-prefix filename dot-path engine)
    (shell-command (format "%s -Tsvg '%s' -o '%s'" "/usr/bin/dot" dot-path svg-path))))

(defun denote-graph/get-files (excluded-tags)
  (seq-filter
   #'(lambda (filename)
       (not (seq-intersection (denote-extract-keywords-from-path filename) excluded-tags)))
   (denote-directory-files)))

(provide 'denote-graph)
;;; denote-graph.el ends here
