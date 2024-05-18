;;----------------------------------------------------------------------------
;; Common Lisp (slime)
;;----------------------------------------------------------------------------
;; (load (expand-file-name "C:\\Users\\Chansey\\quicklisp\\slime-helper.el"))
(setq inferior-lisp-program "sbcl")
(add-hook 'slime-mode-hook 'enable-paredit-mode)
(add-hook 'inferior-lisp-mode 'enable-paredit-mode)


(provide 'sc-set-pl-cl)
