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
    ("4" "projectile--find-file" projectile--find-file)
    ]])
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

(provide 'sc-set-rg)
