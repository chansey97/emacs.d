(let ((minver "24.3"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version< emacs-version "24.5")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

;;----------------------------------------------------------------------------
;; Adjust garbage collection
;;----------------------------------------------------------------------------

(when (eq system-type 'windows-nt)
  (setq gc-cons-threshold (* 512 1024 1024))
  (setq gc-cons-percentage 0.5)
  (run-with-idle-timer 5 t #'garbage-collect)
  ;; show gc info for debugging
  (setq garbage-collection-messages t)
)



;;----------------------------------------------------------------------------
;; Text Editing
;;----------------------------------------------------------------------------

;; make {copy, cut, paste, undo} have {C-c, C-x, C-v, C-z} keys
(cua-mode 1)

;; standard keyboard shortcuts for {Open, Close, Save, Save As, Select All, …}
(progn
 ;; make emacs use standard keys

  ;; Select All. was move-beginning-of-line
  (global-set-key (kbd "C-a") 'mark-whole-buffer)

  ;; search forward with Ctrl-f. was forward-char
  (global-set-key (kbd "C-f") 'isearch-forward)
  (define-key isearch-mode-map [(control f)] (lookup-key isearch-mode-map "\C-s"))
  (define-key minibuffer-local-isearch-map [(control f)]
    (lookup-key minibuffer-local-isearch-map "\C-s"))

  ;; search backward with Alt-f. 
  (global-set-key (kbd "M-f") 'isearch-backward)
  (define-key isearch-mode-map [(meta f)] (lookup-key isearch-mode-map "\C-r"))
  (define-key minibuffer-local-isearch-map [(meta f)]
    (lookup-key minibuffer-local-isearch-map "\C-r"))
  
  (define-key isearch-mode-map (kbd "C-v") 'isearch-yank-kill)

  ;; Save. was isearch-forward
  (global-set-key (kbd "C-s") 'save-buffer)

  ;; Save As. was nil
  (global-set-key (kbd "C-S-s") 'write-file)

  ;; Paste. was scroll-up-command
  (global-set-key (kbd "C-v") 'yank)
  
  ;; Close. was kill-region
  (global-set-key (kbd "C-w") 'kill-buffer)

  ;; Redo. was yank
  (global-set-key (kbd "C-y") 'redo)

  ;; Undo. was suspend-frame
  (global-set-key (kbd "C-z") 'undo)
  ;;
  )

;; make typing delete/overwrites selected text
(delete-selection-mode 1)

;;----------------------------------------------------------------------------
;; Text Highlight
;;----------------------------------------------------------------------------

;; turn on highlighting current line
(global-hl-line-mode 1)

;; turn on bracket match highlight
(show-paren-mode 1)

;; remember cursor position, for emacs 25.1 or later
(save-place-mode 1)

;;----------------------------------------------------------------------------
;; File Encoding
;;----------------------------------------------------------------------------

;; UTF-8 as default encoding
; (set-language-environment "UTF-8")
; (set-default-coding-systems 'utf-8)

;;----------------------------------------------------------------------------
;; Displaying Line Numbers and Column Number
;;----------------------------------------------------------------------------

; always show line numbers
(global-linum-mode 1) 

;; show cursor position within line
(column-number-mode 1)

;;----------------------------------------------------------------------------
;; Stop Backup File
;;----------------------------------------------------------------------------

;; stop creating those backup~ files
(setq make-backup-files nil)

;; stop creating those #auto-save# files
(setq auto-save-default nil)

;; when a file is updated outside emacs, make it update if it's already opened in emacs
(global-auto-revert-mode 1)

;;----------------------------------------------------------------------------
;; Open Recently Opened Files
;;----------------------------------------------------------------------------

;; keep a list of recently opened files
(require 'recentf)
(recentf-mode 1)

;; save/restore opened files
(desktop-save-mode 1)

;;----------------------------------------------------------------------------
;; Tabs, Space, Indentation, Keyword Completion
;;----------------------------------------------------------------------------

;; make indentation commands use space only (never tab character)
(setq-default indent-tabs-mode nil)
;; emacs 23.1, 24.2, default to t
;; if indent-tabs-mode is t, it means it may use tab, resulting mixed space and tab

;; set default tab char's display width to 4 spaces
(setq-default tab-width 4) ; emacs 23.1, 24.2, default to 8

;; make tab key call indent command or insert tab character, depending on cursor position
(setq-default tab-always-indent nil)

;; make return key also do indent, globally
(electric-indent-mode 1)

;; toggle on/off globally for current emacs session.
; (global-whitespace-mode 1)

;;----------------------------------------------------------------------------
;; Type y/n instead of yes/no
;;----------------------------------------------------------------------------

(defalias 'yes-or-no-p 'y-or-n-p)

;;----------------------------------------------------------------------------
;; disable warnings
;;----------------------------------------------------------------------------

(progn
  ;; stop warning prompt for some commands. There's always undo.
  (put 'narrow-to-region 'disabled nil)
  (put 'narrow-to-page 'disabled nil)
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (put 'erase-buffer 'disabled nil)
  (put 'scroll-left 'disabled nil)
  (put 'dired-find-alternate-file 'disabled nil)
  )

;;----------------------------------------------------------------------------
;; minibuffer
;;----------------------------------------------------------------------------

;; save minibuffer history
(savehist-mode 1)


;;----------------------------------------------------------------------------
;; Default Window (frame) Size
;;----------------------------------------------------------------------------

(if (display-graphic-p)
    (progn
      (setq initial-frame-alist
            '(
              (width . 140) ; chars
              (height . 40) ; lines
              ))

      (setq default-frame-alist
            '(
              (width . 140)
              (height . 40)
              ))))

;;----------------------------------------------------------------------------
;; misc
;;----------------------------------------------------------------------------

;; set cursor to i-beam
(setq-default cursor-type 'bar)

;; no-splash
(setq inhibit-splash-screen 1)

;; hippie-expand setup
(setq hippie-expand-try-functions-list
      '(
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        ;; try-expand-dabbrev-from-kill
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol
        try-complete-file-name-partially
        try-complete-file-name
        ;; try-expand-all-abbrevs
        ;; try-expand-list
        ;; try-expand-line
        ))

;; Use F2 open init.el
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(global-set-key (kbd "<f2>") 'open-init-file)


