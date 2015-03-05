moon = require "moon"

[=[
Class: UtilX

A static class used for utility functions that are not specific to Garry's Mod.
	
Depends On:
	* <TableX>

Revisions:
	1.0.0 - Initial.
]=]
export class UtilX
	[=[
	Function: Trim
	Trims leading and tailing whitespace from a string.

	Parameters:
		str - The *string* to trim.

	Returns:
		The trimmed *string*.

	Notes:
		* This is 'trim6' from <http://lua-users.org/wiki/StringTrim>.

	Revisions:
		1.0.0 - Initial.
	]=]
	@Trim: (str using nil) ->
		str\match("^()%s*$") and "" or str\match("^%s*(.*%S)")


	[=[
	Function: LTrim
	Exactly like <Trim> except it only trims the left side. Taken from <http://lua-users.org/wiki/CommonFunctions>

	Revisions:
		1.0.0 - Initial.
	]=]
	@LTrim: (str using nil) ->
		(str\gsub("^%s*", ""))


	[=[
	Function: RTrim
	Exactly like <Trim> except it only trims the right side. Taken from <http://lua-users.org/wiki/CommonFunctions>

	Revisions:
		1.0.0 - Initial.
	]=]
	@RTrim: (str using nil) ->
		n = #str
		while n > 0 and str\find("^%s", n)
			n -= 1
			
		str\sub( 1, n )
		
	
	VardumpHelper = (value, depth, key, done using nil) ->
		str = string.rep "  ", depth

		if key ~= nil
			t = type key
			if t == "string"
				str = string.format "%q", key
			else
				str ..= tostring key
			str ..= " = "

		t = type value
		if t == "table" and not done[value]
			done[value] = true
			str ..= string.format "(table: array size=%i, total values=%i)\n", #value, TableX.Count(value)
			for k, v in pairs value
				str ..= VardumpHelper v, depth+1, k, done
				
		elseif t == "string" then
			str ..= string.format "%q\n", value
			
		else
			str = tostring(value) .. "\n"

		str


	[=[
	Function: Vardump
	Returns useful, readable information about variables.

	Parameters:
		... - Accepts any number of parameters of *any type* and prints them one by one.

	Returns:
		A readable *string* serialization of the data passed in.

	Example:
		:Vardump( { "foo", apple="green", floor=41, shopping={ "milk", "cookies" } } )

		returns the string...

		:(table: array size=1, total values=4)
		:  1 = "foo"
		:  "apple" = "green"
		:  "floor" = 41
		:  "shopping" = (table: array size=2, total values=2)
		:    1 = "milk"
		:    2 = "cookies"

	Notes:
		* A string will always be surrounded by quotes and a number will always stand by itself. This is to make it easier to identify numbers stored as strings.
		* Array size and total size are shown in the table header. Array size is the result of the pound operator (#) on the table, total size is the result of <Count>. 
			Array size is useful debug information when iterating over a table with ipairs or fori.

	Revisions:
		v1.0.0 - Initial.
	]=]
	@Vardump: (... using nil) ->
		str = ""
		t = {...}
		for i=1, select("#", ...)
			str ..= VardumpHelper(t[i], 0, nil, {})

		str\sub(1, -2) -- Remove last newline
		
	
	[=[
	Function: Raise
	TODO
	]=]
	@Raise: (str, level=1 using nil) -> error str, level
		
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
			
	
	timeCodes =
		m: 60
		minute: 60
		minutes: 60
		h: 60 * 60
		hour: 60 * 60
		hours: 60 * 60
		d: 60 * 60 * 24
		day: 60 * 60 * 24
		days: 60 * 60 * 24
		w: 60 * 60 * 24 * 7
		week: 60 * 60 * 24 * 7
		weeks: 60 * 60 * 24 * 7
		M: 60 * 60 * 24 * (365.25/12) -- Very hand-wavy, but we only need an approximate
		month: 60 * 60 * 24 * (365.25/12)
		months: 60 * 60 * 24 * (365.25/12)
		y: 60 * 60 * 24 * 365.25
		year: 60 * 60 * 24 * 365.25
		years: 60 * 60 * 24 * 365.25
	[=[
	Function: TimeStringToSeconds
	A "time string" to convert into seconds. Can accept minutes, hours, days, weeks, months, or years. See examples below.
	
	Parameters:
		str - The *string* or *number* to convert to seconds. If it's a number of a string of a number, passes back that number.
		
	Returns:
		The *number* of seconds.
		
	Examples:
		All of the following return the same thing...
		* "1M7d5h3m11s"
		* "1M 7d 5h 3m 11"
		* "1M, 7d, 5h, 3m 11s"
		* "1 month  7 days, 5h 3minute, 11 seconds"
		
	Notes:
		* Commas and spacing are ignored.
		* Any time multiplier (E.G., weeks) that isn't recognized or supported (E.G., milliseconds) will be considered to be seconds.
		
	Revisions:
		1.0.0 - Initial.
	]=]
	@TimeStringToSeconds: (str using nil) ->
		UtilX.CheckArg 1, "TimeStringToSeconds", {"string", "number"}, str
		str = str\gsub ",", ""
		
		if num = tonumber(str)
			return num
		
		num = 0
		startIdx = 1
		codeIdx = str\find "%D", startIdx
		while codeIdx
			nextIdx = (str\find("%d", codeIdx)) or #str
			
			units = str\sub startIdx, codeIdx-1
			units = tonumber units
			code = str\sub codeIdx, nextIdx-1
			multiplier = timeCodes[code] or 1
			num += units * multiplier
			
			startIdx = nextIdx
			codeIdx = str\find "%D", startIdx
			
		num
	

	-- Transforms the "expected" argument for functions below into a list of strings.
	expectedToStrings = (expected using nil) ->
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
