;;----------------------------------------------------------------------------
;; company
;;----------------------------------------------------------------------------
(require 'company)
(global-company-mode 1)
(setq company-idle-delay 0.1)
(setq company-minimum-prefix-length 1)

;;----------------------------------------------------------------------------
;; company backends
;;----------------------------------------------------------------------------
(require 'company-math)
(setq company-dabbrev-char-regexp "\\sw\\|_\\|-\\|!\\|\\?\\|*\\|+\\|=\\|>\\|<")

;; Note:
;; company-mode/backend-with-yas must be added to last (head of company-backends),
;; otherwise when you type `use` in prolog-mode, the candidates will be
;; |use -> :- use_module(library(${1:predicate1})).|
;; |use                                            |
;; instead of
;; |use                                            |
;; |use -> :- use_module(library(${1:predicate1})).|
;; I don't know why...
;; company-backends-lisp means auto complete |f -> (f)|
;; company-backends-non-lisp means auto complete |f -> f()|
(setq company-backends-lisp '(company-math-symbols-unicode
                              (company-capf
                               company-dabbrev
                               company-yasnippet-autoparens
                               company-yasnippet)
                              ))

(setq company-backends-non-lisp '(company-math-symbols-unicode
                                  (company-capf
                                   company-dabbrev
                                   company-yasnippet-autoparens-2
                                   company-yasnippet)
                                  ))

;; company-backends-lisp is default setting, if need company-backends-non-lisp in a specific mode,
;; (setq-local company-backends company-backends-non-lisp) in that mode hook.
(setq company-backends company-backends-lisp)

;;----------------------------------------------------------------------------
;; company-quickhelp-mode
;;----------------------------------------------------------------------------
(require 'company-quickhelp)
(company-quickhelp-mode)



(provide 'sc-set-company)
