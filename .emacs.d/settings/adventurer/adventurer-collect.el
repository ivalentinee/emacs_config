(defun adventurer/entry-link-regex ()
  (let ((org-link-href-regex "\\[id:\\([^]]+\\)\\]")
        (org-link-title-regex "\\[[^]]+\\]")
        (org-link-tag-regex "\\([^:]+\\)"))
    (format "\\[%s%s\\]\\(:%s\\)?" org-link-href-regex org-link-title-regex org-link-tag-regex)))

(defun adventurer/parse-entry-link (entry-link)
  (if
      (string-match (adventurer/entry-link-regex) entry-link)
      (list
       (cons 'id (match-string 1 entry-link))
       (cons 'tag (or (match-string 3 entry-link) "")))
    nil))

(defun adventurer/parse-entry-links (entry-link-string)
  (if entry-link-string
      (let ((entry-link-elements (string-split entry-link-string)))
        (remq nil (mapcar 'adventurer/parse-entry-link entry-link-elements)))
    '()))

(defun adventurer/build-entry ()
  (if (equal (org-outline-level) 2)
      (list (cons 'id (org-entry-get nil "ID"))
            (cons 'title (org-get-heading t t t t))
            (cons 'links (adventurer/parse-entry-links (org-entry-get nil "LINK"))))
    nil))

(defun adventurer/map-scenes (function)
  (save-excursion
    (org-id-goto "scenes")
    (seq-filter (lambda (entry) entry) (org-map-entries function nil 'tree))))

(defun adventurer/collect-scene-data ()
  (adventurer/map-scenes 'adventurer/build-entry))
