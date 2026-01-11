(defun compose-filename (extension)
  (file-name-with-extension
   (or (file-name-nondirectory (buffer-file-name))
       (buffer-name))
   extension))
