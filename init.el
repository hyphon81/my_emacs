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
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
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

;;(add-to-list 'default-frame-alist '(font . "Ricty-20"))
(set-default-font "Ricty Diminished-13")


;;(setq skk-server-host "slack.hyphon81.net")
;;(setq skk-server-portnum 1178)

;;(require 'skk-autoloads)
;;(global-set-key "\C-x\C-j" 'skk-mode)
;;(global-set-key "\C-xj" 'skk-auto-fill-mode)
;;(global-set-key "\C-xt" 'skk-tutorial)

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
        (:background "#BFBFBF" t))
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

;; mark region highlight
(setq-default transient-mark-mode t)
(set-face-background 'region "yellow")
(set-face-background 'region "red")

;; w3
(require 'w3)
(setq w3-default-homepage "https://google.com")

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
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(setq ensime-startup-snapshot-notification nil)
(require 'mvn)

;; for erlang program
(require 'erlang-start)

;; for nix program
(require 'nix-mode)

;; for C# program
(require 'csharp-mode)

;; for Go program
(add-to-list 'exec-path (expand-file-name "/home/hyphon81/workspace/go/bin"))
(setenv "GOPATH" "/home/hyphon81/workspace/go")
(require 'go-mode)
(require 'company-go)
(add-hook 'go-mode-hook 'company-mode)
(add-hook 'go-mode-hook 'flycheck-mode)
(add-hook 'go-mode-hook (lambda()
                          (add-hook 'before-save-hook' 'gofmt-before-save)
                          (local-set-key (kbd "M-.") 'godef-jump)
                          (set (make-local-variable 'company-backends) '(company-go))
                          (company-mode)
                          (setq indent-tabs-mode nil)    ; タブを利用
                          (setq c-basic-offset 4)        ; tabサイズを4にする
                          (setq tab-width 4)))

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

;; for javascript program
;; js2-mode
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))
(setq js-indent-level 2)

;; for typescript program
;; typscript-mode
(require 'typescript-mode)
(setq typescript-indent-level 2)

;; for haskell program
;; haskell-mode
(require 'haskell-mode)
(require 'flycheck-haskell)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
;(add-hook 'haskell-mode-hook
;          '(lambda ()
;             (setq flycheck-checker 'hlint)
;             (flycheck-mode 1)))

;; for java
(require 'meghanada)
(add-hook 'java-mode-hook
          (lambda ()
            ;; meghanada-mode on
            (meghanada-mode t)
            (setq c-basic-offset 2)
            ;; use code format
            (add-hook 'before-save-hook 'meghanada-code-beautify-before-save)))

;; for yaml
(require 'yaml-mode)

;; for Cofeescript program
;; coffee-mode
(require 'coffee-mode)

;; for markdown
;; markddown-mode
(require 'markdown-mode)

;; for git
(require 'magit)

;; for github
(require 'gh)

;; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)
(define-key ac-complete-mode-map "\C-tab" 'ac-next)
(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)
(require 'auto-complete-c-headers)
(add-hook 'c++-mode-hook '(setq ac-sources (append ac-sources '(ac-source-c-headers))))
(add-hook 'c-mode-hook '(setq ac-sources (append ac-sources '(ac-source-c-headers))))
(add-hook
    'python-mode
    (lambda ()
      ;; Make sure `ac-source-chunk-list' comes first.
      (setq ac-sources (append '(ac-source-chunk-list) ac-sources))
      (setq ac-chunk-list
            '("os.path.abspath" "os.path.altsep" "os.path.basename"))))

;; window size
(setq default-frame-alist
      (append (list
               '(font . "Ricty Diminished-13")
               '(width . 80)
               '(height . 30))
              default-frame-alist))
(setq initial-frame-alist default-frame-alist)

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (typescript-mode company-go go-mode ensime yaml-mode meghanada rjsx-mode jsx-mode markdown-mode erlang csharp-mode nix-mode w3 undo-tree ssh mvn magit js2-mode htmlize grep-a-lot git gh flycheck-haskell coffee-mode cl-format auto-complete-octave auto-complete-c-headers anything))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
