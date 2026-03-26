-- [nfnl] fnl/core.fnl
local _local_1_ = require("nfnl.core")
local __3eset = _local_1_["->set"]
local butlast = _local_1_.butlast
local concat = _local_1_.concat
local complement = _local_1_.complement
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
local rest = _local_1_.rest
local sort = _local_1_.sort
local function snoc(xs, x)
  return concat(xs, {x})
end
local function find_all_2a(s, pattern, hits)
  local hit
  local function _2_()
    if empty_3f(hits) then
      return 0
    else
      return inc(first(last(hits)))
    end
  end
  hit = {string.find(s, pattern, _2_())}
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
local function comp(...)
  local function _4_(f, g)
    if (nil == g) then
      _G.error("Missing argument g on fnl/core.fnl:40", 2)
    else
    end
    if (nil == f) then
      _G.error("Missing argument f on fnl/core.fnl:40", 2)
    else
    end
    local function _7_(...)
      return f(g(...))
    end
    return _7_
  end
  return reduce(_4_, identity, {...})
end
local function find_punctuated_ends(line)
  return __3eset(map(comp(dec, last), find_all(line, "[%.%?!][%)%]\"']*%s")))
end
local honorifics = {"Mr%.", "Dr%.", "Mrs%.", "Ms%."}
local function find_honorific_ends(line)
  local function _8_(_241)
    return map(last, find_all(line, _241))
  end
  return __3eset(mapcat(_8_, honorifics))
end
local function find_list_item_ends(line)
  local hit = {string.find(line, "^%s*%d+%.")}
  local function _9_()
    if empty_3f(hit) then
      return {}
    else
      return {last(hit)}
    end
  end
  return __3eset(_9_())
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
local function every_3f(f, xs)
  if empty_3f(xs) then
    return true
  elseif f(first(xs)) then
    return every_3f(f, rest(xs))
  else
    return false
  end
end
local function zip_2a(xss, result)
  if every_3f(complement(empty_3f), xss) then
    return zip_2a(map(rest, xss), snoc(result, map(first, xss)))
  else
    return result
  end
end
local function zip(...)
  return zip_2a({...}, {})
end
local function apply(f, ...)
  local args = {...}
  return f(unpack(concat(butlast(args), last(args))))
end
local function juxt(...)
  local fs = {...}
  local function _12_(...)
    local xs = {...}
    if (nil == xs) then
      _G.error("Missing argument xs on fnl/core.fnl:96", 2)
    else
    end
    local function _14_(result, f)
      if (nil == f) then
        _G.error("Missing argument f on fnl/core.fnl:97", 2)
      else
      end
      if (nil == result) then
        _G.error("Missing argument result on fnl/core.fnl:97", 2)
      else
      end
      return snoc(result, apply(f, xs))
    end
    return reduce(_14_, {}, fs)
  end
  return _12_
end
local function find_sentence_bounds(line)
  local _18_
  do
    local partial_17_
    local function _19_(_241)
      return string.find(line, "%S", _241)
    end
    partial_17_ = comp(_19_, inc)
    local function _20_(...)
      return map(partial_17_, ...)
    end
    _18_ = _20_
  end
  local function _21_(...)
    return cons(0, ...)
  end
  return apply(zip, juxt(comp(_18_, _21_, butlast), identity)(find_sentence_ends(line)))
end
return {}
