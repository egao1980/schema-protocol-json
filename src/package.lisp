(defpackage #:schema-protocol-json.generated
  (:use))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (let ((pkg (find-package '#:schema-protocol)))
    (dolist (name '("SCHEMA-FORMAT-BACKEND" "REGISTER-SCHEMA-FORMAT"
                    "BACKEND-EMIT-SCHEMA" "BACKEND-PARSE-SCHEMA"))
      (export (intern name pkg) pkg))))

(defpackage #:schema-protocol-json
  (:use #:cl)
  (:nicknames #:stack-schema-json)
  (:import-from #:closer-mop
                #:ensure-class
                #:slot-definition-name
                #:slot-definition-type)
  (:import-from #:schema-protocol
                #:schema-of
                #:schema-slots
                #:schema-class
                #:schema-object
                #:schema-class-extra
                #:schema-extra-policy
                #:schema-class-key-style
                #:schema-class-computes
                #:schema-class-tag
                #:schema-error
                #:find-schema
                #:schema-slot
                #:schema-tag
                #:schema-variants
                #:variant-tag-values
                #:enum-of
                #:enum-members
                #:finalize-schema
                #:type-kind
                #:type-args
                #:sequence-element-type
                #:slot-is-required-p
                #:slot-wire-p
                #:slot-dump-p
                #:slot-wire-key
                #:slot-min-length
                #:slot-max-length
                #:slot-minimum
                #:slot-maximum
                #:slot-format
                #:slot-description
                #:style-key
                #:json-schema
                #:schema-format-backend
                #:register-schema-format
                #:backend-emit-schema
                #:backend-parse-schema
                #:schema-validation-error
                #:schema-validation-error-issues
                #:make-schema-issue
                #:schema-issue-path
                #:schema-issue-message)
  (:export #:json-schema-error
           #:json-schema-error-message
           #:json-schema-ref-error
           #:json-schema-ref-error-ref
           #:json-schema-document
           #:json-schema-document-p
           #:json-schema-table
           #:json-schema-draft
           #:parse-document
           #:emit
           #:compile-schema
           #:compile-validator
           #:validate-instance
           #:valid-instance-p
           #:json-schema-validator
           #:json-schema-validator-p
           #:json-schema-validation-error
           #:draft-uri))

(in-package #:schema-protocol-json)
