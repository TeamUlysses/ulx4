import dofile from require "moonscript"
dofile "moon/tablex.moon"
dofile "moon/utilx.moon"

describe "Test Utilities", (using nil) ->
	it "Round() compliance", (using nil) ->
		assert.equal(41, UtilX.Round(41.41))
		assert.equal(42, UtilX.Round(41.50, 0))
		assert.equal(41, UtilX.Round(41.499999999999, 0))
		assert.equal(410, UtilX.Round(414, -1))
		assert.equal(41.41, UtilX.Round(41.4099, 2))
		return


	it "CheckArg() compliance", (using nil) ->
		assert.True(UtilX.CheckArg(1, "test", "number", 41))
		assert.True(UtilX.CheckArg(2, "test", "string", "41"))
		assert.True(UtilX.CheckArg(3, "test", "table", {}))
		assert.True(UtilX.CheckArg(4, "test", "function", (() ->)))
		assert.True(UtilX.CheckArg(5, "test", "boolean", true))
		assert.True(UtilX.CheckArg(6, "test", "boolean", true))
		assert.True(UtilX.CheckArg(7, "test", "nil", nil))
		assert.True(UtilX.CheckArg(8, "test", UtilX, UtilX))
		assert.True(UtilX.CheckArg(9, "test", UtilX, UtilX!))
		assert.True(UtilX.CheckArg(10, "test", TableX, TableX))
		assert.error(-> UtilX.CheckArg(11, "test", UtilX, TableX))
		assert.error(-> UtilX.CheckArg(12, "test", UtilX, TableX!))
		return


	it "TimeStringToSeconds() compliance", (using nil) ->
		assert.equal 41,
			UtilX.TimeStringToSeconds(41),
			UtilX.TimeStringToSeconds("41"),
			UtilX.TimeStringToSeconds("41s"),
			UtilX.TimeStringToSeconds("41 second"),
			UtilX.TimeStringToSeconds("41 seconds")

		assert.equal 41*60,
			UtilX.TimeStringToSeconds("41 m"),
			UtilX.TimeStringToSeconds("41minute")

		assert.equal 41*60*60,
			UtilX.TimeStringToSeconds("41h"),
			UtilX.TimeStringToSeconds("41 hours ")

		assert.equal 41*60*60*24,
			UtilX.TimeStringToSeconds("41 d"),
			UtilX.TimeStringToSeconds(" 41 day")

		assert.equal 41*60*60*24*7,
			UtilX.TimeStringToSeconds("41 w"),
			UtilX.TimeStringToSeconds("41weeks")

		assert.equal 3252791,
			UtilX.TimeStringToSeconds("1M7d5h3m11s"),
			UtilX.TimeStringToSeconds("1M 7d 5h 3m 11"),
			UtilX.TimeStringToSeconds(" 1M 7d 5h 3m 11"),
			UtilX.TimeStringToSeconds("1M 7d 5h 3m 11 "),
			UtilX.TimeStringToSeconds("1M, 7d, 5h, 3m 11s"),
			UtilX.TimeStringToSeconds("1M, 7d, 5h, 3m 11s "),
			UtilX.TimeStringToSeconds("1 month  7 days, 5h 3minute, 11 seconds"),
			UtilX.TimeStringToSeconds(" 1 month  7 days, 5h 3minute, 11 seconds ")

		return
