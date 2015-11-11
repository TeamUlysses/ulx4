require "moonscript"

require "moon/tablex"
require "moon/utilx"
require "moon/arguments"

describe "Test Arguments", (using nil) ->
	it "Base Arg compliance", (using nil) ->
		a = Arg!
		assert.is_not_nil(a)

		a = with Arg!
			\Default(45)
			\Optional!
			\Hint("arg")
			\Help("this is an arg")

		assert.same({a\UsageShort!}, a\Completes!)
		assert.equals("[<arg: default 45>]", a\UsageShort!)
		assert.equals(
			"Type:     Arg\n" ..
			"Default:  45 (used if argument is unspecified)\n" ..
			"Hint:     arg\n" ..
			"Help:     this is an arg", a\UsageLong!)
		assert.error(-> a\IsValid!)
		assert.error(-> a\Parse!)
		assert.error(-> a\IsPermissible!)
		assert.error(-> a\Serialize!)
		assert.error(-> a\Deserialize!)
		return
