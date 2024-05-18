;;----------------------------------------------------------------------------
;; Window Manager
;;----------------------------------------------------------------------------

;;----------------------------------------------------------------------------
;; popwin 
;;----------------------------------------------------------------------------
;; (require 'popwin)
;; (popwin-mode t)
;; (add-to-list popwin:special-display-config '(help-mode 0.5 :position below))
;; help-mode 的 window 会在底部弹出，是因为 popwin-mode 的关系，并非 help-mode 有什么特殊


;;----------------------------------------------------------------------------
;; ace-window (select and swap window)
;;----------------------------------------------------------------------------
(require 'ace-window)
(setq aw-dispatch-always t)
(set-face-attribute 'aw-leading-char-face nil :foreground "red" :weight 'bold :height 3.0)
;; It's useful when a search window lost focus
(global-set-key (kbd "<f3>") 'ace-swap-window)
(global-set-key (kbd "<f4>") 'ace-window)


