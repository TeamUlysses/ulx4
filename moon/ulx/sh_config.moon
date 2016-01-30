[=[
Class: Config
A class used for configuration setting management.

Revisions:
	4.0.0 - Initial.
]=]
class ulx.Config
	@__base.__index = (key) =>
		--print ulx.UtilX.Vardump @
		base = getmetatable @
		fromBase = base[key]
		if fromBase ~= nil
			return fromBase
		values = rawget @, "Values"
		if values
			return values[key]

	[=[
	Function: new
	TODO
	]=]
	new: (@Name, @Shape using nil) =>
		ulx.UtilX.CheckArg "Config", 1, "string", @Name
		ulx.UtilX.CheckArg "Config", 2, {"nil", tableshape.BaseType}, @Shape
		return

	[=[
	Function: LoadAndUseDefaults
	TODO
	]=]
	LoadAndUseDefaults: (defaults using nil) =>
		success, msg = @Load!

		@Values = @Values or {}
		@Values = ulx.TableX.UnionByKey defaults, @Values

		return success, msg

	[=[
	Function: LoadAndUseDefaultsIfBadFile
	TODO
	]=]
	LoadAndUseDefaultsIfBadFile: (defaults using nil) =>
		success, msg = @Load!
		if not success
			@Values = defaults

		return success, msg

	[=[
	Function: Load
	TODO
	]=]
	Load: (using nil) =>
		path = "data/ulx/config/#{@Name}.json.txt"

		if not ulx.File.Exists path
			return false, "File does not exist"

		txt = ulx.File.ReadAllText path
		data = util.JSONToTable txt

		if not data
			return false, "File is not valid JSON"

		if @Shape
			valid, msg = @Shape.check_value data
			if not valid
				return false, msg

		-- TODO, clear out "extra" values in data that don't belong.
		@Values = data
