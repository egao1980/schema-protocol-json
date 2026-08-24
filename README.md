# schema-protocol-json

JSON Schema **parse / generate** for [`schema-protocol`](https://github.com/egao1980/schema-protocol) — the **json** format implementor.

Same slot later: `schema-protocol-xsd`, …

| System | Role | OCI |
|--------|------|-----|
| `schema-protocol-json` (`stack-schema-json`) | Draft-07 emit + load + compile → CLOS schema-class | **0.1.0** |

`schema-protocol` owns models / validate / dump. This package owns **JSON Schema documents**.

```lisp
(asdf:load-system "schema-protocol-json")

(stack-schema-json:emit 'user)
(stack-schema:json-schema 'user)   ; same, after this system is loaded

(let ((class (stack-schema-json:compile-schema
              '(:type "object"
                :required #("name")
                :additional-properties nil
                :properties (:name (:type "string"))))))
  (stack-schema:parse class '(:name "Ada")))
```

## Prior art

| Source | Take | Leave |
|--------|------|-------|
| **schema-protocol** | CLOS classes are the model | JSON Schema as authoring language |
| **Draft-07 / 2020-12** | `type` / `properties` / `$defs` / `anyOf` / `enum` | Full meta-schema, remote `$ref` |
| **fisxoj/json-schema** | — | Validate data *against* a document (different job) |
| **Pydantic** | `model_json_schema` checklist | Import-as-Python-class DX |

**Wave-1:** local `$ref` (`#/$defs/…`, `#/definitions/…`) only. `pattern` strings are ignored on compile (`schema-protocol` patterns are function designators). Tagged schemas emit OpenAPI `oneOf` + `discriminator`; compile rebuilds `:tag` + subclasses.

## License

MIT — see [LICENSE](LICENSE).
