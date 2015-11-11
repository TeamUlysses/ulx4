unpack = unpack or table.unpack -- This gives us Lua 5.2 and 5.3 compatability

[=[
Class: TableX

A static class used for table-specific utility functions that are not specific to Garry's Mod.

Revisions:
	1.0.0 - Initial.
]=]
export class TableX
	[=[
	Function: Count
	Counts the number of elements in a table using pairs.

	Parameters:
		t - The *table* to count.

	Returns:
		The *number* of elements in the table.

	Example:
		:Count( { "apple", "pear", done=true, banana="yellow" } )

		returns...

		:4

	Notes:
		* This is slow and should be avoided if at all possible.
		* Use the '#' operator instead of this if the table only contains numeric indices or if you only care about the numeric indices.
		* Use <IsEmpty> instead of this if you only want to see if a hash table has any values.
		* Complexity is O(n), where n is the number of values in t.

	Revisions:
		1.0.0 - Initial.
	]=]
	@Count: (t using nil) ->
		c = 0
		for v in pairs t
			c += 1

		c


	[=[
	Function: IsEmpty
	Checks if a table contains any values on any type of key.

	Parameters:
		t - The *table* to check.

	Returns:
		A *boolean*, true if the table t has one or more values, false otherwise.

	Notes:
		* This is much faster than <Count> for checking if a table has any elements.
		* Complexity is O(1).

	Revisions:
		1.0.0 - Initial.
	]=]
	@IsEmpty: (t using nil) ->
		next(t) == nil


	[=[
	Function: Empty
	Removes all data from a table.

	Parameters:
		t - The *table* to empty.

	Returns:
		The *table* t.

	Notes:
		* Complexity is O(Count(t)).

	Revisions:
		1.0.0 - Initial.
	]=]
	@Empty: (t using nil) ->
		for k, v in pairs t
			t[ k ] = nil

		t


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
		{ k, (type(v) == "table" and self.DeepCopy(v) or v) for k, v in pairs t }


	InPlaceHelper = (t, inPlace using nil) ->
		if inPlace then return t
		self.Copy t


	InPlaceHelperI = (t, inPlace using nil) ->
		if inPlace then return t
		self.CopyI t


	[=[
	Function: RemoveDuplicateValues
	Removes any duplicate values from a list.

	Parameters:
		list    - The *list* to remove duplicates from.
		inPlace - An *optional boolean*, defaults to _false_. If true, all operations occur on list itself, rather than a copy.

	Returns:
		The *list* that was passed in with duplicates removed. Returns the original table reference if in_place is true, a new table otherwise.

	Example:
		:RemoveDuplicateValues( { "apple", "pear", "kiwi", "apple", "banana", "pear", "pear" } )

		returns...
		:{ "apple", "pear", "kiwi", "banana" }

	Notes:
		* This function operates over numeric indices. See <A Discussion On fori>.
		* Complexity is around O(#list * log( #list )).
		* Duplicates are removed after the first value occurs. See example above.

	Revisions:
		1.0.0 - Initial.
	]=]
	@RemoveDuplicateValues: (list, inPlace using nil) ->
		list = InPlaceHelperI list, inPlace

		i = 2
		while i <= #list
			v = list[ i ]
			for j=1, i-1
				if list[j] == v
					table.remove list, i
					i -= 1 -- Since we removed it and it will be incremented below otherwise
					break
			i += 1

		list


	[=[
	Function: UnionByKey
	Merges two tables by key.

	Parameters:
		tableA  - The first *table* in the union.
		tableB  - The second *table* in the union.
		inPlace - An *optional boolean*, defaults to _false_. If true, all operations occur on tableA itself, rather than a copy.

	Returns:
		The union *table*. Returns tableA if inPlace is true, a new table otherwise.

	Example:
		:UnionByKey( { apple="red", pear="green", kiwi="hairy" },
		:            { apple="green", pear="green", banana="yellow" } )

		returns...

		:{ apple="green", pear="green", kiwi="hairy", banana="yellow" }

	Notes:
		* If both tables have values on the same key, tableB takes precedence.
		* Complexity is O(Count(tableB)).

	Revisions:
		1.0.0 - Initial.
	]=]
	@UnionByKey: (tableA, tableB, inPlace using nil) ->
		tableA = InPlaceHelper tableA, inPlace

		for k, v in pairs tableB
			tableA[k] = v

		tableA


	[=[
	Function: UnionByKeyI
	Exactly the same as <UnionByKey> except that it uses fori instead of pairs. In general, this
	means that it only merges on numeric keys. See <A Discussion On fori>.

	Revisions:
		1.0.0 - Initial.
	]=]
	@UnionByKeyI: (tableA, tableB, inPlace using nil) ->
		tableA = InPlaceHelperI tableA, inPlace

		for i=1, #tableB do
			if tableB[i] ~= nil
				tableA[i] = tableB[i]

		tableA


	[=[
	Function: Union
	Gets the union of two lists by value. If a value occurs once in listA and once in listB, the result of the union will only have one instance of that value as well.

	Parameters:
		listA - The first *list* in the union.
		listB - The second *list* in the union.
		inPlace - An *optional boolean*, defaults to _false_. If true, all operations occur on tableA itself, rather than a copy.

	Returns:
		The union *list*. Returns tableA if inPlace is true, a new table otherwise.

	Example:
		:Union( { "apple", "pear", "kiwi" }, { "pear", "apple", "banana" } )

		returns...

		:{ "apple", "pear", "kiwi", "banana" }

	Notes:
		* This function operates over numeric indices. See <A Discussion On fori>.
		* The elements that in the returned table are in the same order they were in tableA and then tableB. See example above.
		* This function properly handles duplicate values in either list. All values will be unique in the resulting list.
		* Complexity is O( (#listA + #listB) * log( (#listA + #listB) ) )
		* You might want to consider using <SetFromList> combined with <UnionByKey> for large tables or if you plan on doing this often.

	Revisions:
		1.0.0 - Initial.
	]=]
	@Union: (listA, listB, inPlace using nil) ->
		listA = self.Append listA, listB, inPlace
		self.RemoveDuplicateValues listA, true


	[=[
	Function: IntersectionByKey

	Gets the intersection of two tables by key.

	Parameters:
		tableA - The first *table* in the intersection.
		tableB - The second *table* in the intersection.

	Returns:
		The intersection *table*.

	Example:
		:IntersectionByKey( { apple="red", pear="green", kiwi="hairy" },
		:                   { apple="green", pear="green", banana="yellow" } )

		returns...

		:{ apple="green", pear="green" }

	Notes:
		* If both tables have values on the same key, tableB takes precedence.
		* Complexity is O(Count(tableA)).

	Revisions:
		1.0.0 - Initial.
	]=]
	@IntersectionByKey: (tableA, tableB using nil) ->
		result = {}

		-- Now just fill in each value with whatever the value in tableB is. This takes care of both
		-- elimination and making tableB take precedence when both tables have a value on key k.
		for k, v in pairs tableA
			result[k] = tableB[k]

		result


	[=[
	Function: IntersectionByKeyI
	Exactly the same as <IntersectionByKey> except that it uses fori instead of pairs. In
	general, this means that it only merges on numeric keys. See <A Discussion On fori>.

	Revisions:
		1.0.0 - Initial.
	]=]
	@IntersectionByKeyI: (tableA, tableB using nil) ->
		result = {}

		-- Now just fill in each value with whatever the value in tableB is. This takes care of both
		-- elimination and making tableB take precedence when both tables have a value on key i.
		for i=1, #tableA
			if tableA[i] ~= nil
				result[i] = tableB[i]

		result


	[=[
	Function: Intersection
	Gets the intersection of two lists by value.

	Parameters:
		listA - The first *list* in the intersection.
		listB - The second *list* in the intersection.
		inPlace - An *optional boolean*, defaults to _false_. If true, all operations occur on listA itself, rather than a copy.

	Returns:
		The intersection *list*. Returns tableA if inPlace is true, a new table otherwise.

	Example:
		:Intersection( { "apple", "pear", "kiwi" }, { "pear", "apple", "banana" } )

	returns...
		:{ "apple", "pear" }

	Notes:
		* This function operates over numeric indices. See <A Discussion On fori>.
		* The elements that are left in the returned table are in the same order they were in listA. See example above.
		* This function properly handles duplicate values in either list. All values will be unique in the resulting list.
		* Complexity is O(#ListA * #ListB).
		* You might want to consider using <SetFromList> combined with <IntersectionByKey> for large tables or if you plan on doing this often.

	Revisions:
		1.0.0 - Initial.
	]=]
	@Intersection: (listA, listB, inPlace using nil) ->
		listA = self.RemoveDuplicateValues listA, inPlace

		i = 1
		while i <= #listA
			if self.HasValueI listB, listA[i]
				i += 1
			else
				table.remove listA, i

		listA


	[=[
	Function: DifferenceByKey
	Gets the difference of two tables by key. Difference is defined as all the keys in table A that are not in table B.

	Parameters:
		tableA - The first *table* in the difference.
		tableB - The second *table* in the difference.
		inPlace - An *optional boolean*, defaults to _false_. If true, all operations occur on tableA itself, rather than a copy.

	Returns:
		The difference *table*. Returns tableA if inPlace is true, a new table otherwise.

	Example:
		:DifferenceByKey( { apple="red", pear="green", kiwi="hairy" },
		:                 { apple="green", pear="green", banana="yellow" } )

		returns...

		:{ kiwi="hairy" }

	Notes:
		* Complexity is O(Count(tableB)).

	Revisions:
		1.0.0 - Initial.
	]=]
	@DifferenceByKey: (tableA, tableB, inPlace using nil) ->
		tableA = InPlaceHelper tableA, inPlace

		for k, v in pairs tableB
			tableA[k] = nil

		tableA


	[=[
	Function: DifferenceByKeyI
	Exactly the same as <DifferenceByKey> except that it uses fori instead of pairs. In general,
	this means that it only performs the difference on numeric keys. See <A Discussion On fori>.

	Revisions:
		1.0.0 - Initial.
	]=]
	@DifferenceByKeyI: (tableA, tableB, inPlace using nil) ->
		tableA = InPlaceHelperI tableA, inPlace

		for i=1, #tableB
			if tableB[i] ~= nil
				tableA[i] = nil

		tableA


	[=[
	Function: Difference
	Gets the difference of two lists by value.

	Parameters:
		listA - The first *list* in the difference.
		listB - The second *list* in the difference.
		inPlace - An *optional boolean*, defaults to _false_. If true, all operations occur on tableA itself, rather than a copy.

	Returns:
		The difference *list*. Returns tableA if inPlace is true, a new table otherwise.

	Example:
		:Difference( { "apple", "pear", "kiwi" }, { "pear", "apple", "banana" } )

		returns...

		:{ "kiwi" }

	Notes:
		* This function operates over numeric indices. See <A Discussion On fori>.
		* The elements that are left in the returned table are in the same order they were in tableA. See example above.
		* This function properly handles duplicate values in either list. All values will be unique in the resulting list.
		* Complexity is O(#listA * #listB).
		* You might want to consider using <SetFromList> combined with <DifferenceByKey> for large tables or if you plan on doing this often.

	Revisions:
		1.0.0 - Initial.
	]=]
	@Difference: (listA, listB, inPlace using nil) ->
		listA = self.RemoveDuplicateValues listA, inPlace

		for v in *listB
			hasValue, indexValue = self.HasValueI listA, v
			if hasValue
				table.remove listA, indexValue

		listA


	[=[
	Function: Append
	Appends values with numeric keys from one table to another.

	Parameters:
		listA - The first *list* in the append.
		listB - The second *list* in the append.
		inPlace - An *optional boolean*, defaults to _false_. If true, all operations occur on tableA itself, rather than a copy.

	Returns:
		The *list* result of appending tableB to tableA. Returns tableA if inPlace is true, a new table otherwise.

	Example:
		:Append( { "apple", "banana", "apple", "kiwi" },
		:        { "orange", "pear", "apple" } )

		returns...

		:{ "apple", "banana", "apple", "kiwi", "orange", "pear", "apple" }

	Notes:
		* This function uses fori. See <A Discussion On fori>.
		* Complexity is O(#listB).

	Revisions:
		1.0.0 - Initial.
	]=]
	@Append: (listA, listB, inPlace using nil) ->
		listA = InPlaceHelperI listA, inPlace

		for v in *listB
			table.insert listA, v

		listA

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

	[=[
	Function: SetFromList
	Creates a set from a list. A list is defined as a table with all numeric keys in sequential order (such as {"red", "yellow", "green"}).
	A set is defined as a table that only uses the boolean value true for keys that exist in the table.
	This function takes the values from the list and makes them the keys in a set, all with the value of 'true'.
	Note that you lose ordering and duplicates in the list during this conversion, but gain ease of testing for a value's existence in the table.
	One simply needs to test whether the value of a key is true or nil.

	Parameters:
		list - The *list*.

	Returns:
		The *table* representing the set.

	Example:
		:SetFromList( { "apple", "banana", "kiwi", "pear" } )

		returns...

		:{ apple=true, banana=true, kiwi=true, pear=true }

	Notes:
		* This function uses fori during the conversion process. See <A Discussion On fori>.
		* Complexity is O(#list).

	Revisions:
		1.0.0 - Initial.
	]=]
	@SetFromList: (list using nil) ->
		{ v, true for v in *list }
