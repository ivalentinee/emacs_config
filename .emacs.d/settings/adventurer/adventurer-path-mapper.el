(load "adventurer-common")
(load "adventurer-collect")
(load "adventurer-assets")

(setq *adventurer-pathmapper-indent* 7)

(defun adventurer/build-path-mapper/append-output (output body)
  (string-join (list output body) "\n\n"))

(defun adventurer/build-path-mapper/wallpaper-path ()
  (if-let* ((wallpaper-property (org-collect-keywords '("WALLPAPER")))
            (wallpaper-value (cadar wallpaper-property)))
      wallpaper-value "wallpaper.png"))

(defun adventurer/build-path-mapper/write-wallpaper (output)
  (adventurer/build-path-mapper/append-output
   output
   (format "wallpaper = \"%s\""
           (adventurer/assets/packed-path (adventurer/build-path-mapper/wallpaper-path)))))

(defun adventurer/build-path-mapper/render-alist-property (alist-property)
  (cond ((stringp (cdr alist-property)) (format "%s = \"%s\"" (car alist-property) (cdr alist-property)))
        (t (format "%s = %s" (car alist-property) (cdr alist-property)))))

(defun adventurer/build-path-mapper/render-alist (alist)
  (let* ((non-nil-properties (seq-filter #'(lambda (item) (cdr item)) alist))
         (rendered-properties (mapcar 'adventurer/build-path-mapper/render-alist-property non-nil-properties))
         (property-string (string-join rendered-properties ", "))
         (rendered-alist (format "{ %s }" property-string)))
    rendered-alist))

(defun adventurer/build-path-mapper/indent (string)
  (format "%s%s" (make-string *adventurer-pathmapper-indent* ? ) string))

(defun adventurer/build-path-mapper/write-urls (output)
  (if-let* ((url-property (org-collect-keywords '("URLS")))
            (url-unparsed (split-string (cadar url-property)))
            (urls (mapcar 'adventurer/parse-link url-unparsed))
            (url-strings (mapcar 'adventurer/build-path-mapper/render-alist urls))
            (url-strings (mapcar 'adventurer/build-path-mapper/indent url-strings))
            (url-string (string-join url-strings ",\n"))
            (urls-value (format "urls = [\n%s\n]" url-string))
            (output-with-urls (adventurer/build-path-mapper/append-output output urls-value)))
      output-with-urls output))

(defun adventurer/build-path-mapper/token-file (token)
  (adventurer/assets/packed-file
   (adventurer/assets/asset (alist-get 'image-id token)) 'token))

(defun adventurer/build-path-mapper/render-token (token)
  ;; the declared id becomes the path the package carries it at
  (adventurer/build-path-mapper/indent
   (adventurer/build-path-mapper/render-alist
    (mapcar (lambda (property)
              (if (eq (car property) 'image-id)
                  (cons 'image (adventurer/assets/packed-path
                                (adventurer/build-path-mapper/token-file token)))
                property))
            token))))

(defun adventurer/build-path-mapper/render-scene-tokens (scene)
  (mapcar 'adventurer/build-path-mapper/render-token (alist-get 'tokens scene)))

(defun adventurer/build-path-mapper/render-scene-place-tokens (scene)
  (let ((render-place-token (lambda (place-token) (adventurer/build-path-mapper/indent (adventurer/build-path-mapper/render-alist place-token)))))
    (mapcar render-place-token (alist-get 'place-tokens scene))))

(defun adventurer/build-path-mapper/render-list (list)
  (if (length> list 0)
      (format "[\n%s\n]"(string-join list ",\n"))
    "[]"))

(defun adventurer/build-path-mapper/render-scene (scene)
  (let* ((scene-output "[[scenes]]")
         (scene-title (alist-get 'title scene))
         (scene-id (alist-get 'id scene))
         (scene-ref (alist-get 'ref scene))
         (scene-map (adventurer/assets/packed-path
                     (adventurer/build-path-mapper/map-file (alist-get 'map scene))))
         (scene-tokens (adventurer/build-path-mapper/render-scene-tokens scene))
         (scene-place-tokens (adventurer/build-path-mapper/render-scene-place-tokens scene))
         (scene-output (string-join `(,scene-output ,(format "id = \"%s\"" scene-id)) "\n"))
         (scene-output (string-join `(,scene-output ,(format "ref = \"%s\"" scene-ref)) "\n"))
         (scene-output (string-join `(,scene-output ,(format "name = \"%s\"" scene-title)) "\n"))
         (scene-output (string-join `(,scene-output "type = \"battle\"") "\n"))
         (scene-output (string-join `(,scene-output ,(format "map.file = \"%s\"" scene-map)) "\n"))
         (scene-output (string-join `(,scene-output ,(format "tokens = %s" (adventurer/build-path-mapper/render-list scene-tokens))) "\n"))
         (scene-output (string-join `(,scene-output ,(format "place_tokens = %s" (adventurer/build-path-mapper/render-list scene-place-tokens))) "\n"))
         )
    scene-output))

(defun adventurer/build-path-mapper/write-scenes (output scene-entries)
  (let* ((non-todo-scenes (adventurer/packaged-scenes scene-entries))
         (rendered-scenes (mapcar 'adventurer/build-path-mapper/render-scene non-todo-scenes))
         (scenes-output (string-join rendered-scenes "\n\n")))
    (adventurer/build-path-mapper/append-output output scenes-output)))

(defun adventurer/build-path-mapper/convert-xcf-to-ora (xcf-path)
  (let* ((ora-path (concat (file-name-sans-extension xcf-path) ".ora"))
         (script-path (concat (adventurer/get-script-path) "/xcf-to-ora.sh")))
    (when (or (not (file-exists-p ora-path))
              (file-newer-than-file-p xcf-path ora-path))
      (message "Converting %s -> %s" xcf-path ora-path)
      (let ((output (shell-command-to-string (format "%s \"%s\" \"%s\" 2>&1" script-path xcf-path ora-path))))
        (unless (file-exists-p ora-path)
          (error "XCF to ORA conversion failed for %s:\n%s" xcf-path (string-trim output)))))
    ora-path))

(defun adventurer/build-path-mapper/map-file (map-id)
  ;; the .ora the package carries; convert-xcf-to-ora rebuilds it only when the
  ;; .xcf is newer, which is the freshness rule the authored path used to carry
  (let* ((files (adventurer/assets/asset map-id))
         (xcf (adventurer/assets/with-extension files "xcf")))
    (if xcf
        (adventurer/build-path-mapper/convert-xcf-to-ora xcf)
      (adventurer/assets/packed-file files 'map))))

(defun adventurer/build-path-mapper/collect-scene-files (scene)
  ;; the one file per asset the package carries
  (cons (adventurer/build-path-mapper/map-file (alist-get 'map scene))
        (mapcar 'adventurer/build-path-mapper/token-file (alist-get 'tokens scene))))

(defun adventurer/build-path-mapper/collect-scene-source-files (scene)
  ;; every file of every asset, source formats included; the locality filter is
  ;; adventurer/pack's, because only it knows the archive is the document's own
  (append (adventurer/assets/asset (alist-get 'map scene))
          (flatten-tree
           (mapcar (lambda (token) (adventurer/assets/asset (alist-get 'image-id token)))
                   (alist-get 'tokens scene)))))

(defun adventurer/build-path-mapper/collect-source-files (scene-entries)
  (let* ((scene-files (flatten-tree (mapcar 'adventurer/build-path-mapper/collect-scene-source-files scene-entries)))
         (wallpaper-path (adventurer/build-path-mapper/wallpaper-path))
         (files (cons wallpaper-path scene-files)))
    (seq-uniq files)))

(defun adventurer/build-path-mapper/collect-files (scene-entries)
  (let* ((non-todo-scenes (adventurer/packaged-scenes scene-entries))
         (scene-files (flatten-tree (mapcar 'adventurer/build-path-mapper/collect-scene-files non-todo-scenes)))
         (wallpaper-path (adventurer/build-path-mapper/wallpaper-path))
         (files (cons wallpaper-path scene-files)))
    (seq-uniq files)))

(defun adventurer/build-path-mapper/staging-path ()
  (expand-file-name "package" (adventurer/build-path)))

(defun adventurer/build-path-mapper/pack (files)
  (let* ((staging (adventurer/build-path-mapper/staging-path))
         (output-filename (expand-file-name (adventurer/compose-filename "pmadventure"))))
    (adventurer/assets/stage (seq-filter 'file-exists-p (remq nil files)) staging)
    (copy-file (adventurer/compose-filename "toml")
               (expand-file-name "manifest.toml" staging) t)
    (when (file-exists-p output-filename)
      (delete-file output-filename))
    (shell-command (format "cd \"%s\" && /usr/bin/zip -r \"%s\" assets manifest.toml %s"
                           staging output-filename (adventurer/ignore-shell-output)))
    (delete-directory staging t)))

(defun adventurer/build-path-mapper/clear ()
  (when (file-exists-p (adventurer/compose-filename "toml"))
    (delete-file (adventurer/compose-filename "toml")))
  (when (file-exists-p "manifest.toml")
    (delete-file "manifest.toml"))
  (when (file-exists-p (adventurer/compose-filename "pmadventure"))
    (delete-file (adventurer/compose-filename "pmadventure"))))

(defun adventurer/build-path-mapper (scene-entries)
  (let* ((output (format "title = \"%s\"" (org-get-title)))
         (output (adventurer/build-path-mapper/write-wallpaper output))
         (output (adventurer/build-path-mapper/write-urls output))
         (output (adventurer/build-path-mapper/write-scenes output scene-entries))
         (files (adventurer/build-path-mapper/collect-files scene-entries)))
    (write-region output nil (adventurer/compose-filename "toml"))
    (adventurer/build-path-mapper/pack files)))
