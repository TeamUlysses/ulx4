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
	@GetPhrase: (phrase using nil) ->
		@Phrases[phrase]
