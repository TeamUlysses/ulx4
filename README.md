# ULX #

[![Build Status](https://travis-ci.org/Nayruden/ulx.svg)](https://travis-ci.org/Nayruden/ulx)

ULX is an addon for [Garry's Mod](http://garrysmod.com). Insert some witty and concise description here.

ULX is licensed under the MIT license. For an easy-to-understand summary of the license, please check out [tl;dr Legal](https://tldrlegal.com/license/mit-license).

Note that ULX is written primarily in [MoonScript](http://moonscript.org) (described below). Even though Garry's Mod will be running the compiled version of the MoonScript, we ship ULX with both the original and the compiled source for your convenience.



## Credits ##


### Authors ###

![Nayruden's Avatar](https://avatars.githubusercontent.com/u/16591?s=100)
[Brett "Nayruden" Smith](https://github.com/Nayruden) (Team Lead)

![Stickly Man!'s Avatar](https://avatars.githubusercontent.com/u/95759?s=100)
[Stickly Man!](https://github.com/SticklyMan) (GUI Expert)

![JamminR's Avatar](http://forums.ulyssesmod.net/index.php?action=dlattach;attach=826;type=avatar)
[JamminR](http://forums.ulyssesmod.net/index.php?action=profile;u=133) (Morale & Support)


### Dependencies ###

#### Runtime Dependencies (Included) ####

Besides the modified version of Garry's Mod's Lua 5.1, ULX needs the following dependencies to function. These dependencies are included with ULX.

[dkjson](http://dkolf.de/src/dkjson-lua.fsl) - A [JSON](http://json.org) library.
JSON is the format of choice for ULX when writing to plain text files. This format was chosen over the existing Source KeyValues format because it's an accepted Internet standard (and thus easier to move the data around) in addition to being less prone to errors.

#### Development Dependencies (Not Included) ####

ULX's codebase and documentation were built using the following tools. You do not need these dependencies installed for ULX to function.

[MoonScript](http://moonscript.org) - A programmer friendly language that compiles to Lua.
MoonScript was chosen for ULX in order to minimize typing, increase clarity of intent, and because it remains compatible with Garry's modified version of Lua 5.1.

[Busted](http://olivinelabs.com/busted) - Elegant Lua unit testing.
Busted tests our core functionality to ensure that everything is working as advertised.

[Natural Docs](http://naturaldocs.org) - Documentation generator.
Natural Docs generates ULX documentation from comments in the source code and is available online at http://ulyssesmod.net/ulx4-doc.

[PlantUML](http://plantuml.sf.net) - Generates [Unified Modeling Language (UML)](http://www.uml.org/) diagrams from plain-text descriptions.
This allows us to quickly document ULX source structure without the hassle of a graphical UML editor.



## Installation ##

Install ULX by placing the contents of this repository in `addons\ulx` such that `addon.txt` resides in `addons\ulx\addon.txt`. Your file structure should look like the following:

![File structure](http://nayruden.github.io/ulx/doc/diagrams/file-structure.png)



## Usage ##

Type `ulx help` in your console for a list of available actions.



## Development Setup ##

In order to make changes to ULX's codebase, perform tests, generate documentation, you'll need the following dependencies:

### Windows ###


### Mac ###

If you don't have it already, install Homebrew from [http://brew.sh](http://brew.sh). Once Homebrew is installed, use the following commands to install the required development dependencies:

##### Required (Development) #####
```
brew install lua51 luarocks
luarocks install moonscript LuaSocket
```

##### Optional (Testing and Documentation) #####
```
brew install naturaldocs plantuml
luarocks install busted
```

### Linux ###

For Debian-based Linux distributions (like Ubuntu), use the following commands to install the required development dependencies:

##### Required (Development) #####
```
sudo apt-get install make lua5.1 luarocks
sudo luarocks install moonscript LuaSocket
```

##### Optional (Testing and Documentation) #####
```
sudo apt-get install naturaldocs
sudo luarocks install busted
```

Installing PlantUML will take a bit more work:

```
sudo apt-get install default-jre graphvis
sudo wget -P /usr/local/lib/ -O plantuml.jar http://sourceforge.net/projects/plantuml/files/plantuml.jar/download
sudo sh -c 'echo "/usr/bin/java -jar /usr/local/lib/plantuml.jar \"\$@\"" > /usr/local/bin/plantuml'
sudo chmod 755 /usr/local/bin/plantuml
```



## Change Log ##

### 1.0.0 - (00 Jan 0000) ###

 * Initial release.
