;;----------------------------------------------------------------------------
;; OCaml (tuareg)
;;----------------------------------------------------------------------------
(require 'tuareg)
(setq tuareg-indent-align-with-first-arg t
      tuareg-match-patterns-aligned t)

(define-key tuareg-mode-map [f8] 'caml-types-show-type)
(define-key tuareg-mode-map (kbd "M-<up>") 'drag-stuff-up)
(define-key tuareg-mode-map (kbd "M-<down>") 'drag-stuff-down)
