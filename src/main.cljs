(ns main)

(def state
  (atom nil))

(defn main
  [plugin]
  (reset! state plugin)
  (.registerFunction plugin "Get" (fn [])))