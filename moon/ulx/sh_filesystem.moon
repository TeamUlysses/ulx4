[=[
Class: File

An adapter class used for file accesses. This is necessary because Garry's API changes frequently.

Revisions:
	4.0.0 - Initial.
]=]
class ulx.File
	[=[
	Function: ReadAllText
	TODO

	Revisions:
		4.0.0 - Initial.
	]=]
	@ReadAllText: (path, mount="GAME" using nil) ->
		-- TODO type checking
		file.Read path, search


[=[
Class: File

An adapter class used for directory accesses. This is necessary because Garry's API changes frequently.

Revisions:
	4.0.0 - Initial.
]=]
class ulx.Directory
	[=[
	Function: GetFiles
	TODO

	Revisions:
		4.0.0 - Initial.
	]=]
	@GetFiles: (path=".", searchPattern="*", searchRecursive=false, mount="GAME" using nil) ->
		-- TODO type checking + recurisve
		files, dirs = file.Find path .. "/" .. searchPattern, mount
		files
