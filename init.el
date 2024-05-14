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

;;----------------------------------------------------------------------------
;; Cygwin
;;----------------------------------------------------------------------------
;; 关闭 Cygwin 配置
;; 1. Cygwin 开发者不建议把 Cygwin 放进 PATH
;; > Cygwin developers recommend that you do not put Cygwin on your system PATH for this reason.
;; > Instead you can make the Cygwin tools available within Emacs by setting exec-path in your init file.
;; https://www.gnu.org/software/emacs/manual/html_node/efaq-w32/Cygwin.html
;; 2. 把 Cygwin 放在 exec-path 仍然有风险
;; (1) 比如：treemacs-customization.el treemacs--find-python3 会在 exec-path 下寻找 python3，
;; 但 python 3 在 cygwin 下是一个 symlink Emacs 不支持 https://www.emacswiki.org/emacs/NTEmacsWithCygwin
;; (2) Cygwin tools 可能会与系统安装的同名 tools 冲突
;; 比如：我希望使用 windows native python
;;
;; 故关闭 Cygwin 配置
;; 所有用到的 Cygwin tools e.g. grep/gtags/... 使用 Windows native build standalone 版本
;; 注：Cygwin/MSYS2 bash 仍保留
;;
;; 替换方案（暂不考虑）
;; 1. 采用 Emacs Cygwin build (emacs-w32) 而非 Emacs Windows native 并完全使用 Cygwin 环境开发 
;; 2. 为 Emacs 部署一个专用 Cygwin

;; use grep/gtags/.. in windows
;; (when (eq system-type 'windows-nt)
;;   (add-to-list 'exec-path "C:/cygwin64/usr/local/bin")
;;   (add-to-list 'exec-path "C:/cygwin64/bin")
;;   (setenv "PATH"
;;           (concat
;;            "C:/cygwin64/usr/local/bin" path-separator
;;            "C:/cygwin64/usr/bin" path-separator
;;            "C:/cygwin64/bin" path-separator
;;            (getenv "PATH")))
;;   (require 'cygwin-mount)
;;   (cygwin-mount-activate))

;;----------------------------------------------------------------------------
;; Shell
;;----------------------------------------------------------------------------
(require 'sc-shell)

;;----------------------------------------------------------------------------
;; Graphics
;;----------------------------------------------------------------------------
;; https://github.com/emacs-mirror/emacs/blob/8098ad9679c7f5ea19493bdae18227f7a81b3eb4/etc/NEWS.28#L3951
(when (and (eq system-type 'windows-nt)
           (version<= "28.1" emacs-version))
  (setq w32-use-native-image-API t))

;;----------------------------------------------------------------------------
;; Server
;;----------------------------------------------------------------------------
(require 'server)
(unless (server-running-p)
  (server-start))

;;----------------------------------------------------------------------------
;; Encoding (UTF-8 by default)
;;----------------------------------------------------------------------------
;; TODO:
;; Check the necessary in Emacs 28.1?
;; Emacs now defaults to UTF-8 instead of ISO-8859-1.
;; https://github.com/emacs-mirror/emacs/blob/8098ad9679c7f5ea19493bdae18227f7a81b3eb4/etc/NEWS.28#L779

;; Set locale
;; Note that windows' locale doesn't rely on LANG (or any other LC_X environmental variable).
;; It is set in Control Panel. I set LANG and LC_ALL here is just to simulate *nix behavior,
;; because some applications assume you are using *nix.  
(when (eq system-type 'windows-nt)
  (setenv "LANG" "en_GB.UTF-8")
  (setenv "LC_ALL" "en_GB.UTF-8"))

;; Set emacs language environment
(set-language-environment "UTF-8")

;; Set coding-system
(set-default-coding-systems 'utf-8)
(prefer-coding-system       'utf-8)

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; Set process I/O coding system, but doesn't use currently.
;; encoding means Emacs -> subprocess
;; decoging means Emacs <- subprocess

;; Specify special process I/O coding-system.
;; Note that many process start by cmdproxy.exe, e.g. cmdproxy -c rg xxx,
;; if it is the case, ("[rR][gG]" utf-8-dos . gbk-dos) has no effect.
;; (when (eq system-type 'windows-nt)
;;   (set-default 'process-coding-system-alist
;;                '(("[pP][lL][iI][nN][kK]" utf-8-dos . ,locale-coding-system)
;;                  ("[cC][mM][dD][pP][rR][oO][xX][yY]" utf-8-dos . ,locale-coding-system)
;;                  ("[rR][gG]" utf-8-dos . ,locale-coding-system))))
;;
;; Specify the coding-system for write operations, if some apps need special treatment 
;; (let ((coding-system-for-write coding-system)) body)

;; Procss coding-system related variables (see example of rg-w32-unicode below):
;; process-coding-system-alist
;; prefer-coding-system
;; set-default-coding-systems
;; default-process-coding-system

;; Other rare coding-system variables:
;; w32-ansi-code-page
;; w32-multibyte-code-page
;; locale-coding-system
;; set-locale-environment
;; default-file-name-coding-system,
;; keyboard-coding-system
;; w32-unicode-filenames
;; file-name-coding-system
;; DEFSYM (Qno_conversion, "no-conversion")

;;----------------------------------------------------------------------------
;; Face and Font
;;----------------------------------------------------------------------------
(setq inhibit-compacting-font-caches t)
(require 'sc-font-settings)

;; Resize font
;; Use C-x C-0 to start text-scale-adjust, use + - 0 for further adjustment
(setq text-scale-mode-step 1.1)         ;finer inc/dec than default 1.2

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

;;----------------------------------------------------------------------------
;; Tool Bar - Buttons
;;----------------------------------------------------------------------------

;; Back-button
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
(global-set-key (kbd "C-y") 'redo) ; undo-tree-redo

;; Undo. was suspend-frame
(global-set-key (kbd "C-z") 'undo)

;; make typing delete/overwrites selected text
(delete-selection-mode 1)

;; keyboard selection:  C-.
(global-set-key (kbd "C-.") 'set-mark-command)

;; mouse selection: shift selection
(define-key global-map (kbd "<S-down-mouse-1>") 'mouse-save-then-kill)

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

;;----------------------------------------------------------------------------
;; Text Highlight
;;----------------------------------------------------------------------------

;; turn on highlighting current line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#fef8df")

;; turn on bracket match highlight
(show-paren-mode 1)

;; highlight enclosing parens instead of out
;; https://stackoverflow.com/questions/22770979/parenthesis-highlighting-emacs
(define-advice show-paren-function (:around (fn) fix-show-paren-function)
  "Highlight enclosing parens."
  (cond ((looking-at-p "\\s(") (funcall fn))
        (t (save-excursion
             (ignore-errors (backward-up-list))
             (funcall fn)))))

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
  "Open windows explorer in the current directory and select the current file"  
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
(when (version<= "28.1" emacs-version)
  (setq use-short-answers 't))

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
  (kill-new (file-truename buffer-file-name)))

;; Use F2 open init.el
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el")
  (treemacs--follow))
(global-set-key (kbd "<f2>") 'open-init-file)

;; Use F6 open *Messages* buffer for debugging
;; (defun open-message-bufffer()
;;   (interactive)
;;   (switch-to-buffer "*Messages*"))
;; (global-set-key (kbd "<f6>") 'open-message-bufffer)

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

;; Open *Messages* buffer
(defun open-messages-buffer ()
  (interactive)
  ;; (switch-to-buffer-other-window "*Messages*")
  (pop-to-buffer "*Messages*"))

(tool-bar-add-item "show" 'open-messages-buffer 'open-messages-buffer :help "Open *Messages* buffer")

;; Erase *Messages* buffer
(defun erase-messages-buffer ()
  (interactive)
  (let ((inhibit-read-only t))
    (with-current-buffer "*Messages*"
      (erase-buffer))))

;; ICON can be found at emacs/share/emacs/28.2/etc/images
(tool-bar-add-item "delete" 'erase-messages-buffer 'erase-messages-buffer :help "Erase *Messages* buffer")

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



;;----------------------------------------------------------------------------
;; Utils
;;----------------------------------------------------------------------------
(require 'sc-utils)

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

;; (defconst yas-maybe-clear-field '(menu-item "" yas-clear-field :filter yas--maybe-clear-field-filter)
;;   "A conditional key definition.
;; This can be used as a key definition in keymaps to bind a key to
;; `yas-clear-field' only when at the beginning of an
;; unmodified snippet field.")

;; (define-key yas-keymap (kbd "DEL")   yas-maybe-clear-field)

;; (defun yas-clear-field (&optional field)
;;   "Clears unmodified FIELD if at field start."
;;   (interactive)
;;   (yas--skip-and-clear (or field (yas-current-field))))

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
(setq enable-recursive-minibuffers t)

(require 'ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(add-to-list 'ivy-re-builders-alist '(t . ivy--regex-ignore-order))
;; (setq ivy-re-builders-alist '((swiper . regexp-quote))) ;  disable wildcard when C-f

(require 'swiper)
(global-set-key (kbd "C-f") 'swiper)

(require 'counsel)
(global-set-key (kbd "M-x") 'counsel-M-x)
;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)
;; (global-set-key (kbd "C-h f") 'counsel-describe-function)
;; (global-set-key (kbd "C-h v") 'counsel-describe-variable)

;; tab complete in counsel
(define-key counsel-find-file-map (kbd "<tab>") #'ivy-insert-current)
(define-key counsel-describe-map (kbd "<tab>") #'ivy-insert-current)

;; IDO-style directory navigation
(define-key ivy-minibuffer-map (kbd "RET") #'ivy-alt-done)
(define-key ivy-minibuffer-map (kbd "<up>") #'ivy-previous-line-or-history)

;;----------------------------------------------------------------------------
;; Selection expand-region
;;----------------------------------------------------------------------------
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
;; (global-set-key (kbd "C--") 'er/contract-region); (kbd "C--") be used by select-current-line

;;----------------------------------------------------------------------------
;; popwin 
;;----------------------------------------------------------------------------
;; (require 'popwin)
;; (popwin-mode t)

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
;; sc-cursor-move
;;----------------------------------------------------------------------------
(require 'sc-cursor-move)

;; TODO: if not editing Lisp program?
(global-set-key (kbd "C-<right>") 'sc-forward)
(global-set-key (kbd "C-<left>")  'sc-backward)
(global-set-key (kbd "C-<down>")  'sc-forward-up)
(global-set-key (kbd "C-<up>")    'sc-backward-up)

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
;; Tab Line
;;----------------------------------------------------------------------------
(require 'sc-tab-line)

;;----------------------------------------------------------------------------
;; projectile
;;----------------------------------------------------------------------------
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)
(setq-default projectile-completion-system 'ivy)

;;----------------------------------------------------------------------------
;; rg.el
;;----------------------------------------------------------------------------
(require 'rg)
(setq rg-executable "C:/env/ripgrep/ripgrep-14.1.0-x86_64-pc-windows-msvc/rg.exe")

(when (eq system-type 'windows-nt)
  (setq rg-w32-unicode t))

;; Note: Using the ripgrep configuration file may break functionality of this package if you are not careful.
;; (setenv "RIPGREP_CONFIG_PATH" "C:/env/ripgrep/config/.ripgreprc")
;; (setq rg-ignore-ripgreprc nil)

;; (setq rg-command-line-flags '("--encoding=utf-8"))
;; (setq rg-command-line-flags '("--ignore-file=C:/Users/Chansey/AppData/Roaming/.emacs.d/你好世界/test.txt")) ; path has unicode is support

(transient-define-prefix sc-search ()
  "A menu to do various searches"
  [["Various Searches"
    ("1" "rg" rg)
    ("2" "rg-project" rg-project)
    ("3" "rg-menu" rg-menu)
    ("4" "projectile--find-file" projectile--find-file)]])
(global-set-key (kbd "C-S-f") 'sc-search)

;; Just for debugging rg-w32-unicode feature, no need to exist after finish.
;; Keep it here as an example of start-process.
;; (apply 'start-process
;;        "rg"
;;        "newbuffer123"
;;        "C:/green/emacs/libexec/emacs/28.2/x86_64-w64-mingw32/cmdproxy.exe"
;;        (list 
;;         "-c"
;;         "c:/Users/Chansey/AppData/Roaming/.emacs.d/rg-w32-ripgrep-proxy.bat"))
;; Note 1: the newbuffer123's coding system depends on the following (priority from high to low)
;; process-coding-system-alist
;; prefer-coding-system
;; set-default-coding-systems
;; default-process-coding-system
;; Note 2:
;; The args of cmdproxy.exe are list item
;; The args of rg-w32-ripgrep-proxy.bat are substring, i.e. "c:/.../rg-w32-ripgrep-proxy.bat new-args"

;;----------------------------------------------------------------------------
;; smooth-scroll
;;----------------------------------------------------------------------------
;; (pixel-scroll-mode 1) ; Doesn't see any difference...

;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ; don't accelerate scrolling
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
(setq treemacs-indentation								 2) 
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
;; shell-mode
;;----------------------------------------------------------------------------
(add-hook 'shell-mode-hook
          (lambda ()
            (setq-local company-backends company-backends-non-lisp)
            ))

;;----------------------------------------------------------------------------
;; emacs-lisp-mode
;;----------------------------------------------------------------------------
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook (lambda () (local-set-key [f5] 'eval-last-sexp)))

(defun emacs-lisp-describe-dwim ()
  (interactive)
  (describe-symbol (symbol-at-point)))

(add-hook 'emacs-lisp-mode-hook (lambda () (local-set-key [f1] 'emacs-lisp-describe-dwim)))

(add-hook 'lisp-interaction-mode 'enable-paredit-mode)

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
  (let* ((keyword-list (mapcar #'(lambda (x) (symbol-name (cdr x))) keyword-rules))
	       (keyword-regexp (concat "(\\(" (regexp-opt keyword-list) "\\)[ \n]")))
    (font-lock-add-keywords 'scheme-mode `((,keyword-regexp 1 ',face-name)))))

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
  (cond ((use-region-p) (call-interactively 'scheme-send-region))
        ((sc-current-line-empty-p) (scheme-load-file (buffer-name)))
        (t (scheme-send-last-sexp))))

;; For Chez Scheme 48 use "(expand '%s)" instead of "(expand %s)"
(setq scheme-macro-expand-command "(expand '%s)")

(add-hook 'scheme-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook
          (lambda ()
            (local-set-key [f5] 'run-scheme-dwim)
            (local-set-key [f6] 'scheme-expand-current-form)
            ))
(sp-local-pair 'scheme-mode-hook "'" nil :actions nil)
(add-hook 'inferior-scheme-mode 'enable-paredit-mode)

;; It makes multi-line printing neater.
;; For example,
;; (+ 1 2)| <-- call scheme-send-last-sexp
;; By default, the output in REPL is:
;; > 3
;; Now is:
;; >
;; 3
(defun scheme-send-region/override (start end)
  "Send the current region to the inferior Scheme process."
  (interactive "r")
  (let ((proc (scheme-proc))
        (buf (get-buffer scheme-buffer)))
    ;; Stolen from racket-repl.el
    (with-current-buffer buf
      (save-excursion
        (goto-char (process-mark proc))
        (insert ?\n)
        (set-marker (process-mark proc) (point))))
    (comint-send-region proc start end)
    (comint-send-string proc "\n")))

(advice-add 'scheme-send-region :override #'scheme-send-region/override)

;; Copy from lisp-indent-line in lisp-mode.el
(defun scheme-indent-line (&optional indent)
  "Indent current line as Lisp code."
  (interactive)
  (let ((pos (- (point-max) (point)))
        (indent (progn (beginning-of-line)
                       (or indent (calculate-lisp-indent (lisp-ppss))))))
    (skip-chars-forward " \t")
    (if (or (null indent) (looking-at "\\s<\\s<\\s<"))
	      ;; Don't alter indentation of a ;;; comment line
	      ;; or a line that starts in a string.
        ;; FIXME: inconsistency: comment-indent moves ;;; to column 0.
	      (goto-char (- (point-max) pos))
      ;; Single-semicolon comment lines NOT indented!
      (if (listp indent) (setq indent (car indent)))
      (indent-line-to indent)
      ;; If initial point was within line's indentation,
      ;; position after the indentation.  Else stay at same point in text.
      (if (> (- (point-max) pos) (point))
	        (goto-char (- (point-max) pos))))))

(add-hook 'scheme-mode-hook (lambda () (setq-local indent-line-function 'scheme-indent-line)))

;;----------------------------------------------------------------------------
;; racket-mode
;;----------------------------------------------------------------------------
(require 'racket-mode)
(setq racket-program "C:\\Program Files\\Racket\\Racket.exe")
;; (add-to-list 'auto-mode-alist '("\\.scm\\'" . racket-mode)) ; Racket r5rs
;; (setq racket-error-context 'medium)

(defun racket-raco-make ()
  (let* ((racket  (executable-find racket-program))
         (rkt     (racket--buffer-file-name) )
         (command (format "%s -l raco make -v %s"
                          (shell-quote-wildcard-pattern racket)
                          (shell-quote-wildcard-pattern rkt))))
    (shell-command command)))

;; When your project heavily uses macro, (add-hook 'racket-before-run-hook #'racket-raco-make)
(add-hook 'racket-before-run-hook #'racket-raco-make)
;; (remove-hook 'racket-before-run-hook #'racket-raco-make)

(defun racket-run-dwim ()
  (interactive)
  (cond ((use-region-p) (call-interactively 'racket-send-region))
        ((sc-current-line-empty-p) (racket-run-module-at-point))
        (t (racket-send-last-sexp))))

(add-hook 'racket-mode-hook 'racket-xp-mode)
(add-hook 'racket-mode-hook 'enable-paredit-mode)
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

;; Racket qi's indentation
;; https://docs.racket-lang.org/qi/Introduction_and_Usage.html#%28part._.Indentation%29
(put 'switch 'racket-indent-function 1)
(put 'switch-lambda 'racket-indent-function 1)
(put 'on 'racket-indent-function 1)
(put 'π 'racket-indent-function 1)
(put 'try 'racket-indent-function 1)

;;----------------------------------------------------------------------------
;; pie-mode (the little typer)
;;----------------------------------------------------------------------------
(require 'pie-mode)

;;----------------------------------------------------------------------------
;; Common Lisp (slime)
;;----------------------------------------------------------------------------
;; (load (expand-file-name "C:\\Users\\Chansey\\quicklisp\\slime-helper.el"))
(setq inferior-lisp-program "sbcl")
(add-hook 'slime-mode-hook 'enable-paredit-mode)
(add-hook 'inferior-lisp-mode 'enable-paredit-mode)

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

;; Correct indentation for structures
;; https://lists.gnu.org/archive/html/help-gnu-emacs/2014-10/msg00108.html
(add-function :around (symbol-function 'sml-smie-rules) #'my-sml-rules)

(defun sml-prog-proc-send-line ()
  "Send the content of the current line to the read-eval-print process."
  (interactive)
  (save-mark-and-excursion
    (sc-select-current-line)
    (call-interactively 'sml-prog-proc-send-region)))

(defun run-sml-dwim ()
  (interactive)
  (cond ((use-region-p) (call-interactively 'sml-prog-proc-send-region))
        ((sc-current-line-empty-p) (call-interactively 'sml-prog-proc-load-file))
        (t (sml-prog-proc-send-line))))

(add-hook 'sml-mode-hook
          (lambda ()
            ;; In SML, newline + auto-indentation works fine only if the statements
            ;; are ended in semi-colons. However, most of time we do not use semi-colons in .sml.
            ;; So `electric-indent-mode  have to be disabled for this major mode.
            (electric-indent-local-mode -1)
            (setq-local company-backends company-backends-non-lisp)

            (local-set-key [f5] 'run-sml-dwim)

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

(add-hook 'sml-mode-hook 'enable-paredit-mode)

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
;; (advice-remove 'prolog-indent-line #'prolog-indent-line/around)

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
;; (setq ediprolog-program "c:/PROGRA~1/swipl/bin/swipl-win.exe")

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

(add-hook 'prolog-mode-hook 'enable-paredit-mode)

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

(defun sql-send-dwim ()
  (interactive)
  (cond ((use-region-p) (call-interactively 'sql-send-region))
        ;; ((sc-current-line-empty-p) (sql-send-buffer))
        (t (sql-send-line-and-next))
        ))

(add-hook 'sql-mode-hook 'sql-upcase-mode)
(add-hook 'sql-interactive-mode-hook 'sql-upcase-mode)
(add-hook 'sql-mode-hook (lambda ()
                           (setq-local company-backends company-backends-non-lisp)
                           (local-set-key (kbd "C-M-c") 'comment-line)
                           (local-set-key [f5] 'sql-send-dwim)
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


