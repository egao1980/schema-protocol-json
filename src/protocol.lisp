(in-package #:schema-protocol-json)

(defmethod json-schema ((schema symbol) &key (draft :draft-07))
  (emit schema :draft draft))

(defmethod json-schema ((schema standard-object) &key (draft :draft-07))
  (emit schema :draft draft))

(defmethod json-schema ((schema hash-table) &key (draft :draft-07))
  (emit schema :draft draft))

(defmethod json-schema ((schema json-schema-document) &key (draft :draft-07))
  (emit schema :draft draft))
