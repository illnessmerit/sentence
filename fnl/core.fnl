(local {: ->set
        : butlast
        : complement
        : concat
        : empty?
        : first
        : identity
        : keys
        : last
        : map
        : merge
        : reduce
        : rest} (require :nfnl.core))

(fn snoc [xs x]
  (concat xs [x]))

(fn comp [...]
  (reduce (lambda [f g]
            (lambda [...]
              (f (g ...)))) identity [...]))

(fn disj [set* element]
  (let [set** (merge set*)]
    (tset set** element nil)
    set**))

(fn difference [set* ...]
  (reduce disj set* (keys (merge ...))))

(fn conj [set* element]
  (merge set* (->set [element])))

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

{: apply : comp : cons : conj : disj : difference : juxt : snoc : zip}
