require "lfs"

export class file
	@Exists: (path, mount using nil) ->
		lfs.attributes(path, "mode") ~= nil

	@Read: (path, mount using nil) ->
		f = io.open path
		txt = f\read "*a"
		f\close!
		txt

	@Write: (path, text using nil) ->
		path = "data/" .. path
		f = io.open path, "w"
		f\write text
		f\close!

	@Delete: (path using nil) ->
		os.remove "data/" .. path

	@CreateDir: (path using nil) ->
		cd = "data"
		lfs.mkdir cd
		folders = ulx.UtilX.Explode "/", path
		for folder in *folders
			cd ..= "/" .. folder
			lfs.mkdir cd

	@Find: (pathPattern, mount, sorting using nil) ->
		files = {}
		folders = {}

		posLastSlash = -(pathPattern\reverse!\find("/") or 0)
		path = pathPattern\sub 1, posLastSlash
		path = "./" if path == ""
		searchPattern = pathPattern\sub posLastSlash+1
		searchPattern = searchPattern\gsub("*", ".*", 1, true)\gsub("\\.", "\\.", 1, true) -- To use in RegEx

		for file in lfs.dir path
			if file\find searchPattern
				if lfs.attributes(path .. "/" .. file, "mode") == "file"
					table.insert files, file
				elseif file ~= ".." and file ~= "."
					table.insert folders, file

		return files, folders
