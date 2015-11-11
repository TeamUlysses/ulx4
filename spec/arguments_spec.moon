require "moonscript"

require "moon/tablex"
require "moon/utilx"
require "moon/arguments"

describe "Test Arguments", (using nil) ->
	it "Base Arg compliance", (using nil) ->
		a = Arg!
		assert.is_not_nil(a)

		a = Arg!
		assert.equals("<arg>", a\UsageShort!)

		a\Optional!
		assert.equals("[<arg: default nil>]", a\UsageShort!)

		a\Default(45)\Hint("arg2")
		assert.equals("[<arg2: default 45>]", a\UsageShort!)

		a\Help("this is an arg")

		assert.same({a\UsageShort!}, a\Completes!)
		assert.equals(
			"Type:     Arg\n" ..
			"Default:  45 (used if argument is unspecified)\n" ..
			"Hint:     arg2\n" ..
			"Help:     this is an arg", a\UsageLong!)

		assert.True(a\IsValid("apple"))
		assert.True(a\IsValid(nil))
		assert.False(Arg!\IsValid(nil))
		assert.equals("pear", a\Parse("pear"))
		assert.equals(45, a\Parse(nil))
		assert.True(a\IsPermissible(false))
		return


	it "NumArg compliance", (using nil) ->
		a = ArgNum!
		assert.equals("<number: x>", a\UsageShort!)

		a\Optional!
		assert.equals("[<number: x, default 0>]", a\UsageShort!)

		assert.error(-> a\Default("apple"))
		a\Default 41

		assert.same({a\UsageShort!}, a\Completes!)
		assert.equals(
			"Type:     ArgNum\n" ..
			"Default:  41 (used if argument is unspecified)\n" ..
			"Hint:     number\n" ..
			"Help:     A number argument", a\UsageLong!)

		assert.False(a\IsValid("apple"))
		assert.True(a\IsValid(nil))
		assert.False(ArgNum!\IsValid(nil))
		assert.nil(a\Parse("pear"))
		assert.equals(41, a\Parse(nil))
		assert.True(a\IsPermissible(false))
		return
