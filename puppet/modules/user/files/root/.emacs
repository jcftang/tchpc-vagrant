;; default to better frame titles
(setq frame-title-format (concat "%b - emacs@" system-name))

;; default to unified diffs
(setq diff-switches "-u")

;; default to showing column number
(column-number-mode t)

;; fill at 78 columns by default
(setq-default fill-column 78)

;; store autosaves under the home directory
(defvar autosave-dir "~/.emacs.d/backups/")
(make-directory autosave-dir t)
(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))
(defun make-auto-save-file-name ()
  (concat autosave-dir
    (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
      (expand-file-name (concat "#%" (buffer-name) "#")))))

;; store backups under the home directory
(defvar backup-dir "~/.emacs.d/backups/")
(setq backup-directory-alist (list (cons "." backup-dir)))
