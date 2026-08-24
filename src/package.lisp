(defpackage #:schema-protocol-json.generated
  (:use))

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
                #:schema-class-key-style
                #:schema-class-computes
                #:schema-error
                #:find-schema
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
                #:json-schema)
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
           #:draft-uri))

(in-package #:schema-protocol-json)
