(defun denote-graph/export-groups (denote-groups denote-links groups base-filename)
  (mapcar #'(lambda (group) (denote-graph/export-group denote-groups denote-links groups group base-filename)) groups))

(defun denote-graph/export-group (denote-groups denote-links groups group base-filename)
  (denote-graph/export-group-without-externals denote-groups denote-links groups group base-filename)
  (denote-graph/export-group-with-externals denote-groups denote-links groups group base-filename))

(defun denote-graph/export-group-without-externals (denote-groups denote-links groups group base-filename)
  (let* ((nodes (alist-get group denote-groups))
         (links (denote-graph/collect-links nodes))
         (filename (string-join `(,base-filename ,group) "-")))
    (denote-graph/export `((nil . ,nodes)) links '() filename)))

(defun denote-graph/export-group-with-externals (denote-groups denote-links groups group base-filename)
  (let* ((filename (string-join `(,base-filename ,group "ext") "-")))
    (denote-graph/export (expand-group denote-groups group) denote-links (remove group groups) filename "fdp")))

(defun expand-group (denote-groups group)
  (mapcar
   #'(lambda (item)
       (if (equal (car item) group)
           `(nil . ,(cdr item))
         item))
   denote-groups))
