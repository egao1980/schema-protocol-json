(in-package #:schema-protocol-json)

(defclass json-schema-backend (schema-format-backend) ()
  (:documentation "schema-protocol format backend for :json (JSON Schema)."))

(defmethod backend-emit-schema ((backend json-schema-backend) schema
                                &key (draft :draft-07) &allow-other-keys)
  (declare (ignore backend))
  (emit schema :draft draft))

(defmethod backend-parse-schema ((backend json-schema-backend) source
                                 &key name package draft format &allow-other-keys)
  (declare (ignore backend))
  (apply #'compile-schema source
         (append (when name (list :name name))
                 (when package (list :package package))
                 (when draft (list :draft draft))
                 (when format (list :format format)))))

(eval-when (:load-toplevel :execute)
  (register-schema-format :json (make-instance 'json-schema-backend)))

(defmethod json-schema ((schema symbol) &key (draft :draft-07))
  (emit schema :draft draft))

(defmethod json-schema ((schema standard-object) &key (draft :draft-07))
  (emit schema :draft draft))

(defmethod json-schema ((schema hash-table) &key (draft :draft-07))
  (emit schema :draft draft))

(defmethod json-schema ((schema json-schema-document) &key (draft :draft-07))
  (emit schema :draft draft))
