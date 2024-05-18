;; turn on bracket match highlight
(show-paren-mode 1)

;; highlight enclosing parens instead of out
;; https://stackoverflow.com/questions/22770979/parenthesis-highlighting-emacs
(define-advice show-paren-function (:around (fn) fix-show-paren-function)
  "Highlight enclosing parens."
  (cond ((looking-at-p "\\s(") (funcall fn))
        (t (save-excursion
             (ignore-errors (backward-up-list))
             (funcall fn)))))
