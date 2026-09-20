(require 'denote)
(require 'dash)

(defun denote-graph/graphviz (denote-nodes denote-links groups url-prefix base-path path &optional engine)
  (let* ((graphviz-node-groups (denote-graph/graphviz-node-groups denote-nodes groups url-prefix base-path))
         (graphviz-links (denote-graph/graphviz-links denote-links))
         (content (format "graph DetectiveBoard {\n%s\n\n%s\n\n%s\n}" (denote-graph/graphviz-setup engine) graphviz-node-groups graphviz-links)))
    (write-region content nil path)))

(defun denote-graph/graphviz-node-groups (denote-nodes groups url-prefix base-path)
  (let ((ungrouped-nodes (denote-graph/graphviz-nodes (alist-get nil denote-nodes) url-prefix))
        (node-groups (string-join (mapcar #'(lambda (group) (denote-graph/graphviz-node-group denote-nodes group url-prefix base-path)) groups) "\n")))
    (string-join `(,ungrouped-nodes ,node-groups) "\n")))

(defun denote-graph/graphviz-node-group (denote-nodes group url-prefix base-path)
  (format
   "%s cluster_%s {\n%s\n%s\n    }"
   (denote-graph/graphviz-pad "subgraph")
   group
   (denote-graph/graphviz-group-setup group url-prefix base-path)
   (denote-graph/graphviz-nodes (alist-get group denote-nodes) url-prefix)))

(defun denote-graph/graphviz-nodes (denote-nodes url-prefix)
  (string-join
   (denote-graph/graphviz-pad-all
    (mapcar #'(lambda (denote-node) (denote-graph/graphviz-node denote-node url-prefix)) denote-nodes))
   "\n"))

(defun denote-graph/graphviz-node (denote-node url-prefix)
  (let* ((title (alist-get 'title denote-node))
         (label (if (alist-get 'is-strikethrough denote-node) (format "<s>%s</s>" title) title)))
    (format
     "\"%s\" [label=<%s>, fillcolor=\"%s\", URL=\"%s/%s.html\", target=\"_blank\"];"
     (alist-get 'id denote-node)
     label
     (alist-get 'color denote-node)
     url-prefix
     (alist-get 'id denote-node))))

(defun denote-graph/graphviz-links (denote-links)
  (string-join
   (mapcar #'(lambda (link) (denote-graph/graphviz-pad (format "\"%s\" -- \"%s\";" (car link) (cdr link)))) denote-links)
   "\n"))

(defun denote-graph/graphviz-setup (&optional engine)
  (string-join
   (denote-graph/graphviz-pad-all
    `(,(format "layout=%s;" (or engine "neato"))
      ,(if (equal engine "fdp") "K=0.3;" "")
      ,(if (equal engine "fdp") "overlap=scale;" "overlap=false;")
      ,(if (equal engine "fdp") "overlap_scaling=0.1;" "")
      ,(if (equal (or engine "neato") "neato") "mode=major;" "")
      "splines=true;"
      "node [shape=box, style=filled];"))
   "\n"))

(defun denote-graph/graphviz-group-setup (name url-prefix base-path)
  (string-join
   (denote-graph/graphviz-pad-all
    `("style=filled;"
      "color=lightgrey;"
      ,(format "label = <%s>;" name)
      ,(format "URL=\"%s/%s-%s.svg\"" url-prefix base-path group)))
   "\n"))

(defun denote-graph/graphviz-pad-all (strings)
  (mapcar #'(lambda (string) (denote-graph/graphviz-pad string)) strings))

(defun denote-graph/graphviz-pad (string)
  (concat "    " string))
