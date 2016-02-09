-- Based off GMod command module 18 Jan 2015
require "tests/mocks/common"

-- Engine definitions
AddConsoleCommand = () ->

export RunConsoleCommand = (command, ... using nil) ->
	argvPassed = {...}
	argv = {}
	args = ""
	for arg in *argvPassed
		argType = type arg
		if argType ~= "string" and argType ~= "number"
			break
		if argType == "number"
			arg = string.format "%.2f", arg
		else
			arg = arg\gsub "\"", "'"
		table.insert argv, arg
		args ..= "\"#{arg}\" "
	args = args\sub(1, -2) -- Remove last space
	concommand.Run nil, command, argv, args

-- End engine definitions

export class concommand
	@CommandList: {}
	@CompleteList: {}

	@GetTable: (using nil) ->
		@CommandList, @CompleteList

	@Add: (name, func, completefunc, help, flags using nil) ->
		LowerName = name\lower!
		@CommandList[LowerName] = func
		@CompleteList[LowerName] = completefunc
		AddConsoleCommand name, help, flags

	@Remove: (name using nil) ->
		LowerName = name\lower!
		@CommandList[LowerName] = nil
		@CompleteList[LowerName] = nil

	@Run: (player, command, arguments, args using nil) ->
		LowerCommand = command\lower!

		if @CommandList[LowerCommand] ~= nil
			@CommandList[LowerCommand] player, command, arguments, args
			return true

		Msg "Unknown command: #{command}\n"

		return false

	@AutoComplete: (command, arguments using nil) ->
		LowerCommand = command\lower!

		if @CompleteList[LowerCommand] ~= nil
			return @CompleteList[LowerCommand] command, arguments
