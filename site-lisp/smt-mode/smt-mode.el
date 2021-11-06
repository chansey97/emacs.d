;;; smt-mode.el --- Major mode for editing and run SMT-LIB code.

;; Author: Siyuan Chen (chansey97@gmail.com)

;; NOTE:
;; The smt-mode is derived from scheme-mode instead of lisp-mode,
;; because lisp-mode has been taken over by slime. slime has a bug
;; that if you don't connect to REPL, i.e. start slime, it will cause
;; a "Not connected" error, when using company-mode.

;; TODO:
;; Create a new sexp-mode from general lisp style programming.

;;;###autoload
(define-derived-mode smt-mode scheme-mode "SMT"
  "Major mode for editing and run SMT-LIB code."
  )

;;;###autoload
(define-derived-mode smt-inferior-mode shell-mode "Inferior SMT"
  "Major mode for interacting with an inferior Z3/cvc4/.. process.")

(defun run-z3 ()
  "Send 'z3 -in' to `shell' buffer."
  (interactive)
  (comint-send-string
   (get-buffer-process (shell "*z3*"))
   "z3 -version\nz3 -in\n")
  (smt-inferior-mode)
  )

(defun run-cvc4 ()
  "Send 'cvc4 -m --lang smt2' to `shell' buffer."
  (interactive)
  (comint-send-string
   (get-buffer-process (shell "*cvc4*"))
   "cvc4 -m --lang smt2\n")
  (smt-inferior-mode))

(provide 'smt-mode)
