# ULX #

[![Build Status](https://travis-ci.org/Nayruden/ulx.svg)](https://travis-ci.org/Nayruden/ulx)

ULX is an addon for [Garry's Mod](http://garrysmod.com). Insert some witty and concise description here.

ULX is licensed under the MIT license. For an easy-to-understand summary of the license, please check out [tl;dr Legal](https://tldrlegal.com/license/mit-license).

Note that ULX is written primarily in [MoonScript](http://moonscript.org) (described below). Even though Garry's Mod will be running the compiled version of the MoonScript, we ship ULX with both the original and the compiled source for your convenience.

## Credits ##

### Authors ###

![Nayruden's Avatar](https://avatars3.githubusercontent.com/u/16591?s=100)
[Brett "Nayruden" Smith](https://github.com/Nayruden) (Team Lead)

![Stickly Man!'s Avatar](https://avatars.githubusercontent.com/u/95759?s=100)
[Stickly Man!](https://github.com/SticklyMan) (GUI Expert)

![JamminR's Avatar](http://forums.ulyssesmod.net/index.php?action=dlattach;attach=826;type=avatar)
[JamminR](http://forums.ulyssesmod.net/index.php?action=profile;u=133) (Morale & Support)

### Dependencies ###

#### Runtime Dependencies ####

Besides the modified version of Garry's Mod's Lua 5.1, ULX pulls in the following dependencies:

[dkjson](http://dkolf.de/src/dkjson-lua.fsl) - A [JSON](http://json.org) library.
JSON is the format of choice for ULX when writing to plain text files. This format was chosen over the existing Source KeyValues format because it's an accepted Internet standard (and thus easier to move the data around) in addition to being less prone to errors.

#### Development Dependencies ####

In order to blah blah:

[MoonScript](http://moonscript.org) - A programmer friendly language that compiles to Lua.
MoonScript was chosen for ULX in order to minimize typing, increase clarity of intent, and because it remains compatible with Garry's modified version of Lua 5.1.

[Busted](http://olivinelabs.com/busted) - Elegant Lua unit testing.
Busted runs entirely outside of Garry's Mod, testing our core functionality to ensure that everything is working as advertised.

[Natural Docs](http://naturaldocs.org) - Blah

[PlantUML](http://plantuml.sf.net) - Blah

## Installation ##

Install ULX by placing the contents of this repository in `addons\ulx` such that `addon.txt` resides in `addons\ulx\addon.txt`.

## Usage ##

Type `ulx help` in your console for a list of available actions.

## Change Log ##

0.0.1 - *(00 Jan 2000)*

 * Initial release.