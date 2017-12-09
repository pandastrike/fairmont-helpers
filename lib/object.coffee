import {identity, curry, negate} from "fairmont-core"
import {Method} from "fairmont-multimethods"
import {isObject, isArray, isFunction, isRegExp} from "./type"

property = curry (key, object) -> object[key]

bind = curry (f, x) -> f.bind x

detach = (f) -> curry (x, args...) -> f.apply x, args

properties = do ->
  defaults = enumerable: true, configurable: true
  (object, properties) ->
    for key, value of properties
      include value, defaults
      Object.defineProperty object, key, value

has = curry (p, x) -> x[p]?

keys = Object.keys

values = (x) -> v for k, v of x

pairs = (x) -> [k, v] for k, v of x

pick = curry (f, x) ->
  r = {}
  r[k] = v for k, v of x when f k, v
  r

omit = curry (f, x) -> pick (negate f), x

include = extend = (object, mixins...) -> Object.assign object, mixins...
merge = (objects...) -> Object.assign {}, objects...

# Trivial case: return the same value
clone = Method.create default: identity

# TODO: handle additional cases
# See Lodash implemention as a guide

Method.define clone, isObject, (original) ->
  copy = new original.constructor()
  # TODO: this doesn't clone non-enumerable properties
  for key of original
    copy[key] = (clone original[key])
  return copy

# adapted from lodash as an example
Method.define clone, isRegExp, do (flags=/\w*$/) ->
  (original) ->
    copy = new original.constructor original.source, (flags.exec original)
    copy.lastIndex = original.lastIndex
    copy

# “deep” comparison, when applicable
equal = Method.create default: (a, b) -> a == b

# can't use unique and cat from array b/c array
# depends on object (this file) for detach
cat = detach Array::concat
unique = (ax) -> Array.from new Set ax
Method.define equal, isObject, isObject, (a, b) ->
  (a == b) || do ->
    for key in (unique cat (keys a), (keys b))
      if ! equal a[key], b[key]
        return false
    true

Method.define equal, isArray, isArray, (ax, bx) ->
  (ax == bx) || do ->
    return false if ax.length != bx.length
    for i in [0..ax.length]
      if !equal ax[i], bx[i]
        return false
    true

query = curry (example, target) ->
  if (isObject example) && (isObject target)
    for k, v of example
      return false unless query v, target[k]
    return true
  else
    equal example, target

toJSON = (x, pretty = false) ->
  if pretty
    JSON.stringify x, null, 2
  else
    JSON.stringify x

fromJSON = JSON.parse

export {include, extend, merge, clone,
  equal, properties, property, bind, detach,
  has, keys, values, pairs, pick, omit, query,
  toJSON, fromJSON}