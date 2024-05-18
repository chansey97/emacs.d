;;----------------------------------------------------------------------------
;; Drag S-Expression
;;----------------------------------------------------------------------------
(defun drag-prev-sexp-forward ()
  (interactive)
  (call-interactively 'transpose-sexps))

(defun drag-prev-sexp-backward ()
  (interactive)
  (let ((current-prefix-arg '(-1)))
    (call-interactively 'transpose-sexps)))

(global-set-key (kbd "M-<right>") 'drag-prev-sexp-forward)
(global-set-key (kbd "M-<left>") 'drag-prev-sexp-backward)

(global-set-key (kbd "M-<down>") 'drag-prev-sexp-forward)
(global-set-key (kbd "M-<up>") 'drag-prev-sexp-backward)
