(defun gnuhealth-update ()
  "Format a tab split file to a elisp function"
  (interactive)
  (let ((file (read-file-name "Data file: ")))
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (while (not (eobp))
        (gnuhealth-replace-line
         (buffer-substring-no-properties
          (line-beginning-position)
          (line-end-position)))
        (forward-line 1)))))

(defun gnuhealth-replace-line (line)
  (let* ((line-content (split-string line "	"))
         (class (nth 0 line-content))
         (code (nth 1 line-content))
         (desc (nth 2 line-content))
         (func (intern (format "gnuhealth-replace-%s" class)))
         )
    (when (functionp func)
      (message "Replace:" class code desc)
      (funcall func code desc))))

(defun gnuhealth-replace-icd10-disease (a b &rest c)
  (goto-char (point-min))
  (when (and (re-search-forward
              (format ":%s\""
                      (replace-regexp-in-string
                       "[+*.]" "" a))
              nil t)
             (re-search-forward "msgstr \"" nil t))
    (delete-region (point) (line-end-position))
    (insert b)
    (insert "\""))
  (goto-char (point-min)))

(defun gnuhealth-replace-icd10-section (a b &rest c)
  (goto-char (point-min))
  (when (and (re-search-forward (format "\"(%s)" a) nil t)
             (re-search-forward "msgstr \"" nil t))
    (delete-region (point) (line-end-position))
    (insert (format "(%s) %s" a b))
    (insert "\""))
  (goto-char (point-min)))

(defun gnuhealth-replace-icd10-chapter (a b &rest c)
  (goto-char (point-min))
  (when (and (re-search-forward (format ":icdcat%s\"" a) nil t)
             (re-search-forward "msgstr \"" nil t))
    (delete-region (point) (line-end-position))
    (insert (format "第%s章 %s" a b))
    (insert "\""))
  (goto-char (point-min)))

(defun gnuhealth-replace-icd9pcs (a b &rest c)
  (goto-char (point-min))
  (when (and (re-search-forward
              (format ":cie9_%s\""
                      (replace-regexp-in-string
                       "[.]" "-" a))
              nil t)
             (re-search-forward "msgstr \"" nil t))
    (delete-region (point) (line-end-position))
    (insert b)
    (insert "\""))
  (goto-char (point-min)))
