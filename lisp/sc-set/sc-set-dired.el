;;----------------------------------------------------------------------------
;; Dired
;;----------------------------------------------------------------------------
(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)

;; dired not create multiple buffers
(put 'dired-find-alternate-file 'disabled nil)
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))
