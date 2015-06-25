;;;
;;; Very evil-centric config, focused on Clojure usage.
;;; TODO:
;;; - key bindings for (vc-)Diff mode
;;; - key bindings for magit status/diff
;;; - perspective OR workgroups for windows
;;; - helm? (default install is more annoying than helpful in evil)
;;; - el-get? github? for package mgmt (builtin is annoying) 
;;; - ???
;;; - custom -> custom.el
;;; - load-path -> split out per mode setup
;;; - smartparens hook to jump out of )'s and append ;
;;;   from irc:
;;;   Fuco > (defun my-foo () (interactive) (sp-up-sexp) (insert ";") (newline) (indent-according-to-mode))
;;;   zot  > that's along the line i was thinking, although i'd want to add sth to check that the closer is a ')'
;;;   Fuco > I feel your pain, it's been the same when I got the PHP job :D9:54 am
;;;   Fuco > `sp-get-enclosing-sexp' will return a data structure you can inspcet iwth `sp-get' macro
;;;


;; Turn off mouse interface early in startup to avoid momentary display
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please... jeez
(setq inhibit-startup-screen t)

;; package management, install as needed
(require 'package)
(setq package-user-dir "~/.emacs.d/elpa/")
(setq package-archives '(;; ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ;; ("org" . "http://orgmode.org/elpa/")
                         ;; ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

;; add check for existance of repos, and if not do a refresh

(defvar my-base-packages
  '(ag
    base16-theme
    better-defaults
    cider
    clojure-mode
    company
    delight
    epl
    evil
    evil-leader
    evil-lisp-state
    evil-matchit
    evil-surround
    git-gutter+
    helm
    js2-mode
    magit
    midje-mode
    rainbow-delimiters
    solarized-theme
    smartparens
    undo-tree))

(defvar my-extra-packages
  '(powerline-evil))

;; helm
;; projectile
;; goto-chg

(defun my-install-packages (pkgs)
  (interactive)
  ;; (package-refresh-contents)
  (dolist (p pkgs)
    (unless (package-installed-p p)
      (package-install p))))

(my-install-packages my-base-packages)
(my-install-packages my-extra-packages)
(require 'ido)
(ido-mode t)

;; visual basis
(setq powerline-evil-tag-style 'verbose)
;;(load-theme 'base16-tomorrow t)
(load-theme 'base16-chalk t)
(require 'powerline)
(require 'powerline-evil)

;; -----------------------------------------------------------------------------
;; configure evil basics.
;;

(global-evil-leader-mode)
(evil-leader/set-leader ";")
(global-evil-surround-mode 1)
;;(require 'evil-lisp-state)
(require 'smartparens-config)
(smartparens-global-strict-mode)
(powerline-evil-center-color-theme)

(setq-default evil-symbol-word-search t) ; * and # use emacs-symbols instead of words

(evil-mode 1) ; last so that leader get applied at the right time

;; skip evil in these modes
(mapc (lambda (mode) (evil-set-initial-state mode 'emacs))
      '(inferior-emacs-lisp-mode
        term-mode
        magit-log-edit-mode
        magit-branch-manager-mode))

;; helm goo, experimental
(when nil
  (require 'helm)
  (require 'helm-config)

  (global-set-key (kbd "C-c h") 'helm-command-prefix)
  (global-unset-key (kbd "C-x c"))

  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
  (define-key helm-map (kbd "C-z") 'helm-select-action) ; list actions using C-z

  (when (executable-find "curl")
    (setq helm-google-suggest-use-curl-p t))

  (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
        helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
        helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
        helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
        helm-ff-file-name-history-use-recentf t)

  (helm-mode 1))

;; ----------------------------------------------------------------------------
;; file mode bindings
;;

(add-to-list 'auto-mode-alist '("\\.boot\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljc\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))

;; -----------------------------------------------------------------------------

(setq tab-width 4)
(setq web-mode-markup-indent-offset 4)

;; always UTF-8
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;;(prefer-coding-sytem 'utf-8)

(require 'ws-butler)
(add-hook 'clojure-mode-hook 'ws-butler-mode)

;; lein-clean+cider-restart, from chris@adgoji
(defun my-cider-clean-restart (&optional prompt-project)
  "Quit CIDER, run `lein clean` and restart CIDER. If
  PROMPT-PROJECT is t, then prompt for the project in which to
  restart the server."
  (interactive "P")
  (cider-quit)
  (message "Waiting for CIDER to quit...")
  (sleep-for 2)
  (message "Running lein clean...")
  (let ((exit (shell-command "lein clean")))
    (if (zerop exit) (cider-jack-in prompt-project)
      (message "Could not run lein clean"))))

;; ----------------------------------------------------------------------------
;; Rust mode goo. Very in progress.
;;

(require 'flymake-rust)
(add-hook 'rust-mode-hook 'flymake-rust-load)
(setq racer-rust-src-path "/Users/ben/src/rust/src")
(setq racer-cmd "/Users/ben/src/racer/target/release/racer")
(add-to-list 'load-path "/Users/ben/src/racer/editors/emacs")
(eval-after-load "rust-mode" '(require 'racer))

;; ----------------------------------------------------------------------------

(setq clojure-mode-font-lock-comment-sexp t)
(setq cider-repl-history-file (concat default-directory ".cider-repl.log"))
(setq cider-prompt-for-symbol nil)

(defun my-cider-eval-dwim ()
  (interactive)
  (if (use-region-p) ;; mark-active + use-empty-active-region instead?
      (cider-eval-region (region-beginning) (region-end))
    (cider-eval-last-sexp) ; this is awkward w/ evil
    ))

(defun my-cider-switch-to-repl-buffer ()
  ;; XXX incomplete; idea is to check if one exists, and otherwise make it
  (interactive)
  )

(defun my-cider-re-or-start (skip-confirm)
  ;; TODO add arg support (ctrl-u)? to skip prompting
  (interactive "P")
  (condition-case nil
      (progn
        (cider-get-repl-buffer)
        (nrepl-close)
        (cider-jack-in))
    (error (cider-jack-in))))

(defun my-proggy-bits ()
  (message "Installing proggy-bits")
  (local-set-key (kbd "C-x g") 'magit-status)
  (company-mode)
  (rainbow-delimiters-mode-enable))

(defun my-evil-base-bindings ()
  ;; bdelete
  ;;(evil-ex-define-cmd "bd[elete]" (lambda () ((key-binding (kbd "C-x k"))) (delete-window)))

  ;; unbind SPC and RET from motion, since i don't use them
  ;; to return them to normal, do as http://www.emacswiki.org/emacs/Evil
  ;;(define-key evil-motion-state-map " " nil)
  ;;(define-key evil-motion-state-map (kbd "RET") nil)
  (evil-leader/set-key "a" 'ag-project-regexp)
  (evil-leader/set-key ";a" 'ag-regexp)
  (evil-leader/set-key "w" 'toggle-truncate-lines)

  ;; git related
  (evil-leader/set-key "gs" 'magit-status)
  (evil-leader/set-key "gb" 'vc-annotate)
  (evil-leader/set-key "g;b" 'magit-blame-mode)
  (evil-leader/set-key "gd" 'vc-diff)

  ;; gist
  (evil-leader/set-key "gg" 'gist-list)

  ;; rebind C-M-[nufb] to g[nufb]
  (define-key evil-normal-state-map "gn" (key-binding (kbd "C-M-n") t))
  (define-key evil-normal-state-map "gu" (key-binding (kbd "C-M-u") t))
  (define-key evil-normal-state-map "gb" (key-binding (kbd "C-M-b") t))
  (define-key evil-normal-state-map "gf" (key-binding (kbd "C-M-f") t))

  ;; i love hotkeys for cycling through errors; use my very-old vim
  ;; bindings AND add sth new
  (define-key evil-normal-state-map "f9" 'next-error)
  (define-key evil-normal-state-map "f8" 'previous-error)
  (evil-leader/set-key "gn" 'next-error)
  (evil-leader/set-key "gp" 'previous-error)
  )

;; XXX come back to me.
;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Choosing-Window.html
;; need to understand display-buffer-alist, display-buffer-overriding-action
(defun to-relevant-buffer (&optional arg)
  (interactive)
  (let* ((project-directory
          (or (when (eq 16 arg) (read-directory-name "Project: "))
              (nrepl-project-directory-for (nrepl-current-dir))))
         (connection-buffer
          (or
           (and (= 1 (length nrepl-connection-list)) (car nrepl-connection-list))
           (and project-directory
                (cider-find-connection-buffer-for-project-directory project-directory)))))
    (display-buffer connection-buffer)
    ))

;; (goto-char (point-max))

;; ----------------------------------------------------------------------------

(defun my-evil-midje-bindings ()
  (message "Installing evil-midje bindings")
  (evil-leader/set-key-for-mode 'cider-mode
    "tt" 'midje-check-fact
    "th" 'midje-hide-all-facts
    "ts" 'midje-show-all-facts
    "tf" 'midje-focus-on-this-fact
    "tc" 'midje-clear-comments))

(defun my-evil-cider-test-report-bindings ()
  ;; XXX doesn't work.
  (define-key evil-normal-state-local-map "gd" 'cider-test-ediff)
  (define-key evil-normal-state-local-map "ge" 'cider-test-stacktrace)
  (define-key evil-normal-state-local-map "gt" 'cider-test-jump)
  (define-key evil-normal-state-local-map "gn" 'cider-test-next-result)
  (define-key evil-normal-state-local-map "gp" 'cider-test-previous-result)
  )

(defun my-evil-cider-bindings ()
  ;; still need bindings for eval-region, eval-buffer, etc.
  (define-key evil-normal-state-local-map "\C-]" 'cider-jump-to-var)
  (define-key evil-normal-state-local-map "\C-t" 'cider-jump-back)
  (evil-ex-define-cmd "t[ag]" 'cider-jump-to-var)

  ;; kbd macro to switch to next cider-repl buf
  (fset 'switch-buffer-cider-repl "\C-xbcider-repl\C-m")

  ;; consider adding intermediate ; as a pretty-print modifier
  (evil-leader/set-key-for-mode 'clojure-mode
    ;; evals
    "ed"  'my-cider-eval-dwim               ; "eval dwim"
    "el"  'cider-eval-last-sexp             ; "eval last" (sexp)
    "er"  'cider-eval-region                ; "eval region"
    "et"  'cider-eval-defun-at-point        ; "eval this" top-level sexp
    "ee"  'cider-load-buffer                ; "eval everything" (buffer)
    "e;e" 'cider-refresh                    ; "eval Everything" (all buffers)
    "en"  'cider-eval-ns-form               ; "eval namespace form"

    ;; repl commands
    "rg"  'cider-switch-to-relevant-repl-buffer ; repl go!
    "rn"  'cider-repl-set-ns                ; repl use namespace
    "r;n" 'cider-eval-ns-form               ; repl eval namespace form
    "rt"  'cider-test-run-test              ; repl test
    "r;t" 'cider-test-run-tests             ; repl tests
    ;; "rs"  'cider-jack-in                    ; repl start
    "rs"  'my-cider-re-or-start             ; repl (re)start
    "r;s" 'cider-restart                    ; repl restart
    "rq"  'nrepl-close                      ; repl quit relevant
    ;;"rr"  'cider-switch-to-repl-buffer      ; repl repl!
    "rr"  'switch-buffer-cider-repl         ; repl repl!
    ;; fight! let the winner stand.
    "rl"  'cider-find-and-clear-repl-buffer ; repl clear (from ^L)
    "rc"  'cider-find-and-clear-repl-buffer ; repl clear

    "r;c" nil

    ;; macro expansion
    "mm" 'cider-macroexpand-1               ; default expand: currently 1
    "m1" 'cider-macroexpand-1               ; expand 1
    "mr" 'cider-macroexpand                 ; expand repeatedly, no subforms
    "ma" 'cider-macroexpand-all             ; expand all, w/ subforms

    ;; clojure specific handy
    "ks" 'clojure-toggle-keyword-string     ; :foo -> "foo" -> :foo -> ...

    ;; debugger goo
    "di" 'cider-debug-defun-at-point        ; instrument function
    )

  (evil-leader/set-key-for-mode 'cider-repl-mode
    ;; repl commands
    "rs"  'my-cider-re-or-start             ; repl (re)start
    "r;s" 'cider-restart                    ; repl restart
    "rq"  'nrepl-close                      ; repl quit relevant
    ";"   'cider-repl-return                ; repl return (eval current)

;;(add-hook 'clojure-mode-hook (lambda () (modify-syntax-entry ?- "w")))
    ;; just copy the bit below to repl for now
    ;; (taoensso.timbre/merge-config! {:fmt-output-fn (fn [{:keys [throwable message]} & _] (format ";;; %s%s" (or message "") (or (taoensso.timbre/stacktrace throwable "\n" {}) "")))})
    "r;l" (lambda () (progn (interactive)
                           (cider-tooling-eval
                            "(log/merge-config! {:fmt-output-fn (fn [{:keys [throwable message]} & _] (format \";;; %s%s\" (or message \"\") (or (log/stacktrace throwable \"\\n\" {}) \"\")))}"
                            (cider-interactive-eval-handler (current-buffer)))))
    )

  ;; various cider sub mode hooks
  (evil-add-hjkl-bindings cider-test-report-mode-map 'motion)
  (add-hook 'clojure-test-report-mode-hook 'my-evil-cider-test-report-bindings)
  (my-evil-midje-bindings)
  )

;; ----------------------------------------------------------------------------

(defun my-evil-elisp-bindings ()
  (evil-leader/set-key-for-mode 'emacs-lisp-mode
    "el" 'eval-last-sexp
    "er" 'eval-region
    "et" 'eval-defun
    "ee" 'eval-buffer))

;; ----------------------------------------------------------------------------

(defun my-evil-magit-bindings()
  (evil-add-hjkl-bindings magit-status-mode-map 'emacs
    "C-b" (lookup-key evil-motion-state-map "C-b")
    "C-f" (lookup-key evil-motion-state-map "C-f")
    "K" 'magit-discard-item
    "l" 'magit-key-mode-popup-logging
    "h" 'magit-toggle-diff-refine-hunk)
  
  (evil-add-hjkl-bindings magit-diff-mode-map 'emacs
    "C-b" (lookup-key evil-motion-state-map "C-b")
    "C-f" (lookup-key evil-motion-state-map "C-f"))
  )

;; ----------------------------------------------------------------------------

(defun my-evil-gist-bindings ()
  (evil-add-hjkl-bindings gist-list-mode-map 'motion))

;; ----------------------------------------------------------------------------

(defun my-evil-sp-bindings ()
  (message "Installing evil-sp bindings")

  ;; for pasting, en-/disable smartparens
  (evil-leader/set-key "p" 'smartparens-mode)

  (sp-use-paredit-bindings) ; keep these around while i'm still learning
  (define-key evil-normal-state-map (kbd "C-)") 'sp-forward-slurp-sexp)
  (define-key evil-normal-state-map (kbd "C-}") 'sp-forward-barf-sexp)

  ;; leader versions, replace w/ set-key-mode
  (evil-leader/set-key "ib" 'sp-backward-slurp-sexp)
  (evil-leader/set-key "if" 'sp-forward-slurp-sexp)
  (evil-leader/set-key "ob" 'sp-backward-barf-sexp)
  (evil-leader/set-key "of" 'sp-forward-barf-sexp)

  ;; sexp manipulation
  (evil-leader/set-key "xu" 'sp-unwrap-sexp)
  (evil-leader/set-key "xj" 'sp-join-sexp)
  (evil-leader/set-key "xb" 'sp-backward-sexp)
  (evil-leader/set-key "xf" 'sp-backward-sexp)
  (evil-leader/set-key "xr" 'sp-rewrap-sexp)
  )

(defun my-evil-window-bindings ()
  ;;(define-key evil-normal-state-map (kbd "C-w q") 'ido-kill-buffer)
  (define-key evil-normal-state-map (kbd "-") 'evil-prev-buffer)
  (define-key evil-normal-state-map (kbd "+") 'evil-next-buffer)
  ;; imperfect, but better than nothing 'evil-window-delete; could add (balance-windows)
  (define-key evil-window-map "q" 'delete-window))

(defun my-evil-bindings ()
  (my-evil-base-bindings)
  (my-evil-window-bindings)
  (my-evil-sp-bindings)
  (my-evil-cider-bindings)
  (my-evil-elisp-bindings)
  (my-evil-magit-bindings)
  (my-evil-gist-bindings))

;; ----------------------------------------------------------------------------

(defun my-lispy-bits ()
  (message "Installing lispy-bits")
  (my-proggy-bits))

(defun my-clojure-bits ()
  (my-lispy-bits)
 )

(defun my-json-bits ()
  (make-local-variable 'js-indent-level)
  (setq js-indent-level 2))

(add-hook 'clojure-mode-hook 'my-clojure-bits)
(add-hook 'emacs-lisp-mode 'my-lispy-bits)
(add-hook 'json-mode-hook 'my-json-bits)
(my-evil-bindings)

(defun my-git-bits ()
  (message "Installing git-bits")
  (message "current vc-mode: %s" (car (buffer-local-value 'vc-mode (current-buffer))))
  )

(defun my-terminal-visible-bell ()
  "A friendlier visual bell effect."
  (invert-face 'mode-line)
  (run-with-timer 0.15 nil 'invert-face 'mode-line)
  (run-with-timer 0.30 nil 'invert-face 'mode-line)
  (run-with-timer 0.45 nil 'invert-face 'mode-line))

(setq visible-bell nil
      ring-bell-function 'my-terminal-visible-bell)

;; Count hyphens, etc. as word characters in lisps
;;(add-hook 'clojure-mode-hook (lambda () (modify-syntax-entry ?- "w")))
;;(add-hook 'emacs-lisp-mode-hook (lambda () (modify-syntax-entry ?- "w")))

;; Treat underscores as word characters everywhere
(add-hook 'after-change-major-mode-hook (lambda () (modify-syntax-entry ?_ "w")))

;; ----------------------------------------------------------------------------

(when nil
  ;; http://www.emacswiki.org/emacs/Evil find: RET and SPC
  (defun my-move-key (keymap-from keymap-to key)
    "Moves key binding from one keymap to another, deleting from the old location. "
    (define-key keymap-to key (lookup-key keymap-from key))
    (define-key keymap-from key nil))
  (my-move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))
  (my-move-key evil-motion-state-map evil-normal-state-map " ")
  )

;; ----------------------------------------------------------------------------

;; bind some keys that are manually mapped through iTerm2
(when (not window-system)
  (progn
    (define-key function-key-map "[-^(" (kbd "C-("))
    (define-key function-key-map "[-^)" (kbd "C-)"))
    (define-key function-key-map "[1;5D" (kbd "C-<left>"))
    (define-key function-key-map "[1;5C" (kbd "C-<right>"))
    (define-key function-key-map "[-^{" (kbd "C-{"))
    (define-key function-key-map "[-^}" (kbd "C-}"))
    ))

;; =============================================================================
;; delight (mode display) config
;;

(require 'delight)
(delight '((magit-auto-revert-mode "" magit)
           ;(company-mode "" company)
           (undo-tree-mode "" undo-tree)
           (ws-butler-mode "" ws-butler)
           (cider-mode "cidr" cider)))

;; =============================================================================

;; comment out the rest, for now
(if nil

    ;; clojure += paredit
    (setq clojure-enable-paredit t)

                                        ; from bpalmer @ #emacs to have C-a switch between b-o-text and b-o-line
  (defun my-bol () (interactive) (if (bolp) (back-to-indentation) (beginning-of-line)))

  (put 'erase-buffer 'disabled nil)

  (defun chase-nrepl-server-tails ()
    (dolist (b (buffer-list))
      (when (and (string-prefix-p "*nrepl-server" (buffer-name b))
                 (not (eq b (current-buffer))))
        (with-current-buffer b
          (set-window-point (get-buffer-window b) (point-max))))))


  (defun chase-nrepl-server-tails2 ()
    (let ((bl (buffer-list)))
      (mapc
       (lambda (b)
         (when (string-prefix-p "*nrepl-server" (buffer-name b))
           (unless (eq (current-buffer) b)
             (with-current-buffer b
               (set-window-point (get-buffer-window b) (point-max))))))
       bl)))


  ;;(add-hook 'post-command-hook 'chase-nrepl-server-tails)
  ;;(remove-hook 'post-command-hook 'chase-nrepl-server-tails)

  (defun hook-chase-nrepl-server-tails (_ _ _)
    (set-window-point (get-buffer-window (current-buffer)) (point-max)))

  ;;(add-hook 'after-change-functions 'hook-chase-nrepl-server-tails)
  (put 'upcase-region 'disabled nil)

  ;; -----------------------------------------------------------------------------

  ;; see http://www.emacswiki.org/emacs/AutoIndentation
  (defun kill-and-join-forward (&optional arg)
    (interactive "P")
    (if (and (eolp) (not (bolp)))
        (progn (forward-char 1)
               (just-one-space 0)
               (backward-char 1)
               (kill-line arg))
      (kill-line arg)))

  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("0ed983facae99849805b2f7be926561cb58474eb18e5296d9bb3ad7f9b088a5b" "2a86b339554590eb681ecf866b64ce4814d58e6d093966b1bf5a184acf78874d" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "8022cea21aa4daca569aee5c1b875fbb3f3248a5debc6fc8cf5833f2936fbb22" "a0fdc9976885513b03b000b57ddde04621d94c3a08f3042d1f6e2dbc336d25c7" "c537bf460334a1eca099e05a662699415f3971b438972bed499c5efeb821086b" "7b7ef508f9241c01edaaff3e0d6f03588a6f4fddb1407a995a7a333b29e327b5" "e3c90203acbde2cf8016c6ba3f9c5300c97ddc63fcb78d84ca0a144d402eedc6" default)))
 '(frame-background-mode (quote dark)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(defun cider-refresh ()
  "Refresh loaded code."
  (interactive)
  (cider-tooling-eval
   "(clojure.core/require 'clojure.tools.namespace.repl) (clojure.tools.namespace.repl/refresh)"
   (cider-interactive-eval-handler (current-buffer))))
