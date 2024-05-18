;;----------------------------------------------------------------------------
;; scheme-mode
;;----------------------------------------------------------------------------
(require 'cmuscheme)
(require 'sc-utils)
(setq auto-mode-alist (cons '("\\.ss" . scheme-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.sls" . scheme-mode) auto-mode-alist))

;; properly indent certain Scheme special forms
(put 'cond 'scheme-indent-function 0)
(put 'pmatch 'scheme-indent-function 1)
(put 'match 'scheme-indent-function 1)
(put 'dmatch 'scheme-indent-function 1)
(put 'let-values 'scheme-indent-function 1)
(put 'call-with-values 'scheme-indent-function 2)
(put 'syntax-case 'scheme-indent-function 2)
(put 'test 'scheme-indent-function 1)
(put 'test-check 'scheme-indent-function 1)
(put 'test-divergence 'scheme-indent-function 1)
(put 'make-engine 'scheme-indent-function 0)
(put 'trace-lambda 'scheme-indent-function 1)
;; (put 'if 'scheme-indent-function 1)
(put 'and 'scheme-indent-function 0)

;;; miniKanren-specific indentation
(put 'lambdaf@ 'scheme-indent-function 1)
(put 'lambdag@ 'scheme-indent-function 1)
(put 'fresh 'scheme-indent-function 1)
(put 'exists 'scheme-indent-function 1)
(put 'exist 'scheme-indent-function 1)
(put 'nom 'scheme-indent-function 1)
(put 'run 'scheme-indent-function 2)
(put 'conde 'scheme-indent-function 0)
(put 'conda 'scheme-indent-function 0)
(put 'condu 'scheme-indent-function 0)
(put 'project 'scheme-indent-function 1)
(put 'run* 'scheme-indent-function 1)
(put 'case-inf 'scheme-indent-function 1)
(put 'tabled 'scheme-indent-function 1)

;;; font-lock for additional Scheme keywords
;;; http://www.emacswiki.org/emacs/AddKeywords
(defun scheme-add-keywords (face-name keyword-rules)
  (let* ((keyword-list (mapcar #'(lambda (x) (symbol-name (cdr x))) keyword-rules))
	       (keyword-regexp (concat "(\\(" (regexp-opt keyword-list) "\\)[ \n]")))
    (font-lock-add-keywords 'scheme-mode `((,keyword-regexp 1 ',face-name)))))

(scheme-add-keywords
 'font-lock-keyword-face
 '((1 . fresh)
   (1 . conde)
   (1 . run)
   (1 . run*)
   (1 . match)
   (1 . pmatch)
   (1 . dmatch)
   (1 . tabled)
   (1 . syntax-case)
   (1 . with-syntax)
   (1 . unless)
   (1 . when)
   (1 . library)
   (1 . export)
   (1 . import)
   ))

;; Copy from cmuscheme and override run-scheme, using switch-to-buffer-other-window
;; instead of pop-to-buffer-same-window.
(defun run-scheme/override (cmd)
  (interactive (list (if current-prefix-arg
			                   (read-string "Run Scheme: " scheme-program-name)
			                 scheme-program-name)))
  (if (not (comint-check-proc "*scheme*"))
      (let ((cmdlist (split-string-and-unquote cmd)))
	      (set-buffer (apply 'make-comint "scheme" (car cmdlist)
			                     (scheme-start-file (car cmdlist)) (cdr cmdlist)))
	      (inferior-scheme-mode)))
  (setq scheme-program-name cmd)
  (setq scheme-buffer "*scheme*")
  (switch-to-buffer-other-window "*scheme*"))
(advice-add 'run-scheme :override #'run-scheme/override)

(defun run-scheme-dwim ()
  (interactive)
  (cond ((use-region-p) (call-interactively 'scheme-send-region))
        ((sc-current-line-empty-p) (scheme-load-file (buffer-name)))
        (t (scheme-send-last-sexp))))

;; For Chez Scheme 48 use "(expand '%s)" instead of "(expand %s)"
(setq scheme-macro-expand-command "(expand '%s)")

(add-hook 'scheme-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook
          (lambda ()
            (local-set-key [f5] 'run-scheme-dwim)
            (local-set-key [f6] 'scheme-expand-current-form)
            ))
(sp-local-pair 'scheme-mode-hook "'" nil :actions nil)
(add-hook 'inferior-scheme-mode 'enable-paredit-mode)

;; It makes multi-line printing neater.
;; For example,
;; (+ 1 2)| <-- call scheme-send-last-sexp
;; By default, the output in REPL is:
;; > 3
;; Now is:
;; >
;; 3
(defun scheme-send-region/override (start end)
  "Send the current region to the inferior Scheme process."
  (interactive "r")
  (let ((proc (scheme-proc))
        (buf (get-buffer scheme-buffer)))
    ;; Stolen from racket-repl.el
    (with-current-buffer buf
      (save-excursion
        (goto-char (process-mark proc))
        (insert ?\n)
        (set-marker (process-mark proc) (point))))
    (comint-send-region proc start end)
    (comint-send-string proc "\n")))

(advice-add 'scheme-send-region :override #'scheme-send-region/override)

;; Copy from lisp-indent-line in lisp-mode.el
(defun scheme-indent-line (&optional indent)
  "Indent current line as Lisp code."
  (interactive)
  (let ((pos (- (point-max) (point)))
        (indent (progn (beginning-of-line)
                       (or indent (calculate-lisp-indent (lisp-ppss))))))
    (skip-chars-forward " \t")
    (if (or (null indent) (looking-at "\\s<\\s<\\s<"))
	      ;; Don't alter indentation of a ;;; comment line
	      ;; or a line that starts in a string.
        ;; FIXME: inconsistency: comment-indent moves ;;; to column 0.
	      (goto-char (- (point-max) pos))
      ;; Single-semicolon comment lines NOT indented!
      (if (listp indent) (setq indent (car indent)))
      (indent-line-to indent)
      ;; If initial point was within line's indentation,
      ;; position after the indentation.  Else stay at same point in text.
      (if (> (- (point-max) pos) (point))
	        (goto-char (- (point-max) pos))))))

(add-hook 'scheme-mode-hook (lambda () (setq-local indent-line-function 'scheme-indent-line)))


(provide 'sc-set-pl-scheme)
