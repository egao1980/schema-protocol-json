(defsystem "schema-protocol-json"
  :version "0.1.2"
  :description "JSON Schema parse/generate/validate for schema-protocol"
  :author "egao1980"
  :license "MIT"
  :depends-on ("schema-protocol" "closer-mop" "cl-ppcre")
  :properties (:cl-repo (:ci ()))
  :serial t
  :pathname "src"
  :components ((:file "package")
               (:file "conditions")
               (:file "document")
               (:file "emit")
               (:file "compile")
               (:file "validate")
               (:file "protocol"))
  :in-order-to ((test-op (test-op "schema-protocol-json/tests"))))

(defsystem "schema-protocol-json/tests"
  :depends-on ("schema-protocol-json" "rove")
  :pathname "tests"
  :serial t
  :components ((:file "package")
               (:file "json-schema-test")
               (:file "validate-test"))
  :perform (test-op (o c)
             (unless (symbol-call :rove :run c)
               (error "tests failed for ~A" (component-name c)))))
