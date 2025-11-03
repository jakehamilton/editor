(fn import [module ?exposed]
  (assert-compile (or (list? ?exposed) (= nil ?exposed))
                  "Exposed imports must be specified as a list" ?exposed)
  (if (= nil ?exposed)
      `(require ,module)
      (let [bindings {}]
        (var i 1)
        (while (<= i (length ?exposed))
          (let [item (. ?exposed i)]
            (assert-compile (sym? item) "Exposed import names must be symbols"
                            item)
            (if (and (< i (length ?exposed))
                     (let [next-str (tostring (. ?exposed (+ i 1)))]
                       (or (= next-str :as) (= next-str ":as"))))
                (do
                  (assert-compile (<= (+ i 2) (length ?exposed))
                                  "Expected alias after :as" item)
                  (let [alias (. ?exposed (+ i 2))]
                    (assert-compile (sym? alias) "Alias must be a symbol" alias)
                    (tset bindings (tostring item) alias)
                    (set i (+ i 3))))
                (do
                  (tset bindings (tostring item) item)
                  (set i (+ i 1))))))
        `(local ,bindings (require ,module)))))

(fn import/macro [module ?exposed]
  (assert-compile (or (list? ?exposed) (= nil ?exposed))
                  "Exposed imports must be specified as a list" ?exposed)
  (if (= nil ?exposed)
      `(require ,module)
      (let [bindings {}]
        (var i 1)
        (while (<= i (length ?exposed))
          (let [item (. ?exposed i)]
            (assert-compile (sym? item) "Exposed import names must be symbols"
                            item)
            (if (and (< i (length ?exposed))
                     (let [next-str (tostring (. ?exposed (+ i 1)))]
                       (or (= next-str :as) (= next-str ":as"))))
                (do
                  (assert-compile (<= (+ i 2) (length ?exposed))
                                  "Expected alias after :as" item)
                  (let [alias (. ?exposed (+ i 2))]
                    (assert-compile (sym? alias) "Alias must be a symbol" alias)
                    (tset bindings (tostring item) alias)
                    (set i (+ i 3))))
                (do
                  (tset bindings (tostring item) item)
                  (set i (+ i 1))))))
        `(import-macros ,bindings ,module))))

(fn import/lua [module ?as ?alias]
  (assert-compile (or (and (= nil ?as) (= nil ?alias))
                      (and (= :as ?as) (not= nil ?alias)))
                  "An alias must be provided with :as." ?alias)
  (if (= nil ?as)
      (let [alias (string.match (tostring module) "([^.]+)$")]
        `(local ,(sym alias) (require ,module)))
      `(local ,?alias (require ,module))))

{: import : import/macro : import/lua}
