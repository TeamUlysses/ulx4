if ulx return
export ulx = {}

initCallbacks = {}
ulx.RegisterInitCallback = (callback using nil) ->
	table.insert initCallbacks, callback

IncludeAndAddCSLuaFile = (filename using nil) ->
	include filename
	AddCSLuaFile filename

-- External libs
IncludeAndAddCSLuaFile "lib/tableshape.lua"

-- Utility things
IncludeAndAddCSLuaFile "ulx/sh_consts.lua"
IncludeAndAddCSLuaFile "ulx/sh_tablex.lua"
IncludeAndAddCSLuaFile "ulx/sh_utilx.lua"
IncludeAndAddCSLuaFile "ulx/sh_filesystem.lua"
IncludeAndAddCSLuaFile "ulx/sh_config.lua"
IncludeAndAddCSLuaFile "ulx/sh_lang.lua"

-- GMod things
IncludeAndAddCSLuaFile "ulx/sh_arguments.lua"
IncludeAndAddCSLuaFile "ulx/sh_command.lua"
IncludeAndAddCSLuaFile "ulx/sh_messaging.lua"
IncludeAndAddCSLuaFile "ulx/sh_player.lua"

-- Client things
AddCSLuaFile "autorun/ulx_init.lua"
AddCSLuaFile "ulx/cl_init.lua"

if SERVER
	include("ulx/sv_init.lua")

	ulx.Command "ulx", () ->
		print "ULX called"
	slap = ulx.Command "ulx slap", (ply, dmg) ->
		print "Slap called by #{ply} for #{dmg} damage"
	slap\Args{
		ulx.ArgNum!\Min(0)\Max(100)
	}
else
	include("ulx/cl_init.lua")

for callback in *initCallbacks
	callback!
