-- [nfnl] fnl/core.fnl
local _local_1_ = require("nfnl.core")
local __3eset = _local_1_["->set"]
local butlast = _local_1_.butlast
local complement = _local_1_.complement
local concat = _local_1_.concat
local empty_3f = _local_1_["empty?"]
local first = _local_1_.first
local identity = _local_1_.identity
local keys = _local_1_.keys
local last = _local_1_.last
local map = _local_1_.map
local merge = _local_1_.merge
local reduce = _local_1_.reduce
local rest = _local_1_.rest
local function snoc(xs, x)
  return concat(xs, {x})
end
local function comp(...)
  local function _2_(f, g)
    if (nil == g) then
      _G.error("Missing argument g on fnl/core.fnl:19", 2)
    else
    end
    if (nil == f) then
      _G.error("Missing argument f on fnl/core.fnl:19", 2)
    else
    end
    local function _5_(...)
      return f(g(...))
    end
    return _5_
  end
  return reduce(_2_, identity, {...})
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
  local function _8_(...)
    local xs = {...}
    if (nil == xs) then
      _G.error("Missing argument xs on fnl/core.fnl:54", 2)
    else
    end
    local function _10_(result, f)
      if (nil == f) then
        _G.error("Missing argument f on fnl/core.fnl:55", 2)
      else
      end
      if (nil == result) then
        _G.error("Missing argument result on fnl/core.fnl:55", 2)
      else
      end
      return snoc(result, apply(f, xs))
    end
    return reduce(_10_, {}, fs)
  end
  return _8_
end
return {apply = apply, comp = comp, cons = cons, conj = conj, disj = disj, difference = difference, juxt = juxt, snoc = snoc, zip = zip}
