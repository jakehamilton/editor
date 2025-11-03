(fn export [...]
  (let [items [...]
        bindings {}]
    (var i 1)
    (while (<= i (length items))
      (let [item (. items i)]
        (assert-compile (sym? item) "Export names must be symbols" item)
        (if (and (< i (length items))
                 (let [next-str (tostring (. items (+ i 1)))]
                   (or (= next-str :as) (= next-str ":as"))))
            (do
              (assert-compile (<= (+ i 2) (length items))
                              "Expected alias after :as" item)
              (let [alias (. items (+ i 2))]
                (assert-compile (sym? alias) "Alias must be a symbol" alias)
                (tset bindings (tostring alias) item)
                (set i (+ i 3))))
            (do
              (tset bindings (tostring item) item)
              (set i (+ i 1))))))
    bindings))

{: export}
