[=[
Class: Command
Used to create a new command. Commands are always tied to the console, and optionally to chat as well.

Revisions:
	4.0.0 - Initial.
]=]
class ulx.Command
	@CmdMap: {}

	lang = ulx.Lang -- shortcut

	[=[
	Function: ShortcutFn
	Only available statically, meant for internal use only.
	]=]
	@ShortcutFn: (name, typ, default using nil) ->
		@__base[name] = (val=default using nil) =>
			ulx.UtilX.CheckArg "#{@@__name}.#{name}", 1, typ, val
			@["_" .. name] = val
			@


	splitCommandNameAndArgv = (initialCommandStr, argv using nil) ->
		commandStr = initialCommandStr
		while #argv > 0
			newCommandStr = commandStr .. " " .. argv[1]
			if not @CmdMap[newCommandStr]
				break
			commandStr = newCommandStr
			table.remove argv, 1

		return commandStr, argv

	[=[
	Function: ConsoleRouter
	This static callback function is primarily meant to act as the buffer between the Source console and ULX. *You probably should not call this directly*.
	This function is called by the engine, executes the appropriate callback, and prints any errors back to the caller.

	Parameters:
		ply - The *player* calling the command.
		commandStr - A *string* containing the first word of whatever was specified on console.
		argv - A *list of strings* as parsed by the Source engine but is *ignored* in this function, since Source parses these oddly.
		args - A *string* of everything but the first word of whatever was specified on console. This is used to build our own argv.
	]=]
	@ConsoleRouter: (ply, commandFirstWord, argv, args using nil) ->
		-- Default argv doesn't parse some things correctly, so just do it ourselves
		-- Examples of things that default argv chokes on...
		-- MyCmd hi:there
		-- MyCmd we don't like single quotes
		-- MyCmd http://google.com -- though this information is LOST, so we can't fix it
		argv = ulx.UtilX.SplitArgs args
		commandName, argv = splitCommandNameAndArgv commandFirstWord, argv

		success, argNum, msg = @.ExecutionRouter ply, commandName, argv

		if not success
			fullMsg = lang.GetMutatedPhrase "COMMAND_ARG_MESSAGE",
				COMMANDNAME: commandName
				ARGNUM: argNum
				MESSAGE: msg
			ulx.TSayRed ply, fullMsg
			return false, fullMsg

		return true

	[=[
	Function: ExecutionRouter
	TODO
	]=]
	@ExecutionRouter: (ply, commandName, argv using nil) ->
		cmd = @CmdMap[commandName]
		if not cmd
			--log.warn "ExecutionRouter received unknown command" -- TODO
			return false, lang.GetMutatedPhrase "COMMAND_UNKNOWN",
				COMMANDNAME: commandName

		cmd\Execute ply, argv


	[=[
	Variables: Command Variables
	All these variables are optional, with sensible defaults. *Do not set these directly*. Instead, call the setter
	function of the same name without the underscore. E.G., call `Name("Billy Bob")`.

		_Name         - A *string* of the name of the command.
		_Callback     - A *function* to callback when the command is called.
		_Hint         - A one-line hint *string* for the command.
		_Access       - A *string* or *table* of the groups that get access to the command by default.
		_Category     - A *string* category for the command. See <Plugin.Category>.
		               This is normally set by the plugin, but you can override it here.
		_ChatAlias    - A *string* or *table* of the chat command alias(es) for the command.
		               _Defaults to the command parameter passed to <new()>, prefixed with the default chat prefix_.
		_ConsoleAlias - A *string* or *table* of the console command alias(es) for the command.
		               _Defaults to the command parameter passed to <new()>_.
		_Args         - A *list of <Arguments>* for the command.
		_Restrictions - A *list of <Restrictions>* for the command.
		_Plugin       - TODO
	]=]
	_Name:         nil
	_Callback:     nil
	_Hint:         ""
	_Access:       {}
	_Category:     "unknown"
	_ChatAlias:    {}
	_ConsoleAlias: {}
	_Args:         {}
	_Restrictions: {}
	_Plugin:       {}

	@.ShortcutFn "Name", "string"
	@.ShortcutFn "Callback", "function"
	@.ShortcutFn "Hint", "string"
	@.ShortcutFn "Access", {"string", "table"}
	@.ShortcutFn "Category", "string"
	@.ShortcutFn "ChatAlias", {"string", "table"}
	--@.ShortcutFn "ConsoleAlias", {"string", "table"}
	@.ShortcutFn "Args", "table"
	@.ShortcutFn "Restrictions", "table"
	@.ShortcutFn "Plugin", {"nil", "Plugin"}

	UnregisterCommands: (using nil) =>
		for alias in *@_ConsoleAlias
			@@CmdMap[alias] = nil
			concommand.Remove alias

	ConsoleAlias: (aliases using nil) =>
		ulx.UtilX.CheckArg "#{@@__name}.ConsoleAlias", 1, {"string", "table"}, aliases, 2

		@UnregisterCommands!
		aliases = {aliases} if type(aliases) == "string"
		for alias in *aliases
			@@CmdMap[alias] = self
			concommand.Add alias, @@ConsoleRouter, nil, @_Hint
		@_ConsoleAlias = aliases


	[=[
	Function: new
	Creates a new command.

	Parameters:
		name     - A *string* command name (E.G., "slap").
		callback - A *function* to call when the command is invoked.
		           The callback gets called with the arguments specified in the <Args> variable.
		plugin   - TODO

	Revisions:
		4.0.0 - Initial.
	]=]
	new: (name, callback, plugin using nil) =>
		ulx.UtilX.CheckArgs "Command", {{"string", name},
		                            {"function", callback},
		                            {{"nil", ulx.Plugin}, plugin}}, 3

		@Name name
		@Callback callback
		@ChatAlias "!" .. name
		@ConsoleAlias name
		@Plugin plugin

	[=[
	Function: Execute
	TODO
	]=]
	Execute: (ply, argvRaw using nil) =>
		-- TODO, check access
		argvParsed = {}
		cmdArgs = @_Args

		for i=1, #cmdArgs
			cmdArg = cmdArgs[i]
			argRaw = argvRaw[i]
			argParsed = argRaw
			if type(argRaw) ~= "number"
				parsed, returned = cmdArg\Parse argRaw
				if not parsed
					return false, i, returned
				argParsed = returned

			permissible, msg = cmdArg\IsPermissible argParsed
			if not permissible
				return false, i, msg

			argvParsed[i]=argParsed

		@._Callback ply, unpack(argvParsed)
		return true

[=[
with plugin\Command( "command", ulx.command ) -- Chat alias is automatically assumed, can override with .ChatAlias = ...
	\Hint "Hint text"
	\Access "admin"
	--\Category "fun" -- Only need to specify if differing from plugin category
	--\ChatAlias "command" or {"cmd", "command"} for multiple - if unspecified, "command" from first line is assumed
	--\ConsoleAlias "cmd" or {"cmd1", "cmd2"} for multiple
	\Args{
		ArgPlayer! -- help text for arguments automatically contains "player to <command name>"
		ArgTime!\Optional!\min 0 -- help text "time (in minutes) to <command name>"
		ArgString!\Optional!\Greedy!\RestrictToCompletes!\Completes tbl
	}
	\Restrictions{
		RestrictToOnceEvery "1 hour"
		RestrictToTime "1500-1700" --???
		RestrictToAbsenceOf "%superadmin"
		RestrictToPresenceOf "#user"
		RestrictToCustom (ply, ...) -> if ply\IsAlive() then return false, "you must be alive to run this command" else return true
	}
]=]
