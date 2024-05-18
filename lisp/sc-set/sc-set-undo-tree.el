;;----------------------------------------------------------------------------
;; undo-tree
;;----------------------------------------------------------------------------
(require 'undo-tree)
(global-undo-tree-mode 1)
(defalias 'redo 'undo-tree-redo)


(provide 'sc-set-undo-tree)
