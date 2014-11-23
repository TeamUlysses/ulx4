--[[
Class: Command

Used to create a new command. Commands are always tied to the console, and optionally to chat as well.

Revisions:
	1.0.0 - Initial.
]]
class Command
	--[[
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
	]]
	Tip:    ""
	Access: "user"
	Args:   ArgCommandCaller!
	
	--[[
	Function: new
		
	Creates a new command.
		
	Parameters:
		name     - A *string* command name (E.G., "ulx slap").
		callback - A *function* to call when the command is invoked.
		           The callback gets called with the arguments specified in the <Args> variable.
	
	Revisions:
		1.0.0 - Initial.
	]]
	new: (name, callback) =>
