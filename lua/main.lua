-- [nfnl] fnl/main.fnl
local _local_1_ = require("nfnl.core")
local __3eset = _local_1_["->set"]
local butlast = _local_1_.butlast
local dec = _local_1_.dec
local empty_3f = _local_1_["empty?"]
local first = _local_1_.first
local identity = _local_1_.identity
local inc = _local_1_.inc
local keys = _local_1_.keys
local last = _local_1_.last
local map = _local_1_.map
local mapcat = _local_1_.mapcat
local sort = _local_1_.sort
local _local_2_ = require("core")
local apply = _local_2_.apply
local comp = _local_2_.comp
local conj = _local_2_.conj
local cons = _local_2_.cons
local difference = _local_2_.difference
local juxt = _local_2_.juxt
local snoc = _local_2_.snoc
local zip = _local_2_.zip
local function find_all_2a(s, pattern, hits)
  local hit
  local function _3_()
    if empty_3f(hits) then
      return 0
    else
      return inc(first(last(hits)))
    end
  end
  hit = {string.find(s, pattern, _3_())}
  if empty_3f(hit) then
    return hits
  else
    return find_all_2a(s, pattern, snoc(hits, hit))
  end
end
local function find_all(s, pattern)
  return find_all_2a(s, pattern, {})
end
local function find_line_end(line)
  return first({string.find(line, "%S%s*$")})
end
local function find_punctuated_ends(line)
  return __3eset(map(comp(dec, last), find_all(line, "[%.%?!][%)%]\"']*%s")))
end
local honorifics = {"Mr%.", "Dr%.", "Mrs%.", "Ms%."}
local function find_honorific_ends(line)
  local function _5_(_241)
    return map(last, find_all(line, _241))
  end
  return __3eset(mapcat(_5_, honorifics))
end
local function find_list_item_ends(line)
  local hit = {string.find(line, "^%s*%d+%.")}
  local function _6_()
    if empty_3f(hit) then
      return {}
    else
      return {last(hit)}
    end
  end
  return __3eset(_6_())
end
local function find_sentence_ends(line)
  return sort(keys(conj(difference(find_punctuated_ends(line), find_honorific_ends(line), find_list_item_ends(line)), find_line_end(line))))
end
local function find_sentence_bounds(line)
  local _8_
  do
    local partial_7_
    local function _9_(_241)
      return string.find(line, "%S", _241)
    end
    partial_7_ = comp(dec, _9_, inc)
    local function _10_(...)
      return map(partial_7_, ...)
    end
    _8_ = _10_
  end
  local function _11_(...)
    return cons(0, ...)
  end
  return apply(zip, juxt(comp(_8_, _11_, butlast), identity)(find_sentence_ends(line)))
end
return {}
