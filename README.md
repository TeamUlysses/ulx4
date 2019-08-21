# ULX #

[![Build Status](https://travis-ci.org/TeamUlysses/ulx4.svg?branch=master)](https://travis-ci.org/TeamUlysses/ulx4)

### NOTE: This version of ULX is in early development, and is not currently a full replacement for ULX 3. Do not run this on your servers yet! ###

ULX is an addon for [Garry's Mod](http://garrysmod.com). Insert some witty and concise description here.

ULX is licensed under the MIT license. For an easy-to-understand summary of the license, please check out [tl;dr Legal](https://tldrlegal.com/license/mit-license).

Note that ULX is written primarily in [MoonScript](http://moonscript.org) (described below). Even though Garry's Mod will be running the compiled version of the MoonScript, we ship ULX with both the original and the compiled source for your convenience.



## Credits ##

### Authors ###

![Nayruden's Avatar](https://avatars.githubusercontent.com/u/16591?s=100)
[Brett "Nayruden" Smith](https://github.com/Nayruden) (Team Lead)

![Stickly Man!'s Avatar](https://avatars.githubusercontent.com/u/95759?s=100)
[Stickly Man!](https://github.com/SticklyMan) (GUI Expert)

![JamminR's Avatar](https://forums.ulyssesmod.net/index.php?action=dlattach;attach=1721;type=avatar)
[JamminR](http://forums.ulyssesmod.net/index.php?action=profile;u=133) (Morale & Support)

![MrPresident's Avatar](http://g4p.org/Forum/uploads/avatars/avatar_3.jpg)
[MrPresident](https://forums.ulyssesmod.net/index.php?action=profile;u=758) (Developer)

![Timmy's Avatar](http://timmy.github.io/images/cloister-black-t.png)
[Timmy](https://github.com/timmy) (Developer)

### Translations ###

The following amazing folks have contributed translations for ULX.

* **German** - [Markus](https://github.com/markusmarkusz)
* **Portuguese** - [Bruno "comedinha" Carvalho](https://github.com/comedinha)
* **Russian** - [Fixator10](https://github.com/fixator10)

### Dependencies ###

#### Runtime Dependencies (Included) ####

Besides the modified version of Garry's Mod's Lua 5.1, ULX needs the following dependencies to function. These dependencies are included with ULX.

[tableshape](https://github.com/leafo/tableshape) - A Lua library for verifying the shape (schema, structure, etc.) of a table.
This helps ULX verify the validity of data as it's being loaded or moved around.

#### Development Dependencies (Not Included) ####

ULX's codebase and documentation were built using the following tools. You do not need these dependencies installed for ULX to function.

[MoonScript](http://moonscript.org) - A programmer friendly language that compiles to Lua.
MoonScript was chosen for ULX in order to minimize typing, increase clarity of intent, and because it remains compatible with Garry's modified version of Lua 5.1.

[Busted](http://olivinelabs.com/busted) - Elegant Lua unit testing.
Busted tests our core functionality to ensure that everything is working as advertised.

[lua-cjson](http://www.kyne.com.au/~mark/software/lua-cjson.php) - A [JSON](http://json.org) library.
JSON is the format of choice for ULX when writing to plain text files. This format was chosen over the existing Source KeyValues format because it's an accepted Internet standard (and thus easier to move the data around) in addition to being less prone to errors. Garry's Mod natively supports JSON, but we need to process JSON data in our unit tests.

[LuaFileSystem](https://keplerproject.github.io/luafilesystem/) - File System Library for the Lua Programming Language.
This is necessary since vanilla Lua only implements very basic file I/O functionality.

[Natural Docs](http://naturaldocs.org) - Documentation generator.
Natural Docs generates ULX documentation from comments in the source code and is available online at http://ulyssesmod.net/ulx4-doc.

[PlantUML](http://plantuml.sf.net) - Generates [Unified Modeling Language (UML)](http://www.uml.org/) diagrams from plain-text descriptions.
This allows us to quickly document ULX source structure without the hassle of a graphical UML editor.



## Installation ##

Install ULX by placing the contents of this repository in `addons\ulx` such that `addon.txt` resides in `addons\ulx\addon.txt`. Your file structure should look like the following:

![File structure](http://teamulysses.github.io/ulx4/doc/diagrams/file-structure.png)



## Usage ##

Type `ulx help` in your console for a list of available actions.


## Development ##

If you want to change or add to ULX, please review [the developer's read me](README_DEVELOPMENT.md).
