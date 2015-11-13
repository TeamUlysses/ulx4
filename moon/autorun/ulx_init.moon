if ulx return
export ulx = {}

AddCSLuaFile("autorun/ulx_init.lua")
AddCSLuaFile("ulx/cl_init.lua")
AddCSLuaFile("ulx/sh_consts.lua")

include("ulx/sh_consts.lua")

if SERVER
	include("ulx/sv_init.lua")
else
	include("ulx/cl_init.lua")
