;;----------------------------------------------------------------------------
;; projectile
;;----------------------------------------------------------------------------
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)
(setq-default projectile-completion-system 'ivy)


(provide 'sc-set-projectile)
