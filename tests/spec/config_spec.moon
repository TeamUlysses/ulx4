require "tests/init"

ulx.Directory.CreateDirectory "data/ulx/config"

describe "Test Config", (using nil) ->
	before_each ->
		ulx.File.Delete "data/ulx/config/server.json.txt"
		
	it "tests basic loading", (using nil) ->
		c = ulx.Config "server"
		c\LoadAndUseDefaults
			Language: "english"

		assert.equals "english", c.Language
		return

	it "tests basic saving", (using nil) ->
		c = ulx.Config "server"
		c\LoadAndUseDefaults
			Language: "english"

		c.Language = "german"
		assert.equals "german", c.Language, c.Values.Language
		c\Save!

		c = ulx.Config "server"
		c\LoadAndUseDefaults
			Language: "english"
		assert.equals "german", c.Language, c.Values.Language

		ulx.File.Delete "data/ulx/config/server.json.txt"

		return

	return
