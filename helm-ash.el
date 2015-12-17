;;; helm-ash.el --- Helm interface for ash

;; TODO: add license information.

;;; Commentary:

;; Add the following to your Emacs init file:
;;
;; (require 'helm-ash)
;; (global-set-key (kbd "C-x c C-r") 'helm-ash-inbox)

;;; Code:

(require 'helm)

(defgroup helm-ash nil
  "Helm interface for ash"
  :prefix "helm-ash-"
  :group 'helm)

(defcustom helm-ash-candidate-number-limit 300
  "Limit candidate number of `helm-ash'.

Set it to nil if you don't want this limit."
  :group 'helm-ash
  :type '(choice (const :tag "Disabled" nil) integer))

(defcustom helm-ash-fuzzy-match nil
  "Enable fuzzy matching for Helm Ash."
  :type 'boolean)

(defcustom helm-ash-editor "emacsclient"
  "Editor for review PR."
  :type 'string)

(defvar helm-ash-pr ""
  "Current pull request.")

(defun helm-ash-action-ls-review-file (candidate)
  "Review file CANDIDATE."
  (interactive)
  (start-process "ash" "*ash review*"
                 "ash" "-e" helm-ash-editor helm-ash-pr "review"
                 (nth 1 (split-string candidate))))

(defun helm-ash--do-with-pr (action pr)
  "Do the ACTION with PR."
  (interactive)
  (start-process "ash" "*ash actions*"
                 "ash" "-e" helm-ash-editor pr action))

(defun helm-ash-action-ls-review-pr (candidate)
  "Review pr CANDIDATE."
  (interactive)
  (helm-ash--do-with-pr "review" helm-ash-pr))

(defun helm-ash-action-ls-approve-pr (candidate)
  "Approve pr CANDIDATE."
  (interactive)
  (helm-ash--do-with-pr "approve" helm-ash-pr))

(defun helm-ash-action-ls-decline-pr (candidate)
  "Decline pr CANDIDATE."
  (interactive)
  (helm-ash--do-with-pr "decline" helm-ash-pr))

(defun helm-ash-action-ls-merge-pr (candidate)
  "Merge pr CANDIDATE."
  (interactive)
  (helm-ash--do-with-pr "merge" helm-ash-pr))

(defvar helm-ash-ls-actions
  '(("review file" . helm-ash-action-ls-review-file)
    ("review PR" . helm-ash-action-ls-review-pr)
    ("approve PR" . helm-ash-action-ls-approve-pr)
    ("decline PR" . helm-ash-action-ls-decline-pr)
    ("merge PR" . helm-ash-action-ls-merge-pr)))

(defun helm-ash-action-list-files (candidate)
  "List files modified in the CANDIDATE."
  (interactive)
  (helm :buffer "*helm ash*"
        :candidate-number-limit helm-ash-candidate-number-limit
        :sources (helm-build-async-source "ash ls"
                    :candidates-process (lambda ()
                                          (setq helm-ash-pr (car (split-string candidate)))
                                          (start-process
                                           "ash" nil "ash" helm-ash-pr "ls"))
                    :fuzzy-match helm-ash-fuzzy-match
                    :action helm-ash-ls-actions)))

(defun helm-ash-action-review (candidate)
  "Review CANDIDATE."
  (interactive)
  (helm-ash--do-with-pr "review" (car (split-string candidate))))

(defun helm-ash-action-approve (candidate)
  "Approve CANDIDATE."
  (interactive)
  (helm-ash--do-with-pr "approve" (car (split-string candidate))))

(defun helm-ash-action-decline (candidate)
  "Decline CANDIDATE."
  (interactive)
  (helm-ash--do-with-pr "decline" (car (split-string candidate))))

(defun helm-ash-action-merge (candidate)
  "Merge CANDIDATE."
  (interactive)
  (helm-ash--do-with-pr "merge" (car (split-string candidate))))

(defvar helm-ash-actions
  '(("list" . helm-ash-action-list-files)
    ("review" . helm-ash-action-review)
    ("approve" . helm-ash-action-approve)
    ("decline" . helm-ash-action-decline)
    ("merge" . helm-ash-action-merge))
  "Actions for `helm-ash'.")

(defvar helm-source-ash-inbox
  (helm-build-async-source "ash inbox"
    :candidates-process (lambda ()
                          (start-process "ash" nil "ash" "inbox"))
    :fuzzy-match helm-ash-fuzzy-match
    :action helm-ash-actions)
  "Helm source definition for ash.")

(defun helm-ash-inbox ()
  "Helm interface for ash inbox."
  (interactive)
  (helm :sources 'helm-source-ash-inbox
        :buffer "*helm ash inbox*"
        :candidate-number-limit helm-ash-candidate-number-limit))


(provide 'helm-ash)
;;; helm-ash.el ends here
