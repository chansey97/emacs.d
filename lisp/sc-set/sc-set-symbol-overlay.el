;;----------------------------------------------------------------------------
;; symbol-overlay (highlight at cursor)
;;----------------------------------------------------------------------------
(require 'symbol-overlay)
(setq symbol-overlay-idle-time 0.1)

(defun enable-symbol-overlay-mode ()
  (unless (or (minibufferp)
              (derived-mode-p 'magit-mode)
              (derived-mode-p 'xref--xref-buffer-mode))
    (symbol-overlay-mode t)))

(define-global-minor-mode global-symbol-overlay-mode symbol-overlay-mode
  enable-symbol-overlay-mode)

(global-symbol-overlay-mode)


(provide 'sc-set-symbol-overlay)
