(local {: ->set
        : concat
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
        : reduce} (require :nfnl.core))

(fn find-all* [s pattern hits]
  (let [hit [(string.find s pattern)]]
    (if (empty? hit)
        hits
        (find-all* (->> hit
                        first
                        inc
                        (string.sub s)) pattern
                   (concat hits [(map (if (empty? hits)
                                          identity
                                          (partial + (first (last hits))))
                                      hit)])))))

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

{}
