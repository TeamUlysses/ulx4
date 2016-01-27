require "spec/init"

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

		assert.equal 39*60,
			ux.TimeStringToSeconds("41m -3m 1m"),
			ux.TimeStringToSeconds("41minute  - 3minute 1 m")

		assert.equal 41*60*60,
			ux.TimeStringToSeconds("41h"),
			ux.TimeStringToSeconds("41 hours ")

		assert.equal 41*60*60 - 7*60,
			ux.TimeStringToSeconds("41h -7m"),
			ux.TimeStringToSeconds("41 hours -7 minutes")

		assert.equal 41*60*60*24,
			ux.TimeStringToSeconds("41 d"),
			ux.TimeStringToSeconds(" 41 day")

		assert.equal 41*60*60*24*7,
			ux.TimeStringToSeconds("41 w"),
			ux.TimeStringToSeconds("41weeks")

		assert.equal 41.5*60*60*24*7 - 11*60*60,
			ux.TimeStringToSeconds("41.5 w -  11h"),
			ux.TimeStringToSeconds("41.5weeks -11hours")

		assert.equal 3214991,
			ux.TimeStringToSeconds("1M7d5h3m11s"),
			ux.TimeStringToSeconds("1M 7d 5h 3m 11"),
			ux.TimeStringToSeconds(" 1M 7d 5h 3m 11"),
			ux.TimeStringToSeconds("1M 7d 5h 3m 11 "),
			ux.TimeStringToSeconds("1M, 7d, 5h, 3m 11s"),
			ux.TimeStringToSeconds("1M, 7d, 5h, 3m 11s "),
			ux.TimeStringToSeconds("1 month  7 days, 5h 3minute, 11 seconds"),
			ux.TimeStringToSeconds(" 1 month  7 days, 5h 3minute, 11 seconds ")

		assert.equal 60*60*24*365 - 6*60*60,
			ux.TimeStringToSeconds("1 year - 6 hours")

		assert.equal 60*60*24*365 - 6.5*60*60 + 5*60,
			ux.TimeStringToSeconds("1 year - 6.5 hours + 5 minutes")

		assert.equal 60*60*24*365 - 6*60*60 + 2*60,
			ux.TimeStringToSeconds("1 year - 6 hours + 5 minutes - 3 minutes")
		return


	it "Explode() compliance", (using nil) ->
		assert.same {"This", "is", "a", "sentence"},
			ux.Explode(" ", "This is a sentence")
		return


	it "SplitArgs() compliance", (using nil) ->
		assert.same {'This', 'is', 'a', 'Cool sentence to', 'make', 'split up'},
			ux.SplitArgs('This is a "Cool sentence to" make "split up"')
		return
