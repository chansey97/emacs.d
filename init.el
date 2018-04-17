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
;; Path
;;----------------------------------------------------------------------------

;; use grep/gtags/.. in windows

(when (eq system-type 'windows-nt)
  ;; (add-to-list 'exec-path "c:/env/gnu-win/glo662wb/bin")
  ;; (add-to-list 'exec-path "C:/cygwin64/bin")
  ;; (setenv "PATH"
  ;;         (concat
  ;;          "C:\\env\\gnu-win\\glo662wb\\bin" path-separator
  ;;          "C:\\cygwin64\\bin" path-separator
  ;;          (getenv "PATH")))
  
  (add-to-list 'exec-path "C:/cygwin64/usr/local/bin")
  (add-to-list 'exec-path "C:/cygwin64/bin")
  (setenv "PATH"
          (concat
           "C:\\cygwin64\\usr\\local\\bin" path-separator
           "C:\\cygwin64\\bin" path-separator
           (getenv "PATH")))
  (load-file (expand-file-name "cygwin-mount.el" user-emacs-directory))
  (cygwin-mount-activate)
)

;;----------------------------------------------------------------------------
;; Dired
;;----------------------------------------------------------------------------
(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)

;; dired not create multiple buffers
(put 'dired-find-alternate-file 'disabled nil)
(with-eval-after-load 'dired
    (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

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

;; keyboard selection:  C-.
(global-set-key (kbd "C-.") 'set-mark-command)

;; mouse selection: shift selection
(define-key global-map (kbd "<S-down-mouse-1>") 'mouse-save-then-kill)

;;----------------------------------------------------------------------------
;; Text Highlight
;;----------------------------------------------------------------------------

;; turn on highlighting current line
(global-hl-line-mode 1)

;; turn on bracket match highlight
(show-paren-mode 1)

;; highlight enclosing parens
(define-advice show-paren-function (:around (fn) fix-show-paren-function)
  "Highlight enclosing parens."
  (cond ((looking-at-p "\\s(") (funcall fn))
        (t (save-excursion
             (ignore-errors (backward-up-list))
             (funcall fn)))))

;; remember cursor position, for emacs 25.1 or later
(save-place-mode 1)

;;----------------------------------------------------------------------------
;; File Encoding
;;----------------------------------------------------------------------------

;; UTF-8 as default encoding
;; (set-language-environment "UTF-8")
;; (set-default-coding-systems 'utf-8)

;;----------------------------------------------------------------------------
;; Font
;;----------------------------------------------------------------------------
(set-fontset-font "fontset-default"
                  'symbol (font-spec :family "Symbola"))

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
;; (global-whitespace-mode 1)
;; (global-whitespace-newline-mode 1)

;; tab region like visual studio
(defun indent-region-custom(numSpaces)
  (progn
    ;; default to start and end of current line
    (setq regionStart (line-beginning-position))
    (setq regionEnd (line-end-position))

    ;; if there's a selection, use that instead of the current line
    (when (use-region-p)
      (setq regionStart (region-beginning))
      (setq regionEnd (region-end))
      )

    (save-excursion ; restore the position afterwards
      (goto-char regionStart) ; go to the start of region
      (setq start (line-beginning-position)) ; save the start of the line
      (goto-char regionEnd) ; go to the end of region
      (setq end (line-end-position)) ; save the end of the line

      (indent-rigidly start end numSpaces) ; indent between start and end
      (setq deactivate-mark nil) ; restore the selected region
      )
    )
  )

(defun untab-region (N)
  (interactive "p")
  (indent-region-custom -4)
  )

(defun tab-region (N)
  (interactive "p")
  (if (active-minibuffer-window)
      (minibuffer-complete)    ; tab is pressed in minibuffer window -> do completion
                                        ; else
    (if (string= (buffer-name) "*shell*")
        (comint-dynamic-complete) ; in a shell, use tab completion
                                        ; else
      (if (use-region-p)    ; tab is pressed is any other buffer -> execute with space insertion
          (indent-region-custom 4) ; region was selected, call indent-region
        (insert "    ") ; else insert four spaces as expected
        )))
  )

(global-set-key (kbd "<backtab>") 'untab-region)
(global-set-key (kbd "<tab>") 'tab-region)

;;----------------------------------------------------------------------------
;; Comment/Uncomment
;;----------------------------------------------------------------------------
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

(global-set-key (kbd "C-M-c") 'comment-or-uncomment-region-or-line)

;;----------------------------------------------------------------------------
;; When splitting window, show (other-buffer) in the new window and move cursor
;;----------------------------------------------------------------------------
(eval-when-compile (require 'cl))

(defun split-window-func-with-other-buffer (split-function)
  (lexical-let ((s-f split-function))
    (lambda ()
      (interactive)
      (funcall s-f)
      (set-window-buffer (next-window) (other-buffer))
      (other-window 1))))

(global-set-key (kbd "C-x 2") (split-window-func-with-other-buffer 'split-window-vertically))
(global-set-key (kbd "C-x 3") (split-window-func-with-other-buffer 'split-window-horizontally))

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
;; Frame size and features
;;----------------------------------------------------------------------------
;; no-splash
(setq inhibit-splash-screen 1)

;; frame size
(if (display-graphic-p)
    (progn
      (setq initial-frame-alist
            '(
              (width . 150) ; chars
              (height . 50) ; lines
              ))

      (setq default-frame-alist
            '(
              (width . 150)
              (height . 50)
              ))))

;; frame title use buffer name
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;;----------------------------------------------------------------------------
;; Hippie-expand setup
;;----------------------------------------------------------------------------
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


;;----------------------------------------------------------------------------
;; misc
;;----------------------------------------------------------------------------

;; set cursor to i-beam
(setq-default cursor-type 'bar)

;; turn off ring bell
(setq ring-bell-function 'ignore)

;; open browser when click hyperlink
(add-hook 'prog-mode-hook 'goto-address-prog-mode)
(setq goto-address-mail-face 'link)

;; type y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; open windows explorer in the current directory
(defun open-folder-in-explorer ()
  "Call when editing a file in a buffer. Open windows explorer in the current directory and select the current file"  
  (interactive)
  (w32-shell-execute
   "open" "explorer"
   (concat "/e,/select," (convert-standard-filename buffer-file-name))
   )
  )

;; Use F2 open init.el
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(global-set-key (kbd "<f2>") 'open-init-file)

;;----------------------------------------------------------------------------
;; Standard package repositories
;;----------------------------------------------------------------------------

(require 'package)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ; (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (if (< emacs-major-version 24)
      (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))
    (unless no-ssl
      ;; Force SSL for GNU ELPA
      (setcdr (assoc "gnu" package-archives) "https://elpa.gnu.org/packages/"))))



;;----------------------------------------------------------------------------
;; Auto install packages
;;----------------------------------------------------------------------------
(setq package-enable-at-startup nil)
(package-initialize)

(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (if (boundp 'package-selected-packages)
            ;; Record this as a package the user installed explicitly
            (package-install package nil)
          (package-install package))
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))

(require-package 'avy)
(require-package 'company)
(require-package 'ivy)
(require-package 'counsel)
(require-package 'swiper)
(require-package 'expand-region)
(require-package 'hungry-delete)
(require-package 'popwin)
(require-package 'symbol-overlay)
(require-package 'markdown-mode)
(require-package 'smartparens)
(require-package 'ace-window)
(require-package 'undo-tree)
(require-package 'tabbar)
(require-package 'tabbar-ruler)
(require-package 'scheme-here)
(require-package 'projectile)
(require-package 'ggtags)
(require-package 'sr-speedbar)
(require-package 'projectile-speedbar)



;;----------------------------------------------------------------------------
;; avy
;;----------------------------------------------------------------------------
(require 'avy)
(global-set-key (kbd "C-:") 'avy-goto-char)

;;----------------------------------------------------------------------------
;; company
;;----------------------------------------------------------------------------
(require 'company)
(global-company-mode 1)
(setq company-idle-delay 0.1)
(setq company-minimum-prefix-length 1)

;;----------------------------------------------------------------------------
;; ivy & counsel & swiper
;;----------------------------------------------------------------------------
(require 'ivy)
(require 'counsel)
(require 'counsel)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key (kbd "C-f") 'swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-h f") 'counsel-describe-function)
(global-set-key (kbd "C-h v") 'counsel-describe-variable)

;; IDO-style directory navigation
(define-key ivy-minibuffer-map (kbd "RET") #'ivy-alt-done)
(define-key ivy-minibuffer-map (kbd "<up>") #'ivy-previous-line-or-history)

;;----------------------------------------------------------------------------
;; expand-region
;;----------------------------------------------------------------------------
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;;----------------------------------------------------------------------------
;; hungry-delete
;;----------------------------------------------------------------------------
(require 'hungry-delete)
(setq hungry-delete-chars-to-skip " \t")
(global-hungry-delete-mode)

;;----------------------------------------------------------------------------
;; popwin 
;;----------------------------------------------------------------------------
(require 'popwin)
(popwin-mode t)

;;----------------------------------------------------------------------------
;; symbol-overlay
;;----------------------------------------------------------------------------
(require 'symbol-overlay)
(add-hook 'prog-mode-hook 'symbol-overlay-mode)
(setq symbol-overlay-idle-time 0.1)

;;----------------------------------------------------------------------------
;; symbol-overlay
;;----------------------------------------------------------------------------
(require 'smartparens-config)
(add-hook 'prog-mode-hook 'smartparens-mode)
(sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
(sp-local-pair 'lisp-interaction-mode "'" nil :actions nil)

;;----------------------------------------------------------------------------
;; ace-window
;;----------------------------------------------------------------------------
(require 'ace-window)
(global-set-key (kbd "C-o") 'ace-window)
(global-set-key (kbd "M-o") 'ace-swap-window)
(set-face-attribute 'aw-leading-char-face nil :foreground "red" :weight 'bold :height 3.0)

;;----------------------------------------------------------------------------
;; undo-tree
;;----------------------------------------------------------------------------
(require 'undo-tree)
(global-undo-tree-mode 1)

(defalias 'redo 'undo-tree-redo)

;;----------------------------------------------------------------------------
;; tabbar & tabbar-ruler
;;----------------------------------------------------------------------------
;; (require 'tabbar-ruler)
(setq tabbar-ruler-global-tabbar t)    ; get tabbar
;; (setq tabbar-ruler-global-ruler t)     ; get global ruler
;; (setq tabbar-ruler-popup-menu t)       ; get popup menu.
;; (setq tabbar-ruler-popup-toolbar t)    ; get popup toolbar
;; (setq tabbar-ruler-popup-scrollbar t)  ; show scroll-bar on mouse-move
(require 'tabbar-ruler)


;;----------------------------------------------------------------------------
;; projectile
;;----------------------------------------------------------------------------
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)
(setq-default projectile-completion-system 'ivy)

(global-set-key (kbd "<f3>") 'projectile-find-file)
(global-set-key (kbd "C-S-f") 'projectile-grep)

;;----------------------------------------------------------------------------
;; speedbar sr-speedbar projectile-speedbar
;;----------------------------------------------------------------------------
(require 'sr-speedbar)

(setq sr-speedbar-width-x 40)
(setq sr-speedbar-width-console 40)

(require 'projectile-speedbar)
(global-set-key (kbd "<f4>") 'projectile-speedbar-open-current-buffer-in-tree)



;;----------------------------------------------------------------------------
;; scheme
;;----------------------------------------------------------------------------
(require 'scheme-here)
(add-hook 'scheme-mode-hook
  (lambda ()
    ; (paredit-mode 1)
    (define-key scheme-mode-map (kbd "<f5>") 'scheme-here-send-sexp)
    (define-key scheme-mode-map (kbd "<f6>") 'scheme-here-eval-buffer)))



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (smartparens symbol-overlay page-break-lines popwin hungry-delete expand-region counsel company avy))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
