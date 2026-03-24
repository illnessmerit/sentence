(local core (require :nfnl.core))

(fn cons [x xs]
  (core.concat [x] xs))

{}
