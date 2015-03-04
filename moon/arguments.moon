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
		
		Min     - A *number or nil* specifying the minimum value for the argument.
		Max     - A *number or nil* specifying the maximum value for the argument.
		RoundTo - A *number or nil* specifying the digit to round to, as passed to <UtilX.Round>.
	
	]=]
	Min:     nil
	Max:     nil
	RoundTo: nil

	
[=[
Class: ArgPlayer

The argument class used for player arguments
	
Passes:
	A single, valid *player* object or possibly a "string" of a valid Steam ID if <AllowOfflineID> is set to true.

Revisions:
	1.0.0 - Initial.
]=]	
class ArgPlayer extends Arg
	[=[
	Variables: ArgPlayer Variables
	All these variables are optional, with sensible defaults.
	
		Target         - A *string or nil* specifying the players this argument is allowed to target. 
			This is passed to <???.GetUser()>. Nil indicates no restriction.
		AllowOfflineID - A *boolean* of whether or not to allow the argument to contain Steam IDs of offline players. 
			ID is verified for correctness.

	]=]
	Target:         nil
	AllowOfflineID: false
	