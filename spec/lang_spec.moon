require "spec/init"

describe "Test Language", (using nil) ->
	lang = ulx.Lang -- Save typing

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

	return
