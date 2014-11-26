import dofile from require "moonscript"
dofile "moon/tablex.moon"

describe "Test Table Utilities", (using nil) ->
	it "checks Count() compliance", (using nil) ->
		assert.equal(TableX.Count( {1, 3, "two", [{}]: 4} ), 4)
		assert.equal(TableX.Count( {} ), 0)

	it "checks IsEmpty() compliance", (using nil) ->
		assert.equal(TableX.IsEmpty( {} ), true)
		assert.equal(TableX.IsEmpty( { "one" } ), false)
		assert.equal(TableX.IsEmpty( {[{}]: "apple"} ), false)

	it "checks Empty() compliance", (using nil) ->
		t = {foo: "bar", 3.1415}
		assert.equal(TableX.Empty(t), t) -- Assert returns self
		assert.same(t, {})

	it "checks Copy() and CopyI() compliance", (using nil) ->
		t = {"hey", blah: 67, mango: "one"}
		assert.same(TableX.Copy(t), t)
		assert.same(TableX.CopyI(t), {"hey"})

		t = {"one", "two", {"buckle my shoe", "tie a rope"}}
		assert.same(t, TableX.Copy(t))
		assert.equal(t[3], TableX.Copy(t)[3]) -- Not deep
		assert.same(t, TableX.CopyI(t))
		assert.equal(t[3], TableX.CopyI(t)[3] ) -- Not deep

	it "checks DeepCopy() compliance", (using nil) ->
		t = {"hey", blah: 67, mango: "one"}
		assert.same(TableX.DeepCopy(t), t)

		t = {"one", "two", three: {"buckle my shoe", "tie a rope"}}
		assert.same(t, TableX.DeepCopy(t))
		assert.is_not.equals(t.three, TableX.DeepCopy(t).three) -- Deep

	InPlaceTester = (desired, fn, ... using nil) ->
		args = { ... }
		first = args[1]
		table.insert args, false
		new = fn(unpack(args))
		assert.same(new, desired)
		assert.is_not_equals(new, first)

		args[#args] = true
		new = fn(unpack(args))
		assert.same(new, desired)
		assert.equal(new, first)

	it "checks RemoveDuplicateValues() compliance", (using nil) ->
		InPlaceTester({"apple", "pear", "kiwi", "banana"}, TableX.RemoveDuplicateValues, {"apple", "pear", "kiwi", "apple", "banana", "pear", "pear"})
		InPlaceTester({}, TableX.RemoveDuplicateValues, {})
		InPlaceTester({"bob"}, TableX.RemoveDuplicateValues, {"bob"})

	it "checks Union*() compliance", (using nil) ->
		-- By Key
		t, u = {apple: "red", pear: "green", kiwi: "hairy"}, {apple: "green", pear: "green", banana: "yellow"}
		desired = {apple: "green", pear: "green", kiwi: "hairy", banana: "yellow"}

		assert.same(TableX.UnionByKeyI(t, u), {})
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

	it "checks Intersection*() compliance", (using nil) ->
		-- By Key
		t, u = {apple: "red", pear: "green", kiwi: "hairy"}, {apple: "green", pear: "green", banana: "yellow"}
		desired = {apple: "green", pear: "green"}

		assert.same(TableX.IntersectionByKeyI(t, u), {})
		InPlaceTester(desired, TableX.IntersectionByKey, t, u)

		-- Better test of IntersectionByKeyI
		t, u = {"apple", "pear", "kiwi"}, {"pear", "apple"}
		desired = {"pear", "apple"}
		InPlaceTester(desired, TableX.IntersectionByKeyI, t, u)

		-- By Value
		t, u = {"apple", "pear", "kiwi"}, {"pear", "apple", "banana"}
		desired = {"apple", "pear"}
		InPlaceTester(desired, TableX.IntersectionByValue, t, u)

		t, u = {"apple", "pear", "kiwi", "pear"}, {"pear", "apple", "banana", "apple"}
		InPlaceTester(desired, TableX.IntersectionByValue, t, u)

	it "checks Difference*() compliance", (using nil) ->
		-- By Key
		t, u = {apple: "red", pear: "green", kiwi: "hairy"}, {apple: "green", pear: "green", banana: "yellow"}
		desired = {kiwi: "hairy"}

		assert.same(TableX.DifferenceByKeyI(t, u), {})
		InPlaceTester(desired, TableX.DifferenceByKey, t, u)

		-- Better test of DifferenceByKeyI
		t, u = {"apple", "pear", "kiwi"}, {"pear", "apple"}
		desired = {[3]: "kiwi"}
		InPlaceTester(desired, TableX.DifferenceByKeyI, t, u)

		-- By Value
		t = {"apple", "pear", "kiwi"}
		desired = {"kiwi"}
		InPlaceTester(desired, TableX.DifferenceByValue, t, u)

		t, u = {"apple", "pear", "kiwi", "pear"}, {"pear", "apple", "banana", "apple"}
		InPlaceTester(desired, TableX.DifferenceByValue, t, u )

	it "checks Append() compliance", (using nil) ->
		t, u = {"apple", "banana", "kiwi"}, {"orange", "pear"}
		assert.same(TableX.Append(t, u), {"apple", "banana", "kiwi", "orange", "pear"})

	it "checks HasValue() compliance", (using nil) ->
		t = {apple: "red", pear: "green", kiwi: "hairy"}
		a, b = TableX.HasValue(t, "green")
		assert.equal(a, true)
		assert.equal(b, "pear")

		a, b = TableX.HasValue(t, "blue")
		assert.equal(a, false)
		assert.equal(b, nil)
		
	it "checks SetFromList() compliance", (using nil) ->
		assert.same(TableX.SetFromList({"apple", "banana", "kiwi", "pear"}), {apple: true, banana: true, kiwi: true, pear: true})
