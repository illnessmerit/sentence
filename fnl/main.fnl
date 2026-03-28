(local {: apply : comp : conj : cons : difference : juxt : snoc : zip}
       (require :core))

(local {: blank?} (require :nfnl.string))

(local {: ->set
        : butlast
        : dec
        : empty?
        : first
        : identity
        : inc
        : keys
        : last
        : map
        : mapcat
        : sort} (require :nfnl.core))

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

(fn find-sentence-ends [line]
  (-> (find-punctuated-ends line)
      (difference (find-honorific-ends line) (find-list-item-ends line))
      (conj (find-line-end line))
      keys
      sort))

(fn find-sentence-bounds [line]
  (if (blank? line)
      []
      (apply zip ((juxt (comp (partial map
                                       (comp dec #(string.find line "%S" $) inc))
                              (partial cons 0) butlast)
                        identity) (find-sentence-ends line)))))

{}
