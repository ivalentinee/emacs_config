(load "adventurer-common")

(defun adventurer/print-scene-entry-link-items (id entry-link-items indent)
  (mapcar
   (lambda (link-item) (format "%s%s -> %s [label=\"%s\"];" indent id (alist-get 'id link-item) (alist-get 'tag link-item)))
   entry-link-items))

(defun adventurer/print-scene-entry-links (entry-links)
  (let ((indent "  ")
        (id (alist-get 'id entry-links))
        (title (alist-get 'title entry-links))
        (links (alist-get 'links entry-links)))
    (string-join
     (cons (format "%s%s [label=\"%s\"];" indent id title)
           (adventurer/print-scene-entry-link-items id links indent))
     "\n")))

(defun adventurer/print-scene-links (scene-entries)
  (string-join
   (mapcar 'adventurer/print-scene-entry-links scene-entries)
   "\n"))

(defun adventurer/write-scene-links (scene-entries)
  (write-region
   (format "%s\n%s\n%s" "digraph {" (adventurer/print-scene-links scene-entries) "}")
   nil
   (adventurer/compose-filename "dot")))

(defun adventurer/visualize-graph ()
  (let ((filename-from (adventurer/compose-filename "dot"))
        (filename-to (adventurer/compose-filename "png")))
    (shell-command (format "%s '%s' %s %s '%s'" "/usr/bin/dot" filename-from "-Tpng" ">" filename-to))))

(defun adventurer/build-graph (scene-entries)
  (adventurer/write-scene-links scene-entries)
  (adventurer/visualize-graph))
