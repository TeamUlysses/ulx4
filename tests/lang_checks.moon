require "tests/init"

describe "Translation completeness check", ->
	english = ulx.Lang "english"
	allLangs = ulx.Directory.GetFiles "locale", "*.json", true
	allLangs = [ulx.Path.GetFileNameWithoutExtension(path) for path in *allLangs]
	allLangs = ulx.TableX.RemoveDuplicateValues( allLangs )
	allLangsButEnglish = [lang for lang in *allLangs when lang ~= "english"]

	it "ensures other languages have all phrases included in English", ->
		messageAccum = ""
		basePhrases = english.Phrases
		for lang in *allLangsButEnglish
			langInstance = ulx.Lang lang
			langPhrases = langInstance.Phrases
			diff = ulx.TableX.DifferenceByKey basePhrases, langPhrases
			diff = [k for k, v in pairs(diff)]
			if #diff > 0
				messageAccum ..= "\nLanguage '#{lang}' does not contain the following phrases:\n#{table.concat(diff, "\n")}\n\n"

		if #messageAccum > 0
			assert false, messageAccum
		return

	return
