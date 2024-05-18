;;----------------------------------------------------------------------------
;; Split window
;;----------------------------------------------------------------------------
(eval-when-compile (require 'cl))

;; when splitting window, show (other-buffer) in the new window and move cursor
(defun split-window-func-with-other-buffer (split-function)
  (lexical-let ((s-f split-function))
    (lambda ()
      (interactive)
      (funcall s-f)
      (set-window-buffer (next-window) (other-buffer))
      (other-window 1))))

(global-set-key (kbd "C-x 2") (split-window-func-with-other-buffer 'split-window-vertically))
(global-set-key (kbd "C-x 3") (split-window-func-with-other-buffer 'split-window-horizontally))
(global-set-key (kbd "C-x 0") 'delete-window) ; by default

;; when resolution is high, emacs automatically split window
;; http://blog.mpacula.com/2012/01/28/howto-prevent-emacs-from-splitting-windows/
;; fix the problem about clicking a grep result will split a new window
;; instead of reusing old window
;; https://stackoverflow.com/questions/9433013/can-i-make-emacs-grep-windows-just-use-the-other-window-to-open-files-in
(setq split-height-threshold nil)
(setq split-width-threshold nil)

(provide 'sc-set-window-split)
