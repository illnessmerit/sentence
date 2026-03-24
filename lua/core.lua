-- [nfnl] fnl/core.fnl
local core = require("nfnl.core")
local function cons(x, xs)
  return core.concat({x}, xs)
end
return {}
