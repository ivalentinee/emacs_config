(load "adventurer-collect")

(defun adventurer/validate/describe (description subject)
  (format "  %s: %s"
          description
          (if (adventurer/present-string-p subject) subject "<empty>")))

(defun adventurer/validate/entity-id-problem (id description)
  (unless (adventurer/id/parse id)
    (adventurer/validate/describe description id)))

(defun adventurer/validate/path-id-problem (path description)
  (unless (adventurer/id/from-path path)
    (adventurer/validate/describe description path)))

(defun adventurer/validate/asset-problem (id description)
  ;; the id must be well formed, and must name exactly one asset on disk
  (or (adventurer/validate/entity-id-problem id (format "%s has no valid id" description))
      (when-let* ((problem (adventurer/assets/problem id)))
        (adventurer/validate/describe description problem))))

(defun adventurer/validate/document-problem ()
  (let ((file-name (buffer-file-name)))
    (if file-name
        (adventurer/validate/path-id-problem file-name "Document filename carries no ID")
      (adventurer/validate/describe "Document is not visiting a file" (buffer-name)))))

(defun adventurer/validate/duplicate-problems (ids)
  (let ((seen ())
        (duplicates ()))
    (dolist (id (remq nil ids))
      (if (member id seen) (push id duplicates) (push id seen)))
    (mapcar (lambda (id) (adventurer/validate/describe "Duplicate ID" id))
            (seq-uniq (nreverse duplicates)))))

(defun adventurer/validate/report (problems)
  (let ((found (remq nil (flatten-tree problems))))
    (when found
      (error "Adventurer found %d ID problem(s):\n%s" (length found) (string-join found "\n")))))

(defun adventurer/validate/ref-problem (scene)
  ;; scope is every printed scene, not adventurer/packaged-scenes: an ID is
  ;; required of the scenes a package declares, a ref of the scenes a reader sees
  (unless (adventurer/present-string-p (alist-get 'ref scene))
    (adventurer/validate/describe
     (format "Scene \"%s\" has no :REF:" (alist-get 'title scene))
     (alist-get 'ref scene))))

(defun adventurer/validate/scene-problems (scene)
  (let ((title (alist-get 'title scene)))
    (append
     (list (adventurer/validate/entity-id-problem
            (alist-get 'id scene)
            (format "Scene \"%s\" has no valid :ID:" title))
           (adventurer/validate/asset-problem
            (alist-get 'map scene)
            (format "Scene \"%s\" map" title)))
     (mapcar (lambda (token)
               (adventurer/validate/asset-problem
                (alist-get 'image-id token)
                (format "Scene \"%s\" token \"%s\"" title (alist-get 'name token))))
             (alist-get 'tokens scene))
     (let ((declared (adventurer/scene-token-ids (alist-get 'tokens scene))))
       (mapcar (lambda (place-token)
                 (let ((game-id (alist-get 'game_id place-token)))
                   (unless (member (adventurer/id/placement-token game-id) declared)
                     (adventurer/validate/describe
                      (format "Scene \"%s\" placement names a token the scene does not declare" title)
                      game-id))))
               (alist-get 'place-tokens scene))))))

(defun adventurer/validate/scene-asset-ids (scenes)
  (seq-uniq
   (remq nil
         (flatten-tree
          (mapcar (lambda (scene)
                    (cons (alist-get 'map scene)
                          (adventurer/scene-token-ids (alist-get 'tokens scene))))
                  scenes)))))

(defun adventurer/validate/adventure (scene-entries)
  (let ((scenes (adventurer/packaged-scenes scene-entries)))
    (adventurer/validate/report
     (list (adventurer/validate/document-problem)
           (mapcar 'adventurer/validate/ref-problem scene-entries)
           (mapcar 'adventurer/validate/scene-problems scenes)
           (adventurer/validate/duplicate-problems
            (append (mapcar (lambda (scene) (alist-get 'id scene)) scenes)
                    (adventurer/validate/scene-asset-ids scenes)))))))

(defun adventurer/validate/character-problems (character)
  (let ((name (alist-get 'name character)))
    (append
     (list (adventurer/validate/entity-id-problem
            (alist-get 'id character)
            (format "Character \"%s\" has no valid :ID:" name))
           (adventurer/validate/asset-problem
            (alist-get 'token character)
            (format "Character \"%s\" token" name)))
     (mapcar (lambda (extra-token)
               (adventurer/validate/asset-problem
                (alist-get 'url extra-token)
                (format "Character \"%s\" extra token \"%s\""
                        name (alist-get 'name extra-token))))
             (alist-get 'extra character)))))

(defun adventurer/validate/character-asset-ids (characters)
  (seq-uniq
   (remq nil
         (flatten-tree
          (mapcar (lambda (character)
                    (cons (alist-get 'token character)
                          (mapcar (lambda (extra-token) (alist-get 'url extra-token))
                                  (alist-get 'extra character))))
                  characters)))))

(defun adventurer/validate/group (characters)
  (let ((players (seq-remove 'adventurer/todo-entry-p characters)))
    (adventurer/validate/report
     (list (adventurer/validate/document-problem)
           (mapcar 'adventurer/validate/character-problems players)
           (adventurer/validate/duplicate-problems
            (append (mapcar (lambda (player) (alist-get 'id player)) players)
                    (adventurer/validate/character-asset-ids players)))))))
