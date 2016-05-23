;;~/.emacs.d directry add to loadpath
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
        (expand-file-name (concat user-emacs-directory path))))
          (add-to-list 'load-path default-directory)
            (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
              (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "elisp" "conf" "public_repos")

;; package.el
(when (require 'package nil t)
;; add package repo
  (add-to-list 'package-archives
    '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
;; load-path for installed packages
  (package-initialize))

;; auto-install
(when (require 'auto-install nil t)
  ;; install directory set
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWiki
  (auto-install-update-emacswiki-package-name t)
  ;;install-elispe function
  (auto-install-compatibility-setup))

;; grep-a-lot
(require 'grep-a-lot)
(grep-a-lot-setup-keys)
(grep-a-lot-advise igrep)

;; undo-tree
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

(set-default-coding-systems 'utf-8-unix) ;デフォルトの文字コード 

(add-to-list 'default-frame-alist '(font . "Ricty-20"))
;;(set-default-font "Ricty")

;;(setq skk-server-host "slack.hyphon81.net")
;;(setq skk-server-portnum 1178)

(require 'skk-autoloads)
(global-set-key "\C-x\C-j" 'skk-mode)
(global-set-key "\C-xj" 'skk-auto-fill-mode)
(global-set-key "\C-xt" 'skk-tutorial)

(defadvice abks:open-file (around my-abks:open-file activate)
  (if (require 'doc-view  nil t)
      (find-file (ad-get-arg 0))
    ad-do-it))

;; return string out of window
(setq truncate-partial-width-windows nil)

;; display file size
(size-indication-mode t)

;; display full path top
(setq frame-title-format "%f")

;; display column num
(column-number-mode t)

;; display always line num
(global-linum-mode t)

;; current line high-light
(defface my-hl-line-face
  '((((class color) (background dark))
      (:background "NavyBlue" t))
        (((class color) (background light))
        (:background "DeepSkyBlue" t))
   (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

;; paren mode ()-high-light
(setq show-paren-delay 0) ; default 0.125
(show-paren-mode t)
;; paren style
(setq show-paren-style 'expression)
;; paren face set
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "black")

;; not backup make
;;(setq make-backup-files nil) ;default = t
(add-to-list 'backup-directory-alist
  (cons "." "~/.emacs.d/auto-save-list/"))

;; not auto save make
;;(setq auto-save-default nil) ;default = t
(setq auto-save-file-name-transforms
  `((".*" ,(expand-file-name "~/.emacs.d/auto-save-list/") t)))

;; white space  mode
(require 'whitespace)
(global-whitespace-mode 1)
(set-face-foreground 'whitespace-space "DarkGoldenrod1")
(set-face-background 'whitespace-space nil)
(set-face-bold-p 'whitespace-space t)
(set-face-foreground 'whitespace-tab "DarkOliveGreen1")
(set-face-background 'whitespace-tab "DarkOliveGreen1")
(set-face-underline  'whitespace-tab t)
(setq whitespace-style '(face tabs tab-mark spaces space-mark))
(setq whitespace-space-regexp "\\(\x3000+\\)")
(setq whitespace-display-mappings
  '((space-mark ?\x3000 [?\□])
    (tab-mark   ?\t   [?\xBB ?\t])
  ))

;; w3
(require 'w3)


;; ssh file access
(require 'tramp)
(setq tramp-default-method "scpx")
(add-to-list 'tramp-remote-path "/usr/bin")
(add-to-list 'tramp-default-proxies-alist
             '(".*" "\\`root\\'" "/sshx:%h:"))
(add-to-list 'tramp-default-proxies-alist
             '("localhost" nil nil))
;(add-to-list 'tramp-default-proxies-alist
;             '((regexp-quote (system-name)) nil nil))
(setq tramp-debug-buffer t)
          
;; add-hook #!
(add-hook 'after-save-hook
  'executable-make-buffer-file-executable-if-script-p)

;; emacs-lisp-mode add-hook
(add-hook 'emacs-lisp-mode-hook
  '(lambda ()
    (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode))))

;; redo+
(when (require 'redo+ nil t)
  (global-set-key (kbd "C-.") 'redo)
)

;; default character code utf-8
(prefer-coding-system 'utf-8)

;; intend space only
(setq-default indent-tabs-mode nil)

;; for cuda program
(setq auto-mode-alist
      (cons (cons "\\.cu$" 'c++-mode) auto-mode-alist))

;; for scala program
(require 'scala-mode)

;; for chuck program
(require 'chuck-mode)
(setq auto-mode-alist
      (cons (cons "\\.ck$" 'chuck-mode) auto-mode-alist))

;; for octave program
;; octave mode
(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
           (cons '("\\.m$" . octave-mode) auto-mode-alist))
(add-hook 'octave-mode-hook
               (lambda ()
                 (abbrev-mode 1)
                 (auto-fill-mode 1)
                 (if (eq window-system 'x)
                     (font-lock-mode 1))))

;;(require 'anything) 
;;(require 'anything-config) 
;;(require 'anything-match-plugin) 

;; anything-etags+.el
;;(require 'anything-etags+)
;;(global-set-key "\M-." 'anything-etags+-select-one-key)

;(setenv "PATH"
;  (concat "D:\\PGF\\putty-0.60-JP_Y-2007-08-06" ";"
;    (getenv "PATH")))

;(setenv "PATH"
;   (format "%s;%s;%s"
;    "D:\\PGF\\UnxUtils\\bin"
;    "D:\\PGF\\UnxUtils\\usr\\local\\wbin"
;    (or (getenv "$PATH") "")))
