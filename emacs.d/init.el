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
;(package-refresh-contents)

;; add check for existance of repos, and if not do a refresh

(defvar mp-base-packages
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

(defvar mp-extra-packages
  '(powerline-evil))

;; paredit
;; helm
;; projectile
;; goto-chg

(defun mp-install-packages (pkgs)
  (interactive)
  ;; (package-refresh-contents)
  (dolist (p pkgs)
    (unless (package-installed-p p)
      (package-install p))))

(mp-install-packages mp-base-packages)
(mp-install-packages mp-extra-packages)
(require 'ido)
(ido-mode t)

;; visual basis
;;(load-theme base16-default)
;;(load-theme "solarized-dark")
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

(column-number-mode)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; lein-clean+cider-restart, from chris@adgoji
(defun cider-clean-restart (&optional prompt-project)
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

(defun mp-proggy-bits ()
  (message "Installing proggy-bits")
  (local-set-key (kbd "C-x g") 'magit-status)
  (company-mode)
  (rainbow-delimiters-mode-enable))

(defun mp-evil-base-bindings ()
  (evil-leader/set-key "a" 'ag-project)
  (evil-leader/set-key "A" 'ag)
  (evil-leader/set-key "w" 'toggle-truncate-lines))

; when (fboundp 'cider-mode)
(defun mp-evil-cider-bindings ()
  ;; still need bindings for eval-region, eval-buffer, etc.
  (evil-leader/set-key "t" 'cider-test-run-test)
  (evil-leader/set-key "T" 'cider-test-run-tests)
  (define-key evil-normal-state-map "\C-]" 'cider-jump)
  (define-key evil-motion-state-map "\C-t" 'cider-jump-back))

(defun mp-evil-magit-bindings()
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

(defun mp-evil-sp-bindings ()
  (message "Installing evil-sp bindings")
  (sp-use-paredit-bindings)
  (define-key evil-normal-state-map (kbd "C-)") 'sp-forward-slurp-sexp)
  (define-key evil-normal-state-map (kbd "C-}") 'sp-forward-barf-sexp)

  ;; leader versions, replace w/ set-key-mode
  (evil-leader/set-key "ib" 'sp-backward-slurp-sexp)
  (evil-leader/set-key "if" 'sp-forward-slurp-sexp)
  (evil-leader/set-key "ob" 'sp-backward-barf-sexp)
  (evil-leader/set-key "of" 'sp-forward-barf-sexp)

  ;; git related
  (evil-leader/set-key "g" 'magit-status)
  (evil-leader/set-key "u" 'sp-unwrap-sexp)
  (evil-leader/set-key "j" 'sp-join-sexp)
  (evil-leader/set-key "b" 'sp-backward-sexp)
  (evil-leader/set-key "f" 'sp-backward-sexp)
  )

(defun mp-evil-window-bindings ()
  ;;(define-key evil-normal-state-map (kbd "C-w q") 'ido-kill-buffer)
  (define-key evil-normal-state-map (kbd "-") 'evil-prev-buffer)
  (define-key evil-normal-state-map (kbd "+") 'evil-next-buffer)
  (define-key evil-window-map "q" 'evil-window-delete) ; imperfect, but better than nothing
  )

(defun mp-evil-bindings ()
  (mp-evil-base-bindings)
  (mp-evil-window-bindings)
  (mp-evil-sp-bindings)
  (mp-evil-cider-bindings)
  (mp-evil-magit-bindings))

(defun mp-lispy-bits ()
  (message "Installing lispy-bits")
  (mp-proggy-bits)
  )

(add-hook 'clojure-mode-hook 'mp-lispy-bits)
(add-hook 'emacs-lisp-mode 'mp-lispy-bits)
(mp-evil-bindings)

(defun mp-git-bits ()
  (message "Installing git-bits")
  (message "current vc-mode: %s" (car (buffer-local-value 'vc-mode (current-buffer))))
  )

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
