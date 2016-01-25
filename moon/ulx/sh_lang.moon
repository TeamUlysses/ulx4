[=[
Class: Lang

A static class used for dealing with translated messages.

Revisions:
	4.0.0 - Initial.
]=]
class ulx.Lang
	@CurrentLanguage: "english"
	@BackupLanguage: "english"
	@Phrases: {}

	@Mutators: {
		NonZero: (numToCheck, formatStr using nil) ->
			if type(numToCheck) ~= "number"
				--log.warn "Non-number passed..." -- TODO
				return ""

			if numToCheck == 0
				return ""

			return formatStr\format numToCheck

		Single: (toCheck, strIfSingle, strOtherwise) ->
			#toCheck == 1 and strIfSingle or strOtherwise
	}

	[=[
	Function: SetLanguage
	TODO
	]=]
	@SetLanguage: (language using nil) ->
		language = language\lower!
		@CurrentLanguage = language
		langFiles = ulx.Directory.GetFiles("locale", language .. ".json", true)
		phraseAccum = {}

		if #langFiles == 0
			return false

		for langFile in *langFiles
			txt = ulx.File.ReadAllText langFile
			phrases = util.JSONToTable txt
			ulx.TableX.UnionByKey phraseAccum, phrases, true

		@Phrases = phraseAccum
		return true
	@.SetLanguage @CurrentLanguage -- TODO, make cvar

	[=[
	Function: GetPhrase
	TODO
	]=]
	@GetPhrase: (phraseName using nil) ->
		@Phrases[phraseName]

	[=[
	Function: AddMutator
	TODO
	]=]
	@AddMutator: (name, func using nil) ->
		@Mutators[name] = func

	[=[
	Function: GetMutatedPhrase
	TODO
	]=]
	@GetMutatedPhrase: (phraseName, data using nil) ->
		txt = @.GetPhrase phraseName
		mutatedPhrase = txt\gsub("{.-}", (mutatorBlock using nil) ->
			--print mutatorBlock
			curPos = mutatorBlock\find "[}|]", 3
			replacementName = mutatorBlock\sub(2, curPos-1)
			--print phraseName

			--mutated = data[replacementName]
			mutatorFunctionsAndArguments = {}
			while mutatorBlock\sub(curPos, curPos) == "|"
				nextPos = mutatorBlock\find("[}|]", curPos+1)
				functionBlock = mutatorBlock\sub(curPos+1, nextPos-1)
				fn, args = getFunction functionBlock, mutated
				table.insert mutatorFunctionsAndArguments, {fn, args}
				curPos = nextPos

			replacement = data[replacementName]
			mutated = callMutatorChain replacement, mutatorFunctionsAndArguments
			if type(mutated) == "table"
				mutated = mutateListToString replacement, callMutatorChain, mutatorFunctionsAndArguments

			--print mutated
			return mutated
		)

		return ulx.UtilX.Trim mutatedPhrase

	getFunction = (functionBlock, txt) ->
		--print functionBlock
		curPos = functionBlock\find(":", 1, true) or #functionBlock+1
		functionName = functionBlock\sub(1, curPos-1)
		--print functionName
		args = {}
		while functionBlock\sub(curPos, curPos) == ":"
			nextPos = functionBlock\find(":", curPos+1, true) or #functionBlock+1
			arg = functionBlock\sub(curPos+1, nextPos-1)
			table.insert args, arg
			--print #args, arg
			curPos = nextPos

		return @Mutators[functionName], args

	mutateListToString = (list, fn, ... using nil) ->
		str = ""
		for i=1, #list-2
			str ..= fn(list[i], ...) .. ", "

		if #list > 1
			mutated = fn(list[#list-1], ...)
			conjuction = " " .. @.GetPhrase("AND") .. " "
			str ..= mutated .. conjuction

		str ..= fn(list[#list], ...)
		return str

	callMutatorChain = (replacement, mutatorFunctionsAndArguments using nil) ->
		for mutatorFunctionsAndArgument in *mutatorFunctionsAndArguments
			fn = mutatorFunctionsAndArgument[1]
			args = mutatorFunctionsAndArgument[2]
			replacement = fn(replacement, unpack(args))
		return replacement
