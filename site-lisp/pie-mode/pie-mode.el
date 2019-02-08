(require 'racket-mode)

;;;###autoload
(define-derived-mode pie-mode racket-mode
  "Pie"
  "Major mode for editing pie code of The little typer."
  
  )

(progn
  (add-to-list 'auto-mode-alist '("\\.pie\\'" . pie-mode))
  (modify-coding-system-alist 'file "\\.pie\\'"  'utf-8))

(provide 'pie-mode)
