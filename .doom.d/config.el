(setq doom-font (font-spec :family "mononoki Nerd Font Mono" :size 12)
      doom-variable-pitch-font (font-spec :family "mononoki Nerd Font" :size 12))
(minimap-mode 1)

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
(setq delete-by-moving-to-trash t)

(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired images previews" "d p" #'peep-dired
        :desc "Cue file to emms playlist" "d c" #'emms-add-dired
        :desc "Dired open file width xdg-open" "d x" #'dired-open-xdg
        :desc "Dired view file" "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-open-file ; use dired-find-file instead of dired-open.
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill ; copies filename to kill ring.
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-up-directory
  (kbd "% l") 'dired-downcase
  (kbd "% u") 'dired-upcase
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)

(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(setq dired-open-extensions '(("gif" . "feh")
                             ("jpg" . "feh")
                             ("png" . "feh")
                             ("mkv" . "mpv")
                             ("mp3" . "mpv")
                             ("mp4" . "mpv")))

(require 'emms-setup)
(require 'emms-player-mpd)
(emms-all)
;(emms-default-players)
(setq emms-player-list '(emms-player-mpd))
(add-to-list 'emms-info-functions 'emms-info-mpd)
(add-to-list 'emms-player-list 'emms-player-mpd)
(emms-mode-line-mode 1)
(emms-playing-time-mode 1)
(setq emms-source-file-default-directory "/mnt/plex/Music/"
      emms-playlist-buffer-name "*Music*"
      emms-player-mpd-server-name "localhost"
      emms-player-mpd-server-port "6600"
      emms-player-mpd-music-directory "/mnt/plex/Music/"
      emms-info-asynchronously t
      emms-source-file-directory-tree-function 'emms-source-file-directory-tree-find)
(emms-player-mpd-connect)

(map! :leader
      (:prefix ("e" . "EMMS audio player")
       :desc "Go to emms playlist" "a" #'emms-playlist-mode-go
       :desc "Emms browser" "b" #'emms-browser
       :desc "Emms pause track" "x" #'emms-pause
       :desc "Emms stop track" "s" #'emms-stop
       :desc "Emms play previous track" "p" #'emms-previous
       :desc "Emms play next track" "n" #'emms-next))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jon Saxton"
      user-mail-address "kawaii_kisachan@live.com")

(setq doom-theme 'doom-dracula)

(after! org
  (require 'org-bullets)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (require 'org-journal)
  (setq org-directory "~/Documents/Org/"
        org-journal-dir "~/Documents/Org/Journal/"
        org-journal-date-format "%d-%b-%Y (%a)"
        org-journal-file-format "%d-%m-%Y.org"
        org-agenda-files '("~/Documents/Org/agenda.org")
        org-log-done 'time
        ;; org-log done 'note
        org-todo-keywords '((sequence "TODO(t)" "PROJ(p)" "STUDY(s)" "ASSIGNMENT(a)" "|" "DONE(d)" "CANCELLED(c)")))
)

(require 'ox-publish)
(setq org-html-validation-link nil
      org-html-head-include-scripts nil
      org-html-head-include-default-style nil
      org-html-extension "htm" )

(setq org-publish-project-alist
      '(
        ("jon1996"
         :base-directory "~/Sites/jon1996/org/"
         :base-extension "org"
         :publishing-directory "/srv/http1996/pages/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :auto-preamble t
         :with-author nil
         :with-creator t
         :with-toc nil
         :section-numbers nil)
      ("org-static"
       :base-directory "~/Documents/Org/"
       :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
       :publishing-directory "~/public_html"
       :recrusive t
       :publishing-function org-publish-attachment)
))

(add-to-list 'default-frame-alist '(alpha-background . 80))

(setq display-line-numbers-type t)

(require `mu4e)

(setq mu4e-search-skip-duplicates t)

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

(global-set-key (kbd "M-r") 'elfeed)

(add-hook! 'elfeed-search-mode-hook #'elfeed-update)
