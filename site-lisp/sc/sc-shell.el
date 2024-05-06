
;; TODO: Add PS1 to msys2 home bash
;; Note that Emacs shell mode does not handle the default colored prompt very well, however changing my PS1 to: in my ~/.bashrc gave me a nice readable prompt.
;; https://emacs.stackexchange.com/questions/36182/is-it-possible-to-use-bash-for-windows-as-the-term-in-emacs-for-windows

;; 必须要家如下代码，
;; PS1='\u@\h:\w\$ '
;;
;; 否则不断打回车会出现：很多 ANSI esc seuqnce, cygwin 版本同理
;; ]0;/c/Users/Chansey/AppData/Roaming/.emacs.d

;; TODO:
;; Windows native Emacs uses pure pipe to simulate terminal without pty.
;; This often causes problems, because
;; 1. Apps would emit ANSI escape sequences, but Emacs would not handle it (also for input SIGNAL).
;; 2. Based on the return value of 'isatty', CRTs often have different behaviors.
;;    For example, if 'isatty' = TRUE, 'printf' won't be buffered; otherwise, printf will be buffered, which is bad in REPL.
;; 3. Some interactive apps check stdio handles (via 'isatty'), if not a tty, report a warning.

;; When run 'bash', Emacs reports:
;; 1. bash: cannot set terminal process group (-1): Inappropriate ioctl for device
;; 2. Also,'bash' prompt returns: `]0;/c/Users/Chansey/AppData/Roaming/.emacs.d`
;; They are known problems, and with no known solution (yet)
;; https://stackoverflow.com/questions/9670209/cygwin-bash-does-not-display-correctly-in-emacs-shell/52643961

;; However, it does not actually prevent normal use for non-fancy terminal apps, because
;; 1. We can tolerate escape sequences, because data from pipes are always correct.
;; 2. For 'bash' itself, we forces '-i' switch, so data cannot be buffered.
;; ANSI escapes sequences in 'bash' prompts can be avoided via set `PS1='\u@\h:\w\$ '` in .bashrc.
;; 3. For other interactive apps, we can find similar switch such as '-i'.
;; If not, we have to inject `setvbuf(stdout, NULL, _IONBF, 0)` to it.

;; TODO: Possible solutions:
;; 1. Waiting Emacs supports ConPTY, but it only works on >=Windows 10.
;; 2. Install virtual COM port on Windows, Emacs redirect app's stdio to virtual COM port (then `isatty` should return TRUE),
;; then reads data from other side. This essentially simluate a real pty , but I haven't tried it yet. https://com0com.sourceforge.net/

(defun sc-eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (cond ((version<= "28.1" emacs-version)
         (with-environment-variables (("PATH" (concat "" path-separator (getenv "PATH"))))
           (call-interactively 'eshell-new)))
        (t (call-interactively 'eshell-new))))

(defun sc-shell-cmd ()
  "Open/Switch an instance of cmd in shell mode."
  (interactive)
  (let ((explicit-shell-file-name "cmdproxy")
        (current-prefix-arg 4))
    (cond ((version<= "28.1" emacs-version)
           (with-environment-variables (("PATH" (concat "" path-separator (getenv "PATH"))))
             (call-interactively 'shell)))
          (t (call-interactively 'shell)))
    ))

(defun sc-shell-cygwin-bash ()
  "Open/Switch an instance of cygwin bash in shell mode."
  (interactive)
  (let ((explicit-shell-file-name "C:/cygwin64/bin/bash")
        (explicit-bash-args '("--login" "-i"))
        (current-prefix-arg 4))
    (cond ((version<= "28.1" emacs-version)
           (with-environment-variables (("PATH" (concat "" path-separator (getenv "PATH"))))
             (call-interactively 'shell)))
          (t (call-interactively 'shell)))
    ))

(defun sc-shell-msys2-bash ()
  "Open/Switch an instance of msys2 bash in shell mode."
  (interactive)
  (let ((explicit-shell-file-name "C:/msys64/usr/bin/bash")
        (explicit-bash-args '("--login" "-i"))
        (current-prefix-arg 4))
    (cond ((version<= "28.1" emacs-version)
           (with-environment-variables (("PATH" (concat "" path-separator (getenv "PATH"))))
             (call-interactively 'shell)))
          (t (call-interactively 'shell)))
    ))

(defun sc-shell-msys2-bash-mingw ()
  "Open/Switch an instance of msys2 bash mingw in shell mode."
  (interactive)
  (let ((explicit-shell-file-name "C:/msys64/usr/bin/bash")
        (explicit-bash-args '("--login" "-i"))
        (current-prefix-arg 4))
    (cond ((version<= "28.1" emacs-version)
           (with-environment-variables (("PATH" (concat "" path-separator (getenv "PATH")))
                                        ("MSYSTEM" "MINGW32"))
             (call-interactively 'shell)))
          (t
           (let ((process-environment (cons "MSYSTEM=MINGW32" process-environment)))
             (call-interactively 'shell))))
    ))

(provide 'sc-shell)
