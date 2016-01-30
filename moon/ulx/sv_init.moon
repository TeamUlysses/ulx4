print "ULX v#{ulx.VERSION} loading server-side..."

ulx.CoreConfig = Config "server"
ulx.CoreConfig\LoadAndUseDefaults
	Language: "english"
	SteamAPIKey: 123

util.AddNetworkString(ulx.NET_CMDS)

playerAuth = (ply using net) ->
	net.Start(ulx.NET_CMDS)
	net.WriteString("start")
	net.Send(ply)

hook.Add("PlayerAuthed", "ULX Start Client", playerAuth)

[[
Player loading notes (server-side):
	On a listen server, "PlayerConnect" is not called for the server host.
	"PlayerInitialSpawn" is called about 2-3 seconds before "PlayerAuth".
	Player appears in player.GetAll() shortly after "PlayerInitialSpawn".
	The player sometimes flags for "IsFullyAuthenticated" on PlayerInitialSpawn.

Notes (client-side):
	The name of the local player may be "unconnected" even up to the "InitPostEntity" hook.
]]
