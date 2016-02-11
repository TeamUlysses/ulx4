require "tests/init"

describe "Argument Base", ->
	local Arg, ArgSet, Objects

	before_each ->
		Arg = ulx.Arg!
		ArgSet = ulx.Arg!\Default(123)\Optional!\Hint("my hint")\Help("my help")
		Objects = {123, {}, "hello world", ->}

	it "tests shortcut setters", ->
		assert.equals 123, ArgSet._Default
		assert.equals true, ArgSet._Optional
		assert.equals "my hint", ArgSet._Hint
		assert.equals "my help", ArgSet._Help

		ArgSet\Optional false
		assert.equals false, ArgSet._Optional

		ArgSet\Default nil
		assert.equals nil, ArgSet._Default
		return

	it "tests shortcut errors", ->
		assert.error -> Arg\Optional "apple"
		assert.error -> Arg\Optional {}
		assert.error -> Arg\Hint 41
		assert.error -> Arg\Help(->)
		return

	it "tests UsageShort", ->
		assert.equals "<arg>", Arg\UsageShort!
		assert.equals "[<my hint: default 123>]", ArgSet\UsageShort!
		return

	it "tests UsageLong", ->
		assert.equals [[
Type:     Arg
Hint:     arg
Help:     An arbitrary argument]], Arg\UsageLong!

		assert.equals [[
Type:     Arg
Default:  123 (used if argument is unspecified)
Hint:     my hint
Help:     my help]], ArgSet\UsageLong!
		return

	it "tests Completes", ->
		assert.equal Arg\UsageShort!, Arg\Completes![1]
		assert.equal ArgSet\UsageShort!, ArgSet\Completes![1]
		return

	it "tests IsValid", ->
		pending "determine what this needs to be first"
		return

	it "tests Parse", ->
		for object in *Objects
			assert.equal object, Arg\Parse(object), ArgSet\Parse(object)

		assert.equal nil, Arg\Parse!
		assert.equal 123, ArgSet\Parse!
		return

	it "tests IsPermissible", ->
		objects = {123, {}, "hello world", ->}
		for object in *Objects
			assert.True Arg\IsPermissible(object), ArgSet\IsPermissible(object)
		return

	it "tests Serialize", ->
		assert.equals "", Arg\Serialize!, ArgSet\Serialize!
		return

	it "tests Deserialize", ->
		assert.equals ulx.Arg, moon.type(ulx.Arg.Deserialize!)
		return



-- TODO, same as above for NumArg
	it "NumArg compliance", (using nil) ->
		a = ulx.ArgNum!
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
		assert.False(ulx.ArgNum!\IsValid(nil))
		assert.False(a\Parse("pear"))
		assert.same({true, 41}, {a\Parse(nil)})
		assert.True(a\IsPermissible(3))
		return
