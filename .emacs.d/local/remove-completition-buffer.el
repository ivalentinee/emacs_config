;; remove-completition-buffer.el

;; Remove completion buffer when done

(add-hook 'minibuffer-exit-hook
      '(lambda ()
         (let ((buffer "*Completions*"))
           (and (get-buffer buffer)
            (kill-buffer buffer)))))

(provide 'remove-completition-buffer)