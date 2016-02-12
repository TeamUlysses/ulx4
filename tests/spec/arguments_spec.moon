require "tests/init"

describe "Argument Base", ->
	local Arg, ArgSet, Objects

	before_each ->
		Arg = ulx.Arg!
		ArgSet = ulx.Arg!\Default(123)\Optional!\Hint("my hint")\Help("my help")
		Objects = {123, {}, "hello world", ->, true}

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
		assert.equals Arg\UsageShort!, Arg\Completes![1]
		assert.equals ArgSet\UsageShort!, ArgSet\Completes![1]
		return

	it "tests IsValid", ->
		pending "determine what this needs to be first"
		return

	it "tests Parse", ->
		for object in *Objects
			assert.equals object, Arg\Parse(object), ArgSet\Parse(object)

		assert.equals nil, Arg\Parse!
		assert.equals 123, ArgSet\Parse!
		return

	it "tests IsPermissible", ->
		for object in *Objects
			assert.True Arg\IsPermissible(object), ArgSet\IsPermissible(object)
		return

	it "tests Serialize", ->
		assert.equals "", Arg\Serialize!, ArgSet\Serialize!
		return

	it "tests Deserialize", ->
		assert.equals ulx.Arg, moon.type(ulx.Arg.Deserialize!)
		return


describe "ArgNum", ->
	local ArgNum, ArgNumSet, Objects

	before_each ->
		ArgNum = ulx.ArgNum!
		ArgNumSet = ulx.ArgNum!\Default(12)\Optional!\Hint("my hint")\Help("my help")\Min(-10)\Max(20)\Round(1)

	it "tests shortcut setters", ->
		assert.equals -10, ArgNumSet._Min
		assert.equals 20, ArgNumSet._Max
		assert.equals 1, ArgNumSet._Round

		ArgNumSet\Default(nil)\Min(nil)\Max(nil)\Round(nil)
		assert.equals 0, ArgNumSet._Default
		assert.Nil ArgNumSet._Min, ArgNumSet._Max, ArgNumSet._Round
		return

	it "tests shortcut errors", ->
		assert.error -> ArgNum\Default "apple"
		assert.error -> ArgNum\Min {}
		assert.error -> ArgNum\Max(->)
		assert.error -> ArgNum\Round true
		return

	it "tests UsageShort", ->
		assert.equals "<number: x>", ArgNum\UsageShort!
		assert.equals "[<my hint: -10<=x<=20, default 12>]", ArgNumSet\UsageShort!
		return

	it "tests UsageLong", ->
		assert.equals [[
Type:     ArgNum
Hint:     number
Help:     A number argument]], ArgNum\UsageLong!

		assert.equals [[
Type:     ArgNum
Default:  12 (used if argument is unspecified)
Hint:     my hint
Help:     my help
Min:      -10
Max:      20
Round:    1]], ArgNumSet\UsageLong!
		return

	it "tests Completes", ->
		assert.equals ArgNum\UsageShort!, ArgNum\Completes![1]
		assert.equals ArgNumSet\UsageShort!, ArgNumSet\Completes![1]
		return

	it "tests IsValid", ->
		pending "determine what this needs to be first"
		return

	it "tests Parse", ->
		assert.same {true, nil}, {ArgNum\Parse!}
		assert.same {true, 12}, {ArgNumSet\Parse!}
		assert.same {true, 14}, {ArgNum\Parse("14")}, {ArgNumSet\Parse(14)}
		return

	it "tests Parse failure", ->
		assert.same {false, "Cannot parse 'true' to number"}, {ArgNum\Parse(true)}, {ArgNumSet\Parse(true)}

	it "tests IsPermissible", ->
		assert.True ArgNumSet\IsPermissible!
		assert.True ArgNum\IsPermissible(12), ArgNumSet\IsPermissible(12)
		assert.True ArgNum\IsPermissible(0), ArgNumSet\IsPermissible(0)
		return

	it "tests IsPermissible failure", ->
		assert.same {false, "Mandatory argument not specified"}, {ArgNum\IsPermissible!}
		assert.same {false, "Not a number (given 'hello')"}, {ArgNum\IsPermissible("hello")}, {ArgNumSet\IsPermissible("hello")}
		assert.same {false, "Below minimum (-10)"}, {ArgNumSet\IsPermissible(-11.1)}, {ArgNumSet\IsPermissible(-math.huge)}
		assert.same {false, "Above maximum (20)"}, {ArgNumSet\IsPermissible(20.0000001)}, {ArgNumSet\IsPermissible(math.huge)}
		return

	it "tests Serialize", ->
		assert.equals "", ArgNum\Serialize!
		assert.equals "-10:20", ArgNumSet\Serialize!
		assert.equals "-8.34:20", ArgNumSet\Min(-8.34)\Serialize!
		return

	it "tests Deserialize", ->
		blankArgNum = ulx.ArgNum.Deserialize("")
		assert.equals ulx.ArgNum, moon.type(blankArgNum)
		assert.Nil blankArgNum._Min, blankArgNum._Max

		minArgNum = ulx.ArgNum.Deserialize("13:")
		assert.equals 13, minArgNum._Min
		assert.Nil minArgNum._Max

		maxArgNum = ulx.ArgNum.Deserialize(":41")
		assert.Nil maxArgNum._Min
		assert.equals 41, maxArgNum._Max

		minMaxArgNum = ulx.ArgNum.Deserialize("37:38.5")
		assert.equals 37, minMaxArgNum._Min
		assert.equals 38.5, minMaxArgNum._Max

		equalArgNum1 = ulx.ArgNum.Deserialize("43:43")
		equalArgNum2 = ulx.ArgNum.Deserialize("43")
		assert.equals 43, equalArgNum1._Min, equalArgNum2._Min, equalArgNum1._Max, equalArgNum2._Max
		return
