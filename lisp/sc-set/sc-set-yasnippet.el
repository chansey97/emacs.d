;;----------------------------------------------------------------------------
;; yasnippet
;;----------------------------------------------------------------------------
(require 'yasnippet)
(yas-global-mode 1)

;; (defconst yas-maybe-clear-field '(menu-item "" yas-clear-field :filter yas--maybe-clear-field-filter)
;;   "A conditional key definition.
;; This can be used as a key definition in keymaps to bind a key to
;; `yas-clear-field' only when at the beginning of an
;; unmodified snippet field.")

;; (define-key yas-keymap (kbd "DEL")   yas-maybe-clear-field)

;; (defun yas-clear-field (&optional field)
;;   "Clears unmodified FIELD if at field start."
;;   (interactive)
;;   (yas--skip-and-clear (or field (yas-current-field))))
