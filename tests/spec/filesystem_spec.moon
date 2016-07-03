require "tests/init"

describe "Tests filesystem functions", (using nil) ->

	it "tests ulx.Path.GetFileNameWithoutExtension", (using nil) ->
		fn = ulx.Path.GetFileNameWithoutExtension
		assert.equal "", fn("")
		assert.equal "", fn("/c/some/dir/")
		assert.equal "bob", fn("bob")
		assert.equal "Alice", fn("Alice.txt")
		assert.equal "george", fn("/c/some/dir/george.txt")
		return

	return
