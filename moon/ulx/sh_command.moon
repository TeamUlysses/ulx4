[=[
Class: Command
Used to create a new command. Commands are always tied to the console, and optionally to chat as well.

Revisions:
	4.0.0 - Initial.
]=]
class ulx.Command
	[=[
	Function: ShortcutFn
	Only available statically, meant for internal use only.
	]=]
	@ShortcutFn = (name, typ, default using nil) =>
		@__base[name] = (val=default using nil) =>
			ulx.UtilX.CheckArg "#{@@__name}.#{name}", 1, typ, val
			@["_" .. name] = val
			@

	@CmdList: {}


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
		_Args         - A *table* of the arguments (of type <Argument>) for the command.
		_Restrictions - A *table* of the restrictions (of type <Restriction>) for the command.
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

	@ShortcutFn "Name", "string"
	@ShortcutFn "Callback", "function"
	@ShortcutFn "Hint", "string"
	@ShortcutFn "Access", {"string", "table"}
	@ShortcutFn "Category", "string"
	@ShortcutFn "ChatAlias", {"string", "table"}
	--@ShortcutFn "ConsoleAlias", {"string", "table"}
	@ShortcutFn "Args", "table"
	@ShortcutFn "Restrictions", "table"
	@ShortcutFn "Plugin", {"nil", "Plugin"}

	UnregisterCommands: (using nil) =>
		for alias in *@_ConsoleAlias
			@@CmdList[alias] = nil
			concommand.Remove alias

	ConsoleAlias: (aliases using nil) =>
		ulx.UtilX.CheckArg "#{@@__name}.ConsoleAlias", 1, {"string", "table"}, aliases, 2

		@UnregisterCommands!
		aliases = {aliases} if type(aliases) == "string"
		for alias in *aliases
			@@CmdList[alias] = self
			concommand.Add alias, @_Callback, nil, @_Hint
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
