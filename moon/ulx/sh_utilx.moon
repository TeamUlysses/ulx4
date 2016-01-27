[=[
Class: UtilX

A static class used for utility functions that are not specific to Garry's Mod.

Depends On:
	* <TableX>
	* Moon standard library

Revisions:
	4.0.0 - Initial.
]=]
class ulx.UtilX
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
		4.0.0 - Initial.
	]=]
	@Trim: (str using nil) ->
		str\match("^()%s*$") and "" or str\match("^%s*(.*%S)")


	[=[
	Function: LTrim
	Exactly like <Trim> except it only trims the left side. Taken from <http://lua-users.org/wiki/CommonFunctions>

	Revisions:
		4.0.0 - Initial.
	]=]
	@LTrim: (str using nil) ->
		(str\gsub("^%s*", ""))


	[=[
	Function: RTrim
	Exactly like <Trim> except it only trims the right side. Taken from <http://lua-users.org/wiki/CommonFunctions>

	Revisions:
		4.0.0 - Initial.
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
				str ..= string.format "%q", key
			else
				str ..= tostring key
			str ..= " = "

		t = type value
		if t == "table" and not done[value]
			done[value] = true
			str ..= string.format "(table: array size=%i, total values=%i)\n", #value, ulx.TableX.Count(value)
			for k, v in pairs value
				str ..= VardumpHelper v, depth+1, k, done

		elseif t == "string" then
			str ..= string.format "%q\n", value

		else
			str ..= tostring(value) .. "\n"

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
		v4.0.0 - Initial.
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
	@Raise: (str, level=1 using nil) ->
		error str, level+1

	[=[
	Function: RaiseUnimplemented
	TODO
	]=]
	@RaiseUnimplemented: (str, level=1 using nil) ->
		@.Raise str .. " called, but unimplemented", level+1

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
		4.0.0 - Initial.
	]=]
	@Round: (num, places=0 using nil) ->
		mult = 10 ^ places
		math.floor(num * mult + 0.5) / mult


	timeCodesRaw =
		minute: 60
		hour: 60 * 60
		day: 60 * 60 * 24
		week: 60 * 60 * 24 * 7
		month: 60 * 60 * 24 * 30 -- Very hand-wavy, but we only need an approximate
		year: 60 * 60 * 24 * 365
	timeCodeLanguageMapping =
		MINUTES: timeCodesRaw.minute
		MINUTE: timeCodesRaw.minute
		MINUTE_SHORT: timeCodesRaw.minute
		HOURS: timeCodesRaw.hour
		HOUR: timeCodesRaw.hour
		HOUR_SHORT: timeCodesRaw.hour
		DAYS: timeCodesRaw.day
		DAY: timeCodesRaw.day
		DAY_SHORT: timeCodesRaw.day
		WEEKS: timeCodesRaw.week
		WEEK: timeCodesRaw.week
		WEEK_SHORT: timeCodesRaw.week
		MONTHS: timeCodesRaw.month
		MONTH: timeCodesRaw.month
		MONTH_SHORT: timeCodesRaw.month
		YEARS: timeCodesRaw.year
		YEAR: timeCodesRaw.year
		YEAR_SHORT: timeCodesRaw.year
	timeCodes = {}

	fillTimeCodes = (using timeCodes) ->
		timeCodes = {}
		for phraseName, value in pairs timeCodeLanguageMapping
			phrase = ulx.Lang.GetPhrase phraseName
			timeCodes[phrase] = value
	[=[
	Function: TimeStringToSeconds
	A natural language time string to convert into seconds. Can accept minutes, hours, days, weeks, months, or years.
	Amounts can be fractional and positive or negative. See examples below.

	Parameters:
		str - The *string* or *number* to convert to seconds. If it's a number, it's simply passed back.

	Returns:
		The *number* of seconds.

	Examples:
		All of the following return the same number of seconds...
		* "1M7d5h3m11s"
		* "1M 7d 5h 3m 11"
		* "1M, 7d, 5h, 3m 11s"
		* "1 month  7 days, 5h 3minute, 11 seconds"

		You can use negative and fractional times, or even repeat a time span...
		* "1 year - 6.5 hours"
		* "1 year - 6 hours + 5 minutes - 3 minutes"

	Notes:
		* Commas and spacing are ignored.
		* Any time multiplier that isn't recognized or supported (E.G., milliseconds) will be considered to be seconds.

	Revisions:
		4.0.0 - Initial.
	]=]
	@TimeStringToSeconds: (str using nil) ->
		@.CheckArg "TimeStringToSeconds", 1, {"string", "number"}, str

		if timeCodes.CurrentLanguage ~= ulx.Lang.CurrentLanguage
			fillTimeCodes!

		if num = tonumber(str)
			return num

		str = @.Trim(str\gsub("[+,]", "")\gsub("-%s+", "-"))
		len = #str
		num = 0
		startIdx = 1
		codeIdx = str\find "[^-\\.%d]", startIdx
		while codeIdx
			nextIdx = (str\find("[-\\.%d]", codeIdx)) or len+1

			units = str\sub startIdx, codeIdx-1
			units = tonumber units
			code = @.Trim(str\sub codeIdx, nextIdx-1)
			multiplier = timeCodes[code] or 1
			num += units * multiplier

			startIdx = nextIdx
			codeIdx = str\find "[^-\\.%d]", startIdx

			if not codeIdx and startIdx < len
				num += tonumber(str\sub startIdx)

		num


	-- Transforms the "expected" argument for functions below into a list of strings.
	expectedToStrings = (expected using nil) ->
		[ type(v) == "string" and v or v.__name for v in *expected ]


	[=[
	Function: RaiseBadArg
	Raises an error similar to the Lua standard error of "bad argument #x to <fn_name> (<type> expected, got <type>)".
	This function intelligently figures out how best to word the error with the given information.

	Parameters:
		fnName   - The *optional string* of the function name being called.
		argnum   - The *optional number* of the argument that was bad.
		expected - The *optional string, class (via moon.type), or list* of the type(s) you expected.
		data     - *Optional and any type*, the actual data you got.
		level    - The *optional number* of how many levels up (from this function) to throw the error. Defaults to _1_.

	Returns:
		Always returns using *<Raise()>*.

	Revisions:
		4.0.0 - Initial.
	]=]
	@RaiseBadArg: (fnName, argnum, expected, data, level=1 using nil) ->
		expected = { expected } if expected and moon.type(expected) ~= "table"
		dataStr = moon.type(data)
		dataStr = data.__class.__name if type(dataStr) ~= "string"

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

		@.Raise str, level+1


	[=[
	Function: CheckArg
	Used to check to see if a function argument matches what is expected. If it doesn't, calls <RaiseBadArg()>.
	This function is primarily useful at the beginning of a function definition to ensure that the correct type of data was passed in.

	Parameters:
		fnName   - The *optional string* of the function name being called.
		argnum   - The *optional number* of the argument that was bad.
		expected - The *optional string, class (via moon.type), or list* of the type(s) you expected.
		data     - *Optional and any type*, the actual data you got.
		level    - The *optional number* of how many levels up (from this function) to throw the error. Defaults to _1_.

	Returns:
		Returns using *<Raise()>* if the argument doesn't match what's expected, otherwise returns *true*.

	Example:
		:CheckArg("test", 1, "number", 41)

		returns...

		:true

	Revisions:
		4.0.0 - Initial.
	]=]
	@CheckArg: (fnName, argnum, expected, data, level=1 using nil) ->
		if expected == nil return true
		if moon.type(expected) ~= "table"
			if expected == moon.type(data)
				return true
		elseif ulx.TableX.HasValueI(expected, moon.type(data)) then
			return true

		@.RaiseBadArg fnName, argnum, expected, data, level+1


	[=[
	Function: CheckArgs
	A shortcut for checking all the arguments passed into a function via <CheckArg>.

	Parameters:
		fnName - The *optional string* of the function name being called.
		args   - The *array* containing one *array* for each argument.
		         In each sub-array, the first argument is the expected arg in <CheckArg>.
		         The second argument is the data arg in <CheckArg>.
		level  - The *optional number* of how many levels up (from this function) to throw the error. Defaults to _1_.

	Returns:
		Returns using *<Raise()>* if the arguments don't match what's expected, otherwise returns *true*.

	Example:
		:CheckArgs("test", {{"boolean", true}, {"string", "41"}})

		returns...

		:true

	Revisions:
		4.0.0 - Initial.
	]=]
	@CheckArgs: (fnName, args, level=1 using nil) ->
		for argnum=1, #args
			continue if args[argnum] == nil
			{expected, data} = args[argnum]

			if not @.CheckArg fnName, argnum, expected, data, level+1
				return false

		true


	[=[
	Function: Explode
	Split a string by a separator.

	Parameters:
		separator - The *string* separator. This can be RegEx.
		str - The *string* to explode.
		limit - The *optional number* specifying the maximum times to explode.

	Returns:
		A *list of strings*.

	Example:
		:Explode( " ", "This is a sentence" )

		returns...

		:{ "This", "is", "a", "sentence" }

		Revisions:
			4.0.0 - Initial.
	]=]
	@Explode: (separator, str, limit using nil) ->
		t = {}
		curpos = 1
		while true -- We have a break in the loop
			newpos, endpos = str\find separator, curpos -- find the next separator in the string
			if newpos ~= nil -- if found then..
				table.insert t, str\sub(curpos, newpos-1) -- Save it in our table.
				curpos = endpos + 1 -- save just after where we found it for searching next time.
			else
				if limit and #t > limit
					return t -- Reached limit
				table.insert( t, str\sub(curpos) ) -- Save what's left in our array.
				break

		return t


	[=[
	Function: SplitArgs
	This is similar to a string explode function on whitespace, except that it also allows for grouping with startToken and endToken.

	Parameters:
		args - The *string* to split into individual arguments.
		startToken - The *string* character to start a string with, default to _'"'_ (double quotes).
		endToken - The *string* character to end a string with, default to _'"'_ (double quotes).

	Returns:
		1 - A *list of strings*. Each item is one argument.
		2 - A *boolean*, which is true if the start and end tokens were mismatched (parsing ended while looking for an endToken).

	Example:
		:SplitArgs('This is a "Cool sentence to" make "split up"')

		returns...

		:{'This', 'is', 'a', 'Cool sentence to', 'make', 'split up'}

	Notes:
		* Mismatched quotes will result in having the last quote grouping the remaining input into one argument.
		* Args outside of quotes are trimmed (via string.Trim), while args inside quotes is not trimmed at all.

	Revisions:
		4.0.0 - Initial.
	]=]
	@SplitArgs: (args, startToken='"', endToken='"' using nil) ->
		args = @.Trim args
		argv = {}
		currentPos = 1 -- Our current position within the string
		inQuote = false -- Is the text we're currently processing in a quote?
		argsLen = #args

		while inQuote or currentPos <= argsLen
			tokenToLookFor = inQuote and endToken or startToken
			tokenPos = args\find tokenToLookFor, currentPos, true

			-- The string up to the quote, the whole string if no quote was found
			prefix = args\sub currentPos, (tokenPos or 0) - 1
			if not inQuote
				trimmedPrefix = @.Trim prefix
				if trimmedPrefix ~= "" -- Something to be had from this...
					arg = @.Explode( "%s+", trimmedPrefix )
					ulx.TableX.Append argv, arg, true
			else
				table.insert argv, prefix

			-- If a quote was found, update our position and note our state
			if tokenPos ~= nil
				currentPos = tokenPos + 1
				inQuote = not inQuote
			else -- Otherwise we've processed the whole string now
				break

		return argv, inQuote
