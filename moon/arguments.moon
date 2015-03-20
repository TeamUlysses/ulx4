[=[
File: Arguments
This file defines argument types to be used in TODO.
]=]

[=[
Class: Arg

The base argument class.

Revisions:
	1.0.0 - Initial.
]=]
class Arg
	[=[
	Variables: Arg Variables
	All these variables are optional, with sensible defaults.

		Default    - A value of *any type*. If an argument is optional and unspecified, this value is used.
		IsOptional - A *boolean* of whether or not this argument is optional.

	]=]
	Default: nil
	IsOptional: false

	[=[
	Function: Optional
	A quick shortcut to set <IsOptional> to true.

	Returns:
		*self*.
	]=]
	Optional: =>
		IsOptional = true
		return self


[=[
Class: ArgNum
The argument class used for any numeric data.

Passes:
	A *number* value, defaulting to _0_.

Revisions:
	1.0.0 - Initial.
]=]
class ArgNum extends Arg
	[=[
	Variables: ArgNum Variables
	All these variables are optional, with sensible defaults.

		Default - A *number*, defaults to _0_. If an argument is optional and unspecified, this value is used.
		Min     - A *number or nil* specifying the minimum value for the argument.
		Max     - A *number or nil* specifying the maximum value for the argument.
		RoundTo - A *number or nil* specifying the digit to round to, as passed to <UtilX.Round>.
	]=]
	Default: 0
	Min:     nil
	Max:     nil
	RoundTo: nil


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
		Completes           - A *table or nil* of auto-completes (suggestions) for the argument.

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
