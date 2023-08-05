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

(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired images previews" "d p" #'peep-dired
        :desc "Cue file to emms playlist" "d c" #'emms-add-dired
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
                             ("mp4" . "mpv")
                             ("zip" . "file-roller")
                             ("rar" . "file-roller")
                             ("7z" . "file-roller")
                             ("tar" . "file-roller")
                             ("xz" . "file-roller")))

(use-package dashboard
  :init
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "\nKEYBINDINGS:\nFind file (SPC .)\nFind recent file (SPC f r)\nOpen dired file manager (SPC d d)\nList keybindings (SPC h b b)")
  (setq dashboard-startup-banner "~/.doom.d/doom-emacs-dash.png")
  (setq dashboard-items `((recents . 5)
        (agenda . 5)
        (bookmarks . 5)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons `((recents . "file-text")
                                    (bookmarks . "book"))))

(setq doom-fallback-buffer-name "*dashboard*")

(emms-all)
(emms-default-players)
(emms-mode-line 1)
(emms-playing-time 1)
(setq emms-source-file-default-directory "/mnt/plex/Music/"
      emms-playlist-buffer-name "*Music*"
      emms-info-asynchronously t
      emms-source-file-directory-tree-function 'emms-source-file-directory-tree-find)

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
         :base-directory "/srv/http1996/org/"
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

;; (add-to-list 'default-frame-alist '(alpha-background . 80)) commented out until Manjaro has Emacs 29, maybe causing long load times!

(require 'exwm)
(require 'exwm-config)
(exwm-config-default)

(require 'exwm-systemtray)
(exwm-systemtray-enable)

(add-hook 'exwm-update-class-hook
          (lambda ()
                 (exwm-workspace-rename-buffer exwm-class-name)))

(defun exwm-logout ()
  (interactive)
  (recentf-save-list)
  (save-some-buffers)
  (start-process-shell-command "logout" nil "lxsession-logout"))
(defun exwm-lock ()
  (interactive)
  (start-process-shell-command "slock" nil "slock"))

(exwm-input-set-key (kbd "s-Q") 'exwm-logout)
(exwm-input-set-key (kbd "C-s-q") 'exwm-lock)
(exwm-input-set-key (kbd "s-w") '+workspace/close-window-or-workspace)
(exwm-input-set-key (kbd "s-q") 'kill-this-buffer)
(exwm-input-set-key (kbd "s-/") 'dmenu)
(exwm-input-set-key (kbd "s-<tab>") 'exwm-workspace-switch-to-buffer)
(exwm-input-set-key (kbd "M-<tab>") 'exwm-workspace-switch)
(exwm-input-set-key (kbd "s-l") 'evil-window-right)
(exwm-input-set-key (kbd "s-h") 'evil-window-left)
(exwm-input-set-key (kbd "s-j") 'evil-window-down)
(exwm-input-set-key (kbd "s-k") 'evil-window-up)
(exwm-input-set-key (kbd "s-s") 'evil-window-split)
(exwm-input-set-key (kbd "s-v") 'evil-window-vsplit)
(exwm-input-set-key (kbd "s-t") '+vterm/toggle)
(exwm-input-set-key (kbd "s-<return>") 'execute-extended-command)
(exwm-input-set-key (kbd "s-m") 'exwm-layout-toggle-fullscreen)
(exwm-input-set-key (kbd "s-c") 'exwm-input-toggle-keyboard)
(exwm-input-set-key (kbd "s-d") 'dired)

(display-time)

(setq display-line-numbers-type t)

(require `mu4e)

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

(global-set-key (kbd "M-r") 'elfeed)

(add-hook! 'elfeed-search-mode-hook #'elfeed-update)
