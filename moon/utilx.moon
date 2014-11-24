[=[
Class: UtilX

A class used for utility functions that are not specific to Garry's Mod.

Revisions:
	1.0.0 - Initial.
]=]
export class UtilX
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
	@Round: (num, places=0) ->
		mult = 10 ^ places
		math.floor( num * mult + 0.5 ) / mult
