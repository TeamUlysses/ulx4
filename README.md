# ULX #
========

[![Build Status](https://travis-ci.org/Nayruden/ulx.svg)](https://travis-ci.org/Nayruden/ulx)

ULX is an addon for [Garry's Mod](http://garrysmod.com). Insert some witty and concise description here.

## Credits ##

### Authors ###

![Nayruden's Avatar](https://avatars3.githubusercontent.com/u/16591?s=100)
Brett "Nayruden" Smith (Team Lead)

![Stickly Man!'s Avatar](https://avatars.githubusercontent.com/u/95759?s=100)
Stickly Man! (GUI Expert)

![JamminR's Avatar](http://forums.ulyssesmod.net/index.php?action=dlattach;attach=826;type=avatar)
JamminR (Morale & Support)

### Dependencies ###

Besides the modified version of Garry's Mod's Lua 5.1, ULX pulls in the following dependencies:

[MoonScript](http://moonscript.org) - A programmer friendly language that compiles to Lua.
MoonScript was chosen for ULX in order to minimize typing, increase clarity of intent, and because it remains compatible with Garry's modifed version of Lua 5.1.

[dkjson](http://dkolf.de/src/dkjson-lua.fsl) - A [JSON](http://json.org) library.
JSON is the format of choice for ULX when writing to plain text files. This format was chosen over the existing Source KeyValues format because it's an accepted Internet standard (and thus easier to move the data around) in addition to being less prone to errors.

[Busted](http://olivinelabs.com/busted) - Elegant Lua unit testing.
Busted runs entirely outside of Garry's Mod, testing our core functionality to ensure that everything is working as advertised.

## Installation ##

Install ULX by placing the contents of this repository in `addons\ulx` such that `addon.txt` resides in `addons\ulx\addon.txt`.

## Usage ##

Type `ulx help` in your console for a list of available actions.

## Change Log ##

0.0.1 - *(00 Jan 2000)*

 * Initial relase.
