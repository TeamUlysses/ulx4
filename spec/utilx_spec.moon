_G.ulx = _G.ulx or {}

require "moonscript"

require "moon/ulx/sh_tablex"
require "moon/ulx/sh_utilx"

tx = ulx.TableX -- Save us typing
ux = ulx.UtilX

describe "Test Utilities", (using nil) ->
	it "Round() compliance", (using nil) ->
		assert.equal(41, ux.Round(41.41))
		assert.equal(42, ux.Round(41.50, 0))
		assert.equal(41, ux.Round(41.499999999999, 0))
		assert.equal(410, ux.Round(414, -1))
		assert.equal(41.41, ux.Round(41.4099, 2))
		return


	it "CheckArg() basic compliance", (using nil) ->
		assert.True(ux.CheckArg("test", 1, "number", 41))
		assert.True(ux.CheckArg("test", 2, "string", "41"))
		assert.True(ux.CheckArg("test", 3, "table", {}))
		assert.True(ux.CheckArg("test", 4, "function", (() ->)))
		assert.True(ux.CheckArg("test", 5, "boolean", true))
		assert.True(ux.CheckArg("test", 6, "boolean", false))
		assert.True(ux.CheckArg("test", 7, "nil", nil))
		assert.True(ux.CheckArg("test", 8, ux, ux))
		assert.True(ux.CheckArg("test", 9, ux, ux!))
		assert.True(ux.CheckArg("test", 10, tx, tx))
		assert.error(-> ux.CheckArg("test", 11, ux, tx))
		assert.error(-> ux.CheckArg("test", 12, ux, tx!))
		return


	it "CheckArg() corner cases", (using nil) ->
		assert.True(ux.CheckArg())
		assert.True(ux.CheckArg("test"))
		assert.True(ux.CheckArg("test", 3))
		assert.True(ux.CheckArg("test", 4, "function", (() ->)))
		assert.True(ux.CheckArg(nil, 5, "boolean", true))
		assert.True(ux.CheckArg("test", nil, "boolean", false))
		assert.True(ux.CheckArg("test", 7, nil, "41"))
		assert.True(ux.CheckArg(nil, nil, ux, ux))
		assert.True(ux.CheckArg(nil, nil, nil, ux!))
		assert.True(ux.CheckArg(nil, 10, nil, tx))
		assert.error(-> ux.CheckArg("test", 11, ux, nil))
		assert.error(-> ux.CheckArg(nil, 12, "string", nil))
		assert.error(-> ux.CheckArg("test", nil, "string", 42))
		assert.error(-> ux.CheckArg(nil, nil, "table", true))
		return


	it "CheckArgs() compliance", (using nil) ->
		assert.True(ux.CheckArgs("test", {{"boolean", true}, {"string", "41"}}))
		assert.True(ux.CheckArgs("test", {{"number", 41},
		                                     {"string", "41"},
		                                     {"table", {}},
		                                     {"function", (() ->)},
		                                     {"boolean", true},
		                                     {"boolean", false},
		                                     {"nil", nil},
		                                     {ux, ux},
		                                     {ux, ux!},
		                                     {tx, tx}}))
		assert.error(-> ux.CheckArgs("test", {{ux, tx}}))
		assert.error(-> ux.CheckArgs("test", {{ux, tx!}}))
		return


	it "TimeStringToSeconds() compliance", (using nil) ->
		assert.equal 41,
			ux.TimeStringToSeconds(41),
			ux.TimeStringToSeconds("41"),
			ux.TimeStringToSeconds("41s"),
			ux.TimeStringToSeconds("41 second"),
			ux.TimeStringToSeconds("41 seconds")

		assert.equal 41*60,
			ux.TimeStringToSeconds("41 m"),
			ux.TimeStringToSeconds("41minute")

		assert.equal 41*60*60,
			ux.TimeStringToSeconds("41h"),
			ux.TimeStringToSeconds("41 hours ")

		assert.equal 41*60*60*24,
			ux.TimeStringToSeconds("41 d"),
			ux.TimeStringToSeconds(" 41 day")

		assert.equal 41*60*60*24*7,
			ux.TimeStringToSeconds("41 w"),
			ux.TimeStringToSeconds("41weeks")

		assert.equal 3252791,
			ux.TimeStringToSeconds("1M7d5h3m11s"),
			ux.TimeStringToSeconds("1M 7d 5h 3m 11"),
			ux.TimeStringToSeconds(" 1M 7d 5h 3m 11"),
			ux.TimeStringToSeconds("1M 7d 5h 3m 11 "),
			ux.TimeStringToSeconds("1M, 7d, 5h, 3m 11s"),
			ux.TimeStringToSeconds("1M, 7d, 5h, 3m 11s "),
			ux.TimeStringToSeconds("1 month  7 days, 5h 3minute, 11 seconds"),
			ux.TimeStringToSeconds(" 1 month  7 days, 5h 3minute, 11 seconds ")

		return
