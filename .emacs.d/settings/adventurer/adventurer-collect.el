(defun adventurer/parse-link (link-string)
  (when (string-match "\\[\\[\\([^]]+\\)\\]\\[\\([^]]*\\)\\]" link-string)
    (list (cons 'url (match-string 1 link-string))
          (cons 'name (match-string 2 link-string)))))

(defun adventurer/collect-links (string)
  (let ((link-regexp "\\[\\[\\([^]]+\\)\\]\\[\\([^]]*\\)\\]")
        (start 0)
        (matches ()))
    (while (string-match link-regexp string start)
      (push (match-string 0 string) matches)
      (setq start (match-end 0)))
    (nreverse matches)))

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

(defun adventurer/get-token-property (token-properties property-name &optional default)
  (if-let* ((prefix (format "%s:" property-name))
            (property (seq-find #'(lambda (item) (and (stringp item) (string-prefix-p prefix item))) token-properties))
            (property-value (string-trim (string-replace prefix "" property))))
      property-value default))

(defun adventurer/parse-token-item (token)
  (let* ((parsed-token (adventurer/parse-link token))
         (name (alist-get 'name parsed-token))
         (token-properties (mapcar 'string-trim (string-split (alist-get 'url parsed-token) "|")))
         (path (nth 0 token-properties))
         (owner (nth 1 token-properties))
         (size (string-to-number (adventurer/get-token-property token-properties "size" "1"))))
    `((name . ,name)
      (owner . ,owner)
      (size . ,size)
      (image . ,path))))

(defun adventurer/parse-tokens (token-string)
  (if token-string
      (let ((token-elements (adventurer/collect-links token-string)))
        (remq nil (mapcar 'adventurer/parse-token-item token-elements)))
    '()))

(defun adventurer/parse-place-token-item (token)
  (let* ((parsed-token (adventurer/parse-link token))
         (title (alist-get 'name parsed-token))
         (token-properties (mapcar 'string-trim (string-split (alist-get 'url parsed-token) "|")))
         (name (nth 0 token-properties))
         (state (nth 1 token-properties))
         (type (nth 2 token-properties))
         (x (string-to-number (nth 3 token-properties)))
         (y (string-to-number (nth 4 token-properties))))
    `((title . ,title)
      (name . ,name)
      (state . ,state)
      (type . ,type)
      (x . ,x)
      (y . ,y))))

(defun adventurer/parse-place-tokens (place-token-string)
  (if place-token-string
      (let ((token-elements (adventurer/collect-links place-token-string)))
        (remq nil (mapcar 'adventurer/parse-place-token-item token-elements)))
    '()))

(defun adventurer/parse-xp (line)
  (when (string-match "^#\\+xp:\\s-+\\[\\([^]]+\\)\\]\\s-\\(.*\\)$" line)
    `((xp-string . ,(match-string 1 line))
      (description . ,(match-string 2 line)))))

(defun adventurer/get-entry-xp ()
  (let* ((body (org-get-entry))
         (strings (string-split body "\n")))
    (remq nil (mapcar 'adventurer/parse-xp strings))))

(defun adventurer/build-entry ()
  (if (equal (org-outline-level) 2)
      `((id . ,(org-entry-get nil "ID"))
        (title . ,(org-get-heading t t t t))
        (body . ,(org-get-entry))
        (links . ,(adventurer/parse-entry-links (org-entry-get nil "LINK")))
        (map . ,(or (org-entry-get nil "MAP") (format "%s.ora" (org-entry-get nil "ID"))))
        (tokens . ,(adventurer/parse-tokens (org-entry-get nil "TOKENS")))
        (place-tokens . ,(adventurer/parse-place-tokens (org-entry-get nil "PLACE-TOKENS")))
        (xp . ,(adventurer/get-entry-xp)))
    nil))

(defun adventurer/map-scenes (function)
  (save-excursion
    (beginning-of-buffer)
    (search-forward ":ID: scenes")
    (seq-filter (lambda (entry) entry) (org-map-entries function nil 'tree))))

(defun adventurer/collect-description ()
  (save-excursion
    (beginning-of-buffer)
    (search-forward ":ID: description")
    (org-get-entry)))

(defun adventurer/collect-prepare ()
  (save-excursion
    (beginning-of-buffer)
    (search-forward ":ID: prepare")
    (org-get-entry)))

(defun adventurer/collect-title ()
  (save-excursion (org-get-title)))

(defun adventurer/collect-scene-data ()
  (adventurer/map-scenes 'adventurer/build-entry))
