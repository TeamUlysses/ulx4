print "ULX v#{ulx.VERSION} loading..."

hook.Add("PlayerAuthed","t",(ply, ...) -> print( SysTime(), "auth", ply, ...))
hook.Add("PlayerConnect","t",(...) -> print( SysTime(), "connect", ...))
hook.Add("PlayerInitialSpawn","t",(ply) -> print( SysTime(), "spawn", ply, ply\SteamID!, ply\IsFullyAuthenticated!))
-- TODO next: sent init command to client
