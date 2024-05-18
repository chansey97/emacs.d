;;----------------------------------------------------------------------------
;; SMT
;;----------------------------------------------------------------------------
(require 'smt-mode)
(add-to-list 'auto-mode-alist '("\\.smt\\'" . smt-mode))
(add-to-list 'auto-mode-alist '("\\.smt2\\'" . smt-mode))

(define-key smt-mode-map (kbd "C-<down>")  'forward-paragraph)
(define-key smt-mode-map (kbd "C-<up>")  'backward-paragraph)

