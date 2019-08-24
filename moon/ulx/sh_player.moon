[=[
File: Player
Helpers for dealing with player objects
]=]

[=[
Function: IsServerConsole
TODO
]=]
ulx.IsServerConsole = (obj using nil) ->
	obj and obj.EntIndex and obj\EntIndex! == 0
