;;----------------------------------------------------------------------------
;; Tool Bar
;;----------------------------------------------------------------------------
(tool-bar-mode 1)

;; Open *Messages* buffer
(defun open-messages-buffer ()
  (interactive)
  ;; (switch-to-buffer-other-window "*Messages*")
  (pop-to-buffer "*Messages*"))

(tool-bar-add-item "show" 'open-messages-buffer 'open-messages-buffer :help "Open *Messages* buffer")

;; Erase *Messages* buffer
(defun erase-messages-buffer ()
  (interactive)
  (let ((inhibit-read-only t))
    (with-current-buffer "*Messages*"
      (erase-buffer))))

;; ICON can be found at emacs/share/emacs/28.2/etc/images
(tool-bar-add-item "delete" 'erase-messages-buffer 'erase-messages-buffer :help "Erase *Messages* buffer")

;; TODO: Open *scratch* buffer and *ielm* buffer


(provide 'sc-set-tool-bar)
