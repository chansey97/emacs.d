(require 'racket-mode)

;;;###autoload
(define-derived-mode pie-mode racket-mode
  "Pie"
  "Major mode for editing pie code of The little typer."
  )

;;;###autoload
(progn
  (add-to-list 'auto-mode-alist '("\\.pie\\'" . pie-mode))
  (modify-coding-system-alist 'file "\\.pie\\'"  'utf-8)
  
  (put 'claim 'racket-indent-function 1)
  (put 'the 'racket-indent-function 1)
  (put 'Pair 'racket-indent-function 1)
  (put 'Sigma 'racket-indent-function 1)
  (put 'cons 'racket-indent-function 1)
  (put '-> 'racket-indent-function 1)
  (put 'Pi 'racket-indent-function 1)
  (put 'add1 'racket-indent-function 1)
  (put 'which-Nat 'racket-indent-function 1)
  (put 'iter-Nat 'racket-indent-function 1)
  (put 'rec-Nat 'racket-indent-function 1)
  (put 'ind-Nat 'racket-indent-function 1)
  (put ':: 'racket-indent-function 1)
    
  (put 'rec-List 'racket-indent-function 1)
  (put 'ind-List 'racket-indent-function 1)
  (put 'Vec 'racket-indent-function 1)
  (put 'vec:: 'racket-indent-function 1)
  (put 'ind-Vec 'racket-indent-function 1)
  (put 'cong 'racket-indent-function 1)
  (put 'replace 'racket-indent-function 1)
  (put 'trans 'racket-indent-function 1)
  (put 'ind-= 'racket-indent-function 1)
  (put 'Either 'racket-indent-function 1)
  (put 'ind-Either 'racket-indent-function 1)
  (put 'ind-Absurd 'racket-indent-function 1)
  )

(provide 'pie-mode)


