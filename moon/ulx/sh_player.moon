[=[
File: Player
Helpers for dealing with player objects

Revisions:
	4.0.0 - Initial.
]=]

[=[
Function: IsServerConsole
TODO
]=]
ulx.IsServerConsole = (obj using nil) ->
	obj and obj.EntIndex and obj\EntIndex! == 0
