;;----------------------------------------------------------------------------
;; menu
;;----------------------------------------------------------------------------

;; Automatically add an Imenu menu to the menu bar
(defun try-to-add-imenu ()
  (condition-case nil (imenu-add-to-menubar "imenu") (error nil)))
(add-hook 'prog-mode-hook 'try-to-add-imenu)
