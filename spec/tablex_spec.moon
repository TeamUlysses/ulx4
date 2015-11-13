unpack = unpack or table.unpack -- This gives us Lua 5.2 and 5.3 compatability
_G.ulx = _G.ulx or {}

require "moonscript"

require "moon/ulx/sh_tablex"
require "moon/ulx/sh_utilx"

tx = ulx.TableX -- Save typing

describe "Test Table Utilities", (using nil) ->
	it "Count() compliance", (using nil) ->
		assert.equal(4, tx.Count( {1, 3, "two", [{}]: 4} ))
		assert.equal(0, tx.Count( {} ))
		return


	it "IsEmpty() compliance", (using nil) ->
		assert.True(tx.IsEmpty( {} ))
		assert.False(tx.IsEmpty( { "one" } ))
		assert.False(tx.IsEmpty( {[{}]: "apple"} ))
		return


	it "Empty() compliance", (using nil) ->
		t = {foo: "bar", 3.1415}
		assert.equal(t, tx.Empty(t)) -- Assert returns self
		assert.same({}, t)
		return


	it "Copy*() compliance", (using nil) ->
		t = {"hey", blah: 67, mango: "one"}
		assert.same(t, tx.Copy(t))
		assert.same({"hey"}, tx.CopyI(t))

		t = {"one", "two", {"buckle my shoe", "tie a rope"}}
		assert.same(t, tx.Copy(t))
		assert.equal(t[3], tx.Copy(t)[3]) -- Not deep
		assert.same(t, tx.CopyI(t))
		assert.equal(t[3], tx.CopyI(t)[3] ) -- Not deep

		return


	it "DeepCopy() compliance", (using nil) ->
		t = {"hey", blah: 67, mango: "one"}
		assert.same(t, tx.DeepCopy(t))

		t = {"one", "two", three: {"buckle my shoe", "tie a rope"}}
		assert.same(t, tx.DeepCopy(t))
		assert.is_not.equals(t.three, tx.DeepCopy(t).three) -- Deep

		return


	InPlaceTester = (desired, fn, ... using nil) ->
		args = { ... }
		first = args[1]
		table.insert args, false
		new = fn(unpack(args))
		assert.same(desired, new)
		assert.is_not_equals(first, new)

		args[#args] = true
		new = fn(unpack(args))
		assert.same(desired, new)
		assert.equal(first, new)
		return


	it "RemoveDuplicateValues() compliance", (using nil) ->
		InPlaceTester({"apple", "pear", "kiwi", "banana"}, tx.RemoveDuplicateValues, {"apple", "pear", "kiwi", "apple", "banana", "pear", "pear"})
		InPlaceTester({}, tx.RemoveDuplicateValues, {})
		InPlaceTester({"bob"}, tx.RemoveDuplicateValues, {"bob"})
		return


	it "Union*() compliance", (using nil) ->
		-- By Key
		t, u = {apple: "red", pear: "green", kiwi: "hairy"}, {apple: "green", pear: "green", banana: "yellow"}
		desired = {apple: "green", pear: "green", kiwi: "hairy", banana: "yellow"}

		assert.same({}, tx.UnionByKeyI(t, u))
		InPlaceTester(desired, tx.UnionByKey, t, u)

		-- Better test of UnionByKeyI
		t, u = {"apple", "pear", "kiwi" }, { "pear", "apple", "banana"}
		desired = {"pear", "apple", "banana"}
		InPlaceTester(desired, tx.UnionByKeyI, t, u)

		-- By Value
		t = {"apple", "pear", "kiwi"}
		desired = {"apple", "pear", "kiwi", "banana"}
		InPlaceTester(desired, tx.Union, t, u)

		t, u = {"apple", "pear", "kiwi", "pear"}, {"pear", "apple", "banana", "apple"}
		desired = {"apple", "pear", "kiwi", "banana"}
		InPlaceTester(desired, tx.Union, t, u)

		return


	it "Intersection*() compliance", (using nil) ->
		-- By Key
		t, u = {apple: "red", pear: "green", kiwi: "hairy"}, {apple: "green", pear: "green", banana: "yellow"}
		desired = {apple: "green", pear: "green"}

		assert.same({}, tx.IntersectionByKeyI(t, u))
		assert.same(desired, tx.IntersectionByKey(t, u))

		-- Better test of IntersectionByKeyI
		t, u = {"apple", "pear", "kiwi"}, {"pear", "apple"}
		desired = {"pear", "apple"}
		assert.same(desired, tx.IntersectionByKeyI(t, u))

		-- By Value
		t, u = {"apple", "pear", "kiwi"}, {"pear", "apple", "banana"}
		desired = {"apple", "pear"}
		InPlaceTester(desired, tx.Intersection, t, u)

		t, u = {"apple", "pear", "kiwi", "pear"}, {"pear", "apple", "banana", "apple"}
		InPlaceTester(desired, tx.Intersection, t, u)

		return


	it "Difference*() compliance", (using nil) ->
		-- By Key
		t, u = {apple: "red", pear: "green", kiwi: "hairy"}, {apple: "green", pear: "green", banana: "yellow"}
		desired = {kiwi: "hairy"}

		assert.same({}, tx.DifferenceByKeyI(t, u))
		InPlaceTester(desired, tx.DifferenceByKey, t, u)

		-- Better test of DifferenceByKeyI
		t, u = {"apple", "pear", "kiwi"}, {"pear", "apple"}
		desired = {[3]: "kiwi"}
		InPlaceTester(desired, tx.DifferenceByKeyI, t, u)

		-- By Value
		t = {"apple", "pear", "kiwi"}
		desired = {"kiwi"}
		InPlaceTester(desired, tx.Difference, t, u)

		t, u = {"apple", "pear", "kiwi", "pear"}, {"pear", "apple", "banana", "apple"}
		InPlaceTester(desired, tx.Difference, t, u )

		return


	it "Append() compliance", (using nil) ->
		t, u = {"apple", "banana", "kiwi"}, {"orange", "pear"}
		assert.same({"apple", "banana", "kiwi", "orange", "pear"}, tx.Append(t, u))

		return


	it "HasValue*() compliance", (using nil) ->
		t = {apple: "red", pear: "green", kiwi: "hairy", "orange"}
		a, b = tx.HasValue(t, "green")
		assert.True(a)
		assert.equal("pear", b)

		a, b = tx.HasValue(t, "orange")
		assert.True(a)
		assert.equal(1, b)

		a, b = tx.HasValue(t, "blue")
		assert.False(a)
		assert.Nil(b)

		a, b = tx.HasValueI(t, "green")
		assert.False(a)
		assert.Nil(b)

		a, b = tx.HasValueI(t, "orange")
		assert.True(a)
		assert.equal(1, b)

		return


	it "SetFromList() compliance", (using nil) ->
		assert.same({apple: true, banana: true, kiwi: true, pear: true}, tx.SetFromList({"apple", "banana", "kiwi", "pear"}))
		return
