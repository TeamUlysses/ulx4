require "tests/init"

describe "Test Language", (using nil) ->
	lang = ulx.Lang -- Save typing
	red = {r:255, g:000, b:000}
	green = {r:000, g:255, b:000}
	blue = {r:000, g:000, b:255}
	white = {r:255, g:255, b:255}
	black = {r:000, g:000, b:000}

	it "tests GetPhrase", (using nil) ->
		slap = lang.GetPhrase "SLAP"
		assert.string slap
		return

	it "tests GetMutatedPhrase", (using nil) ->
		slap = lang.GetMutatedPhrase "SLAP",
			INITIATOR: "AdminX"
			TARGETS: {"Alice", "Bob"}
			DAMAGE: 3
		assert.equals "AdminX slapped Alice and Bob for 3 damage", slap

		slap = lang.GetMutatedPhrase "SLAP",
			INITIATOR: "AdminX"
			TARGETS: {"Alice", "Bob", "Candy"}
			DAMAGE: 0
		assert.equals "AdminX slapped Alice, Bob and Candy", slap

		slap = lang.GetMutatedPhrase "SLAP",
			INITIATOR: "AdminX"
			TARGETS: {"Doug"}
			DAMAGE: nil
		assert.equals "AdminX slapped Doug", slap

		slap = lang.GetMutatedPhrase "SLAP_ANON",
			INITIATOR: "AdminX"
			TARGETS: {"Alice", "Bob"}
			DAMAGE: 3
		assert.equals "Alice and Bob were slapped for 3 damage", slap

		slap = lang.GetMutatedPhrase "SLAP_ANON",
			INITIATOR: "AdminX"
			TARGETS: {"Alice", "Bob", "Candy"}
			DAMAGE: 0
		assert.equals "Alice, Bob and Candy were slapped", slap

		slap = lang.GetMutatedPhrase "SLAP_ANON",
			INITIATOR: "AdminX"
			TARGETS: {"Doug"}
			DAMAGE: nil
		assert.equals "Doug was slapped", slap
		return

	it "tests GetColoredMutatedPhrase", (using nil) ->
		slap = lang.GetColoredMutatedPhrase "SLAP",
			INITIATOR: "AdminX"
			TARGETS: {"Alice", "Bob"}
			DAMAGE: 3
			COLOR_DEFAULT: nil
		expect = {"AdminX slapped Alice and Bob for 3 damage"}
		assert.same expect, slap

		slap = lang.GetColoredMutatedPhrase "SLAP",
			INITIATOR: "AdminX"
			TARGETS: {"Alice", "Bob"}
			DAMAGE: 3
			COLOR_DEFAULT: white
		expect = {
			white
			"AdminX slapped Alice and Bob for 3 damage"
		}
		assert.same expect, slap

		slap = lang.GetColoredMutatedPhrase "SLAP",
			INITIATOR: "AdminX"
			TARGETS: {"Alice", "Bob"}
			DAMAGE: 3
			COLOR_DEFAULT: white
			COLOR_DEFAULT_REPLACED: red
		expect = {
			red
			"AdminX"
			white
			" slapped "
			red
			"Alice and Bob for 3 damage"
		}
		assert.same expect, slap

		slap = lang.GetColoredMutatedPhrase "SLAP",
			INITIATOR: "AdminX"
			TARGETS: {"Alice", "Bob"}
			DAMAGE: 3
			COLOR_DEFAULT: white
			COLOR_DEFAULT_REPLACED: red
			COLOR_INITIATOR: green
		expect = {
			green
			"AdminX"
			white
			" slapped "
			red
			"Alice and Bob for 3 damage"
		}
		assert.same expect, slap

		slap = lang.GetColoredMutatedPhrase "SLAP",
			INITIATOR: "AdminX"
			TARGETS: {"Alice", "Bob"}
			DAMAGE: 3
			COLOR_DEFAULT: white
			COLOR_DEFAULT_REPLACED: red
			COLOR_INITIATOR: green
			COLOR_TARGETS: blue
			COLOR_DAMAGE: black
		expect = {
			green
			"AdminX"
			white
			" slapped "
			blue
			"Alice and Bob "
			black
			"for 3 damage"
		}
		assert.same expect, slap
		return

	return
