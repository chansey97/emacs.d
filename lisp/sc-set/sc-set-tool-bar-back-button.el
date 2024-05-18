;; Back-button
;; press the plus sign in the toolbar to create a mark
;; press the arrows in the toolbar to navigate marks
;; or use C-x C-Space as usual, then try C-x C-<right>
;; to reverse the operation
(when (eq system-type 'windows-nt)
  (require 'back-button)
  (back-button-mode 1))
