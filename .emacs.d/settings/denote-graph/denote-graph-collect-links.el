(require 'dash)

(defun denote-graph/collect-links (denote-nodes)
  (let* ((denote-ids (mapcar #'(lambda (denote-node) (alist-get 'id denote-node)) denote-nodes))
         (denote-files (mapcar #'(lambda (denote-node) (alist-get 'filename denote-node)) denote-nodes))
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
