require "moonscript"

export unpack = unpack or table.unpack -- This gives us Lua 5.2 and 5.3 compatability
export moon = require "moon"
export ulx = ulx or {}

-- Hijack the typing system so we can pass our mock objects off as something coming from the Source engine
oldType = moon.type
moon.type = (value using nil) ->
	typ = oldType value
	if typ and typ.Type
		typ = typ.Type!
	typ
