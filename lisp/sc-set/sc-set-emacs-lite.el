


;;----------------------------------------------------------------------------
;; smooth-scroll
;;----------------------------------------------------------------------------
;; (pixel-scroll-mode 1) ; Doesn't see any difference...

;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ; don't accelerate scrolling
;; (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
;; (setq scroll-step 1) ;; keyboard scroll one line at a time

;; TODO: fast drag the vertical scroll bar would cause screen freezing
;; Don't know what happen, but not the problem of cua-mode, back-button, and treemacs.
