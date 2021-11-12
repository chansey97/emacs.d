(require 'paredit)

(defun looking-back-one-char-p (regexp)
  (save-excursion
    (backward-char)
    (looking-at-p regexp)))

(defun backward-same-syntax ()
  (interactive)
  (let ((current-prefix-arg '(-1)))
    (call-interactively 'forward-same-syntax)))

(defun sc/forward-sexp ()
  (interactive)
  (let ((sp (point)))
    (call-interactively 'paredit-forward)
    (call-interactively 'paredit-backward)
    (when (<= (point) sp)
      (call-interactively 'paredit-forward))
    ))

(defun sc/backward-sexp ()
  (interactive)
  (let ((sp (point)))
    (call-interactively 'paredit-backward)
    (call-interactively 'paredit-forward)
    (when (>= (point) sp)
      (call-interactively 'paredit-backward))))

(defun sc/forward-token ()
  (interactive)
  (cond
   ((looking-at-p "\\s(")
    (call-interactively 'forward-char))
   (t
    (call-interactively 'sc/forward-sexp))))

(defun sc/backward-token ()
  (interactive)
  (cond
   ((looking-back-one-char-p "\\s)")
    (call-interactively 'backward-char))
   (t
    (call-interactively 'sc/backward-sexp))))

(defun try-paredit-forward-up ()
  (let ((r t))
    (condition-case nil
          (paredit-forward-up)
        (scan-error (setq r nil)))
    r))

(defun try-paredit-backward-up ()
  (let ((r t))
    (condition-case nil
          (paredit-backward-up)
        (scan-error (setq r nil)))
    r))

(defun sc/forward ()
  (interactive)
  (if (use-region-p)
      (call-interactively 'sc/forward-sexp)
    (if (looking-at-p "\\s(\\|\\s)")
        (call-interactively 'forward-same-syntax)
      (call-interactively 'sc/forward-token))))

(defun sc/backward ()
  (interactive)
  (if (use-region-p)
      (call-interactively 'sc/backward-sexp)
    (if (looking-back-one-char-p "\\s(\\|\\s)")
        (call-interactively 'backward-same-syntax)
      (call-interactively 'sc/backward-token))))

(defun sc/forward-up ()
  (interactive)
  (when (not (try-paredit-forward-up))
    (call-interactively 'sc/forward-sexp)))

(defun sc/backward-up ()
  (interactive)
  (when (not (try-paredit-backward-up))
    (call-interactively 'sc/backward-sexp)))

(provide 'sc/cursor-move)
