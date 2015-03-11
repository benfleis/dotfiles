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
  '(base16-theme
    better-defaults
    cider
    clojure-mode
    company
    epl
    evil
    evil-leader
    evil-lisp-state
    evil-matchit
    evil-surround
    git-gutter+
    magit
    rainbow-delimiters
    solarized-theme
    smartparens
    undo-tree))

(defvar my-extra-packages
  '(powerline-evil))

;; paredit
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
                                        ;(require 'evil-lisp-state)
(require 'smartparens-config)
(smartparens-global-strict-mode)
(powerline-evil-center-color-theme)
(evil-mode 1) ; last so that leader get applied at the right time

;; skip evil in these modes
(mapc (lambda (mode) (evil-set-initial-state mode 'emacs))
      '(inferior-emacs-lisp-mode
        shell-mode
        term-mode
        ;; cider-repl-mode
        magit-log-edit-mode
        magit-branch-manager-mode))

;; ----------------------------------------------------------------------------
;; file mode bindings
;;

(add-to-list 'auto-mode-alist '("\\.boot\\'" . clojure-mode))

;; -----------------------------------------------------------------------------

;; always UTF-8
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;;(prefer-coding-sytem 'utf-8)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

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

(setq cider-repl-history-file (concat default-directory ".cider-repl.log"))

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
        (cider-restart))
    (error (cider-jack-in))))

(defun my-proggy-bits ()
  (message "Installing proggy-bits")
  (local-set-key (kbd "C-x g") 'magit-status)
  (company-mode)
  (rainbow-delimiters-mode-enable))

(defun my-evil-base-bindings ()
  ;; unbind SPC and RET from motion, since i don't use them
  ;; to return them to normal, do as http://www.emacswiki.org/emacs/Evil
  ;;(define-key evil-motion-state-map " " nil)
  ;;(define-key evil-motion-state-map (kbd "RET") nil)
  (evil-leader/set-key "a" 'ag-project-regexp)
  (evil-leader/set-key ";a" 'ag-regexp)
  (evil-leader/set-key "w" 'toggle-truncate-lines)

  ;; rebind C-M-[ufb] to g[ufb]
  (define-key evil-normal-state-map "gu" (key-binding (kbd "C-M-u") t))
  (define-key evil-normal-state-map "gb" (key-binding (kbd "C-M-b") t))
  (define-key evil-normal-state-map "gf" (key-binding (kbd "C-M-f") t))
  )

(defun my-evil-cider-bindings ()
  ;; still need bindings for eval-region, eval-buffer, etc.
  (define-key evil-normal-state-map "\C-]" 'cider-jump-to-var)
  (define-key evil-normal-state-map "\C-t" 'cider-jump-back)
  ;; consider adding intermediate ; as a pretty-print modifier
  (evil-leader/set-key-for-mode 'clojure-mode
    ;; evals
    "ed"  'my-cider-eval-dwim               ; "eval dwim"
    "el"  'cider-eval-last-sexp             ; "eval last" (sexp)
    "er"  'cider-eval-region                ; "eval region"
    "et"  'cider-eval-defun-at-point        ; "eval this" top-level sexp
    "ee"  'cider-load-buffer                ; "eval everything" (buffer)
    "e;e" 'cider-refresh                    ; "eval Everything" (all buffers)

    ;; repl commands
    "rn"  'cider-repl-set-ns                ; repl namespace
    "rt"  'cider-test-run-test              ; repl test
    "r;t" 'cider-test-run-tests             ; repl tests
    ;; "rs"  'cider-jack-in                    ; repl start
    "rs"  'my-cider-re-or-start             ; repl (re)start
    "r;s" 'cider-restart                    ; repl restart
    "rq"  'cider-close-nrepl-session        ; repl quit
    "rr"  'cider-switch-to-repl-buffer      ; repl repl!
    ;; fight! let the winner stand.
    "rl" 'cider-find-and-clear-repl-buffer  ; repl clear (from ^L)
    "rc" 'cider-find-and-clear-repl-buffer  ; repl clear

    ;; macro expansion
    "mm" 'cider-macroexpand-1               ; default expand: currently 1
    "m1" 'cider-macroexpand-1               ; expand 1
    "mr" 'cider-macroexpand                 ; expand repeatedly, no subforms
    "ma" 'cider-macroexpand-all             ; expand all, w/ subforms
    ))

(defun my-evil-elisp-bindings ()
  (evil-leader/set-key-for-mode 'emacs-lisp-mode
    "el" 'eval-last-sexp
    "er" 'eval-region
    "et" 'eval-defun
    "ee" 'eval-buffer))

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

(defun my-evil-sp-bindings ()
  (message "Installing evil-sp bindings")
  (sp-use-paredit-bindings) ; keep these around while i'm still learning
  (define-key evil-normal-state-map (kbd "C-)") 'sp-forward-slurp-sexp)
  (define-key evil-normal-state-map (kbd "C-}") 'sp-forward-barf-sexp)

  ;; leader versions, replace w/ set-key-mode
  (evil-leader/set-key "ib" 'sp-backward-slurp-sexp)
  (evil-leader/set-key "if" 'sp-forward-slurp-sexp)
  (evil-leader/set-key "ob" 'sp-backward-barf-sexp)
  (evil-leader/set-key "of" 'sp-forward-barf-sexp)

  ;; git related
  (evil-leader/set-key "gs" 'magit-status)
  (evil-leader/set-key "gd" 'vc-diff)
  (evil-leader/set-key "u" 'sp-unwrap-sexp)
  (evil-leader/set-key "j" 'sp-join-sexp)
  (evil-leader/set-key "b" 'sp-backward-sexp)
  (evil-leader/set-key "f" 'sp-backward-sexp)
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
  (my-evil-magit-bindings))

(defun my-lispy-bits ()
  (message "Installing lispy-bits")
  (my-proggy-bits))

(add-hook 'clojure-mode-hook 'my-lispy-bits)
(add-hook 'emacs-lisp-mode 'my-lispy-bits)
(my-evil-bindings)

(defun my-git-bits ()
  (message "Installing git-bits")
  (message "current vc-mode: %s" (car (buffer-local-value 'vc-mode (current-buffer))))
  )

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
