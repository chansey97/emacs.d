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
;; TODO: might be use fontlock attribute
;; https://github.com/Alexander-Miller/treemacs/issues/652
;; https://github.com/Alexander-Miller/treemacs/issues/842
(add-hook 'treemacs-mode-hook
          (lambda ()
            (message "treemacs-mode-hook `%s'" (current-buffer))
            (text-scale-increase -2)
            ;; Disable line-numbers-mode on treemacs
            ;; https://github.com/Alexander-Miller/treemacs/issues/137
            (if (version< emacs-version "29.1")
                (linum-mode -1)
              (display-line-numbers-mode -1))
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
