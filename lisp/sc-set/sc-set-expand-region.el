;;----------------------------------------------------------------------------
;; Selection expand-region
;;----------------------------------------------------------------------------
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
;; (global-set-key (kbd "C--") 'er/contract-region); (kbd "C--") be used by select-current-line

(provide 'sc-set-expand-region)
