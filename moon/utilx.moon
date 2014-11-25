moon = require "moon"

[=[
Class: UtilX

A static class used for utility functions that are not specific to Garry's Mod.

Revisions:
	1.0.0 - Initial.
]=]
export class UtilX
	[=[
		Blah
	]=]
	@Raise: (str, level) -> error str, level
		
	[=[
	Function: Round
	Rounds a number to a given decimal place.

	Parameters:
		num    - The *number* to round.
		places - The *optional number* of places to round to. Defaults to _0_.
		         0 rounds to the nearest whole number, 1 rounds to the nearest tenth, 2 rounds to the nearest thousandth, etc. 
		         Negative numbers round into the non-fractional places; -1 rounds to the nearest tens, -2 rounds to the nearest hundreds, etc.

	Returns:
		The rounded *number*.

	Revisions:
		1.0.0 - Initial.
	]=]
	@Round: (num, places=0 using nil) ->
		mult = 10 ^ places
		math.floor(num * mult + 0.5) / mult

	-- Transforms the "expected" argument for functions below into a list of strings.
	expectedToStrings = (expected) ->
		[ type(v) == "string" and v or v.__name for v in *expected ]

	[=[
	Function: RaiseBadArg
	Raises an error similar to the Lua standard error of "bad argument #x to <fn_name> (<type> expected, got <type>)".
	This function intelligently figures out how best to word the error with the given information.

	Parameters:
		argnum   - The *optional number* of the argument that was bad.
		fnName   - The *optional string* of the function name being called.
		expected - The *optional string, class (via moon.type), or list* of the type(s) you expected.
		data     - *Optional and any type*, the actual data you got.
		level    - The *optional number* of how many levels up (from this function) to throw the error. Defaults to _1_.

	Returns:
		Always returns using *<Raise()>*.

	Revisions:
		1.0.0 - Initial.
	]=]
	@RaiseBadArg: (argnum, fnName, expected, data, level=1 using nil) ->
		expected = { expected } if expected and moon.type(expected) ~= "table"
		dataStr = moon.type(data)
		dataStr = data.__name if type(dataStr) ~= "string"

		str = "bad argument"
		if argnum then 
			str ..= " #" .. tostring(argnum)
		if fnName then 
			str ..= " to " .. fnName
		if expected or data then 
			str ..= " ("
			if expected then 
				str ..= table.concat(expectedToStrings(expected), " or ") .. " expected"
			if expected and data then 
				str ..= ", "
			if data then 
				str ..= "got " .. dataStr
			str ..= ")"

		self.Raise str, level+1
		

	[=[
	Function: CheckArg

	Used to check to see if a function argument matches what is expected. If it doesn't, calls <RaiseBadArg()>.
	This function is primarily useful at the beginning of a function definition to ensure that the correct type of data was passed in.

	Parameters:
		argnum   - The *optional number* of the argument that was bad.
		fnName   - The *optional string* of the function name being called.
		expected - The *optional string, class (via moon.type), or list* of the type(s) you expected.
		data     - *Optional and any type*, the actual data you got.
		level    - The *optional number* of how many levels up (from this function) to throw the error. Defaults to _1_.

	Returns:
		Returns using *<Raise()>* if the argument doesn't match what's expected, otherwise returns *true*.

	Revisions:
		1.0.0 - Initial.
	]=]
	@CheckArg: (argnum, fnName, expected, data, level=1 using nil) ->
		if moon.type(expected) ~= "table"
			if expected == moon.type(data)
				return true
		elseif TableX.HasValueI(expected, moon.type(data)) then
			return true
			
		self.RaiseBadArg argnum, fnName, expected, data, level+1
