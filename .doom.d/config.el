(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;;Dired config!
(defun mydired-sort ()
  "Sort dired listings with directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2) ;; beyond dir. header
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
    (set-buffer-modified-p nil)))

(defadvice dired-readin
  (after dired-after-updating-hook first () activate)
  "Sort dired listings with directories first before adding marks."
  (mydired-sort))

(setq-default dired-listing-switches "-alh")

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jon Saxton"
      user-mail-address "jjon.saxton@gmail.com")

(setq doom-theme 'doom-one)

(after! org
  (require 'org-bullets)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-directory "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org"
        org-agenda-files '("~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/Org/todo.org")
        org-log-done 'time
        ;; org-log done 'note
        org-todo-keywords '((sequence "TODO(t)" "PROJ(p)" "STUDY(s)" "ASSIGNMENT(a)" "|" "DONE(d)" "CANCELLED(c)")))
)

(setq display-line-numbers-type t)
