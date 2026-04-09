(ns main
  (:require
   [clojure.set :refer [difference]]
   [clojure.string :refer [blank?]]
   [com.rpl.specter :refer [FIRST transform]]
   [promesa.core :as promesa]))

(defn snoc
  [xs x]
  (concat xs [x]))

(defn find-all*
  [s query hits]
  (let [hit (.exec query s)]
    (if hit
      (find-all* s query (snoc hits [(.-index hit) (.-lastIndex query)]))
      hits)))

(defn find-all
  [s re]
  (find-all* s (js/RegExp. re "g") []))

(defn find-line-end
  [line]
  (inc (.search line #"\S\s*$")))

(defn find-punctuated-ends
  [line]
  (apply sorted-set-by < (map (comp dec
                                    last)
                              (find-all line #"[.?!][)\]\"']*\s"))))

(def honorifics
  [#"Mr\." #"Dr\." #"Mrs\." #"Ms\."])

(defn find-honorific-ends
  [line]
  (set (mapcat (comp (partial map last)
                     (partial find-all line))
               honorifics)))

(defn find-list-item-ends
  [line]
  (let [query (js/RegExp. #"^\s*\d+\." "g")]
    (if (.exec query line)
      #{(.-lastIndex query)}
      #{})))

(defn find-sentence-ends
  [line]
  (conj (difference (find-punctuated-ends line)
                    (find-honorific-ends line)
                    (find-list-item-ends line))
        (find-line-end line)))

(def zip
  (partial map vector))

(defn search
  [re s offset]
  (+ offset (.search (subs s offset) re)))

(defn find-sentence-bounds
  [line]
  (if (blank? line)
    []
    (let [ends (find-sentence-ends line)]
      (zip (->> ends
                drop-last
                (cons 0)
                (map (partial search #"\S" line)))
           ends))))

(defonce state
  (atom nil))

(defn count-bounds
  [column bounds]
  (count (take-while (comp (partial > column)
                           last)
                     bounds)))

(defn seek-forward
  [n])

(defn seek-backward
  [n])

(defn get**
  [{:keys [offset pos]}]
  (promesa/let [buffer (.-nvim.buffer @state)
                lines (.getLines buffer (clj->js {:start (first pos)
                                                  :end (inc (first pos))}))
                bounds (-> lines
                           js->clj
                           first
                           find-sentence-bounds)
                n (+ offset (count-bounds (last pos) bounds))]
    (cond (<= (count bounds) n) (seek-forward (- n (count bounds)))
          (< n 0) (seek-backward n)
          :else (nth bounds n))))

(defn get*
  [args]
  (promesa/let [args* (js->clj args :keywordize-keys true)
                window (.-nvim.window @state)
                cursor (.-cursor window)]
    (get** (merge {:offset 0
                   :pos (transform FIRST dec (js->clj cursor))}
                  (if (zero? (count args*))
                    {}
                    (first args*))))))

(defn main
  [plugin]
  (reset! state plugin)
  (.registerFunction plugin "Get" get*))