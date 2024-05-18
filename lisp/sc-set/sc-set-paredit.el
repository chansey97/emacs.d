;;----------------------------------------------------------------------------
;; paredit
;;----------------------------------------------------------------------------
(require 'paredit)

;; making paredit work with delete-selection-mode
(put 'paredit-forward-delete 'delete-selection 'supersede)
(put 'paredit-backward-delete 'delete-selection 'supersede)
(put 'paredit-newline 'delete-selection t)

;; C-) eat right expression i.e. ctrl + shift + )
;; C-( eat left expression i.e. ctrl + shift + (
;; C-} spit out right expression i.e. ctrl + shift + }
;; C-{ spit out left expression i.e. ctrl + shift + (
;; M-r raise-sexp (remove one level outer parentheses) i.e. alt + r
;; C-M-f cursor forward
;; C-M-b cursor backward

;; Change nasty paredit keybindings (s means superkey, S means shift)
(defvar my-nasty-paredit-keybindings-remappings
  '(("M-s"         "s-s"         paredit-splice-sexp)
    ("M-<up>"      "s-<up>"      paredit-splice-sexp-killing-backward)
    ("M-<down>"    "s-<down>"    paredit-splice-sexp-killing-forward)
    ("C-<right>"   "s-<right>"   paredit-forward-slurp-sexp)
    ("C-<left>"    "s-<left>"    paredit-forward-barf-sexp)
    ("C-M-<left>"  "s-S-<left>"  paredit-backward-slurp-sexp)
    ("C-M-<right>" "s-S-<right>" paredit-backward-barf-sexp)))

;; (define-key paredit-mode-map (kbd "s-r") 'paredit-raise-sexp)

(--each my-nasty-paredit-keybindings-remappings
  (let ((original (car it))
        (replacement (cadr it))
        (command (car (last it))))
    (define-key paredit-mode-map (read-kbd-macro original) nil)
    (define-key paredit-mode-map (read-kbd-macro replacement) command)))

;; don't hijack \ please (eg: ^S\)
(define-key paredit-mode-map (kbd "\\") nil)
