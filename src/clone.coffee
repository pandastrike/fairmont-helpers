import {identity} from "@pandastrike/garden"
import Method from "panda-generics"
import {
  isSymbol, isRegExp,
  isBuffer, isArrayBuffer, isTypedArray, isDataView,
  isMap, isArray, isObject, isSet,
  isBoolean, isDate, isNumber, isString,
  isFunction, isWeakMap, isError
} from "./type"

{create, define} = Method

clone = create
  name: "clone"
  description: "Creates a deep clone of an entity."
  # When no match, throw to alert that we cannot deliver a deep clone.
  default: (entity) ->
    throw new Error "clone: no match on entity #{JSON.stringify entity}"

define clone, isObject, (original) ->
  copy = new original.constructor()
  for key, value of original
    copy[clone key] = clone value
  copy


define clone, isArrayBuffer, (original) ->
  copy = new original.constructor original.byteLength
  new Uint8Array(copy).set new Uint8Array original
  copy

define clone, isTypedArray, (original) ->
  new original.constructor (clone original.buffer),
    original.byteOffset, original.length

define clone, isDataView, (original) ->
  new original.constructor (clone original.buffer),
    original.byteOffset, original.byteLength

# Only available within Node.js API. isBuffer will only match when Buffer is
# available on global. Otherwise, it returns false.
define clone, isBuffer, (original) ->
  Buffer.from original



cloneIterator = (original, add) ->
  copy = new original.constructor()
  add copy, entry for entry from original
  copy

define clone, isMap, (original) ->
  cloneIterator original, (copy, [key, value]) ->
    copy.set (clone key), (clone value)

define clone, isArray, (original) ->
  cloneIterator original, (copy, entry) -> copy.push clone entry

define clone, isSet, (original) ->
  cloneIterator original, (copy, entry) -> copy.add clone entry



isPrimitive = (x) -> (isBoolean x) || (isNumber x) || (isString x)

define clone, isPrimitive, identity

define clone, isDate, (original) ->
  new original.constructor original

define clone, isSymbol, (original) ->
  original.valueOf()

define clone, isRegExp, do (flags=/\w*$/) ->
  (original) ->
    copy = new original.constructor original.source, (flags.exec original)
    copy.lastIndex = original.lastIndex
    copy





define clone, isFunction, (original) ->
  throw new Error "clone: does not clone Function"

define clone, isWeakMap, (original) ->
  throw new Error "clone: does not clone WeakMap"

define clone, isError, (original) ->
  throw new Error "clone: does not clone Error"

export {clone}
