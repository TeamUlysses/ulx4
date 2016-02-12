require "tests/init"

describe "Test Commands", (using nil) ->
	local ply1, runArgs, fn, wrappedFn
	setup ->
		ply1 = Player "Megiddo"
		player.Add ply1

	before_each ->
		fn = spy.new (ply, ... using nil) ->
			--print ulx.UtilX.Vardump(ply, ...)
		wrappedFn = (...) -> fn(...)
		runArgs = {ply1, "slap", {"arg1", "arg21's arg22"}, 'arg1 "arg21\'s arg22"'}
		return


	it "tests basic adding", (using nil) ->
		command = ulx.Command "slap", wrappedFn
		concommand.Run unpack(runArgs)
		--assert.spy(fn).was_called_with unpack(runArgs)
		return


	it "tests removing", (using nil) ->
		command = ulx.Command "slap", wrappedFn

		spy.on(concommand, "Remove")

		command\ConsoleAlias{"slap2", "slap3"}
		--assert.spy(concommand.Remove).was_called_with "slap"
		concommand.Remove\clear!

		command\ConsoleAlias{"slap4", "slap5"}
		--assert.spy(concommand.Remove).was_called_with "slap2"
		--assert.spy(concommand.Remove).was_called_with "slap3"
		return


	it "tests multiple alias mapping correctly", (using nil) ->
		command = ulx.Command "slap", wrappedFn
		command\ConsoleAlias{"slap2", "slap3"}

		runArgs[2] = "slap2"
		concommand.Run unpack(runArgs)
		--assert.spy(fn).was_called_with unpack(runArgs)

		runArgs[2] = "slap3"
		concommand.Run unpack(runArgs)
		--assert.spy(fn).was_called_with unpack(runArgs)
		return


	it "tests number arguments", (using nil) ->
		command = with ulx.Command "slap", wrappedFn
			\Args{
				ulx.ArgNum!\Min(0)\Max(100)
			}

		executed, msg = command\Execute ply1, {"41.2"}
		assert.True executed
		assert.spy(fn).was_called!
		assert.spy(fn).was_called_with ply1, 41.2

		fn\clear!
		command\Args{
			ulx.ArgNum!\Min(0)\Max(100)\Round(0)
		}

		command\Execute ply1, {"41.2"}
		assert.True executed
		assert.spy(fn).was_called!
		assert.spy(fn).was_called_with ply1, 41.0
		return

	it "tests arguments with bad permissions", (using nil) ->
		command = with ulx.Command "slap", wrappedFn
			\Args{
				ulx.ArgNum!\Min(0)\Max(100)
			}

		executed, msg = command\Execute ply1, {"100.1"}
		assert.False executed
		assert.spy(fn).was_not_called!

		executed, msg = command\Execute ply1, {"-0.1"}
		assert.False executed
		assert.spy(fn).was_not_called!
		return

	it "tests errors", (using nil) ->
		command = with ulx.Command "slap", wrappedFn
			\Args{
				ulx.ArgNum!\Min(0)\Max(100)
			}
		spy.on(ply1, "ChatPrint")

		executed, msg = ulx.Command.ConsoleRouter ply1, "slap", nil, "100.1"
		assert.False executed
		assert.spy(fn).was_not_called!
		assert.spy(ply1.ChatPrint).was_called_with ply1, [["slap" arg #1: Above maximum (100)]]
		ply1.ChatPrint\clear!

		executed, msg = ulx.Command.ConsoleRouter ply1, "slap", nil, "bob"
		assert.False executed
		assert.spy(fn).was_not_called!
		assert.spy(ply1.ChatPrint).was_called_with ply1, [["slap" arg #1: Cannot parse 'bob' to number]]
		return


	it "tests commands with spaces", (using nil) ->
		ulx.Command "ulx", () ->
		ulx.Command "ulx slap", wrappedFn
		ulx.Command "ulx slap dummy", wrappedFn  -- TODO, this needs so much work

		concommand.Run ply1, "ulx", {"slap"}, "slap"
		assert.spy(fn).was_called!

		fn\clear!

		concommand.Run ply1, "ulx", {"slap", "dummy"}, "slap dummy"
		assert.spy(fn).was_called!
		return

	return
