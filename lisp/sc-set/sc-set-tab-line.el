;;----------------------------------------------------------------------------
;; Tab Line
;; tab-line.el (new)
;; (version<= "27.1" emacs-version)
;;----------------------------------------------------------------------------
(require 'w32-browser)

;; tab-line appearance

(global-tab-line-mode 1)
(set-face-attribute 'tab-line nil :height 1 :inherit nil :box nil)
(let ((bg (face-attribute 'tab-line-tab :background))
      (fg (face-attribute 'default :foreground))
	    (hg (face-attribute 'default :background)))
  (set-face-attribute 'tab-line-tab nil           :background bg :foreground fg  :weight 'normal :inherit nil :box nil)
  (set-face-attribute 'tab-line-tab-inactive nil  :background bg :foreground fg  :weight 'normal :inherit nil :box nil)
  (set-face-attribute 'tab-line-highlight nil     :background hg :foreground fg  :weight 'normal :inherit nil :box nil)
  (set-face-attribute 'tab-line-tab-current nil   :background hg :foreground fg  :weight 'normal :inherit nil :box nil))

;; tab-line context menu

(defun sc-tab-line-delete-window (&optional event)
  (interactive (list last-nonmenu-event))
  (let* ((posnp (and (listp event) (event-start event)))
         (window (and posnp (posn-window posnp))))
    (delete-window window)))

(easy-menu-define sc-tab-line-context-menu nil
  "Menu for Emacs Lisp mode."
  '("Context Menu"
    ["New tab" tab-line-new-tab :help "Create a new tab"]
    ["Delete window" sc-tab-line-delete-window]
    ))

(with-eval-after-load 'tab-line
  (defun tab-line-context-menu (&optional event)
    "Pop up the context menu for the tab line."
    (interactive "e")
    (let ((menu sc-tab-line-context-menu))
      (popup-menu menu event))))

;; tab-line tab context menu

(setq tab-line-close-tab-function 'kill-buffer)

(defvar sc-tab-line-tab-context-menu-last-window nil)
(defvar sc-tab-line-tab-context-menu-last-tab nil)

(easy-menu-define sc-tab-line-tab-context-menu nil
  "Context Menu for tab."
  '("Context Menu"
    ["Source focus" sc-tab-line-tab-source-focus]
    ["Open folder in explorer" sc-tab-line-tab-open-folder-in-explorer]
    "---"
    ["Bury" sc-tab-line-tab-bury]
    ["Bury all BUT this" sc-tab-line-tab-bury-all-but]
    ["Kill" sc-tab-line-tab-kill]
    ["Kill all BUT this" sc-tab-line-tab-kill-all-but]
    "---"
    ["Copy full path" sc-tab-line-tab-copy-path :active (--sc-tab-line-tab-is-file)]
    ["Copy directory path" sc-tab-line-tab-copy-dir :active (--sc-tab-line-tab-is-file)]
    ["Copy file-name" sc-tab-line-tab-copy-file-name :active (--sc-tab-line-tab-is-file)]
    ["Copy buffer name" sc-tab-line-tab-copy-buffer-name]
    ))

(with-eval-after-load 'tab-line
  (defun tab-line-tab-context-menu (&optional event)
    "Pop up the context menu for a tab-line tab."
    (interactive "e")
    (let* ((posnp (and (listp event) (event-start event)))
           (window (and posnp (posn-window posnp)))
           (tab (tab-line--get-tab-property 'tab (car (posn-string posnp)))))
      (setq sc-tab-line-tab-context-menu-last-tab tab)
      (setq sc-tab-line-tab-context-menu-last-window window))
    (let ((menu sc-tab-line-tab-context-menu))
      (popup-menu menu event))))

(defun sc-tab-line-tab-source-focus (&optional event)
  (interactive (list last-nonmenu-event))
  (let* ((window sc-tab-line-tab-context-menu-last-window)
         (tab sc-tab-line-tab-context-menu-last-tab)
         (buffer (if (bufferp tab) tab (cdr (assq 'buffer tab)))))
    (with-selected-window (or window (selected-window))
      (switch-to-buffer buffer)
      (force-mode-line-update))
    ;;(treemacs--follow-tag-at-point)
    (when (fboundp 'treemacs--follow)
      (treemacs--follow))
    ))

(defun sc-tab-line-tab-open-folder-in-explorer (&optional event)
  (interactive (list last-nonmenu-event))
  (let* ((tab sc-tab-line-tab-context-menu-last-tab)
         (buffer (if (bufferp tab) tab (cdr (assq 'buffer tab))))
         (fn (buffer-file-name buffer)))
    (cond ((eq system-type 'windows-nt) (w32explore (convert-standard-filename fn)))
          (t (message "TODO: Not Implemented - open-folder-in-explorer")))))

(defun --sc-tab-line-tab-close (window tab)
  (let* ((buffer (if (bufferp tab) tab (cdr (assq 'buffer tab))))
         (close-function (unless (bufferp tab) (cdr (assq 'close tab)))))
    (with-selected-window (or window (selected-window))
      (cond
       ((functionp close-function)
        (funcall close-function))
       ((eq tab-line-close-tab-function 'kill-buffer)
        (kill-buffer buffer))
       ((eq tab-line-close-tab-function 'bury-buffer)
        (if (eq buffer (current-buffer))
            (bury-buffer)
          (set-window-prev-buffers nil (assq-delete-all buffer (window-prev-buffers)))
          (set-window-next-buffers nil (delq buffer (window-next-buffers)))))
       ((functionp tab-line-close-tab-function)
        (funcall tab-line-close-tab-function tab)))
      (force-mode-line-update))))

(defun sc-tab-line-tab-bury (&optional event)
  (interactive (list last-nonmenu-event))
  (let* ((window sc-tab-line-tab-context-menu-last-window)
         (tab sc-tab-line-tab-context-menu-last-tab))
    (let ((tab-line-close-tab-function 'bury-buffer))
      (--sc-tab-line-tab-close window tab))))

(defun sc-tab-line-tab-bury-all-but (&optional event)
  (interactive (list last-nonmenu-event))
  (let* ((window sc-tab-line-tab-context-menu-last-window)
         (tab sc-tab-line-tab-context-menu-last-tab)
         (tabs (funcall tab-line-tabs-function)))
    (mapc (lambda(x-tab)
            (unless (eq tab x-tab) ; TODO: eq? or equai?
              (let ((tab-line-close-tab-function 'bury-buffer))
                (--sc-tab-line-tab-close window x-tab))))
          tabs)))

(defun sc-tab-line-tab-kill (&optional event)
  (interactive (list last-nonmenu-event))
  (let ((tab-line-close-tab-function 'kill-buffer))
    (tab-line-close-tab event)))

(defun sc-tab-line-tab-kill-all-but (&optional event)
  (interactive (list last-nonmenu-event))
  (let* ((window sc-tab-line-tab-context-menu-last-window)
         (tab sc-tab-line-tab-context-menu-last-tab)
         (tabs (funcall tab-line-tabs-function)))
    (mapc (lambda(x-tab)
            (unless (eq tab x-tab) ; TODO: eq? or equai?
              (let ((tab-line-close-tab-function 'kill-buffer))
                (--sc-tab-line-tab-close window x-tab))))
          tabs)))

(defun sc-tab-line-tab-copy-path (&optional event)
  (interactive (list last-nonmenu-event))
  (let* ((tab sc-tab-line-tab-context-menu-last-tab)
         (buffer (if (bufferp tab) tab (cdr (assq 'buffer tab))))
         (fn (buffer-file-name buffer)))
    (kill-new fn)))

(defun sc-tab-line-tab-copy-dir (&optional event)
  (interactive (list last-nonmenu-event))
  (let* ((tab sc-tab-line-tab-context-menu-last-tab)
         (buffer (if (bufferp tab) tab (cdr (assq 'buffer tab))))
         (fn (buffer-file-name buffer)))
    (kill-new (file-name-directory fn))))

(defun sc-tab-line-tab-copy-file-name (&optional event)
  (interactive (list last-nonmenu-event))
  (let* ((tab sc-tab-line-tab-context-menu-last-tab)
         (buffer (if (bufferp tab) tab (cdr (assq 'buffer tab))))
         (fn (buffer-file-name buffer)))
    (kill-new (file-name-nondirectory fn))))

(defun sc-tab-line-tab-copy-buffer-name (&optional event)
  (interactive (list last-nonmenu-event))
  (let* ((tab sc-tab-line-tab-context-menu-last-tab)
         (buffer (if (bufferp tab) tab (cdr (assq 'buffer tab))))
         (fn (buffer-name buffer)))
    (kill-new fn)))

(defun --sc-tab-line-tab-is-file ()
  (let* ((tab sc-tab-line-tab-context-menu-last-tab)
         (buffer (if (bufferp tab) tab (cdr (assq 'buffer tab)))))
    (and (buffer-file-name buffer)
         (file-exists-p (buffer-file-name buffer)))))

;; TODO: tab-line drag & drop tab

;; (with-eval-after-load 'tab-line
;;   (define-key tab-line-tab-map [tab-line drag-mouse-1] 'sc-tab-line-drag-drop-tab))

;; (defun sc-tab-line-drag-drop-tab (&optional event)
;;   (interactive "e")
;;   (let* ((start-posnp (and (listp event) (event-start event)))
;;          (start-window (and start-posnp (posn-window start-posnp)))
;;          (start-tab (tab-line--get-tab-property 'tab (car (posn-string start-posnp))))
;;          (start-buffer (if (bufferp start-tab) tab (cdr (assq 'buffer start-tab))))
;;          (end-posnp (and (listp event) (event-end event)))
;;          (end-window (and end-posnp (posn-window end-posnp)))
;;          (end-tab (tab-line--get-tab-property 'tab (car (posn-string end-posnp))))
;;          (end-buffer (if (bufferp end-tab) tab (cdr (assq 'buffer end-tab)))))
;;
;;     (message "move %s %s" start-buffer end-buffer)
;;     (when (and (eq start-window end-window)
;;                (not (eq start-buffer end-buffer)))
;;       ;; 实现 Drag & drop tab 非常困难
;;       ;; 1. 一个 window 上关联哪些 tabs，Emacs 没有提供一个现成的 list，而是通过函数 tab-line-tabs-function
;;       ;; 当需要显示 tabs 时，调用 (funcall tab-line-tabs-function)，因此无法直接对 tabs 位置进行调整
;;       ;; 2. 我可以 advice tab-line-tabs-function 让它保存一个 last-tabs 作为全局变量
;;       ;; 但这个方法有一个问题：无法获取对应的 window
;;       ;; 存在一些 workaround，但需要处理两个问题：
;;       ;; (1) last-tabs 不是一个简单 list，而是一个 map（key 是 window，value 是 list of tab）
;;       ;; (2) Emacs 对于 tab-line-tabs-function 给用户提供了三种选项
;;       ;; 实现 drag & dop 只能基于 tab-line-tabs-window-buffers 模式（或更简单），而无法做到通用
;;    
;;       (force-mode-line-update)
;;       )))

;; TODO:
;; 1. Try tab-line-tabs-buffer-groups? not good though...
;; (setq tab-line-tabs-buffer-groups
;;       '(("Info\\|Help\\|Apropos\\|Man\\|Message\\|rg\\|" . "Misc")
;;         ("\\<C\\>" . "C")
;;         ("ObjC" . "C")
;;         ("Text" . "Text")
;;         ("Outline" . "Text")
;;         ("\\(HT\\|SG\\|X\\|XHT\\)ML" . "SGML")
;;         ("\\blog\\b\\|diff\\|\\bvc\\b\\|cvs\\|Git\\|Annotate" . "Version Control")
;;         ("Threads\\|Memory\\|Disassembly\\|Breakpoints\\|Frames\\|Locals\\|Registers\\|Inferior I/O\\|Debugger" . "GDB")
;;         ("Lisp" . "Lisp")))
;; 2. 设置 display-buffer-alist 把文件 buffer 放到 site-window 上面，非文件 buffer 放到 site-window 下面


(provide 'sc-set-tab-line)
