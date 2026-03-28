-- [nfnl] fnl/main.fnl
local _local_1_ = require("core")
local apply = _local_1_.apply
local comp = _local_1_.comp
local conj = _local_1_.conj
local cons = _local_1_.cons
local difference = _local_1_.difference
local juxt = _local_1_.juxt
local snoc = _local_1_.snoc
local zip = _local_1_.zip
local _local_2_ = require("nfnl.string")
local blank_3f = _local_2_["blank?"]
local _local_3_ = require("nfnl.core")
local __3eset = _local_3_["->set"]
local butlast = _local_3_.butlast
local dec = _local_3_.dec
local empty_3f = _local_3_["empty?"]
local first = _local_3_.first
local identity = _local_3_.identity
local inc = _local_3_.inc
local keys = _local_3_.keys
local last = _local_3_.last
local map = _local_3_.map
local mapcat = _local_3_.mapcat
local sort = _local_3_.sort
local function find_all_2a(s, pattern, hits)
  local hit
  local function _4_()
    if empty_3f(hits) then
      return 0
    else
      return inc(first(last(hits)))
    end
  end
  hit = {string.find(s, pattern, _4_())}
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
  local function _6_(_241)
    return map(last, find_all(line, _241))
  end
  return __3eset(mapcat(_6_, honorifics))
end
local function find_list_item_ends(line)
  local hit = {string.find(line, "^%s*%d+%.")}
  local function _7_()
    if empty_3f(hit) then
      return {}
    else
      return {last(hit)}
    end
  end
  return __3eset(_7_())
end
local function find_sentence_ends(line)
  return sort(keys(conj(difference(find_punctuated_ends(line), find_honorific_ends(line), find_list_item_ends(line)), find_line_end(line))))
end
local function find_sentence_bounds(line)
  if blank_3f(line) then
    return {}
  else
    local _9_
    do
      local partial_8_
      local function _10_(_241)
        return string.find(line, "%S", _241)
      end
      partial_8_ = comp(dec, _10_, inc)
      local function _11_(...)
        return map(partial_8_, ...)
      end
      _9_ = _11_
    end
    local function _12_(...)
      return cons(0, ...)
    end
    return apply(zip, juxt(comp(_9_, _12_, butlast), identity)(find_sentence_ends(line)))
  end
end
return {}
