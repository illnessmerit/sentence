(ns main)

(def state
  (atom nil))

(defn snoc
  [xs x]
  (concat xs [x]))

(defn find-all*
  [s pattern hits]
  (let [hit (.exec pattern s)]
    (if hit
      (find-all* s pattern (snoc hits [(.-index hit) (.-lastIndex pattern)]))
      hits)))

(defn find-all
  [s pattern]
  (find-all* s (js/RegExp. pattern "g") []))

(defn find-line-end
  [line]
  (.search line #"\S\s*$"))

(defn find-punctuated-ends [line]
  (set (map (comp dec dec last) (find-all line #"[.?!][)\]\"']*\s"))))

(defn main
  [plugin]
  (reset! state plugin)
  (.registerFunction plugin "Get" (fn [])))