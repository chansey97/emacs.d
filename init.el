;;----------------------------------------------------------------------------
;; Debug
;;----------------------------------------------------------------------------
;; (setq debug-on-error t)

;; Check which command uses.
;; (defun --print-post-command ()
;;   (message "--print-post-command: %s" this-command))
;; (add-hook 'post-command-hook '--print-post-command)
;; (remove-hook 'post-command-hook '--print-post-command)

;;----------------------------------------------------------------------------
;; Emacs Version
;;----------------------------------------------------------------------------
(let ((minver "27.2"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))

;;----------------------------------------------------------------------------
;; Adjust garbage collection
;;----------------------------------------------------------------------------
(setq garbage-collection-messages t)
;; The default value of gc-cons-threshold is 800000 - just 7.6MiB,
;; but I didn't see any remarkable effect when setting the these variables. 
;; (setq gc-cons-threshold (* gc-cons-threshold 2))
;; (setq gc-cons-percentage 0.5)
;; (run-with-idle-timer 30 t #'garbage-collect)

;; Profiling variables:
;; gcs-done
;; (emacs-init-time)

;;----------------------------------------------------------------------------
;; Load Path
;;----------------------------------------------------------------------------
(defun add-subdirs-to-load-path (dir)
  "Recursive add `dir' and its subdirectories to `load-path'."
  (let ((default-directory (file-name-as-directory dir)))
    (add-to-list 'load-path dir)
    (normal-top-level-add-subdirs-to-load-path)))
(add-subdirs-to-load-path (expand-file-name "site-lisp" user-emacs-directory))
(add-subdirs-to-load-path (expand-file-name "lisp" user-emacs-directory))

;;----------------------------------------------------------------------------
;; Emacs Lite
;;----------------------------------------------------------------------------
;; The minimal portable configuration, for debug purpose.
(require 'sc-set-emacs-lite)



;;----------------------------------------------------------------------------
;; Emacs Configurations
;;----------------------------------------------------------------------------

;; (require 'sc-set-cygwin)

;;----------------------------------------------------------------------------
;; Graphics
;;----------------------------------------------------------------------------
;; https://github.com/emacs-mirror/emacs/blob/8098ad9679c7f5ea19493bdae18227f7a81b3eb4/etc/NEWS.28#L3951
(when (and (eq system-type 'windows-nt)
           (version<= "28.1" emacs-version))
  (setq w32-use-native-image-API t))

(require 'sc-set-server)

(require 'sc-set-coding-system)

(require 'sc-set-font)

;;----------------------------------------------------------------------------
;; Recycle Bin
;;----------------------------------------------------------------------------
(setq delete-by-moving-to-trash t)

;;----------------------------------------------------------------------------
;; Context Menu
;;----------------------------------------------------------------------------
;; https://github.com/emacs-mirror/emacs/blob/61ad641893bc521e98cc06162634299d57b2bf8a/etc/NEWS.28#L277
(when (version<= "28.1" emacs-version)
  (context-menu-mode 1))

(require 'sc-set-tool-bar-back-button)

(require 'sc-set-dired)

;;----------------------------------------------------------------------------
;; Text Editing
;;----------------------------------------------------------------------------

;; make {copy, cut, paste, undo} have {C-c, C-x, C-v, C-z} keys
;; Since I use cua-mode by default, so you can use C-Enter into "cua-set-rectangle-mark" directly.
(cua-mode 1)

;; standard keyboard shortcuts for {Open, Close, Save, Save As, Select All, …}

;; make emacs use standard keys

;; Select All. was move-beginning-of-line
(global-set-key (kbd "C-a") 'mark-whole-buffer)

;; search forward with Ctrl-f. was forward-char
;; (global-set-key (kbd "C-f") 'isearch-forward)
;; (define-key isearch-mode-map [(control f)] (lookup-key isearch-mode-map "\C-s"))
;; (define-key minibuffer-local-isearch-map [(control f)]
;;   (lookup-key minibuffer-local-isearch-map "\C-s"))

;; search backward with Alt-f. 
;; (global-set-key (kbd "M-f") 'isearch-backward)
;; (define-key isearch-mode-map [(meta f)] (lookup-key isearch-mode-map "\C-r"))
;; (define-key minibuffer-local-isearch-map [(meta f)]
;;   (lookup-key minibuffer-local-isearch-map "\C-r"))

;; (define-key isearch-mode-map (kbd "C-v") 'isearch-yank-kill)

;; Save. was isearch-forward
(global-set-key (kbd "C-s") 'save-buffer)

;; Save As. was nil
;; (global-set-key (kbd "C-S-s") 'write-file)

;; Paste. was scroll-up-command
(global-set-key (kbd "C-v") 'yank)

;; Close. was kill-region
(global-set-key (kbd "C-w") 'kill-buffer)

;; Redo. was yank
;; (global-set-key (kbd "C-y") 'undo-redo)
(global-set-key (kbd "C-y") 'redo) ; undo-tree-redo

;; Undo. was suspend-frame
(global-set-key (kbd "C-z") 'undo)

;; make typing delete/overwrites selected text
(delete-selection-mode 1)

;; keyboard selection:  C-.
;; Note: I can't bind C-m as 'set-mark-command, because in default emacs C-m is the same as RET.
;; When run in a terminal, return and C-m are not distinguishable. https://stackoverflow.com/questions/7235381/unbind-c-m-from-ret
;; (global-set-key (kbd "C-m") 'set-mark-command)
(global-set-key (kbd "C-.") 'set-mark-command)

;; mouse selection: shift selection
(define-key global-map (kbd "<S-down-mouse-1>") 'mouse-save-then-kill)

(require 'sc-set-select-current-line)

;;----------------------------------------------------------------------------
;; Text Highlight
;;----------------------------------------------------------------------------

;; turn on highlighting current line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#fef8df")

(require 'sc-set-paren)

;; remember cursor position, for emacs 25.1 or later
(save-place-mode 1)

;;----------------------------------------------------------------------------
;; Displaying Line Numbers and Column Number
;;----------------------------------------------------------------------------

;; always show line numbers
(if (version< emacs-version "29.1")
    (global-linum-mode 1)
  (global-display-line-numbers-mode 1))

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

;; TODO: Try 'kill-buffer-delete-auto-save-files' in Emacs 28.1
;; https://github.com/emacs-mirror/emacs/blob/8098ad9679c7f5ea19493bdae18227f7a81b3eb4/etc/NEWS.28#L316

;;----------------------------------------------------------------------------
;; Open Recently Opened Files
;;----------------------------------------------------------------------------

;; keep a list of recently opened files
(require 'recentf)
(recentf-mode 1)

;; save/restore opened files
(desktop-save-mode 1)

(setq desktop-base-lock-name
      (convert-standard-filename (format ".emacs.desktop.lock-%d" (emacs-pid))))

;;----------------------------------------------------------------------------
;; Tabs, Space, Indentation, Keyword Completion
;;----------------------------------------------------------------------------

;; make indentation commands use space only (never tab character)
;; if indent-tabs-mode is t, it means it may use tab, resulting mixed space and tab
;; emacs 23.1, 24.2, default to t
(setq-default indent-tabs-mode nil)

;; set default tab char's display width to 4 spaces
(setq-default tab-width 2) ; emacs 23.1, 24.2, default to 8

;; make tab key call indent command or insert tab character, depending on cursor position
(setq-default tab-always-indent nil)


;; make return key also do indent, globally
;; Start from Emacs 28.1, 'electric-indent-mode' now also indents inside strings and comments,
;; but can recover the previous behavior if you want.
;; https://github.com/emacs-mirror/emacs/blob/8098ad9679c7f5ea19493bdae18227f7a81b3eb4/etc/NEWS.28#L874
(electric-indent-mode 1)

;; toggle on/off globally for current emacs session.
;; (global-whitespace-mode 1)
;; (global-whitespace-newline-mode 1)

;; tab region like visual studio (means: use customized tab instead of emacs' tab)
(defun indent-region-custom (numSpaces)
  
  ;; default to start and end of current line
  (setq regionStart (line-beginning-position))
  (setq regionEnd (line-end-position))

  ;; if there's a selection, use that instead of the current line
  (when (use-region-p)
    (setq regionStart (region-beginning))
    (setq regionEnd (region-end))
    )
  
  ;; restore the position afterwards
  (save-excursion
    (goto-char regionStart) ; go to the start of region
    (setq start (line-beginning-position)) ; save the start of the line
    (goto-char regionEnd) ; go to the end of region
    (setq end (line-end-position)) ; save the end of the line

    (indent-rigidly start end numSpaces) ; indent between start and end
    (setq deactivate-mark nil) ; restore the selected region
    ))

(defun untab-region (N)
  (interactive "p")
  (indent-region-custom -2)
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
          (indent-region-custom 2) ; region was selected, call indent-region
        (insert "  ") ; else insert 2 spaces as expected
        )))
  )

(global-set-key (kbd "<backtab>") 'untab-region)
(global-set-key (kbd "<S-tab>") 'untab-region)
(global-set-key (kbd "<tab>") 'tab-region)

;; Indent

;; indent whole buffer (replace some code pretty plugins)
(defun indent-buffer()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer()
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end))
          (message "Indent selected region."))
      (progn
        (indent-buffer)
        (message "Indent buffer.")))))

;; https://github.com/greghendershott/racket-mode/issues/603#issuecomment-1068405777
;; (defun sc-indent-buffer-except-comments ()
;;   "Indent the entire buffer, except for comment lines."
;;   (interactive)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (let ((end (point-max)))
;;       (while (< (point) end)
;;         (unless (elt (syntax-ppss) 4) ;comment
;;           (indent-according-to-mode))
;;         (forward-line 1)))))
;; (global-set-key (kbd "C-M-l") 'sc-indent-buffer-except-comments)

(global-set-key (kbd "C-M-l") 'indent-region-or-buffer)

;;----------------------------------------------------------------------------
;; hungry delete
;;----------------------------------------------------------------------------
;; (require 'hungry-delete)
;; (setq hungry-delete-chars-to-skip " \t")
;; (global-hungry-delete-mode)

;; https://emacs.stackexchange.com/questions/33734/how-to-get-hungry-delete-working-in-paredit-mode
(setq backward-delete-char-untabify-method 'hungry)

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


(require 'sc-set-window-split)

;;----------------------------------------------------------------------------
;; disable warnings
;;----------------------------------------------------------------------------

;; stop warning prompt for some commands. There's always undo.
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)
(put 'scroll-left 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)


;;----------------------------------------------------------------------------
;; minibuffer
;;----------------------------------------------------------------------------

;; save minibuffer history
(savehist-mode 1)

;;----------------------------------------------------------------------------
;; Frame size and features
;;----------------------------------------------------------------------------

;; maximize on start-up
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
;; (toggle-frame-maximized)

;; frame size
;; (if (display-graphic-p)
;;     (progn
;;       (setq initial-frame-alist
;;             '(
;;               (width . 150) ; chars
;;               (height . 50) ; lines
;;               ))

;;       (setq default-frame-alist
;;             '(
;;               (width . 150)
;;               (height . 50)
;;               ))))

;; no-splash
(setq inhibit-splash-screen 1)

;; frame title use buffer name
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; show menu
(menu-bar-mode 1)

(require 'sc-set-hippie-exp)

;;----------------------------------------------------------------------------
;; page-break-lines
;;----------------------------------------------------------------------------
;; To insert ^L in an Emacs buffer, hit ‘C-q C-l’.
(require 'page-break-lines)
(global-page-break-lines-mode)

;;----------------------------------------------------------------------------
;; misc
;;----------------------------------------------------------------------------
(when (version<= "28.1" emacs-version)
  (setq use-short-answers 't))

;; set cursor to i-beam
(setq-default cursor-type 'bar)
(add-hook 'overwrite-mode-hook ; press INSERT key to enable/disable overwrite-mode
          (lambda ()
            (setq cursor-type (if overwrite-mode t 'bar))))

;; turn off ring bell
(setq ring-bell-function 'ignore)

;; open browser when click hyperlink
(add-hook 'prog-mode-hook 'goto-address-prog-mode)
(setq goto-address-mail-face 'link)

;; type y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Use F2 open init.el
(defun open-init-file()
  (interactive)
  (find-file (expand-file-name "init.el" user-emacs-directory))
  (when (fboundp 'treemacs--follow)
    (treemacs--follow)))
(global-set-key (kbd "<f2>") 'open-init-file)

(require 'sc-set-menu)

;; TODO: add a mouse menu to copy, cut, paste, etc
(global-set-key [mouse-3] 'mouse-buffer-menu)
;; (global-set-key [mouse-3] 'mouse-popup-menubar-stuff)
;; (global-set-key [mouse-3] 'mouse-popup-menubar)

;; Unbind [C-x C-b] (list-buffers) to avoid mistouching
;; switch-to-buffer's key-binding is [C-x b].
;; kill-buffer's      key-binding is [C-x k].
(global-set-key [C-x C-b] nil)

;; Prevent accidental touch with middle click
(global-unset-key [mouse-2])

;; Mark
(setq global-mark-ring-max 500)

(require 'sc-set-tool-bar)


;; Redefine xref-find-references keybinding 
;; xref-find-references's keybinding should be M-?, I don't know why it be used by dabbrev-expand M-/
(global-set-key (kbd "M-/") 'xref-find-references)



;;----------------------------------------------------------------------------
;; Standard package repositories
;;----------------------------------------------------------------------------
(require 'package)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
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

;; Need package-refresh-contents first before installing



(require-package 'avy)
(require-package 'ivy)
(require-package 'counsel)
(require-package 'swiper)
(require-package 'expand-region)
;; (require-package 'popwin)
(require-package 'symbol-overlay)
(require-package 'markdown-mode)
(require-package 'smartparens)
(require-package 'paredit)
(require-package 'ace-window)
(require-package 'undo-tree)
(require-package 'projectile)
(require-package 'ggtags)
(require-package 'sml-mode)
(require-package 'tuareg)
(require-package 'el-search)
(require-package 'haskell-mode)
(require-package 'slime)
(require-package 'drag-stuff)
;; (require-package 'racket-mode)
;; (require-package 'rg)



(require 'sc-set-drag-stuff)
(require 'sc-set-drag-sexp)

(require 'sc-set-yasnippet)
(require 'sc-set-company)
(require 'sc-set-ivy)
(require 'sc-set-expand-region)
(require 'sc-set-symbol-overlay)
(require 'sc-set-smartparens)
(require 'sc-set-paredit)

(require 'sc-set-cursor-move)

(require 'sc-set-window)
(require 'sc-set-undo-tree)
(require 'sc-set-tab-line)
(require 'sc-set-header-line)
(require 'sc-set-projectile)
(require 'sc-set-rg)
(require 'sc-set-treemacs)
(require 'sc-set-shell)

(require 'sc-set-pl-elisp)
(require 'sc-set-pl-scheme)
(require 'sc-set-pl-racket)
(require 'sc-set-pl-racket-pie)
(require 'sc-set-pl-cl)
(require 'sc-set-pl-sml)
(require 'sc-set-pl-ocaml)
(require 'sc-set-pl-haskell)
(require 'sc-set-pl-prolog)
(require 'sc-set-pl-smt)
(require 'sc-set-pl-sql)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(slime yasnippet smartparens symbol-overlay page-break-lines popwin hungry-delete expand-region counsel company avy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


