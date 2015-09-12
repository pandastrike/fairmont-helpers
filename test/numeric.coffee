assert = require "assert"
Amen = require "amen"

Amen.describe "Numeric functions", (context) ->

  {gt, lt, gte, lte, add, sub, mul, div, mod,
    even, odd, min, max, abs, pow} = require "../src/numeric"
  
  context.test "gt", -> assert gt 5, 6
  
  context.test "lt", -> assert lt 6, 5
  
  context.test "gte", ->
    assert gte 6, 6
    assert gte 1, 6
  
  context.test "lte", ->
    assert lte 6, 6
    assert lte 6, 1

  context.test "add", -> assert add 1, 3 == 4
  
  context.test "sub", -> assert sub 1, 3 == 2
  
  context.test "mul", -> assert mul(2, 4) == 8
  
  context.test "div", -> assert div(2, 4) == 2
  
  context.test "mod", -> assert mod -3, 4 == 1

  context.test "even", -> assert even 6

  context.test "odd", -> assert odd 5

  context.test "min", -> assert min(1, 5, 10) == 1

  context.test "max", -> assert max(1, 5, 10) == 10

  context.test "abs", -> assert abs(-5) == 5
  
  context.test "pow", -> assert pow 6, 2 == 36
  
  
