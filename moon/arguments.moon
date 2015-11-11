[=[
File: Arguments
This file defines argument types to be used in TODO.
]=]

[=[
Class: Arg
The base argument class. This class is not really meant to be used in practice and is basically a pass through itself,
but <Arg> lays down some important shared functionality for the other argument classes.

Revisions:
	1.0.0 - Initial.
]=]
export class Arg
	[=[
	Function: ShortcutFn
	Only available statically, meant for internal use only.
	]=]
	@ShortcutFn = (name, typ, default using nil) =>
		@__base[name] = (val=default using nil) =>
			UtilX.CheckArg "#{@@__name}.#{name}", 1, typ, val
			@["_" .. name] = val
			@


	[=[
	Variables: Arg Variables
	All these variables are optional, with sensible defaults. *Do not set these directly*. Instead, call the setter
	function of the same name without the underscore. E.G., call "Defult(myDefaultValue)".

		_Default  - A value of *any type*. If an argument is optional and unspecified, this value is used.
		_Optional - A *boolean* of whether or not this argument is optional.
		_Hint - A *string* (usually a word or two) used in help output to give users a general idea of what the argument is for.
		_Help - A *string* used in longer help output to describe the argument.
	]=]
	_Default:  nil
	_Optional: false
	_Hint:     ""
	_Help:     ""

	@ShortcutFn "Default"
	@ShortcutFn "Optional", "boolean", true
	@ShortcutFn "Hint", "string"
	@ShortcutFn "Help", "string"


	[=[
	Function: UsageShort

	Parameters:
		str - An optional *string* to add the help into. _Defaults to ""_.

	Returns:
		A short, one-line help *string* for using the argument.
	]=]
	UsageShort: (str = "" using nil) =>
		str ..= ", "                   if @_Optional and #str > 0
		str ..= "default #{@_Default}" if @_Optional
		str = "#{@_Hint}: " .. str     if @_Hint
		str = "<" .. str .. ">"
		str = "[" .. str .. "]"        if @_Optional

		str


	[=[
	Function: UsageLong
	Similar to <UsageShort>, but has no length restrictions on the returned text.

	Parameters:
		str - An optional *string* to add the help into. _Defaults to ""_.

	Returns:
		A full *string* help for using the argument.
	]=]
	UsageLong: (str = "" using nil) =>
		str ..=   "Type:     #{@@__name}"
		str ..= "\nDefault:  #{@_Default} (used if argument is unspecified)" if @_Optional
		str ..= "\nHint:     #{@_Hint}"    if @_Hint
		str ..= "\nHelp:     #{@_Help}"    if @_Help

		str


	[=[
	Function: Completes

	Parameters:
		str - The *string* input for the command so far.

	Returns:
		A *list of strings* to be used as command autocomplete suggestions.
	]=]
	Completes: (str using nil) =>
		{@UsageShort!}


	[=[
	Function: IsValid
	"Valid" for <Arg> is any object that is not nil, or nil if the argument is optional.

	Parameters:
		obj - A value of *any type*.

	Returns:
		A *boolean* on whether the passed object is valid for this argument type.
	]=]
	IsValid: (obj using nil) =>
		obj ~= nil or @_Optional


	[=[
	Function: Parse

	Parameters:
		obj - A value of *any type*.

	Returns:
		The parsed argument for this argument type. For <ArgNum> (this class), it simply passes back what it receives or the
		default.
	]=]
	Parse: (obj using nil) =>
		if obj == nil and @_Optional
			return @_Default
		obj


	[=[
	Function: IsPermissible

	Parameters:
		obj - A value of *any type*. For other argument classes, you pass only a parsed object of the appropriate type.
		      Under most circumstances, you'll be passing the output from <Parse> into this function.

	Returns:
		A *boolean* stating whether the passed object meets the restrictions specified by the class configuration.
		If it returns false, a *string* explaining why it is not permissible is passed as the second return value.
	]=]
	IsPermissible: (obj using nil) =>
		true


	[=[
	Function: Serialize

	Returns:
		A serialized *string* version of the restrictions in this class to be used by <Deserialzie>. Since ULX is only
		concerned about saving restrictions created by a user for various commands, nothing is saved by this base class.
	]=]
	Serialize: (using nil) =>
		""


	[=[
	Function: Deserialize

	Parameters:
		str - A serialized *string* generated by <Serialize>.

	Returns:
		An instantiation of *<Arg>*. For the derived classes, it returns the appopriate class instantiation with the
		restrictions set according to what the serialized string contained.
	]=]
	@Deserialize: (str using nil) ->
		Arg!



[=[
Class: ArgNum
The argument class used for any numeric data.

Passes:
	A *number* value, defaulting to _0_.

Revisions:
	1.0.0 - Initial.
]=]
export class ArgNum extends Arg
	-- Values from parent that we want to override the defaults for
	_Default: 0
	_Hint:    "number"
	_Help:    "A number argument"

	@ShortcutFn "Default", "number"

	[=[
	Variables: ArgNum Variables
	All these variables are optional, with sensible defaults. See <Arg.Arg Variables> above for an important note.

		_Min   - A *number or nil* specifying the minimum value for the argument.
		_Max   - A *number or nil* specifying the maximum value for the argument.
		_Round - A *number or nil* specifying the digit to round to, as passed to <UtilX.Round>.
		_Hint  - A *string* (usually a word or two) used in help output to give users a general idea of what the argument is for.
	]=]
	_Min:   nil
	_Max:   nil
	_Round: nil

	@ShortcutFn "Min", {"number", "nil"}
	@ShortcutFn "Max", {"number", "nil"}
	@ShortcutFn "Round", {"number", "nil"}, 0


	[=[
	Function: UsageShort
	See <Arg.UsageShort>.
	]=]
	UsageShort: (str = "" using nil) =>
		if @_Min and @_Min == @_Max
			str ..= tostring @_Min

		else
			str ..= @_Min .. "<=" if @_Min
			str ..= "x"
			str ..= "<=" .. @_Max if @_Max

		super\UsageShort str


	[=[
	Function: UsageLong
	See <Arg.UsageLong>.
	]=]
	UsageLong: (str = "" using nil) =>
		str = super\UsageLong(str)

		str ..= "\nMin:      #{@_Min}"   if @_Min
		str ..= "\nMax:      #{@_Max}"   if @_Max
		str ..= "\nRound:    #{@_Round}" if @_Round

		str


	[=[
	Function: IsValid
	See <Arg.IsValid>. For <ArgNum>, "valid" is anything that passes tonumber().
	]=]
	IsValid: (obj using nil) =>
		if not super\IsValid(obj)
			return false
		tonumber(obj) ~= nil


	[=[
	Function: Parse
	See <Arg.Parse>.

	Returns:
		An appropriately rounded *number* or *nil* if parsing fails.
	]=]
	Parse: (obj using nil) =>
		num = tonumber(obj)
		num = @_Default if obj == nil and @_Optional
		num = UtilX.Round num, @_Round if num and @_Round
		num


	[=[
	Function: IsPermissible
	See <Arg.IsPermissible>. For <ArgNum>, checks the bounds of the number.

	Parameters:
		num - A *number*.
	]=]
	IsPermissible: (num using nil) =>
		return false, "Below minimum (#{@_Min})" if @_Min and num < @_Min
		return false, "Above maximum (#{@_Max})" if @_Max and num > @_Max
		true


	[=[
	Function: Serialize
	See <Arg.Serialize>.

	Returns:
		A *string* in the format "min_num:max_num".
	]=]
	Serialize: (using nil) =>
		str = ""
		str ..= tostring(@_Min) if @_Min
		str ..= ":"
		str ..= tostring(@_Max) if @_Max
		str


	[=[
	Function: Deserialize
	See <Arg.Deserialize>.
	]=]
	@Deserialize: (str using nil) ->
		splitPt = str\find ":"

		local min, max
		if splitPt
			min = tonumber(str\sub(1, splitPt-1))
			max = tonumber(str\sub(splitPt+1))
		else -- Assume they want it restricted to one value
			min = tonumber(str)
			max = min

		ArgNum!\Min(min)\Max(max)



[=[
Class: ArgTime
The argument class used for a timespan using natural language.

Passes:
	A *number* of seconds, defaulting to _0_.

Revisions:
	1.0.0 - Initial.
]=]
class ArgTime extends ArgNum
	[=[
	Variables: ArgNum Variables
	All these variables are optional, with sensible defaults.

		Min - A *number, string, or nil* specifying the minimum value for the argument.
		Max - A *number, string, or nil* specifying the maximum value for the argument.
	]=]
	Min: nil
	Max: nil



[=[
Class: ArgString
The argument class used for string arguments.

Passes:
	A *string* value, defaulting to _0_.

Revisions:
	1.0.0 - Initial.
]=]
class ArgString extends Arg
	[=[
	Variables: ArgString Variables
	All these variables are optional, with sensible defaults.

		Default - A *string*, defaults to _""_. If an argument is optional and unspecified, this value is used.
		RestrictToCompletes - A *boolean*, defaults to _false_.
			If true, the argument passed will /always/ be one of the arguments from the <Completes> table.
		Completes           - A *list of strings or nil* of auto-completes (suggestions) for the argument.

	]=]
	Default:             ""
	RestrictToCompletes: false
	Completes:           nil



[=[
Class: ArgPlayerID
The argument class used for SteamID arguments.

Passes:
	A *table of strings or players* (between one and <MaximumTargets> items).
	Each item is either a valid SteamID or a connected player.

Revisions:
	1.0.0 - Initial.
]=]
class ArgPlayerID extends Arg
	[=[
	Variables: ArgPlayerID Variables
	All these variables are optional, with sensible defaults.

		Default            - A *string*, defaults to _"^"_ (keyword for the player calling the command).
			If an argument is optional and unspecified, this value is used.
		RestrictTarget     - A *string or nil* specifying the players this argument is allowed to target.
			This is passed to <TODO.GetUser()>. Nil indicates no restriction.
		MaximumTargets     - A *number*, defaulting to _1_, specifying the maximum number of players this argument can target.
		PassPlayerIfActive - A *boolean*. If true, will pass the player object if they are connected.

	]=]
	Default:            "^"
	RestrictTarget:     nil
	MaximumTargets:     1
	PassPlayerIfActive: false



[=[
Class: ArgPlayerActive
The argument class used for player arguments.

Passes:
	A *table of players* (between one and <MaximumTargets> items).

Revisions:
	1.0.0 - Initial.
]=]
class ArgPlayerActive extends ArgPlayerID
