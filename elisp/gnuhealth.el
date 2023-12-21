(defun gnuhealth-po-update ()
  (interactive)
  (let* ((file (read-file-name "Data file: "))
         (records (split-string
                   (with-temp-buffer
                     (insert-file-contents file)
                     (buffer-string))
                   "\n+")))
    (dolist (record records)
      (gnuhealth--handle-record record))
    (message "PO buffer update finished.")))

(defun gnuhealth--handle-record (record)
  (let* ((content (split-string record "	"))
         (class (nth 0 content))
         (code (nth 1 content))
         (desc (nth 2 content))
         (func (intern (format "gnuhealth--handle-%s" class))))
    (when (> (length class) 0)
      (if (not (functionp func))
          (message "WARN: class %s is invaild!!!" class)
        (message "Replacing %s: %s %s ..." class code desc)
        (funcall func code desc)))))

(defun gnuhealth--handle-icd10-disease (code desc)
  (goto-char (point-min))
  (when (and (re-search-forward
              (format ":%s\""
                      (replace-regexp-in-string
                       "[+*.]" "" code))
              nil t)
             (re-search-forward "msgstr \"" nil t))
    (delete-region (point) (line-end-position))
    (insert desc)
    (insert "\""))
  (goto-char (point-min)))

(defun gnuhealth--handle-icd10-section (code desc)
  (goto-char (point-min))
  (when (and (re-search-forward (format "\"(%s)" code) nil t)
             (re-search-forward "msgstr \"" nil t))
    (delete-region (point) (line-end-position))
    (insert (format "(%s) %s" code desc))
    (insert "\""))
  (goto-char (point-min)))

(defun gnuhealth--handle-icd10-chapter (code desc)
  (goto-char (point-min))
  (when (and (re-search-forward (format ":icdcat%s\"" code) nil t)
             (re-search-forward "msgstr \"" nil t))
    (delete-region (point) (line-end-position))
    (insert (format "第%s章 %s" code desc))
    (insert "\""))
  (goto-char (point-min)))

(defun gnuhealth--handle-icd9procs (code desc)
  (goto-char (point-min))
  (when (and (re-search-forward
              (format ":cie9_%s\""
                      (replace-regexp-in-string
                       "[.]" "-" code))
              nil t)
             (re-search-forward "msgstr \"" nil t))
    (delete-region (point) (line-end-position))
    (insert desc)
    (insert "\""))
  (goto-char (point-min)))
