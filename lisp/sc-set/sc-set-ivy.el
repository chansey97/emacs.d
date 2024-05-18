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
