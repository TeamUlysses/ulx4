dataFolder = "data/"
verifyAndRemoveDataFolder = (path) ->
	assert(path\sub(1, #dataFolder) == dataFolder, "cannot write outside of data directory")
	path\sub #dataFolder + 1

[=[
Class: File

An adapter class used for file accesses. This is necessary because Garry's API changes frequently.

Revisions:
	4.0.0 - Initial.
]=]
class ulx.File
	[=[
	Function: Exists
	TODO

	Revisions:
		4.0.0 - Initial.
	]=]
	@Exists: (path, mount="GAME" using nil) ->
		-- TODO type checking and mounting
		file.Exists path, mount

	[=[
	Function: ReadAllText
	TODO

	Revisions:
		4.0.0 - Initial.
	]=]
	@ReadAllText: (path, mount="GAME" using nil) ->
		-- TODO type checking and mounting
		file.Read path, mount

	[=[
	Function: WriteAllText
	TODO

	Revisions:
		4.0.0 - Initial.
	]=]
	@WriteAllText: (path, txt, mount="GAME" using nil) ->
		-- TODO type checking and mounting
		if mount == "GAME"
			path = verifyAndRemoveDataFolder path

		file.Write path, txt

	[=[
	Function: Delete
	TODO

	Revisions:
		4.0.0 - Initial.
	]=]
	@Delete: (path, mount="GAME" using nil) ->
		-- TODO type checking and mounting
		if mount == "GAME"
			path = verifyAndRemoveDataFolder path

		file.Delete path


[=[
Class: Directory

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
	@GetFiles: (path="", searchPattern="*", searchRecursive=false, mount="GAME" using nil) ->
		-- TODO type checking and mounting
		files = GetFilesHelper path, searchPattern, searchRecursive, mount, {}
		files

	[=[
	Function: CreateDirectory
	TODO

	Revisions:
		4.0.0 - Initial.
	]=]
	@CreateDirectory: (path) ->
		-- TODO type checking
		path = verifyAndRemoveDataFolder path
		file.CreateDir path

	GetFilesHelper = (path, searchPattern, searchRecursive, mount, filesAccum using nil) ->
		if path ~= "" and path\sub(-1) ~= "\\"
			path ..= "/"

		files = file.Find(path .. searchPattern, mount)
		dummy, dirs = file.Find(path .. "*", mount)

		for file in *files
			table.insert(filesAccum, path .. file)

		if searchRecursive
			for dir in *dirs
				GetFilesHelper(path .. dir, searchPattern, searchRecursive, mount, filesAccum)

		return filesAccum
