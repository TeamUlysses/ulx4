AddCSLuaFile("autorun/ulx4_init.lua")
AddCSLuaFile("ulx4/cl_init.lua")

file.CreateDir("ulx")

if SERVER
	include("ulx4/sv_init.lua")
else
	include("ulx4/cl_init.lua")
