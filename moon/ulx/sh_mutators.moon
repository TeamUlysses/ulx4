[=[
File: Mutators
A file containing mutators which are added to <Lang>.

Revisions:
	4.0.0 - Initial.
]=]

class Mutators
	[=[
	Mutator: NonZero
	Tests for non-nil and non-zero.

	Accepts:
		A *number*.

	Parameters:
		1 - A *string* which is formatted with the passed number, if the number is non-zero. Defaults to _""_ (an empty string).
		2 - A *string* which is formatted with the passed number, if the number is zero or nil. Defaults to _""_ (an empty string).

	Example:
		"Slap {DAMAGE|NonZero:for %i damage}" -> Shows "Slap for 3 damage" if 3 is passed for DAMAGE.

		"Slap {DAMAGE|NonZero:for %i damage}" -> Shows "Slap" if 0 or nil is passed for DAMAGE.
	]=]
	NonZero: (numToCheck, strIfNonZero="", strOtherwise="" using nil) ->
		typ = type toCheck
		if typ ~= "number" and typ ~= "nil"
			--log.warn "Non-number passed..." -- TODO
			return ""

		if numToCheck == nil or numToCheck == 0
			return strOtherwise\format numToCheck
		else
			return strIfNonZero\format numToCheck

	[=[
	Mutator: Single
	TODO
	]=]
	Single: (toCheck, strIfSingle="", strOtherwise="") ->
		typ = type toCheck
		if typ ~= "table" and typ ~= "string"
			--log.warn "Non-countable passed..." -- TODO
			return ""

		return #toCheck == 1 and strIfSingle or strOtherwise

-- Now register these with Lang.
for name, fn in pairs Mutators.__base
	if name\sub(1, 1) ~= "_"
		ulx.Lang.AddMutator name, fn
