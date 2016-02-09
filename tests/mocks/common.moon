export isnumber = (o using nil) -> type(o) == "number"
export isstring = (o using nil) -> type(o) == "string"
export istable  = (o using nil) -> type(o) == "table"

table.GetKeys = (items using nil) -> [key for key, value in pairs items]

export Msg = io.write

export PrintTable = (t, indent=0, done={} using nil) ->
	keys = table.GetKeys t

	table.sort(keys, (a, b) ->
		if isnumber(a) and isnumber(b)
			return a < b
		return tostring(a) < tostring(b)
	)

	for key in *keys
		value = t[ key ]
		Msg string.rep("\t", indent)

		if istable(value) and not done[ value ]
			done[value] = true
			Msg "#{key}:\n"
			PrintTable value, indent + 2, done

		else
			Msg "#{key}\t=\t"
			Msg "#{value}\n"
