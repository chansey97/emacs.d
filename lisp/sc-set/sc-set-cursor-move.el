;;----------------------------------------------------------------------------
;; sc-cursor-move
;;----------------------------------------------------------------------------
(require 'sc-cursor-move)

;; TODO: if not editing Lisp program?
(global-set-key (kbd "C-<right>") 'sc-forward)
(global-set-key (kbd "C-<left>")  'sc-backward)
(global-set-key (kbd "C-<down>")  'sc-forward-up)
(global-set-key (kbd "C-<up>")    'sc-backward-up)
