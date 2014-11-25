import dofile from require "moonscript"
dofile "moon/tablex.moon"
dofile "moon/utilx.moon"

describe "Test Utilities", ->
	it "checks Round() compliance", ->
		assert.equal(UtilX.Round(41.41), 41)
		assert.equal(UtilX.Round(41.50, 0), 42)
		assert.equal(UtilX.Round(41.499999999999, 0), 41)
		assert.equal(UtilX.Round(414, -1), 410)
		assert.equal(UtilX.Round(41.4099, 2), 41.41)
		return
		
	it "checks CheckArg() compliance", ->
		assert.True(UtilX.CheckArg(1, "test", "number", 41))
		assert.True(UtilX.CheckArg(2, "test", "string", "41"))
		assert.True(UtilX.CheckArg(3, "test", "table", {}))
		assert.True(UtilX.CheckArg(4, "test", "function", (() ->)))
		assert.True(UtilX.CheckArg(5, "test", UtilX, UtilX))
		assert.True(UtilX.CheckArg(6, "test", UtilX, UtilX!))
		assert.error(UtilX.CheckArg(5, "test", UtilX, TableX))
		assert.error(UtilX.CheckArg(5, "test", UtilX, TableX!))
		return
