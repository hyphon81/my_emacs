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
     (:background "LightGoldenrodYellow" t))
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
(set-face-underline-p 'show-paren-match-face "yellow")

;; not backup make
;;(setq make-backup-files nil) ;default = t
(add-to-list 'backup-directory-alist
	     (cons "." "~/.emacs.d/auto-save-list/"))

;; not auto save make
;;(setq auto-save-default nil) ;default = t
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/auto-save-list/") t)))

;; ssh file access
(require 'tramp)
(setq tramp-default-method "ssh")

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
