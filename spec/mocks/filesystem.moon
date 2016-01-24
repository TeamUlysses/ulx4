require "lfs"

export class file
	@Read: (path, mount using nil) ->
		f = io.open path
		f\read "*a"

	@Find: (pathPattern, mount, sorting using nil) ->
		files = {}
		folders = {}

		posLastSlash = -(pathPattern\reverse!\find("/") or 0)
		path = pathPattern\sub 1, posLastSlash
		path = "./" if path == ""
		searchPattern = pathPattern\sub posLastSlash+1
		searchPattern = searchPattern\gsub("*", ".*", 1, true)\gsub(".", "\.", 1, true) -- To use in RegEx

		for file in lfs.dir path
			if file\find searchPattern
				if lfs.attributes(path .. "/" .. file, "mode") == "file"
					table.insert files, file
				elseif file ~= ".." and file ~= "."
					table.insert folders, file

		return files, folders
