[=[
Class: Command

Used to create a new command. Commands are always tied to the console, and optionally to chat as well.

Revisions:
	1.0.0 - Initial.
]=]
class Command
	[=[
	Variables: Command Variables
	All these variables are optional, with sensible defaults.

		Tip          - A *string* tip/help for the command.
		Access       - A *string* of the group who gets access to the command by default.
		Category     - A *string* category for the command. See <Plugin.Category>.
		               This is normally set by the plugin, but you can override it here.
		ChatAlias    - A *string* or *table* of the chat command alias(es) for the command.
		               _Defaults to the command parameter passed to <new()>, prefixed with the default chat prefix_.
		ConsoleAlias - A *string* or *table* of the console command alias(es) for the command.
		               _Defaults to the command parameter passed to <new()>_.
		Args         - A *table* of the arguments (of type <Argument>) for the command.
	]=]
	Tip:          ""
	Access:       "user"
	Category:     "unknown"
	ChatAlias:    {}
	ConsoleAlias: {}
	Args:         {}


	[=[
	Function: new

	Creates a new command.

	Parameters:
		name     - A *string* command name (E.G., "ulx slap").
		callback - A *function* to call when the command is invoked.
		           The callback gets called with the arguments specified in the <Args> variable.

	Revisions:
		1.0.0 - Initial.
	]=]
	new: (name, callback) =>


with plugin\Command( "command", ulx.command ) -- Chat alias is automatically assumed, can override with .ChatAlias = ...
	.Tip = "Help text"
	.Access = "admin"
	--.Category = "fun" -- Only need to specify if differing from plugin category
	--.ChatAlias = "command" or {"cmd", "command"} for multiple - if unspecified, "command" from first line is assumed
	--.ConsoleAlias = "cmd" or {"cmd1", "cmd2"} for multiple
	.Args = {
		ArgPlayer! -- help text for arguments automatically contains "player to <command name>"
		ArgTime!\Optional!\min 0 -- help text "time (in minutes) to <command name>"
		ArgString!\Optional!\Greedy!\RestrictToCompletes!\Completes tbl
	}
	.Restrictions = {
		RestrictToOnceEvery "1 hour"
		RestrictToTime "1500-1700" --???
		RestrictToAbsenceOf "%superadmin"
		RestrictToPresenceOf "#user"
		RestrictCustom (ply, ...) -> if ply\IsAlive() then return false, "you must be alive to run this command" else return true
	}
	