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
	
