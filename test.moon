cjson = require "cjson.safe"
export ulx = {}
require "tests/mocks/filesystem"
require "tests/mocks/util"
require "moon/ulx/sh_tablex"
require "moon/ulx/sh_utilx"
require "moon/ulx/sh_filesystem"
require "moon/ulx/sh_lang"

--print ulx.UtilX.Vardump file.Find("*")

--print ulx.UtilX.Vardump ulx.Directory.GetFiles("", "*.lua", true)
--print ulx.UtilX.Vardump ulx.Directory.GetFiles("locale", "english.json", true)
--print ulx.Lang.GetPhrase "SLAP"
txt = "{INITIATOR} slapped {TARGETS} {DAMAGE|NonZero:for %i damage:yay|Test|Test2}"

processFunction = (functionBlock) ->
	print functionBlock
	curPos = functionBlock\find(":", 1, true) or #functionBlock+1
	functionName = functionBlock\sub(1, curPos-1)
	print functionName
	args = {}
	while functionBlock\sub(curPos, curPos) == ":"
		nextPos = functionBlock\find(":", curPos+1, true) or #functionBlock+1
		arg = functionBlock\sub(curPos+1, nextPos-1)
		table.insert args, arg
		print #args, arg
		curPos = nextPos

--print ulx.UtilX.Vardump
for mutatorBlock in txt\gmatch("{.-}")
	print mutatorBlock
	curPos = mutatorBlock\find "[}|]", 3
	phraseName = mutatorBlock\sub(2, curPos-1)
	print phraseName

	while mutatorBlock\sub(curPos, curPos) == "|"
		nextPos = mutatorBlock\find("[}|]", curPos+1)
		functionBlock = mutatorBlock\sub(curPos+1, nextPos-1)
		processFunction functionBlock
		curPos = nextPos
	--for b, c in functionBlocks\gmatch("|(.-)(.-)[}|]")
		--print b, c
