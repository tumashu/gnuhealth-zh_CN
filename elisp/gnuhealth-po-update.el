;;; gnuhealth-po-update.el --- A tool used to update GNU Health po file  -*- lexical-binding: t; -*-

;; Author: Feng Shu <tumashu@163.com>
;; Url: https://hg.savannah.gnu.org/hgweb/health/
;; Version: 0.0.1
;; Keywords: po, utils

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package is useful to update po files of GNU Health modules:

;; 1. health_icd10
;; 2. health_icd9procs

;; There are many strings need to translate in health_icd10 and
;; health_icd9procs modules, the context of po files is like below:

;;     msgctxt "model:gnuhealth.pathology,name:A00"
;;     msgid "Cholera"
;;     msgstr ""

;; If the below data is found, for example:

;;     class	code	desc-translation
;;     icd10-disease	A00	霍乱

;; We can use this Emacs package to update po files in following
;; steps:

;; 1. Find the translated version of icd10 and icd9procs, in most
;;    case, we can find two xlsx files.
;; 2. Extract infos from xlsx files and update data/icd10-*.txt and
;;    icd9procs.txt
;; 3. Add (add-to-list 'load-path "/PATH/TO/health/tryton/script/health-po-update") to
;;    '~/.emacs'
;; 4. Open file with Emacs: health/tryton/health_icd10/locale/zh_CN.po
;; 5. Run Emacs command (M-x): gnuhealth-po-update
;; 6. Save po file.
;; 7. Review diff with the help of hg.

;;; Code:
(defun gnuhealth-po-update ()
  (interactive)
  (let ((module (completing-read
                 "GNU Health module:"
                 '(health_icd10 health_icd9procs)))
        (elfile (or (locate-library "gnuhealth-po-update.el")
                    (read-file-name "gnuhealth-po-update.el file:"))))
    (when elfile
      (let* ((dir (file-name-directory elfile))
             (icd10-chapter (expand-file-name "data/icd10-chapter.txt" dir))
             (icd10-section (expand-file-name "data/icd10-section.txt" dir))
             (icd10-disease (expand-file-name "data/icd10-disease.txt" dir))
             (icd9procs (expand-file-name "data/icd9procs.txt" dir))
             (records (split-string
                       (with-temp-buffer
                         (if (equal module 'health_icd9procs)
                             (insert-file-contents icd0procs)
                           (insert-file-contents icd10-chapter)
                           (insert-file-contents icd10-section)
                           (insert-file-contents icd10-disease))
                         (buffer-string))
                       "\n+")))
        (dolist (record records)
          (gnuhealth--handle-record record))
        (message "PO buffer update finished.")))))

(defun gnuhealth--handle-record (record)
  (let* ((content (split-string record "	+"))
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

(provide 'gnuhealth-po-update)
