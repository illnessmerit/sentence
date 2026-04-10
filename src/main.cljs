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

(defn find-sentence-bounds*
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

(defn find-sentence-bounds
  [row]
  (promesa/let [buffer (.-nvim.buffer @state)
                lines (.getLines buffer (clj->js {:start row
                                                  :end (inc row)}))]
    (-> lines
        js->clj
        first
        find-sentence-bounds*)))

(defn seek-forward
  [row offset]
  (promesa/loop [row* row
                 offset* offset]
    (promesa/let [buffer (.-nvim.buffer @state)
                  length (.-length buffer)]
      (if (= length row*)
        nil
        (promesa/let [bounds (find-sentence-bounds row*)]
          (if (<= (count bounds) offset*)
            (promesa/recur (inc row*) (- offset* (count bounds)))
            (cons row* (nth bounds offset*))))))))

(defn seek-backward
  [row offset]
  (promesa/loop [row* row
                 offset* offset]
    (if (neg? row*)
      nil
      (promesa/let [bounds (find-sentence-bounds row*)]
        (if (<= (count bounds) offset*)
          (promesa/recur (dec row*) (- offset* (count bounds)))
          (cons row* (nth (reverse bounds) offset*)))))))

(defn get***
  [{:keys [offset pos]}]
  (promesa/let [bounds (find-sentence-bounds (first pos))
                offset* (+ offset (count-bounds (last pos) bounds))]
    (cond (<= (count bounds) offset*) (seek-forward (inc (first pos)) (- offset* (count bounds)))
          (< offset* 0) (seek-backward (dec (first pos)) (- 0 offset* (count bounds)))
          :else (cons (first pos) (nth bounds offset*)))))

(defn get**
  [opts]
  (promesa/let [window (.-nvim.window @state)
                cursor (.-cursor window)]
    (get*** (merge {:offset 0
                    :pos (transform FIRST dec (js->clj cursor))}
                   opts))))

(defn get*
  [args]
  (get** (let [args* (js->clj args :keywordize-keys true)]
           (if (zero? (count args*))
             {}
             (first args*)))))

(defn move-forward
  []
  (promesa/let [count* (.nvim.getVvar @state "count1")
                bounds (get** {:offset count*})]
    (when bounds
      (promesa/let [window (.-nvim.window @state)]
        (->> bounds
             (take 2)
             (transform FIRST inc)
             clj->js
             (set! (.-cursor window)))))))

(defn main
  [plugin]
  (reset! state plugin)
  (.registerFunction plugin "Get" get* (clj->js {:sync true}))
  (.registerFunction plugin "MoveForward" move-forward (clj->js {:sync true})))