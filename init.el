;;~/.emacs.d directry add to loadpath
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

;; add to loadpath these directorys recursivery
(add-to-load-path "elisp" "conf" "public_repos")

;; display file size
(size-indication-mode t)

;; display full path top
(setq frame-title-format "%f")

;; display always line num
(global-linum-mode t)

;; not backup make
(setq make-backup-files nil) ;default = t

;; not auto save make
(setq auto-save-default nil) ;default = t

;; ssh file access
(require 'tramp)
(setq tramp-default-method "ssh")
