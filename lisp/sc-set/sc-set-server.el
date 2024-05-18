;;----------------------------------------------------------------------------
;; Server
;;----------------------------------------------------------------------------
(require 'server)

;; Passing files from obsidian to Emacs
;; 1. Install "Open with Plugin" in Obsidian
;; Add Emacsclientw C:\green\emacs-sh\emacsclientw.lnk
;; 2. Create emacsclientw.cmd in C:\green\emacs-sh
;; ```
;; @echo off
;; start emacsclientw.exe %1
;; exit
;; ```
;; 3. Create emacsclientw.lnk
;; Properties -> Shortcut -> Run -> Minimized

(unless server-process
  (server-start))

(provide 'sc-set-server)
