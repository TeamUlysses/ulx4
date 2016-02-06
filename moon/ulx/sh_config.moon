[=[
Class: Config
A class used for configuration setting management.
]=]
class ulx.Config
	@__base.__index = (key) =>
		base = getmetatable @
		fromBase = base[key]
		if fromBase ~= nil
			return fromBase
		values = rawget @, "Values"
		if values
			return values[key]

	@__base.__newindex = (key, value) =>
		values = @Values
		if values and not ulx.TableX.HasValueI({"Name", "Shape", "Values", "Path"}, key)
			values[key] = value
		else
			rawset @, key, value

	[=[
	Function: new
	TODO
	]=]
	new: (@Name, @Shape using nil) =>
		ulx.UtilX.CheckArg "Config", 1, "string", @Name
		ulx.UtilX.CheckArg "Config", 2, {"nil", tableshape.BaseType}, @Shape
		@Path = "data/ulx/config/#{@Name}.json.txt"
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
		if not ulx.File.Exists @Path
			return false, "File does not exist"

		txt = ulx.File.ReadAllText @Path
		data = util.JSONToTable txt

		if not data
			return false, "File is not valid JSON"

		if @Shape
			valid, msg = @Shape.check_value data
			if not valid
				return false, msg

		-- TODO, clear out "extra" values in data that don't belong.
		@Values = data

	[=[
	Function: Save
	TODO
	]=]
	Save: (using nil) =>
		txt = util.TableToJSON @Values
		ulx.File.WriteAllText @Path, txt
