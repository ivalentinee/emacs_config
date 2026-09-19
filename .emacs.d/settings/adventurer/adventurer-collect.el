(load "adventurer-common")
(load "adventurer-id")

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
         (image-id (nth 0 token-properties))
         (owner-property (nth 1 token-properties))
         ;; a token's name, size and owner are its own defaults; a scene states one
         ;; only to override it, so an unstated field is emitted by nobody
         (owner (when (adventurer/present-string-p owner-property) owner-property))
         (size-property (adventurer/get-token-property token-properties "size"))
         (size (when (adventurer/present-string-p size-property)
                 (string-to-number size-property))))
    `((name . ,name)
      (owner . ,owner)
      (size . ,size)
      (image-id . ,image-id))))

(defun adventurer/parse-tokens (token-string)
  (if token-string
      (let ((token-elements (adventurer/collect-links token-string)))
        (remq nil (mapcar 'adventurer/parse-token-item token-elements)))
    '()))

(defun adventurer/parse-coordinate (value)
  ;; grid cells, whole or fractional; not pixels
  (when (adventurer/present-string-p value) (string-to-number value)))

(defun adventurer/parse-tagged-property (field)
  ;; "owner: enemy" -> (owner . "enemy"), rendered as owner = "enemy";
  ;; "rotation: 90" -> (rotation . 90), rendered as rotation = 90.
  ;; a numeric-looking value becomes a number, so a field needing one costs no code
  (when (string-match "\\`\\([a-z_][a-z0-9_]*\\) *: *\\(.*\\)\\'" field)
    (let ((key (match-string 1 field))
          (value (string-trim (match-string 2 field))))
      (when (adventurer/present-string-p value)
        (cons (intern key)
              (if (string-match-p "\\`[-+]?[0-9]*\\.?[0-9]+\\'" value)
                  (string-to-number value)
                value))))))

(defun adventurer/parse-tagged-properties (fields)
  (remq nil (mapcar 'adventurer/parse-tagged-property fields)))

(defun adventurer/parse-place-token-item (place-token)
  ;; [[<game_id> | <state> | <x> | <y> | key: value | ...][<name>]]
  ;; four positional slots, then any number of tagged ones passed straight
  ;; through — owner today, whatever PathMapper adds next without a code change.
  ;; the first slot is a game_id, or a bare token id to have one generated
  (let* ((parsed (adventurer/parse-link place-token))
         (name (alist-get 'name parsed))
         (fields (mapcar 'string-trim (string-split (alist-get 'url parsed) "|")))
         (state (nth 1 fields)))
    (append
     `((token-id . ,(nth 0 fields))
       (x . ,(adventurer/parse-coordinate (nth 2 fields)))
       (y . ,(adventurer/parse-coordinate (nth 3 fields)))
       (state . ,(when (adventurer/present-string-p state) state)))
     (adventurer/parse-tagged-properties (nthcdr 4 fields))
     `((name . ,(when (adventurer/present-string-p name) name))))))

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

(defun adventurer/place-token-game-id (value counts taken)
  "Keeps an authored game_id, and gives a bare token id the next free suffix."
  (let ((token-id (adventurer/id/placement-token value)))
    (if (not (equal value token-id))
        value
      (let ((number (1+ (gethash token-id counts 0))))
        (while (member (format "%s-%d" token-id number) taken)
          (setq number (1+ number)))
        (puthash token-id number counts)
        (format "%s-%d" token-id number)))))

(defun adventurer/number-place-token (place-token counts taken)
  (mapcar (lambda (property)
            (if (eq (car property) 'token-id)
                (cons 'game_id
                      (adventurer/place-token-game-id (cdr property) counts taken))
              property))
          place-token))

(defun adventurer/number-place-tokens (place-tokens)
  ;; a suffix the author or an export supplied is never replaced; a generated one
  ;; steps over anything already claimed in this scene
  (let ((counts (make-hash-table :test 'equal))
        (taken (mapcar (lambda (place-token) (alist-get 'token-id place-token))
                       place-tokens)))
    (mapcar (lambda (place-token) (adventurer/number-place-token place-token counts taken))
            place-tokens)))

(defun adventurer/scene-token-ids (tokens)
  ;; the ids the scene declares, read from the declarations rather than from
  ;; filenames — which is what a placement is compared against
  (remq nil (mapcar (lambda (token) (alist-get 'image-id token)) tokens)))

(defun adventurer/build-entry ()
  (if (equal (org-outline-level) 2)
      (let ((tokens (adventurer/parse-tokens (org-entry-get nil "TOKENS"))))
        `((id . ,(org-entry-get nil "ID"))
          (ref . ,(org-entry-get nil "REF"))
          (title . ,(org-get-heading t t t t))
          (todo . ,(equal (nth 2 (org-heading-components)) "TODO"))
          (body . ,(org-get-entry))
          (links . ,(adventurer/parse-entry-links (org-entry-get nil "LINK")))
          (map . ,(org-entry-get nil "MAP"))
          (tokens . ,tokens)
          (place-tokens . ,(adventurer/number-place-tokens
                            (adventurer/parse-place-tokens (org-entry-get nil "PLACE-TOKENS"))))
          (xp . ,(adventurer/get-entry-xp))
          (music . ,(org-entry-get nil "MUSIC"))))
    nil))

(defun adventurer/scene-printed-form (scene)
  (string-join (seq-filter 'adventurer/present-string-p
                           (list (alist-get 'ref scene) (alist-get 'title scene)))
               " "))

(defun adventurer/todo-entry-p (entry)
  (alist-get 'todo entry))

(defun adventurer/packaged-scenes (scene-entries)
  (seq-remove 'adventurer/todo-entry-p
              (seq-filter (lambda (scene) (alist-get 'map scene)) scene-entries)))

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

(defun adventurer/collect-statblocks ()
  (save-excursion
    (beginning-of-buffer)
    (when (search-forward ":ID: statblocks" nil t)
      (org-get-entry))))

(defun adventurer/collect-scene-data ()
  (adventurer/map-scenes 'adventurer/build-entry))
