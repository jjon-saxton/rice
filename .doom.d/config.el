(setq doom-font (font-spec :family "mononoki Nerd Font Mono" :size 12)
      doom-variable-pitch-font (font-spec :family "mononoki Nerd Font" :size 12))

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
  (require 'org-journal)
  (setq org-directory "~/Documents/Org/"
        org-journal-dir "~/Documents/Org/Journal/"
        org-journal-date-format "%d-%b-%Y (%a)"
        org-journal-file-format "%d-%m-%Y.org"
        org-agenda-files '("~/Documents/Org/agenda.org" "~/Documents/Org/todo.org")
        org-log-done 'time
        ;; org-log done 'note
        org-todo-keywords '((sequence "TODO(t)" "PROJ(p)" "STUDY(s)" "ASSIGNMENT(a)" "|" "DONE(d)" "CANCELLED(c)")))
)

(require 'ox-publish)
(setq org-publish-project-alist
      '(
        ("yayoi world"
         :base-directory "~/Documents/Org/Yayoi"
         :base-extension "org"
         :publishing-directory "~/public_html/yayoi/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 4
         :auto-preamble t)
      ("org-static"
       :base-directory "~/Documents/Org/"
       :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
       :publishing-directory "~/public_html"
       :recrusive t
       :publishing-function org-publish-attachment)
))

(setq display-line-numbers-type t)

(require `mu4e)
(require `org-mu4e)

(setq mu4e-headers-skip-duplicates t)

(setq mu4e-get-mail-command "offlineimap")

(setq mu4e-contexts
      `(, (make-mu4e-context
           :name "Primary"
           :match-func (lambda(msg) (when msg
                                      (string-prefix-p "/Primary" (mu4e-message-field msg :maildir))))
           :vars `(
                   (mu4e-trash-folder . "/Primary/Deleted Messages")
                   (mu4e-refile-folder . "/Primary/Archive")
                   ))
          , (make-mu4e-context
             :name "Live"
             :match-func (lambda (msg) (when msg
                                         (string-prefix-p "/Live" (mu4e-message-field msg :maildir))))
             :vars '(
                     (mu4e-trash-folder . "/Live/Deleted")
                     (mu4e-refile-folder . "/Live/Archive")
                     ))
            ))

(setq mu4e-sent-folder "/sent"
      mu4e-drafts-folder "/drafts"
      user-mail-address "kawaii_kisachan@live.com"
      smtpmail-smtp-user "kawaii_kisachan@live.com"
      smtpmail-default-smtp-server "smtp.office365.com"
      smtpmail-smtp-server "smtp.office365.com"
      smtpmail-smtp-service 587)

(global-set-key  (kbd "M-m") 'mu4e)
