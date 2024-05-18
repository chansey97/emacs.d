;;----------------------------------------------------------------------------
;; sml-mode
;;----------------------------------------------------------------------------
(require 'sml-mode)
(require 'sc-utils)

(defun my-sml-rules (orig kind token)
  (pcase (cons kind token)
    (`(:before . "d=")
     (if (smie-rule-parent-p "structure" "signature" "functor") 2
       (funcall orig kind token)))
    (`(:after . "struct") 2)
    (_ (funcall orig kind token))))

(defadvice sml-smie-rules (around my-sml-rules activate)
  (let ((i (pcase (cons (ad-get-arg 0) (ad-get-arg 1))
             (`(:before . "d=")
              (if (smie-rule-parent-p "structure" "signature" "functor") 2))
             (`(:after . "struct") 2))))
    (if i
        (setq ad-return i)
      ad-do-it)))

;; Correct indentation for structures
;; https://lists.gnu.org/archive/html/help-gnu-emacs/2014-10/msg00108.html
(add-function :around (symbol-function 'sml-smie-rules) #'my-sml-rules)

(defun sml-prog-proc-send-line ()
  "Send the content of the current line to the read-eval-print process."
  (interactive)
  (save-mark-and-excursion
    (sc-select-current-line)
    (call-interactively 'sml-prog-proc-send-region)))

(defun run-sml-dwim ()
  (interactive)
  (cond ((use-region-p) (call-interactively 'sml-prog-proc-send-region))
        ((sc-current-line-empty-p) (call-interactively 'sml-prog-proc-load-file))
        (t (sml-prog-proc-send-line))))

(define-key sml-mode-map [f5] 'run-sml-dwim)
(define-key sml-mode-map (kbd "M-<up>") 'drag-stuff-up)
(define-key sml-mode-map (kbd "M-<down>") 'drag-stuff-down)
(define-key sml-mode-map (kbd "C-<down>") 'forward-paragraph)
(define-key sml-mode-map (kbd "C-<up>") 'backward-paragraph)

(add-hook 'sml-mode-hook
          (lambda ()
            ;; In SML, newline + auto-indentation works fine only if the statements
            ;; are ended in semi-colons. However, most of time we do not use semi-colons in .sml.
            ;; So `electric-indent-mode  have to be disabled for this major mode.
            (electric-indent-local-mode -1)
            (setq-local company-backends company-backends-non-lisp)
            ))

(add-hook 'inferior-sml-mode-hook
          (lambda ()
            (electric-indent-local-mode -1)
            (setq-local company-backends company-backends-non-lisp)
            ))

(defun sml--at-expression-paredit-space-for-delimiter-predicate (endp delimiter)
  (if (not endp) nil t))

(add-hook 'sml-mode-hook
          (lambda ()
            (setq-local paredit-space-for-delimiter-predicates '(sml--at-expression-paredit-space-for-delimiter-predicate))
            (enable-paredit-mode)))

(add-hook 'inferior-sml-mode-hook
          (lambda ()
            (setq-local paredit-space-for-delimiter-predicates '(sml--at-expression-paredit-space-for-delimiter-predicate))
            (enable-paredit-mode)))


(provide 'sc-set-pl-sml)
