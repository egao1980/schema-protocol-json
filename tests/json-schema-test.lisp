(in-package #:schema-protocol-json/tests)

(defun %ht (&rest plist)
  (let ((ht (make-hash-table :test #'equal)))
    (loop for (k v) on plist by #'cddr
          do (setf (gethash k ht) v))
    ht))

(deftest emit-object
  (defschema %js-addr ()
    (city string))
  (defschema %js-user ()
    (name string :min-length 1)
    (age integer :minimum 0 :optional t)
    (address %js-addr)
    (tags (vector string))
    (:compute label (self)
      (slot-value self 'name))
    (:extra :forbid))
  (let ((js (emit '%js-user)))
    (ok (equal "object" (gethash "type" js)))
    (ok (equal "http://json-schema.org/draft-07/schema#" (gethash "$schema" js)))
    (ok (equalp #("name" "address" "tags") (gethash "required" js)))
    (ok (eq nil (gethash "additionalProperties" js)))
    (let ((props (gethash "properties" js)))
      (ok (equal "string" (gethash "type" (gethash "name" props))))
      (ok (= 1 (gethash "minLength" (gethash "name" props))))
      (ok (equal "#/$defs/%js-addr" (gethash "$ref" (gethash "address" props))))
      (ok (eq t (gethash "readOnly" (gethash "label" props)))))
    (ok (hash-table-p (gethash "%js-addr" (gethash "$defs" js))))
    (ok (hash-table-p (json-schema '%js-user)))))

(deftest emit-union-enum
  (defschema %js-opt ()
    (color (member :red :blue))
    (note (or :null string) :optional t))
  (let* ((js (emit '%js-opt))
         (props (gethash "properties" js)))
    (ok (equalp #(:red :blue) (gethash "enum" (gethash "color" props))))
    (ok (vectorp (gethash "anyOf" (gethash "note" props))))))

(deftest compile-and-parse
  (let* ((doc (%ht "type" "object"
                   "additionalProperties" nil
                   "required" #("name")
                   "properties" (%ht "name" (%ht "type" "string" "minLength" 1)
                                     "age" (%ht "type" "integer" "minimum" 0))))
         (class (compile-schema doc :name 'compiled-person))
         (obj (schema-protocol:parse class (%ht "name" "Ada" "age" 36))))
    (ok (equal "Ada" (slot-value obj (intern "NAME" (symbol-package (class-name class))))))
    (ok (signals (schema-protocol:parse class (%ht "age" 1))
                 'schema-validation-error))
    (ok (signals (schema-protocol:parse class (%ht "name" "Ada" "x" 1))
                 'schema-validation-error))))

(deftest emit-compile-roundtrip
  (defschema %rt-note ()
    (title string)
    (body (or :null string) :optional t)
    (:extra :forbid))
  (let* ((js (emit '%rt-note))
         (class (compile-schema js :name 'rt-note))
         (obj (schema-protocol:parse class (%ht "title" "hi" "body" :null))))
    (ok (equal "hi" (slot-value obj (intern "TITLE" (symbol-package (class-name class))))))
    (ok (eq :null (slot-value obj (intern "BODY" (symbol-package (class-name class))))))))

(deftest parse-document-and-ref
  (let* ((addr (%ht "type" "object"
                    "properties" (%ht "city" (%ht "type" "string"))
                    "required" #("city")
                    "additionalProperties" nil))
         (doc (%ht "type" "object"
                   "$defs" (%ht "addr" addr)
                   "properties" (%ht "home" (%ht "$ref" "#/$defs/addr"))
                   "required" #("home")
                   "additionalProperties" nil))
         (parsed (parse-document doc))
         (class (compile-schema parsed :name 'has-home))
         (obj (schema-protocol:parse class
                                     (%ht "home" (%ht "city" "London")))))
    (ok (json-schema-document-p parsed))
    (ok (equal "object" (gethash "type" (json-schema-table parsed))))
    (let ((home (slot-value obj (intern "HOME" (symbol-package (class-name class))))))
      (ok (equal "London" (slot-value home (intern "CITY" (symbol-package (class-name (class-of home))))))))))
