export ulx = ulx or {}

initCallbacks = {} -- TODO, find better way rather than repeating this
ulx.RegisterInitCallback = (callback using nil) ->
	table.insert initCallbacks, callback

require "moonscript"

require "spec/mocks/command"
require "spec/mocks/filesystem"
require "spec/mocks/util"
require "spec/mocks/entity"
require "spec/mocks/player"

require "moon/lib/tableshape"

require "moon/ulx/sh_tablex"
require "moon/ulx/sh_utilx"
require "moon/ulx/sh_filesystem"
require "moon/ulx/sh_config"
require "moon/ulx/sh_lang"
require "moon/ulx/sh_mutators"
require "moon/ulx/sh_arguments"
require "moon/ulx/sh_command"
require "moon/ulx/sh_messaging"
require "moon/ulx/sh_player"

export unpack = unpack or table.unpack -- This gives us Lua 5.2 and 5.3 compatability
export moon = require "moon"

-- Hijack the typing system so we can pass our mock objects off as something coming from the Source engine
oldType = moon.type
moon.type = (value using nil) ->
	typ = oldType value
	if typ and typ.EngineType
		typ = typ.EngineType!
	typ


ulx.CoreConfig = ulx.Config "server"
ulx.CoreConfig\LoadAndUseDefaults
	Language: "english"
	SteamAPIKey: 123

for callback in *initCallbacks
	callback!
