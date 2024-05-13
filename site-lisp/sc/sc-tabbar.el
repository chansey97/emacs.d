
;;----------------------------------------------------------------------------
;; tabbar.el (old)
;;----------------------------------------------------------------------------
(require 'tabbar)
(tabbar-mode t)

(defun tabbar-popup-source-focus ()
  (interactive)
  (let ((buffer (tabbar-tab-value tabbar-last-tab)))
    (switch-to-buffer buffer))
  ;;(treemacs--follow-tag-at-point)
  (treemacs--follow))

(defun tabbar-popup-open-folder-in-explorer ()
  (interactive)
  (let* ((buf (tabbar-tab-value tabbar-last-tab))
         (fn (buffer-file-name buf)))
    (w32explore (file-name-directory fn))))

(defun tabbar-popup-menu/filter-return (xs)
  (let ((x (car xs))
        (xs (cdr xs))
        (y1 `["Source focus" tabbar-popup-source-focus])
        (y2 `["Open folder in explorer" tabbar-popup-open-folder-in-explorer])
        (l "---")
        )
    (cons x (cons y1 (cons y2 (cons "---" xs))))))

(defun tabbar-scroll-left/override (event)
  "On mouse EVENT, scroll current tab set on left. step 10"
  (when (eq (event-basic-type event) 'mouse-1)
    (tabbar-scroll (tabbar-current-tabset) -10)))

;; TODO: doesn't work in terminal?
(when (display-graphic-p)
  (require 'tabbar-ruler)
  (setq tabbar-ruler-global-tabbar t)
  (advice-add 'tabbar-popup-menu :filter-return #'tabbar-popup-menu/filter-return)
  (advice-add 'tabbar-scroll-left :override #'tabbar-scroll-left/override)
  )

(provide 'sc-tabbar)
