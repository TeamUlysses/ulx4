require "spec/init"

require "moon/ulx/sh_tablex"
require "moon/ulx/sh_utilx"
require "moon/ulx/sh_arguments"
require "moon/ulx/sh_command"

require "spec/mocks/command"
require "spec/mocks/entity"
require "spec/mocks/player"

describe "Test Commands", (using nil) ->
	local ply1
	setup ->
		ply1 = Player "Megiddo"
		player.Add ply1

	it "Base Command compliance", (using nil) ->
		command = ulx.Command "slap", (p, c, v, s) ->
			PrintTable(v)
			print(s)

		--RunConsoleCommand "slap", "test", "this", '"thing right" here'
		--concommand.Run ply1, "slap", {}, "hi"
		return
	return
