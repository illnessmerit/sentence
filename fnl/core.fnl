(local {: concat : empty? : first : identity : inc : last : map &as core}
       (require :nfnl.core))

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

{}
