require "spec/init"

require "moon/ulx/sh_tablex"
require "moon/ulx/sh_utilx"
require "moon/ulx/sh_arguments"
require "moon/ulx/sh_command"

require "spec/mocks/command"
require "spec/mocks/entity"
require "spec/mocks/player"

describe "Test Commands", (using nil) ->
	local ply1, runArgs, fn, wrappedFn
	setup ->
		ply1 = Player "Megiddo"
		player.Add ply1

	before_each ->
		fn = spy.new (ply, command, argv, args using nil) ->
		wrappedFn = (...) -> fn(...)
		runArgs = {ply1, "slap", {"arg1", "arg21 arg22"}, 'arg1 "arg21 arg22"'}

	it "tests basic adding", (using nil) ->
		command = ulx.Command "slap", wrappedFn
		concommand.Run unpack(runArgs)
		assert.spy(fn).was_called_with unpack(runArgs)

	it "tests removing", (using nil) ->
		command = ulx.Command "slap", wrappedFn

		spy.on(concommand, "Remove")

		command\ConsoleAlias{"slap2", "slap3"}
		assert.spy(concommand.Remove).was_called_with "slap"
		concommand.Remove\clear!

		command\ConsoleAlias{"slap4", "slap5"}
		assert.spy(concommand.Remove).was_called_with "slap2"
		assert.spy(concommand.Remove).was_called_with "slap3"

	it "tests multiple alias mapping correctly", (using nil) ->
		command = ulx.Command "slap", wrappedFn
		command\ConsoleAlias{"slap2", "slap3"}

		runArgs[2] = "slap2"
		concommand.Run unpack(runArgs)
		assert.spy(fn).was_called_with unpack(runArgs)

		runArgs[2] = "slap3"
		concommand.Run unpack(runArgs)
		assert.spy(fn).was_called_with unpack(runArgs)
		return
	return
