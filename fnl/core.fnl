(local {: ->set
        : butlast
        : concat
        : complement
        : dec
        : empty?
        : first
        : identity
        : inc
        : keys
        : last
        : map
        : mapcat
        : merge
        : reduce
        : rest
        : sort} (require :nfnl.core))

(fn snoc [xs x]
  (concat xs [x]))

(fn find-all* [s pattern hits]
  (let [hit [(string.find s pattern
                          (if (empty? hits) 0
                              (-> hits
                                  last
                                  first
                                  inc)))]]
    (if (empty? hit)
        hits
        (find-all* s pattern (snoc hits hit)))))

(fn find-all [s pattern]
  (find-all* s pattern []))

(fn find-line-end [line]
  (first [(string.find line "%S%s*$")]))

(fn comp [...]
  (reduce (lambda [f g]
            (lambda [...]
              (f (g ...)))) identity [...]))

(fn find-punctuated-ends [line]
  (->set (map (comp dec last) (find-all line "[%.%?!][%)%]\"']*%s"))))

(local honorifics ["Mr%." "Dr%." "Mrs%." "Ms%."])

(fn find-honorific-ends [line]
  (->set (mapcat #(map last (find-all line $)) honorifics)))

(fn find-list-item-ends [line]
  (let [hit [(string.find line "^%s*%d+%.")]]
    (->set (if (empty? hit)
               []
               [(last hit)]))))

(fn disj [set* element]
  (let [set** (merge set*)]
    (tset set** element nil)
    set**))

(fn difference [set* ...]
  (reduce disj set* (keys (merge ...))))

(fn conj [set* element]
  (merge set* (->set [element])))

(fn find-sentence-ends [line]
  (-> (find-punctuated-ends line)
      (difference (find-honorific-ends line) (find-list-item-ends line))
      (conj (find-line-end line))
      keys
      sort))

(fn cons [x xs]
  (concat [x] xs))

(fn every? [f xs]
  (if (empty? xs) true
      (f (first xs)) (every? f (rest xs))
      false))

(fn zip* [xss result]
  (if (every? (complement empty?) xss)
      (zip* (map rest xss) (snoc result (map first xss)))
      result))

(fn zip [...]
  (zip* [...] []))

(fn apply [f & args]
  (f (unpack (concat (butlast args) (last args)))))

(fn juxt [& fs]
  (lambda [& xs]
    (reduce (lambda [result f]
              (snoc result (apply f xs))) [] fs)))

(fn find-sentence-bounds [line]
  (apply zip ((juxt (comp (partial map (comp #(string.find line "%S" $) inc))
                          (partial cons 0) butlast)
                    identity) (find-sentence-ends line))))

{}
