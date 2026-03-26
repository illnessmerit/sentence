-- [nfnl] fnl/core.fnl
local _local_1_ = require("nfnl.core")
local __3eset = _local_1_["->set"]
local concat = _local_1_.concat
local dec = _local_1_.dec
local empty_3f = _local_1_["empty?"]
local first = _local_1_.first
local identity = _local_1_.identity
local inc = _local_1_.inc
local keys = _local_1_.keys
local last = _local_1_.last
local map = _local_1_.map
local mapcat = _local_1_.mapcat
local merge = _local_1_.merge
local reduce = _local_1_.reduce
local sort = _local_1_.sort
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
local function comp(...)
  local function _8_(f, g)
    if (nil == g) then
      _G.error("Missing argument g on fnl/core.fnl:36", 2)
    else
    end
    if (nil == f) then
      _G.error("Missing argument f on fnl/core.fnl:36", 2)
    else
    end
    local function _11_(...)
      return f(g(...))
    end
    return _11_
  end
  return reduce(_8_, identity, {...})
end
local function find_punctuated_ends(line)
  return __3eset(map(comp(dec, last), find_all(line, "[%.%?!][%)%]\"']*%s")))
end
local honorifics = {"Mr%.", "Dr%.", "Mrs%.", "Ms%."}
local function find_honorific_ends(line)
  local function _12_(_241)
    return map(last, find_all(line, _241))
  end
  return __3eset(mapcat(_12_, honorifics))
end
local function find_list_item_ends(line)
  local hit = {string.find(line, "^%s*%d+%.")}
  local function _13_()
    if empty_3f(hit) then
      return {}
    else
      return {last(hit)}
    end
  end
  return __3eset(_13_())
end
local function disj(set_2a, element)
  local set_2a_2a = merge(set_2a)
  set_2a_2a[element] = nil
  return set_2a_2a
end
local function difference(set_2a, ...)
  return reduce(disj, set_2a, keys(merge(...)))
end
local function conj(set_2a, element)
  return merge(set_2a, __3eset({element}))
end
local function find_sentence_ends(line)
  return sort(keys(conj(difference(find_punctuated_ends(line), find_honorific_ends(line), find_list_item_ends(line)), find_line_end(line))))
end
local function cons(x, xs)
  return concat({x}, xs)
end
return {}
