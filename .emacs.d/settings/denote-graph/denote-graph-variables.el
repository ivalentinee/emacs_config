(defvar-local denote-graph-excluded-tags '())
(put 'denote-graph-excluded-tags 'safe-local-variable
     (lambda (val) (and (listp val) (seq-every-p #'stringp val))))

(defvar-local denote-graph-build-dir nil)
(put 'denote-graph-build-dir 'safe-local-variable 'stringp)

(defvar-local denote-graph-url-prefix "")
(put 'denote-graph-url-prefix 'safe-local-variable 'stringp)

(defvar-local denote-graph-palette ())
(put 'denote-graph-palette 'safe-local-variable
     (lambda (val) (and (listp val) (seq-every-p #'(lambda (item) (and (stringp (car item)) (stringp (cdr item)))) val))))

(defvar-local denote-graph-groups ())
(put 'denote-graph-groups 'safe-local-variable
     (lambda (val) (and (listp val) (seq-every-p #'stringp val))))

(defvar-local denote-graph-strikethrough ())
(put 'denote-graph-strikethrough 'safe-local-variable
     (lambda (val) (and (listp val) (seq-every-p #'stringp val))))
