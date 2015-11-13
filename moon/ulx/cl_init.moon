print "ULX v#{ulx.VERSION} loading..."

[[
Player loading notes:
	On a listen server, "PlayerConnect" is not called for the server host.
	"PlayerInitialSpawn" is called about 3 seconds before "PlayerAuth".
]]
