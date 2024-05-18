;;----------------------------------------------------------------------------
;; Encoding (UTF-8 by default)
;;----------------------------------------------------------------------------
;; TODO:
;; Check the necessary in Emacs 28.1?
;; Emacs now defaults to UTF-8 instead of ISO-8859-1.
;; https://github.com/emacs-mirror/emacs/blob/8098ad9679c7f5ea19493bdae18227f7a81b3eb4/etc/NEWS.28#L779

;; Set locale
;; Note that windows' locale doesn't rely on LANG (or any other LC_X environmental variable).
;; It is set in Control Panel. I set LANG and LC_ALL here is just to simulate *nix behavior,
;; because some applications assume you are using *nix.  
(when (eq system-type 'windows-nt)
  (setenv "LANG" "en_GB.UTF-8")
  (setenv "LC_ALL" "en_GB.UTF-8"))

;; Set emacs language environment
(set-language-environment "UTF-8")

;; Set coding-system
(set-default-coding-systems 'utf-8)
(prefer-coding-system       'utf-8)

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; Set process I/O coding system, but doesn't use currently.
;; encoding means Emacs -> subprocess
;; decoging means Emacs <- subprocess

;; Specify special process I/O coding-system.
;; Note that many process start by cmdproxy.exe, e.g. cmdproxy -c rg xxx,
;; if it is the case, ("[rR][gG]" utf-8-dos . gbk-dos) has no effect.
;; (when (eq system-type 'windows-nt)
;;   (set-default 'process-coding-system-alist
;;                '(("[pP][lL][iI][nN][kK]" utf-8-dos . ,locale-coding-system)
;;                  ("[cC][mM][dD][pP][rR][oO][xX][yY]" utf-8-dos . ,locale-coding-system)
;;                  ("[rR][gG]" utf-8-dos . ,locale-coding-system))))
;;
;; Specify the coding-system for write operations, if some apps need special treatment 
;; (let ((coding-system-for-write coding-system)) body)

;; Procss coding-system related variables (see example of rg-w32-unicode below):
;; process-coding-system-alist
;; prefer-coding-system
;; set-default-coding-systems
;; default-process-coding-system

;; Other rare coding-system variables:
;; w32-ansi-code-page
;; w32-multibyte-code-page
;; locale-coding-system
;; set-locale-environment
;; default-file-name-coding-system,
;; keyboard-coding-system
;; w32-unicode-filenames
;; file-name-coding-system
;; DEFSYM (Qno_conversion, "no-conversion")


(provide 'sc-set-coding-system)
