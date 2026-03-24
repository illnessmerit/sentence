-- [nfnl] fnl/core.fnl
local core = require("nfnl.core")
local function find_all_2a(s, pattern, hits)
  local hit = {string.find(s, pattern)}
  if core["empty?"](hit) then
    return hits
  else
    local _1_
    if core["empty?"](hits) then
      _1_ = core.identity
    else
      local partial_2_ = core.first(core.last(hits))
      local function _4_(...)
        return (partial_2_ + ...)
      end
      _1_ = _4_
    end
    return find_all_2a(string.sub(s, core.inc(core.first(hit))), pattern, core.concat(hits, {core.map(_1_, hit)}))
  end
end
local function find_all(s, pattern)
  return find_all_2a(s, pattern, {})
end
local function find_line_end(line)
  return core.first({string.find(line, "%S%s*$")})
end
return {}
