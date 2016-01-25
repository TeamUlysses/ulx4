cjson = require "cjson.safe"

export class util
	@JSONToTable: (json using nil) ->
		-- TODO, make sure return format matches
		cjson.decode json

	@TableToJSON: (tbl using nil) ->
		cjson.encode tbl
