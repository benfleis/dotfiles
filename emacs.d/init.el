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
  '(better-defaults
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

;; -----------------------------------------------------------------------------
;; configure evil basics.
;;

(global-evil-leader-mode)
(evil-leader/set-leader ";")
(global-evil-surround-mode 1)
;(require 'evil-lisp-state)
(require 'smartparens-config)
(smartparens-global-strict-mode)
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

(setq cider-repl-history-file "./.cider-repl.log")

(defun mp-proggy-bits ()
  (message "Installing proggy-bits")
  (local-set-key (kbd "C-x g") 'magit-status)
  (company-mode)
  (rainbow-delimiters-mode-enable))

(defun mp-evil-sp-bindings ()
  (message "Installing evil-sp bindings")
  ;; (sp-local-pair)
  (sp-use-paredit-bindings)
  ;; this is wrong, since it's not local, but i can't figure out how to get sp-local-pair to work w/ clojure-mode:
  ;; (sp-local-pair 'clojure-mode '"'" nil :actions :rem)
  ;; (sp-pair "'" nil :actions nil)
  (define-key evil-normal-state-map (kbd "C-)") 'sp-forward-slurp-sexp)

  ;; leader versions, replace w/ set-key-mode
  (evil-leader/set-key "i9" 'sp-backward-slurp-sexp)
  (evil-leader/set-key "i0" 'sp-forward-slurp-sexp)
  (evil-leader/set-key "o9" 'sp-backward-barf-sexp)
  (evil-leader/set-key "o0" 'sp-forward-barf-sexp)
  (evil-leader/set-key "u" 'sp-unwrap-sexp)
  (evil-leader/set-key "j" 'sp-join-sexp)
  (evil-leader/set-key "b" 'sp-backward-sexp)
  (evil-leader/set-key "f" 'sp-backward-sexp)
  )

(defun mp-lispy-bits ()
  (message "Installing lispy-bits")
  (mp-proggy-bits)
  (mp-evil-sp-bindings))

(add-hook 'clojure-mode-hook 'mp-lispy-bits)
(add-hook 'emacs-lisp-mode 'mp-lispy-bits)

(defun mp-git-bits ()
  (message "Installing git-bits")
  (message "current vc-mode: %s" (car (buffer-local-value 'vc-mode (current-buffer))))
  )

(defun mp-evil-cider-bindings ()
  (when (fboundp 'cider-mode)
    (define-key evil-normal-state-map (kbd "C-]") 'cider-jump)))

;; (add-hook 'clojure-mode-hook 'mp-evil-cider-bindings)

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
    ("a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
