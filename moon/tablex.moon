[=[
Class: TableX

A static class used for table-specific utility functions that are not specific to Garry's Mod.

Revisions:
	1.0.0 - Initial.
]=]
export class TableX
	[=[
	Function: Copy
	Make a shallow copy of a table. A shallow copy means that any subtables will still refer to the	same underlying table.

	Parameters:
		t - The *table* to make a copy of.

	Returns:
		The copied *table*.

	Notes:
		* Complexity is O(Count(t)).

	Revisions:
		1.0.0 - Initial.
	]=]
	@Copy: (t using nil) ->
		{ k, v for k, v in pairs t }


	[=[
	Function: CopyI
	Exactly the same as <Copy> except that it uses fori instead of pairs. 
	In general, this means that it only copies numeric keys. See <A Discussion On fori>.
	
	Revisions:
		1.0.0 - Initial.
	]=]
	@CopyI: (t using nil) ->
		[ v for v in *t ]

	[=[
	Function: DeepCopy
	Make a deep copy of a table. A deep copy means that any subtables will refer to a new copy of the original subtable.

	Parameters:
		t - The *table* to make a copy of. Must not have any cycles.

	Returns:
		The copied *table*.

	Revisions:
		1.0.0 - Initial.
	]=]
	@DeepCopy: (t using nil) ->
		{ k, (type(v) == "table" and DeepCopy(v) or v) for k, v in pairs t }

	InPlaceHelper = (t, inPlace using nil) ->
		if inPlace then return t
		Copy t

	InPlaceHelperI = (t, inPlace using nil) ->
		if inPlace then return t
		CopyI t 

	[=[
	Function: HasValue
	Checks for the presence of a value in a table.

	Parameters:
		t     - The *table* to check for the value's presence within.
		value - *Any type*, the value to check for within t.

	Returns:
		1 - A *boolean*. True if the table has the value, false otherwise.
		2 - A value of *any type*. The first key the value was found under if it was found, nil otherwise.

	Example:
		:HasValue( { apple="red", pear="green", kiwi="hairy" }, "green" )

		returns...

		:true, "pear"

	Revisions:
		1.0.0 - Initial.
	]=]
	@HasValue: (t, value using nil) ->
		for k, v in pairs t
			if v == value
				return true, k

		false, nil


	[=[
	Function: HasValueI
	Exactly the same as <HasValue> except that it uses fori instead of pairs.
	In general, this means that it only merges on numeric keys. See <A Discussion On fori>.
	
	Revisions:
		1.0.0 - Initial.
	]=]
	@HasValueI: (t, value using nil) ->
		for i=1, #t do
			if t[i] == value then
				return true, i

		false, nil
