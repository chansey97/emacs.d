;;----------------------------------------------------------------------------
;; Cygwin
;;----------------------------------------------------------------------------
;; 关闭 Cygwin 配置
;; 1. Cygwin 开发者不建议把 Cygwin 放进 PATH
;; > Cygwin developers recommend that you do not put Cygwin on your system PATH for this reason.
;; > Instead you can make the Cygwin tools available within Emacs by setting exec-path in your init file.
;; https://www.gnu.org/software/emacs/manual/html_node/efaq-w32/Cygwin.html
;; 2. 把 Cygwin 放在 exec-path 仍然有风险
;; (1) 比如：treemacs-customization.el treemacs--find-python3 会在 exec-path 下寻找 python3，
;; 但 python 3 在 cygwin 下是一个 symlink Emacs 不支持 https://www.emacswiki.org/emacs/NTEmacsWithCygwin
;; (2) Cygwin tools 可能会与系统安装的同名 tools 冲突
;; 比如：我希望使用 windows native python
;;
;; 故关闭 Cygwin 配置
;; 所有用到的 Cygwin tools e.g. grep/gtags/... 使用 Windows native build standalone 版本
;; 注：Cygwin/MSYS2 bash 仍保留
;;
;; 替换方案（暂不考虑）
;; 1. 采用 Emacs Cygwin build (emacs-w32) 而非 Emacs Windows native 并完全使用 Cygwin 环境开发 
;; 2. 为 Emacs 部署一个专用 Cygwin

;; use grep/gtags/.. in windows
;; (when (eq system-type 'windows-nt)
;;   (add-to-list 'exec-path "C:/cygwin64/usr/local/bin")
;;   (add-to-list 'exec-path "C:/cygwin64/bin")
;;   (setenv "PATH"
;;           (concat
;;            "C:/cygwin64/usr/local/bin" path-separator
;;            "C:/cygwin64/usr/bin" path-separator
;;            "C:/cygwin64/bin" path-separator
;;            (getenv "PATH")))
;;   (require 'cygwin-mount)
;;   (cygwin-mount-activate))
