;;----------------------------------------------------------------------------
;; eldoc, pos-tip
;;----------------------------------------------------------------------------
(defun eldoc-pos-tip-message (format-string &rest args)
  "Display eldoc message near point."
  (message "eldoc-pos-tip-message asd")
  (when format-string
    (pos-tip-show (format format-string args))))

(setq eldoc-message-function #'eldoc-pos-tip-message)

;;----------------------------------------------------------------------------
;; emacs-lisp-mode
;;----------------------------------------------------------------------------
(defun emacs-lisp-describe-dwim ()
  (interactive)
  (let ((s (symbol-at-point)))
    (if s (describe-symbol s) (call-interactively 'describe-symbol))))

(define-key emacs-lisp-mode-map [f1] 'emacs-lisp-describe-dwim)
(define-key help-mode-map [f1] 'emacs-lisp-describe-dwim)
(define-key Info-mode-map [f1] 'emacs-lisp-describe-dwim)
(define-key lisp-interaction-mode-map [f1] 'emacs-lisp-describe-dwim)

(define-key emacs-lisp-mode-map [f5] 'eval-last-sexp)
(define-key lisp-interaction-mode-map [f5] 'eval-last-sexp)

(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)

;; *scratch* is a kind of lisp-interaction-mode buffer
(add-hook 'lisp-interaction-mode 'enable-paredit-mode)
(sp-local-pair 'lisp-interaction-mode "'" nil :actions nil)

(with-eval-after-load 'help-mode
  (setq help-mode-tool-bar-map
        (let ((map (copy-keymap (default-value 'tool-bar-map))))
          (define-key-after map [separator-4] menu-bar-separator)
          (tool-bar-local-item "close" 'quit-window 'quit map
                               :help "Quit help"
                               :vert-only t)
          (define-key-after map [separator-5] menu-bar-separator)
          (tool-bar-local-item-from-menu 'help-go-back "left-arrow" map help-mode-map
                                         :rtl "right-arrow" :vert-only t)
          (tool-bar-local-item-from-menu 'help-go-forward "right-arrow" map help-mode-map
                                         :rtl "left-arrow" :vert-only t)
          map)))

(with-eval-after-load 'info
  (setq info-tool-bar-map
        (let ((map (copy-keymap (default-value 'tool-bar-map))))
          (define-key-after map [separator-4] menu-bar-separator)
          (tool-bar-local-item-from-menu 'Info-history-back "left-arrow" map Info-mode-map
				                                 :rtl "right-arrow"
				                                 :label "Back"
				                                 :vert-only t)
          (tool-bar-local-item-from-menu 'Info-history-forward "right-arrow" map Info-mode-map
				                                 :rtl "left-arrow"
				                                 :label "Forward"
				                                 :vert-only t)
          (define-key-after map [separator-5] menu-bar-separator)
          (tool-bar-local-item-from-menu 'Info-prev "prev-node" map Info-mode-map
				                                 :rtl "next-node")
          (tool-bar-local-item-from-menu 'Info-next "next-node" map Info-mode-map
				                                 :rtl "prev-node")
          (tool-bar-local-item-from-menu 'Info-up "up-node" map Info-mode-map
				                                 :vert-only t)
          (define-key-after map [separator-6] menu-bar-separator)
          (tool-bar-local-item-from-menu 'Info-top-node "home" map Info-mode-map
				                                 :vert-only t)
          (tool-bar-local-item-from-menu 'Info-goto-node "jump-to" map Info-mode-map)
          (define-key-after map [separator-7] menu-bar-separator)
          (tool-bar-local-item-from-menu 'Info-index "index" map Info-mode-map
				                                 :label "Index")
          (tool-bar-local-item-from-menu 'Info-search "search" map Info-mode-map
				                                 :vert-only t)
          (tool-bar-local-item-from-menu 'quit-window "exit" map Info-mode-map
				                                 :vert-only t)
          map))
  )
