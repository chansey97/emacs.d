;;----------------------------------------------------------------------------
;; Prolog
;;----------------------------------------------------------------------------
(require 'prolog)
(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))
(setq-default prolog-system 'swi)
;; (setq-default prolog-system 'xsb)

(setq prolog-paren-indent-p t)
(setq prolog-align-small-comments-flag nil)
(setq prolog-head-delimiter "\\(:-\\|\\+:\\|-:\\|\\+\\?\\|-\\?\\|-->\\|-->>\\|<=>\\|==>\\|=>\\)")

(defun restart-prolog()
  "Kill and Restart an inferior Prolog process"
  (interactive)
  (let ((current-prefix-arg '(1)))
    (call-interactively 'run-prolog)))

(defun prolog-indent-line/around (orig-fun &rest args)
  (save-excursion
    (condition-case nil
        (apply orig-fun args)
      (beginning-of-buffer 'noindent))))

(advice-add 'prolog-indent-line :around  #'prolog-indent-line/around)
;; (advice-remove 'prolog-indent-line #'prolog-indent-line/around)

(add-hook 'prolog-mode-hook
          (lambda ()
            (setq-local company-backends company-backends-non-lisp)
            ))

(define-key prolog-mode-map (kbd "C-M-c")      'comment-line)
(define-key prolog-mode-map (kbd "<f1>")       'prolog-help-on-predicate)

(define-key prolog-mode-map (kbd "M-<up>")     'drag-stuff-up)
(define-key prolog-mode-map (kbd "M-<down>")   'drag-stuff-down)

(define-key prolog-mode-map (kbd "C-<down>")   'prolog-end-of-clause)
(define-key prolog-mode-map (kbd "C-<up>")     'prolog-beginning-of-clause)

(add-hook 'prolog-inferior-mode-hook
          (lambda ()
            (setq-local company-backends company-backends-non-lisp)
            ))

(require 'ediprolog)
(setq ediprolog-system 'swi)
;; avoid conflicting with cygwin's swipl 
(setq ediprolog-program "c:/PROGRA~1/swipl/bin/swipl.exe")
;; (setq ediprolog-program "c:/PROGRA~1/swipl/bin/swipl-win.exe")

(defun ediprolog-kill ()
  (interactive "")
  (let ((current-prefix-arg 0))
    (call-interactively 'ediprolog-dwim)))

;; press [f5] to query, when cursor at ?-, 
;; press [f5] to consult file, when cursor at other position
;; press C-0 [f5] to kill ediprog's process
(define-key prolog-mode-map [f5]  'ediprolog-dwim)  ; when interaction block Emacs, press C-g to unblock
(define-key prolog-mode-map [f6]  'ediprolog-toplevel)  ; press f6 to resume interaction 
(define-key prolog-mode-map [f8]  'ediprolog-kill)

(defun prolog--at-expression-paredit-space-for-delimiter-predicate (endp delimiter)
  (if (not endp) nil t))

(add-hook 'prolog-mode-hook
          (lambda ()
            (setq-local paredit-space-for-delimiter-predicates '(prolog--at-expression-paredit-space-for-delimiter-predicate))
            (enable-paredit-mode)))

(add-hook 'prolog-inferior-mode-hook
          (lambda ()
            (setq-local paredit-space-for-delimiter-predicates '(prolog--at-expression-paredit-space-for-delimiter-predicate))
            (enable-paredit-mode)))

(provide 'sc-set-pl-prolog)
