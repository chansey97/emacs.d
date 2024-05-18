;;----------------------------------------------------------------------------
;; tab-line.el (new)
;;----------------------------------------------------------------------------
;; (version<= "27.1" emacs-version)

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
    (cond ((eq system-type 'windows-nt) (w32explore fn))
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


;; (setq my-tab-line-buffer-list ())
;;
;; ;; Filter special buffers from tab-line while maintaining current order
;; (setq tab-line-tabs-function
;;       (lambda ()
;;         (let* ((current-tabs (--select (buffer-file-name it) (buffer-list)))
;;                (intersect-tabs (--select (member it current-tabs) my-tab-line-buffer-list))
;;                (new-tabs (--select (not (member it my-tab-line-buffer-list)) current-tabs)))
;;           (setq my-tab-line-buffer-list (append intersect-tabs new-tabs)))))


;; tab-line-tabs-window-buffers 默认行为
;; (setq tab-line-tabs-function 'tab-line-tabs-window-buffers)

;; tab-line-tabs-mode-buffers 每个 major mode 一个 window
;; 这显然不是很好的做法，导致需要很多 window 但一个屏幕里的 window 有限
;; 注意：+ New Tab 符号没了，好在可以用右键
;; (setq tab-line-tabs-function 'tab-line-tabs-mode-buffers)

;; tab-line-tabs-buffer-groups
;; 类似 tab-line-tabs-mode-buffers，但是允许多个 mode 分在一个组（左上角显示分组和选择分组）
;; 理论上，如果只分两个组，应该是不错的
;; 注意：+ New Tab 符号没了，好在可以用右键
;; 注意：此方法也并不能修正 Back-button 问题，另外当前 select 的 buffer 会被还到首位..
;; (setq tab-line-tabs-function 'tab-line-tabs-buffer-groups)
;; (setq tab-line-tabs-buffer-group-function
;;       (lambda (buf)
;;         (cond ((string-match-p "Info\\|Help\\|Apropos\\|Man\\|Message" buf) "Misc")
;;               (t "MainGroup"))
;;         ))

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

;; (string-match-p "Info\\|Help\\|Apropos\\|Man" "Man")




;;---  new tab button 定制?

;;无法修改，因为 menu 的内容会动态改变（比如：根据大小什么的。。。感觉 emacs 有点过度设计了），没有固定格式，问减少的时候不会group as submenu
;;但是有一个 mouse-buffer-menu-mode-groups 可以分类倒是能做做，因为 emacs 默认情况下并没有分类
;;可以增加一些分类的

;; 可以设置 major-mode 变量来决定创建哪种文件

;;(defun sc-mouse-buffer-menu-map (menu)
;;  (let ((subdivided-menus (cdr menu))
;;        (new-item (concat "temp_" (symbol-name (cl-gensym)))))
;;    (cons "Buffer Menu"
;;          (cons (cons "New" (list `("temp" . ,new-item)))
;;                subdivided-menus))
;;    ))
;;(advice-add 'mouse-buffer-menu-map :filter-return #'sc-mouse-buffer-menu-map)
;;(advice-remove 'mouse-buffer-menu-map #'sc-mouse-buffer-menu-map)


;;tab-line-tabs-function
;;这个是否应该分文件和非文件 buffer，一个在上面一个在下面？需要研究

(provide 'sc-set-tab-line)
