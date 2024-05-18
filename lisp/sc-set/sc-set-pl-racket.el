;;----------------------------------------------------------------------------
;; racket-mode
;;----------------------------------------------------------------------------
(require 'racket-mode)
(require 'sc-utils)
(setq racket-program "C:\\Program Files\\Racket\\Racket.exe")
;; (add-to-list 'auto-mode-alist '("\\.scm\\'" . racket-mode)) ; Racket r5rs
;; (setq racket-error-context 'medium)

(defun racket-raco-make ()
  (let* ((racket  (executable-find racket-program))
         (rkt     (racket--buffer-file-name) )
         (command (format "%s -l raco make -v %s"
                          (shell-quote-wildcard-pattern racket)
                          (shell-quote-wildcard-pattern rkt))))
    (shell-command command)))

;; When your project heavily uses macro, (add-hook 'racket-before-run-hook #'racket-raco-make)
(add-hook 'racket-before-run-hook #'racket-raco-make)
;; (remove-hook 'racket-before-run-hook #'racket-raco-make)

(defun racket-run-dwim ()
  (interactive)
  (cond ((use-region-p) (call-interactively 'racket-send-region))
        ((sc-current-line-empty-p) (racket-run-module-at-point))
        (t (racket-send-last-sexp))))

(define-key racket-mode-map [f1] 'racket-xp-documentation)
(define-key racket-mode-map [f5] 'racket-run-dwim)
(define-key racket-mode-map [f6] 'racket-expand-last-sexp)
(define-key racket-mode-map [f7] 'racket-run-with-debugging)
(define-key racket-mode-map [f8] 'racket-debug-disable)

(add-hook 'racket-mode-hook 'racket-xp-mode)
(add-hook 'racket-mode-hook 'enable-paredit-mode)

;; (setq racket-logger-config '((racket-mode . debug)
;;                             (cm-accomplice . warning)
;;                             (GC . info)
;;                             (module-prefetch . warning)
;;                             (optimizer . info)
;;                             (racket/contract . error)
;;                             (sequence-specialization . info)
;;                             (* . fatal)))

;; Racket qi's indentation
;; https://docs.racket-lang.org/qi/Introduction_and_Usage.html#%28part._.Indentation%29
(put 'switch 'racket-indent-function 1)
(put 'switch-lambda 'racket-indent-function 1)
(put 'on 'racket-indent-function 1)
(put 'π 'racket-indent-function 1)
(put 'try 'racket-indent-function 1)
