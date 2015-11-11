[=[
Class: Plugin

Used to create a new ULX plugin. Stores plugin configuration information as well and offers an API to interact with ULX.

Revisions:
	4.0.0 - Initial.
]=]
class Plugin
	[=[
	Variables: Plugin Variables
	All these variables are optional.

		Name           - A *string* name of the plugin.
		Author         - A *string* author of the plugin.
		Description    - A *string* description of the plugin.
		Category       - A *string* category of the plugin. Use a single word category for grouping similar plugins together.
		                 E.G., "Fun", "Utility", "Teleport". Use the singular version of whatever word you use.
		ReleaseVersion - A *string* version of the plugin. We recommend using <Semantic Versioning at http://semver.org>.
	]=]
	Name:           "Unknown"
	Author:         "Unknown"
	Description:    "Not set"
	Category:       "Unknown"
	ReleaseVersion: "0.0.0"
	
	AddCommand: (name, callback) =>
		return with Commmand!
			.Category = @Category
