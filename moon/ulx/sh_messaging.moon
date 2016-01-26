[=[
File: Messaging
Helpers for sending notifications to players.

Revisions:
	4.0.0 - Initial.
]=]

[=[
Function: TSay
TODO
]=]
ulx.TSay = (ply, msg using nil) ->
	if CLIENT and type(ply) == "string" -- Allow them to omit first arg on client
		ply, msg = nil, ply

	ulx.UtilX.CheckArg "ulx.TSay", 1, {"nil", "Player", "Entity"}, ply -- The console is considered an Entity
	ulx.UtilX.CheckArg "ulx.TSay", 2, "string", msg

	if CLIENT
		LocalPlayer!\ChatPrint msg
		return

	if ulx.IsServerConsole ply
		Msg msg .. "\n"
		return

	ply\ChatPrint msg

[=[
Function: TSayRed
TODO
]=]
ulx.TSayRed = (ply, msg using nil) ->
	ulx.TSay ply, msg -- TODO, use color
