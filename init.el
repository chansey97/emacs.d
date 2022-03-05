;; (setq debug-on-error t)

;; (defun print-post-command ()
;;   (message "this-command: %s" this-command))
;; (add-hook 'post-command-hook 'print-post-command)
;; (remove-hook 'post-command-hook 'print-post-command)

(let ((minver "24.3"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version< emacs-version "24.5")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))



;;----------------------------------------------------------------------------
;; Adjust garbage collection
;;----------------------------------------------------------------------------

(when (eq system-type 'windows-nt)
  (setq gc-cons-threshold 80000000) ;; original value *100 = 80MB
  ;; (setq gc-cons-threshold (* 512 1024 1024))
  ;;   (setq gc-cons-percentage 0.5)
  ;;   (run-with-idle-timer 30 t #'garbage-collect)
  ;;   ;; show gc info for debugging
  ;;   (setq garbage-collection-messages t)
  )


;;----------------------------------------------------------------------------
;; Path
;;----------------------------------------------------------------------------

;; load path
(defun add-subdirs-to-load-path (dir)
  "Recursive add directories to `load-path'."
  (let ((default-directory (file-name-as-directory dir)))
    (add-to-list 'load-path dir)
    (normal-top-level-add-subdirs-to-load-path)))
(add-subdirs-to-load-path (concat user-emacs-directory "site-lisp"))

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

  (require 'cygwin-mount)
  (cygwin-mount-activate))

(defun shell-cygwin ()
  "Run cygwin bash in shell mode."
  (interactive)
  (let ((explicit-shell-file-name "C:/cygwin64/bin/bash"))
    (call-interactively 'shell)))

;;----------------------------------------------------------------------------
;; Encoding (UTF-8 by default)
;;----------------------------------------------------------------------------
;; Set locale
;; Note that windows' locale doesn't rely on LANG (or any other LC_X environmental variable).
;; It is set in Control Panel. I set LANG and LC_ALL here is just to simulate *nix behavior,
;; because some applications assume you are using *nix.  
(when (eq system-type 'windows-nt)
  (setenv "LANG" "en_GB.UTF-8")
  (setenv "LC_ALL" "en_GB.UTF-8"))

;; Set emacs language environment
(set-language-environment "UTF-8")

;; Set coding system
(set-default-coding-systems 'utf-8)
(prefer-coding-system       'utf-8)

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; Workaound for windows cmd.exe
;; (when (eq system-type 'windows-nt)
;;   (set-default 'process-coding-system-alist
;;                '(("[pP][lL][iI][nN][kK]" gbk . gbk)
;; 	               ("[cC][mM][dD][pP][rR][oO][xX][yY]" gbk . gbk)
;; 	               ("[gG][sS]" gbk . gbk))))

;;----------------------------------------------------------------------------
;; Recycle Bin
;;----------------------------------------------------------------------------
(setq delete-by-moving-to-trash t)

;;----------------------------------------------------------------------------
;; Back-button
;;----------------------------------------------------------------------------
;; press the plus sign in the toolbar to create a mark
;; press the arrows in the toolbar to navigate marks
;; or use C-x C-Space as usual, then try C-x C-<right>
;; to reverse the operation

(when (eq system-type 'windows-nt)
  (require 'back-button)
  (back-button-mode 1))

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
;; Since I use cua-mode by default, so you can use C-Enter into "cua-set-rectangle-mark" directly.
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

;; select current line
(defvar sc/last-pos nil)

(defun sc/select-current-line ()
  "Select the current line"
  (interactive)
  (setq sc/last-pos (point))
  (beginning-of-line)
  (push-mark (point) nil t)
  (end-of-line))

(defun sc/select-current-line-cancel ()
  (when (eq last-command 'sc/select-current-line)
    (goto-char sc/last-pos)))

(advice-add 'keyboard-quit :before #'sc/select-current-line-cancel)
(advice-add 'minibuffer-keyboard-quit :before #'sc/select-current-line-cancel)
(advice-add 'cua-cancel :before #'sc/select-current-line-cancel)

(global-set-key (kbd "C--") 'sc/select-current-line)

;;----------------------------------------------------------------------------
;; Text Highlight
;;----------------------------------------------------------------------------

;; turn on highlighting current line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#fef8df")

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
;; Font of text
;;----------------------------------------------------------------------------
(setq inhibit-compacting-font-caches t)

(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font)
                    charset (font-spec :family "Microsoft Yahei" :size 14)))

;; Symbola include many Mathematical Alphanumeric Symbols, but windows has no this font by default.
;; So install it, if use windows. https://fontlibrary.org/en/font/symbola
(set-fontset-font "fontset-default"
                  'symbol (font-spec :family "Symbola" :size 16))

;; Resize font
;; Use C-x C-0 to start text-scale-adjust, use + - 0 for further adjustment
(setq text-scale-mode-step 1.1)         ;finer inc/dec than default 1.2

;;----------------------------------------------------------------------------
;; Displaying Line Numbers and Column Number
;;----------------------------------------------------------------------------

;; always show line numbers
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
(electric-indent-mode 1)

;; toggle on/off globally for current emacs session.
;; (global-whitespace-mode 1)
;; (global-whitespace-newline-mode 1)

;; tab region like visual studio (means: use customized tab instead of emacs' tab)
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
;; Open windows explorer
;;----------------------------------------------------------------------------
(require 'w32-browser)
;; support directory path and filename path
;; (w32explore "c:/Users/Chansey/AppData/Roaming/.emacs.d/site-lisp/prolog.el")
;; (w32explore "c:/Users/Chansey/AppData/Roaming/.emacs.d/site-lisp/")

(defun open-folder-in-explorer ()
  "Call when editing a file in a buffer. Open windows explorer in the current directory and select the current file"  
  (interactive)
  (w32explore (convert-standard-filename buffer-file-name)))

;;----------------------------------------------------------------------------
;; page-break-lines
;;----------------------------------------------------------------------------
;; To insert ^L in an Emacs buffer, hit ‘C-q C-l’.
(require 'page-break-lines)
(global-page-break-lines-mode)

;;----------------------------------------------------------------------------
;; misc
;;----------------------------------------------------------------------------

;; set cursor to i-beam
(setq-default cursor-type 'bar)
(add-hook 'overwrite-mode-hook
          (lambda ()
            (setq cursor-type (if overwrite-mode t 'bar))))

;; turn off ring bell
(setq ring-bell-function 'ignore)

;; open browser when click hyperlink
(add-hook 'prog-mode-hook 'goto-address-prog-mode)
(setq goto-address-mail-face 'link)

;; type y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; get current file’s path
(defun get-current-file-path ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name))
  (kill-new (file-truename buffer-file-name))
  )

;; Use F2 open init.el
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el")
  (treemacs--follow))

(global-set-key (kbd "<f2>") 'open-init-file)

;; Automatically add an Imenu menu to the menu bar
(defun try-to-add-imenu ()
  (condition-case nil (imenu-add-to-menubar "imenu") (error nil)))
(add-hook 'prog-mode-hook 'try-to-add-imenu)

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

;; Clear *Messages* buffer, if too many messages.
(defun erase-messages-buffer ()
  (interactive)
  (let ((inhibit-read-only t))
    (with-current-buffer "*Messages*"
      (erase-buffer))))

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

(require-package 'avy)
(require-package 'ivy)
(require-package 'counsel)
(require-package 'swiper)
(require-package 'expand-region)
(require-package 'popwin)
(require-package 'symbol-overlay)
(require-package 'markdown-mode)
(require-package 'smartparens)
(require-package 'paredit)
(require-package 'ace-window)
(require-package 'undo-tree)
(require-package 'tabbar)
(require-package 'tabbar-ruler)
(require-package 'projectile)
(require-package 'ggtags)
(require-package 'sml-mode)
(require-package 'yasnippet)
(require-package 'yasnippet-snippets)
(require-package 'tuareg)
(require-package 'el-search)
(require-package 'haskell-mode)
(require-package 'slime)
(require-package 'drag-stuff)
;; (require-package 'racket-mode)



;;----------------------------------------------------------------------------
;; Utils
;;----------------------------------------------------------------------------
(require 'sc/utils)

;;----------------------------------------------------------------------------
;; Drag-stuff
;;----------------------------------------------------------------------------
(require 'drag-stuff)
(setq drag-stuff-by-symbol-p 1)
;; (global-set-key (kbd "M-<up>") 'drag-stuff-up)
;; (global-set-key (kbd "M-<down>")  'drag-stuff-down)

;;----------------------------------------------------------------------------
;; Drag S-Expression
;;----------------------------------------------------------------------------
(defun drag-prev-sexp-forward ()
  (interactive)
  (call-interactively 'transpose-sexps))

(defun drag-prev-sexp-backward ()
  (interactive)
  (let ((current-prefix-arg '(-1)))
    (call-interactively 'transpose-sexps)))

(global-set-key (kbd "M-<right>") 'drag-prev-sexp-forward)
(global-set-key (kbd "M-<left>") 'drag-prev-sexp-backward)

(global-set-key (kbd "M-<down>") 'drag-prev-sexp-forward)
(global-set-key (kbd "M-<up>") 'drag-prev-sexp-backward)

;;----------------------------------------------------------------------------
;; avy
;;----------------------------------------------------------------------------
(require 'avy)
(global-set-key (kbd "C-:") 'avy-goto-char)

;;----------------------------------------------------------------------------
;; yasnippet
;;----------------------------------------------------------------------------
(require 'yasnippet)
(yas-global-mode 1)

;;----------------------------------------------------------------------------
;; company
;;----------------------------------------------------------------------------
(require 'company)
(global-company-mode 1)
(setq company-idle-delay 0.1)
(setq company-minimum-prefix-length 1)

;;----------------------------------------------------------------------------
;; company backends
;;----------------------------------------------------------------------------
(require 'company-math)
(setq company-dabbrev-char-regexp "\\sw\\|_\\|-\\|!\\|\\?\\|*\\|+\\|=\\|>\\|<")

;; Note:
;; company-mode/backend-with-yas must be added to last (head of company-backends),
;; otherwise when you type `use` in prolog-mode, the candidates will be
;; |use -> :- use_module(library(${1:predicate1})).|
;; |use                                            |
;; instead of
;; |use                                            |
;; |use -> :- use_module(library(${1:predicate1})).|
;; I don't know why...
;; company-backends-lisp means auto complete |f -> (f)|
;; company-backends-non-lisp means auto complete |f -> f()|
(setq company-backends-lisp '(company-math-symbols-unicode
                              (company-capf
                               company-dabbrev
                               company-yasnippet-autoparens
                               company-yasnippet)
                              ))

(setq company-backends-non-lisp '(company-math-symbols-unicode
                                  (company-capf
                                   company-dabbrev
                                   company-yasnippet-autoparens-2
                                   company-yasnippet)
                                  ))

;; company-backends-lisp is default setting, if need company-backends-non-lisp in a specific mode,
;; (setq-local company-backends company-backends-non-lisp) in that mode hook.
(setq company-backends company-backends-lisp)

;;----------------------------------------------------------------------------
;; company-quickhelp-mode
;;----------------------------------------------------------------------------
(require 'company-quickhelp)
(company-quickhelp-mode)

;;----------------------------------------------------------------------------
;; ivy & counsel & swiper
;;----------------------------------------------------------------------------
(require 'ivy)
(require 'counsel)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key (kbd "C-f") 'swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-h f") 'counsel-describe-function)
(global-set-key (kbd "C-h v") 'counsel-describe-variable)

;; tab complete in counsel
(define-key counsel-find-file-map (kbd "<tab>") #'ivy-insert-current)
(define-key counsel-describe-map (kbd "<tab>") #'ivy-insert-current)

;; IDO-style directory navigation
(define-key ivy-minibuffer-map (kbd "RET") #'ivy-alt-done)
(define-key ivy-minibuffer-map (kbd "<up>") #'ivy-previous-line-or-history)

;; ;; disable wildcard when C-f
;; (setq ivy-re-builders-alist
;;       '((swiper . regexp-quote)
;;         ))

;;----------------------------------------------------------------------------
;; Selection expand-region
;;----------------------------------------------------------------------------
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
;; (global-set-key (kbd "C--") 'er/contract-region); (kbd "C--") be used by select-current-line

;;----------------------------------------------------------------------------
;; popwin 
;;----------------------------------------------------------------------------
(require 'popwin)
(popwin-mode t)

;;----------------------------------------------------------------------------
;; symbol-overlay (highlight at cursor)
;;----------------------------------------------------------------------------
(require 'symbol-overlay)
(setq symbol-overlay-idle-time 0.1)

(defun enable-symbol-overlay-mode ()
  (unless (or (minibufferp)
              (derived-mode-p 'magit-mode)
              (derived-mode-p 'xref--xref-buffer-mode))
    (symbol-overlay-mode t)))

(define-global-minor-mode global-symbol-overlay-mode symbol-overlay-mode
  enable-symbol-overlay-mode)

(global-symbol-overlay-mode)

;;----------------------------------------------------------------------------
;; smartparens
;;----------------------------------------------------------------------------
(require 'smartparens-config)

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

;;----------------------------------------------------------------------------
;; sc/cursor-move
;;----------------------------------------------------------------------------
(require 'sc/cursor-move)

;; TODO: if not editing Lisp program?
(global-set-key (kbd "C-<right>") 'sc/forward)
(global-set-key (kbd "C-<left>")  'sc/backward)
(global-set-key (kbd "C-<down>")  'sc/forward-up)
(global-set-key (kbd "C-<up>")    'sc/backward-up)

;;----------------------------------------------------------------------------
;; ace-window (select and swap window)
;;----------------------------------------------------------------------------
(require 'ace-window)
(setq aw-dispatch-always t)
(set-face-attribute 'aw-leading-char-face nil :foreground "red" :weight 'bold :height 3.0)
;; It's useful when a search window lost focus
(global-set-key (kbd "<f3>") 'ace-swap-window)
(global-set-key (kbd "<f4>") 'ace-window)

;;----------------------------------------------------------------------------
;; undo-tree
;;----------------------------------------------------------------------------
(require 'undo-tree)
(global-undo-tree-mode 1)

(defalias 'redo 'undo-tree-redo)

;;----------------------------------------------------------------------------
;; tabbar
;;----------------------------------------------------------------------------
(require 'tabbar)
(tabbar-mode t)

(defun tabbar-popup-source-focus ()
  (interactive)
  (let ((buffer (tabbar-tab-value tabbar-last-tab)))
    (switch-to-buffer buffer))
  ;;(treemacs--follow-tag-at-point)
  (treemacs--follow))

(defun tabbar-popup-open-folder-in-explorer ()
  (interactive)
  (let* ((buf (tabbar-tab-value tabbar-last-tab))
         (fn (buffer-file-name buf)))
    (w32explore (file-name-directory fn))))

(defun tabbar-popup-menu/filter-return (xs)
  (let ((x (car xs))
        (xs (cdr xs))
        (y1 `["Source focus" tabbar-popup-source-focus])
        (y2 `["Open folder in explorer" tabbar-popup-open-folder-in-explorer])
        (l "---")
        )
    (cons x (cons y1 (cons y2 (cons "---" xs))))))

(defun tabbar-scroll-left/override (event)
  "On mouse EVENT, scroll current tab set on left. step 10"
  (when (eq (event-basic-type event) 'mouse-1)
    (tabbar-scroll (tabbar-current-tabset) -10)))

;; TODO: doesn't work in terminal?
(when (display-graphic-p)
  (require 'tabbar-ruler)
  (setq tabbar-ruler-global-tabbar t)
  (advice-add 'tabbar-popup-menu :filter-return #'tabbar-popup-menu/filter-return)
  (advice-add 'tabbar-scroll-left :override #'tabbar-scroll-left/override)
  )

;;----------------------------------------------------------------------------
;; projectile
;;----------------------------------------------------------------------------
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)
(setq-default projectile-completion-system 'ivy)

(defun projectile-get-project-directories/override () '("./"))
(defun projectile-prepend-project-name/override (string) (format "[.] %s" string))

(defun projectile-current-directory-grep ()
  "Perform rgrep in the current directory."
  (advice-add 'projectile-get-project-directories :override #'projectile-get-project-directories/override)
  (advice-add 'projectile-prepend-project-name :override #'projectile-prepend-project-name/override)
  (call-interactively 'projectile-grep)
  (advice-remove 'projectile-get-project-directories #'projectile-get-project-directories/override)
  (advice-remove 'projectile-prepend-project-name #'projectile-prepend-project-name/override))

(defun sc/projectile-search (c)
  "Perform various search."
  (interactive
   (list
    (read-char "Search text in current directory (by default), or project (𝟭), or search file (𝟮): ")))
  (cond
   ((equal c ?1) (call-interactively 'projectile-grep))
   ((equal c ?2) (call-interactively 'projectile--find-file))
   (t (projectile-current-directory-grep))))

(global-set-key (kbd "C-S-f") 'sc/projectile-search)

(defun ch-remove-grep--command ()
  (save-excursion
    (goto-char 1)
    (search-forward "Grep started at " nil t)
    (line-move 2)
    (delete-region (line-beginning-position) (line-end-position))
    )
  )

(add-hook 'compilation-filter-hook 'ch-remove-grep--command)

;;----------------------------------------------------------------------------
;; smooth-scroll
;;----------------------------------------------------------------------------
;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
;; (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
;; (setq scroll-step 1) ;; keyboard scroll one line at a time

;;----------------------------------------------------------------------------
;; treemacs
;;----------------------------------------------------------------------------
(require 'treemacs)

;; - Start
(add-hook 'emacs-startup-hook 'treemacs)

;; (with-eval-after-load 'winum
;;   (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))

;; If want to decrease font size in treemacs, use text-scale-decrease in treemacs buffer
;; current win-emacs has no magick support, so can not decrease icon
;; https://github.com/Alexander-Miller/treemacs/issues/652
;; https://github.com/Alexander-Miller/treemacs/issues/842
(add-hook 'treemacs-mode-hook
          (lambda ()
            (message "treemacs-mode-hook `%s'" (current-buffer))
            (text-scale-increase -2)
            ))

;; - Session Persistence
(setq treemacs-persist-file							 (expand-file-name ".cache/treemacs-persist" user-emacs-directory))

;; - View
(setq treemacs-width											 50)
(setq treemacs-space-between-root-nodes	   t) 
(setq treemacs-sorting										 'alphabetic-asc) 
(setq treemacs-no-png-images							 nil) 
(setq treemacs-is-never-other-window			 nil) 
(setq treemacs-show-hidden-files					 t)
(setq treemacs-indentation								 1) 
(setq treemacs-indentation-string				 " ")

;; The default width and height of the icons is 22 pixels. If you are
;; using a Hi-DPI display, uncomment this to double the icon size.
(treemacs-resize-icons 22)

;; if need to resize treemacs' window, select treemacs window and call treemacs-toggle-fixed-width
;; https://github.com/Alexander-Miller/treemacs/issues/514

;; - Follow-mode and Tag-follow-mode

;; Make scrolling activate the treemacs window so the follow modes don't reset the position all the time
;; (if (string-equal system-type "gnu/linux") ;; linux
;;     (progn
;; 	    (define-key treemacs-mode-map [mouse-4] (lambda () (interactive) (treemacs-select-window) (scroll-down 5)))
;; 	    (define-key treemacs-mode-map [mouse-5] (lambda () (interactive) (treemacs-select-window) (scroll-up 5))))
;;   (progn
;;     (define-key treemacs-mode-map [wheel-up] (lambda () (interactive) (treemacs-select-window) (scroll-down 5)))
;;     (define-key treemacs-mode-map [wheel-down] (lambda () (interactive) (treemacs-select-window) (scroll-up 5)))
;;     ))

;; (setq treemacs-follow-after-init          t) 
;; (setq treemacs-tag-follow-cleanup					t) 
;; (setq treemacs-tag-follow-delay						1.5)
;; (setq treemacs-project-follow-cleanup		  nil)
;; (setq treemacs-recenter-after-file-follow nil) 
;; (setq treemacs-recenter-after-tag-follow	 nil)
;; (setq treemacs-goto-tag-strategy					 'refetch-index)

;; Eventually I closed the follow-modes, the problem of the follow-modes is that
;; we may have many different projects open, when close the current buffer,
;; the next buffer is "unknown", then treemacs will be far away. Therefore, we follow
;; the IDEA's "Scroll from Source" behavior, call `treemacs--follow` or `treemacs--follow-tag-at-point`
;; manually. I have created a new button for `tabbar-popup-menu` to work around this problem.
(treemacs-follow-mode -1)
(treemacs-tag-follow-mode -1)

;; - Filewatch-mode
(setq treemacs-file-event-delay					 2000)
(setq treemacs-silent-filewatch					 nil) 
(setq treemacs-silent-refresh						 nil)
(setq treemacs-collapse-dirs              (if (executable-find "python") 3 0))
(treemacs-filewatch-mode t)

;; - Git-mode
;; (pcase (cons (not (null (executable-find "git")))
;;              (not (null (executable-find "python3"))))
;;   (`(t . t)
;;    (treemacs-git-mode 'extended))
;;   (`(t . _)
;;    (treemacs-git-mode 'simple))))
;; (treemacs-git-mode -1)

;; - Fringe-indicator-mode
(treemacs-fringe-indicator-mode t)

;; - Key-bindings
(define-key global-map (kbd "M-0") 'treemacs-select-window)
;; (define-key global-map (kbd "C-x t 1") 'treemacs-delete-other-windows)
;; (define-key global-map (kbd "C-x t t") 'treemacs)
;; (define-key global-map (kbd "C-x t B") 'treemacs-bookmark)
;; (define-key global-map (kbd "C-x t C-t") 'treemacs-find-file)
;; (define-key global-map (kbd "C-x t M-t") 'treemacs-find-tag)

;;----------------------------------------------------------------------------
;; eldoc, pos-tip
;;----------------------------------------------------------------------------
(defun eldoc-pos-tip-message (format-string &rest args)
  "Display eldoc message near point."
  (when format-string
    (pos-tip-show (format format-string args))))

(setq eldoc-message-function #'eldoc-pos-tip-message)



;;----------------------------------------------------------------------------
;; emacs-lisp-mode
;;----------------------------------------------------------------------------
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-mode-hook (lambda () (local-set-key [f5] 'eval-last-sexp)))
(add-hook 'lisp-interaction-mode 'paredit-mode)

(sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
(sp-local-pair 'lisp-interaction-mode "'" nil :actions nil)

;;----------------------------------------------------------------------------
;; scheme-mode
;;----------------------------------------------------------------------------
(require 'cmuscheme)
(setq auto-mode-alist (cons '("\\.ss" . scheme-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.sls" . scheme-mode) auto-mode-alist))

;; properly indent certain Scheme special forms
(put 'cond 'scheme-indent-function 0)
(put 'pmatch 'scheme-indent-function 1)
(put 'match 'scheme-indent-function 1)
(put 'dmatch 'scheme-indent-function 1)
(put 'let-values 'scheme-indent-function 1)
(put 'call-with-values 'scheme-indent-function 2)
(put 'syntax-case 'scheme-indent-function 2)
(put 'test 'scheme-indent-function 1)
(put 'test-check 'scheme-indent-function 1)
(put 'test-divergence 'scheme-indent-function 1)
(put 'make-engine 'scheme-indent-function 0)
(put 'trace-lambda 'scheme-indent-function 1)
;; (put 'if 'scheme-indent-function 1)
(put 'and 'scheme-indent-function 0)

;;; miniKanren-specific indentation
(put 'lambdaf@ 'scheme-indent-function 1)
(put 'lambdag@ 'scheme-indent-function 1)
(put 'fresh 'scheme-indent-function 1)
(put 'exists 'scheme-indent-function 1)
(put 'exist 'scheme-indent-function 1)
(put 'nom 'scheme-indent-function 1)
(put 'run 'scheme-indent-function 2)
(put 'conde 'scheme-indent-function 0)
(put 'conda 'scheme-indent-function 0)
(put 'condu 'scheme-indent-function 0)
(put 'project 'scheme-indent-function 1)
(put 'run* 'scheme-indent-function 1)
(put 'case-inf 'scheme-indent-function 1)
(put 'tabled 'scheme-indent-function 1)

;;; font-lock for additional Scheme keywords
;;; http://www.emacswiki.org/emacs/AddKeywords
(defun scheme-add-keywords (face-name keyword-rules)
  (let* ((keyword-list (mapcar #'(lambda (x)
				   (symbol-name (cdr x)))
			       keyword-rules))
	 (keyword-regexp (concat "(\\("
				 (regexp-opt keyword-list)
				 "\\)[ \n]")))
    (font-lock-add-keywords 'scheme-mode
			    `((,keyword-regexp 1 ',face-name)))))

(scheme-add-keywords
 'font-lock-keyword-face
 '((1 . fresh)
   (1 . conde)
   (1 . run)
   (1 . run*)
   (1 . match)
   (1 . pmatch)
   (1 . dmatch)
   (1 . tabled)
   (1 . syntax-case)
   (1 . with-syntax)
   (1 . unless)
   (1 . when)
   (1 . library)
   (1 . export)
   (1 . import)
   ))

;; Copy from cmuscheme and override run-scheme, using switch-to-buffer-other-window
;; instead of pop-to-buffer-same-window.
(defun run-scheme/override (cmd)
  (interactive (list (if current-prefix-arg
			                   (read-string "Run Scheme: " scheme-program-name)
			                 scheme-program-name)))
  (if (not (comint-check-proc "*scheme*"))
      (let ((cmdlist (split-string-and-unquote cmd)))
	      (set-buffer (apply 'make-comint "scheme" (car cmdlist)
			                     (scheme-start-file (car cmdlist)) (cdr cmdlist)))
	      (inferior-scheme-mode)))
  (setq scheme-program-name cmd)
  (setq scheme-buffer "*scheme*")
  (switch-to-buffer-other-window "*scheme*"))
(advice-add 'run-scheme :override #'run-scheme/override)

(defun run-scheme-dwim ()
  (interactive)
  (if (sc/current-line-empty-p)
      (scheme-load-file (buffer-name))
    (scheme-send-last-sexp)))

(add-hook 'scheme-mode-hook 'paredit-mode)
(add-hook 'scheme-mode-hook (lambda () (local-set-key [f5] 'run-scheme-dwim)))
(sp-local-pair 'scheme-mode-hook "'" nil :actions nil)
(add-hook 'inferior-scheme-mode 'paredit-mode)
 
;;----------------------------------------------------------------------------
;; racket-mode
;;----------------------------------------------------------------------------
(require 'racket-mode)
(setq racket-program "C:\\Program Files\\Racket\\Racket.exe")
;; (add-to-list 'auto-mode-alist '("\\.scm\\'" . racket-mode)) ; Racket r5rs

(defun racket-run-dwim ()
  (interactive)
  (if (sc/current-line-empty-p)
      (racket-run)
    (racket-send-last-sexp)))

(add-hook 'racket-mode-hook 'racket-xp-mode)
(add-hook 'racket-mode-hook 'paredit-mode)
(add-hook 'racket-mode-hook
          (lambda ()
            (local-set-key [f1] 'racket-xp-documentation)
            (local-set-key [f5] 'racket-run-dwim)
            (local-set-key [f6] 'racket-expand-last-sexp)
            (local-set-key [f7] 'racket-run-with-debugging)
            (local-set-key [f8] 'racket-debug-disable)
            ))

;; (setq racket-logger-config '((racket-mode . debug)
;;                             (cm-accomplice . warning)
;;                             (GC . info)
;;                             (module-prefetch . warning)
;;                             (optimizer . info)
;;                             (racket/contract . error)
;;                             (sequence-specialization . info)
;;                             (* . fatal)))

;;----------------------------------------------------------------------------
;; pie-mode (the little typer)
;;----------------------------------------------------------------------------
(require 'pie-mode)

;;----------------------------------------------------------------------------
;; Common Lisp (slime)
;;----------------------------------------------------------------------------
;; (load (expand-file-name "C:\\Users\\Chansey\\quicklisp\\slime-helper.el"))
(setq inferior-lisp-program "sbcl")
(add-hook 'slime-mode-hook 'paredit-mode)
(add-hook 'inferior-lisp-mode 'paredit-mode)

;;----------------------------------------------------------------------------
;; sml-mode
;;----------------------------------------------------------------------------
(defun my-sml-rules (orig kind token)
  (pcase (cons kind token)
    (`(:before . "d=")
     (if (smie-rule-parent-p "structure" "signature" "functor") 2
       (funcall orig kind token)))
    (`(:after . "struct") 2)
    (_ (funcall orig kind token))))

(defadvice sml-smie-rules (around my-sml-rules activate)
  (let ((i (pcase (cons (ad-get-arg 0) (ad-get-arg 1))
             (`(:before . "d=")
              (if (smie-rule-parent-p "structure" "signature" "functor") 2))
             (`(:after . "struct") 2))))
    (if i
        (setq ad-return i)
      ad-do-it)))

(add-hook 'sml-mode-hook
          (lambda ()
            ;; In SML, newline + auto-indentation works fine only if the statements
            ;; are ended in semi-colons. However, most of time we do not use semi-colons in .sml.
            ;; So `electric-indent-mode  have to be disabled for this major mode.
            (electric-indent-local-mode -1)

            ;; Correct indentation for structures
            ;; https://lists.gnu.org/archive/html/help-gnu-emacs/2014-10/msg00108.html
            (add-function :around (symbol-function 'sml-smie-rules) #'my-sml-rules)

            (setq-local company-backends company-backends-non-lisp)
            
            (local-set-key (kbd "M-<up>")   'drag-stuff-up)
            (local-set-key (kbd "M-<down>") 'drag-stuff-down)
            
            (local-set-key (kbd "C-<down>") 'forward-paragraph)
            (local-set-key (kbd "C-<up>")   'backward-paragraph)
            ))

(defun sml--at-expression-paredit-space-for-delimiter-predicate (endp delimiter)
  (if (and (memq major-mode '(sml-mode inferior-sml-mode))
           (not endp))
      nil
    t))

(eval-after-load 'paredit
  '(add-hook 'paredit-space-for-delimiter-predicates
             'sml--at-expression-paredit-space-for-delimiter-predicate))

(add-hook 'sml-mode-hook 'paredit-mode)

;;----------------------------------------------------------------------------
;; OCaml (tuareg)
;;----------------------------------------------------------------------------
(require 'tuareg)
(setq tuareg-indent-align-with-first-arg t
      tuareg-match-patterns-aligned t)

(add-hook 'tuareg-mode-hook
          (lambda ()
            (define-key tuareg-mode-map (kbd "<f8>") 'caml-types-show-type)
            (local-set-key (kbd "M-<up>")   'drag-stuff-up)
            (local-set-key (kbd "M-<down>") 'drag-stuff-down)
            ))

;;----------------------------------------------------------------------------
;; haskell-mode
;;----------------------------------------------------------------------------
;; (setq haskell-process-log t)
(require 'haskell-mode)
(require 'haskell-interactive-mode)
(require 'haskell-process)
(setq haskell-process-suggest-remove-import-lines t
      haskell-process-auto-import-loaded-modules t
      haskell-process-type 'ghci)

(define-key haskell-mode-map (kbd "M-.") 'haskell-mode-jump-to-def)
(define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)

(defun haskell-process-toggle ()
  "Toggle GHCi process between cabal and ghci"
  (interactive)
  (if (equal 'ghci haskell-process-type)
      (progn (setq haskell-process-type 'cabal-repl)
             (message "Using cabal repl"))
    (progn (setq haskell-process-type 'ghci)
           (message "Using GHCi"))))

(add-hook 'haskell-mode-hook
          (lambda ()
            (local-set-key (kbd "M-<up>")   'drag-stuff-up)
            (local-set-key (kbd "M-<down>") 'drag-stuff-down)
            
            (local-set-key (kbd "C-<down>") 'forward-paragraph)
            (local-set-key (kbd "C-<up>")   'backward-paragraph)
            ))

;;----------------------------------------------------------------------------
;; Prolog
;;----------------------------------------------------------------------------
(require 'prolog)
(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))
(setq-default prolog-system 'swi)
;; (setq-default prolog-system 'xsb)

(setq prolog-paren-indent-p t)
(setq prolog-align-small-comments-flag nil)
(setq prolog-head-delimiter "\\(:-\\|\\+:\\|-:\\|\\+\\?\\|-\\?\\|-->\\|-->>\\|<=>\\|==>\\|=>\\)")

(defun restart-prolog()
  "Kill and Restart an inferior Prolog process"
  (interactive)
  (let ((current-prefix-arg '(1)))
    (call-interactively 'run-prolog)))

(defun prolog-indent-line/around (orig-fun &rest args)
  (save-excursion
    (condition-case nil
        (apply orig-fun args)
      (beginning-of-buffer 'noindent))))

(advice-add 'prolog-indent-line :around  #'prolog-indent-line/around)

(add-hook 'prolog-mode-hook
          (lambda ()
            (setq-local company-backends company-backends-non-lisp)
            (local-set-key (kbd "C-M-c") 'comment-line)
            (local-set-key (kbd "<f1>")   'prolog-help-on-predicate)
            
            (local-set-key (kbd "M-<up>")   'drag-stuff-up)
            (local-set-key (kbd "M-<down>") 'drag-stuff-down)
            
            (local-set-key (kbd "C-<down>") 'prolog-end-of-clause)
            (local-set-key (kbd "C-<up>")   'prolog-beginning-of-clause)
            ))

(add-hook 'prolog-inferior-mode-hook
          (lambda ()
            (setq-local company-backends company-backends-non-lisp)
            ))

(require 'ediprolog)
(setq ediprolog-system 'swi)
;; avoid conflicting with cygwin's swipl 
(setq ediprolog-program "c:/PROGRA~1/swipl/bin/swipl.exe")

(defun ediprolog-kill ()
  (interactive "")
  (let ((current-prefix-arg 0))
    (call-interactively 'ediprolog-dwim)))

(add-hook 'prolog-mode-hook
          (lambda ()
            ;; press [f5] to query, when cursor at ?-, 
            ;; press [f5] to consult file, when cursor at other position
            ;; press C-0 [f5] to kill ediprog's process
            (local-set-key [f5] 'ediprolog-dwim) ; when interaction block Emacs, press C-g to unblock
            (local-set-key [f6] 'ediprolog-toplevel) ; press f6 to resume interaction 
            (local-set-key [f8] 'ediprolog-kill)))

(defun prolog--at-expression-paredit-space-for-delimiter-predicate (endp delimiter)
  (if (and (memq major-mode '(prolog-mode prolog-inferior-mode))
           (not endp))
      nil
    t))

(eval-after-load 'paredit
  '(add-hook 'paredit-space-for-delimiter-predicates
             'prolog--at-expression-paredit-space-for-delimiter-predicate))

(add-hook 'prolog-mode-hook 'paredit-mode)

;;----------------------------------------------------------------------------
;; SMT
;;----------------------------------------------------------------------------
(require 'smt-mode)
(add-to-list 'auto-mode-alist '("\\.smt\\'" . smt-mode))
(add-to-list 'auto-mode-alist '("\\.smt2\\'" . smt-mode))

(add-hook 'smt-mode-hook
          (lambda ()
            (local-set-key (kbd "C-<down>") 'forward-paragraph)
            (local-set-key (kbd "C-<up>")   'backward-paragraph) 
            ))

;;----------------------------------------------------------------------------
;; SQL Mode
;;----------------------------------------------------------------------------
(require 'sql)
(require 'sql-upcase)
(add-hook 'sql-mode-hook 'sql-upcase-mode)
(add-hook 'sql-interactive-mode-hook 'sql-upcase-mode)
(add-hook 'sql-mode-hook (lambda ()
                           (local-set-key (kbd "C-M-c") 'comment-line)
                           ;; TODO: sql-send-dwim (buffer and region)
                           (local-set-key [f5] 'sql-send-line-and-next)
                           (local-set-key (kbd "C-M-u") 'sql-upcase-buffer)
                           ))
;; sqlite
;; avoid conflicting with cygwin's sqlite3 
(setq sql-sqlite-program "c:/env/sqlite/sqlite-win32-x86-3370000/sqlite3.exe")
;; (add-to-list 'sql-sqlite-options "-interactive")

(require 'sqlite-dump)
(modify-coding-system-alist 'file "\\.sqlite3\\'" 'raw-text-unix)
(modify-coding-system-alist 'file "\\.sqlite\\'" 'raw-text-unix)
(add-to-list 'auto-mode-alist '("\\.sqlite3\\'" . sqlite-dump))
(add-to-list 'auto-mode-alist '("\\.sqlite\\'" . sqlite-dump))

;; postgres
(setq sql-postgres-program "C:/PROGRA~1/PostgreSQL/12/bin/psql.exe")
(setenv "PGPASSWORD" "")



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


