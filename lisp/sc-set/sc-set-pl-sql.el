;;----------------------------------------------------------------------------
;; SQL Mode
;;----------------------------------------------------------------------------
(require 'sql)
(require 'sql-upcase)
;; (require 'sc-utils)

(defun sql-send-dwim ()
  (interactive)
  (cond ((use-region-p) (call-interactively 'sql-send-region))
        ;; ((sc-current-line-empty-p) (sql-send-buffer))
        (t (sql-send-line-and-next))
        ))

(define-key sql-mode-map [f5]  'sql-send-dwim)
(define-key sql-mode-map (kbd "C-M-c")  'comment-line)
(define-key sql-mode-map (kbd "C-M-u")  'sql-upcase-buffer)

(add-hook 'sql-mode-hook 'sql-upcase-mode)
(add-hook 'sql-interactive-mode-hook 'sql-upcase-mode)
(add-hook 'sql-mode-hook (lambda ()
                           (setq-local company-backends company-backends-non-lisp)
                           ))

;; sqlite
;; avoid conflicting with cygwin's sqlite3 
(setq sql-sqlite-program "c:/env/sqlite/sqlite-win32-x86-3370000/sqlite3.exe")
;; (add-to-list 'sql-sqlite-options "-interactive")

(require 'sqlite-dump)
(modify-coding-system-alist 'file "\\.sqlite3\\'" 'raw-text-unix)
(modify-coding-system-alist 'file "\\.sqlite\\'" 'raw-text-unix)
(add-to-list 'auto-mode-alist '("\\.sqlite3\\'" . sqlite-dump))
(add-to-list 'auto-mode-alist '("\\.sqlite\\'" . sqlite-dump))

;; postgres
(setq sql-postgres-program "C:/PROGRA~1/PostgreSQL/12/bin/psql.exe")
(setenv "PGPASSWORD" "")
