import dofile from require "moonscript"
dofile "moon/tablex.moon"
dofile "moon/utilx.moon"

describe "Test Table Utilities", (using nil) ->
	it "Count() compliance", (using nil) ->
		assert.equal(4, TableX.Count( {1, 3, "two", [{}]: 4} ))
		assert.equal(0, TableX.Count( {} ))
		return


	it "IsEmpty() compliance", (using nil) ->
		assert.True(TableX.IsEmpty( {} ))
		assert.False(TableX.IsEmpty( { "one" } ))
		assert.False(TableX.IsEmpty( {[{}]: "apple"} ))
		return


	it "Empty() compliance", (using nil) ->
		t = {foo: "bar", 3.1415}
		assert.equal(t, TableX.Empty(t)) -- Assert returns self
		assert.same({}, t)
		return


	it "Copy*() compliance", (using nil) ->
		t = {"hey", blah: 67, mango: "one"}
		assert.same(t, TableX.Copy(t))
		assert.same({"hey"}, TableX.CopyI(t))

		t = {"one", "two", {"buckle my shoe", "tie a rope"}}
		assert.same(t, TableX.Copy(t))
		assert.equal(t[3], TableX.Copy(t)[3]) -- Not deep
		assert.same(t, TableX.CopyI(t))
		assert.equal(t[3], TableX.CopyI(t)[3] ) -- Not deep

		return


	it "DeepCopy() compliance", (using nil) ->
		t = {"hey", blah: 67, mango: "one"}
		assert.same(t, TableX.DeepCopy(t))

		t = {"one", "two", three: {"buckle my shoe", "tie a rope"}}
		assert.same(t, TableX.DeepCopy(t))
		assert.is_not.equals(t.three, TableX.DeepCopy(t).three) -- Deep

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
		InPlaceTester({"apple", "pear", "kiwi", "banana"}, TableX.RemoveDuplicateValues, {"apple", "pear", "kiwi", "apple", "banana", "pear", "pear"})
		InPlaceTester({}, TableX.RemoveDuplicateValues, {})
		InPlaceTester({"bob"}, TableX.RemoveDuplicateValues, {"bob"})
		return


	it "Union*() compliance", (using nil) ->
		-- By Key
		t, u = {apple: "red", pear: "green", kiwi: "hairy"}, {apple: "green", pear: "green", banana: "yellow"}
		desired = {apple: "green", pear: "green", kiwi: "hairy", banana: "yellow"}

		assert.same({}, TableX.UnionByKeyI(t, u))
		InPlaceTester(desired, TableX.UnionByKey, t, u)

		-- Better test of UnionByKeyI
		t, u = {"apple", "pear", "kiwi" }, { "pear", "apple", "banana"}
		desired = {"pear", "apple", "banana"}
		InPlaceTester(desired, TableX.UnionByKeyI, t, u)

		-- By Value
		t = {"apple", "pear", "kiwi"}
		desired = {"apple", "pear", "kiwi", "banana"}
		InPlaceTester(desired, TableX.Union, t, u)

		t, u = {"apple", "pear", "kiwi", "pear"}, {"pear", "apple", "banana", "apple"}
		desired = {"apple", "pear", "kiwi", "banana"}
		InPlaceTester(desired, TableX.Union, t, u)

		return


	it "Intersection*() compliance", (using nil) ->
		-- By Key
		t, u = {apple: "red", pear: "green", kiwi: "hairy"}, {apple: "green", pear: "green", banana: "yellow"}
		desired = {apple: "green", pear: "green"}

		assert.same({}, TableX.IntersectionByKeyI(t, u))
		assert.same(desired, TableX.IntersectionByKey(t, u))

		-- Better test of IntersectionByKeyI
		t, u = {"apple", "pear", "kiwi"}, {"pear", "apple"}
		desired = {"pear", "apple"}
		assert.same(desired, TableX.IntersectionByKeyI(t, u))

		-- By Value
		t, u = {"apple", "pear", "kiwi"}, {"pear", "apple", "banana"}
		desired = {"apple", "pear"}
		InPlaceTester(desired, TableX.Intersection, t, u)

		t, u = {"apple", "pear", "kiwi", "pear"}, {"pear", "apple", "banana", "apple"}
		InPlaceTester(desired, TableX.Intersection, t, u)

		return


	it "Difference*() compliance", (using nil) ->
		-- By Key
		t, u = {apple: "red", pear: "green", kiwi: "hairy"}, {apple: "green", pear: "green", banana: "yellow"}
		desired = {kiwi: "hairy"}

		assert.same({}, TableX.DifferenceByKeyI(t, u))
		InPlaceTester(desired, TableX.DifferenceByKey, t, u)

		-- Better test of DifferenceByKeyI
		t, u = {"apple", "pear", "kiwi"}, {"pear", "apple"}
		desired = {[3]: "kiwi"}
		InPlaceTester(desired, TableX.DifferenceByKeyI, t, u)

		-- By Value
		t = {"apple", "pear", "kiwi"}
		desired = {"kiwi"}
		InPlaceTester(desired, TableX.Difference, t, u)

		t, u = {"apple", "pear", "kiwi", "pear"}, {"pear", "apple", "banana", "apple"}
		InPlaceTester(desired, TableX.Difference, t, u )

		return


	it "Append() compliance", (using nil) ->
		t, u = {"apple", "banana", "kiwi"}, {"orange", "pear"}
		assert.same({"apple", "banana", "kiwi", "orange", "pear"}, TableX.Append(t, u))

		return


	it "HasValue*() compliance", (using nil) ->
		t = {apple: "red", pear: "green", kiwi: "hairy", "orange"}
		a, b = TableX.HasValue(t, "green")
		assert.True(a)
		assert.equal("pear", b)

		a, b = TableX.HasValue(t, "orange")
		assert.True(a)
		assert.equal(1, b)

		a, b = TableX.HasValue(t, "blue")
		assert.False(a)
		assert.Nil(b)

		a, b = TableX.HasValueI(t, "green")
		assert.False(a)
		assert.Nil(b)

		a, b = TableX.HasValueI(t, "orange")
		assert.True(a)
		assert.equal(1, b)

		return


	it "SetFromList() compliance", (using nil) ->
		assert.same({apple: true, banana: true, kiwi: true, pear: true}, TableX.SetFromList({"apple", "banana", "kiwi", "pear"}))
		return
