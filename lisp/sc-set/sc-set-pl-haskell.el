;;----------------------------------------------------------------------------
;; haskell-mode
;; I doesn't use haskell-mode in Emacs at the moment, use vscode instead.
;;----------------------------------------------------------------------------
;; (setq haskell-process-log t)
(require 'haskell-mode)
(require 'haskell-interactive-mode)
(require 'haskell-process)

(setq haskell-process-suggest-remove-import-lines t
      haskell-process-auto-import-loaded-modules t
      haskell-process-type 'ghci)

(define-key haskell-mode-map (kbd "M-.") 'haskell-mode-jump-to-def)
(define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)

(define-key haskell-mode-map (kbd "M-<up>")   'drag-stuff-up)
(define-key haskell-mode-map (kbd "M-<down>") 'drag-stuff-down)
(define-key haskell-mode-map (kbd "C-<down>") 'forward-paragraph)
(define-key haskell-mode-map (kbd "C-<up>")   'backward-paragraph)

(defun haskell-process-toggle ()
  "Toggle GHCi process between cabal and ghci"
  (interactive)
  (if (equal 'ghci haskell-process-type)
      (progn (setq haskell-process-type 'cabal-repl)
             (message "Using cabal repl"))
    (progn (setq haskell-process-type 'ghci)
           (message "Using GHCi"))))
