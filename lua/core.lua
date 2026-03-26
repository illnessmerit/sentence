-- [nfnl] fnl/core.fnl
local _local_1_ = require("nfnl.core")
local concat = _local_1_.concat
local empty_3f = _local_1_["empty?"]
local first = _local_1_.first
local identity = _local_1_.identity
local inc = _local_1_.inc
local last = _local_1_.last
local map = _local_1_.map
local core = _local_1_
local function find_all_2a(s, pattern, hits)
  local hit = {string.find(s, pattern)}
  if empty_3f(hit) then
    return hits
  else
    local _2_
    if empty_3f(hits) then
      _2_ = identity
    else
      local partial_3_ = first(last(hits))
      local function _5_(...)
        return (partial_3_ + ...)
      end
      _2_ = _5_
    end
    return find_all_2a(string.sub(s, inc(first(hit))), pattern, concat(hits, {map(_2_, hit)}))
  end
end
local function find_all(s, pattern)
  return find_all_2a(s, pattern, {})
end
local function find_line_end(line)
  return first({string.find(line, "%S%s*$")})
end
return {}
