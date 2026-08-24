(in-package #:schema-protocol-json)

(define-condition json-schema-error (schema-error)
  ((message :initarg :message :reader json-schema-error-message :initform nil))
  (:report (lambda (c s)
             (format s "JSON Schema error~@[: ~A~]" (json-schema-error-message c)))))

(define-condition json-schema-ref-error (json-schema-error)
  ((ref :initarg :ref :reader json-schema-ref-error-ref))
  (:report (lambda (c s)
             (format s "Unresolved JSON Schema $ref ~S~@[: ~A~]"
                     (json-schema-ref-error-ref c)
                     (json-schema-error-message c)))))
