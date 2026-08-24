(in-package #:schema-protocol-json)

(defun draft-uri (draft)
  (ecase draft
    ((:draft-07 :draft7)
     "http://json-schema.org/draft-07/schema#")
    ((:draft-2020-12 :2020-12)
     "https://json-schema.org/draft/2020-12/schema")))

(defun detect-draft (table)
  (let ((uri (and (hash-table-p table) (gethash "$schema" table))))
    (cond
      ((null uri) :draft-07)
      ((search "2020-12" uri) :draft-2020-12)
      (t :draft-07))))

(defun stringify-key (key)
  (etypecase key
    (string key)
    (symbol (string-downcase (symbol-name key)))
    (character (string key))))

(defun stringify-json (value)
  (cond
    ((hash-table-p value)
     (let ((out (make-hash-table :test #'equal)))
       (maphash (lambda (k v)
                  (setf (gethash (stringify-key k) out) (stringify-json v)))
                value)
       out))
    ((and (vectorp value) (not (stringp value)))
     (map 'vector #'stringify-json value))
    ((and (listp value) (keywordp (first value)))
     (let ((out (make-hash-table :test #'equal)))
       (loop for (k v) on value by #'cddr
             do (setf (gethash (stringify-key k) out) (stringify-json v)))
       out))
    ((and (listp value) (consp (first value)))
     (let ((out (make-hash-table :test #'equal)))
       (dolist (pair value out)
         (setf (gethash (stringify-key (car pair)) out) (stringify-json (cdr pair))))))
    ((listp value)
     (mapcar #'stringify-json value))
    (t value)))

(defun %maybe-decode (source format)
  (if (null format)
      source
      (let* ((pkg (find-package "SERDES-PROTOCOL"))
             (fn (and pkg (find-symbol "DECODE" pkg))))
        (unless fn
          (error 'json-schema-error :message "load serdes-protocol to use :format"))
        (funcall fn source :format format))))

(defun table-from-source (source &key format)
  (let ((source (%maybe-decode source format)))
    (cond
      ;; JSON Schema boolean: true accepts all, false rejects all.
      ((eq source t) t)
      ((null source) nil)
      ((hash-table-p source) (stringify-json source))
      ((typep source 'json-schema-document) (json-schema-table source))
      ((or (stringp source) (listp source)) (stringify-json source))
      (t (error 'json-schema-error
                :message (format nil "cannot read JSON Schema from ~S" (type-of source)))))))

(defclass json-schema-document ()
  ((table :initarg :table :reader json-schema-table)
   (draft :initarg :draft :reader json-schema-draft :initform :draft-07))
  (:documentation "Parsed JSON Schema document (hash-table, string keys)."))

(defun json-schema-document-p (object)
  (typep object 'json-schema-document))

(defun parse-document (source &key draft format)
  "SOURCE (hash-table / plist / alist / string+format) → JSON-SCHEMA-DOCUMENT."
  (let ((table (table-from-source source :format format)))
    (make-instance 'json-schema-document
                   :table table
                   :draft (or draft (detect-draft table)))))
