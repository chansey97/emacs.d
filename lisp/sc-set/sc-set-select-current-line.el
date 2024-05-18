;; select current line
(defvar sc-last-pos nil)

(defun sc-select-current-line ()
  "Select the current line"
  (interactive)
  (setq sc-last-pos (point))
  (beginning-of-line)
  (push-mark (point) nil t)
  (end-of-line))

(defun sc-select-current-line-cancel ()
  (when (eq last-command 'sc-select-current-line)
    (goto-char sc-last-pos)))

(advice-add 'keyboard-quit :before #'sc-select-current-line-cancel)
(advice-add 'minibuffer-keyboard-quit :before #'sc-select-current-line-cancel)
(advice-add 'cua-cancel :before #'sc-select-current-line-cancel)

(global-set-key (kbd "C--") 'sc-select-current-line)
