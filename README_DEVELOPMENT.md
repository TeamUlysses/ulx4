# ULX Development Setup #

In order to make changes to ULX's codebase, perform tests, or generate documentation, you'll need the following dependencies:

## Mac ##

If you don't have it already, install Homebrew from [https://brew.sh](https://brew.sh). Once Homebrew is installed, use the following commands to install the required development dependencies:

### Required (Development) ###
```
brew install lua51
sudo luarocks-5.1 install moonscript
sudo luarocks-5.1 install LuaSocket
```

### Optional (Testing and Documentation) ###
```
brew install naturaldocs plantuml
sudo luarocks-5.1 install busted
sudo luarocks-5.1 install lua-cjson
sudo luarocks-5.1 install luafilesystem
```

## Linux ##

For Debian-based Linux distributions (like Ubuntu), use the following commands to install the required development dependencies:

#### Required (Development) ####
```
sudo apt-get install make lua5.1 luarocks
sudo luarocks install moonscript LuaSocket
```

### Optional (Testing and Documentation) ###
```
sudo apt-get install naturaldocs
sudo luarocks install busted
sudo luarocks install lua-cjson
sudo luarocks install luafilesystem
```

Installing PlantUML will take a bit more work:

```
sudo apt-get install default-jre graphvis
sudo wget -P /usr/local/lib/ -O plantuml.jar https://sourceforge.net/projects/plantuml/files/plantuml.jar/download
sudo sh -c 'echo "/usr/bin/java -jar /usr/local/lib/plantuml.jar \"\$@\"" > /usr/local/bin/plantuml'
sudo chmod 755 /usr/local/bin/plantuml
```

## Windows ##

Getting a development environment set up for Windows is currently a bit of a hassle. Keep in mind that Moonscript is the only real dependency you need for active development. The testing and documentation generation can be easily done on a Linux or Mac machine/server/VM if you have one available.

### Lua 5.1 (Required) w/ LuaRocks ###
Note: LuaRocks requires [Visual Studio (free)](https://visualstudio.microsoft.com/vs/community/) installed to compile binaries. LuaRocks makes installing some dependencies very easy. If you do not plan on installing Visual Studio, then you may choose to [install Lua5.1 binaries manually instead](http://luabinaries.sourceforge.net/download.html). We chose to keep LuaRocks in the setup guide as setup is straightforward, and it comes bundled with Lua5.1 binaries.

1. [Download LuaRocks for Windows](https://keplerproject.github.io/luarocks/releases/luarocks-2.2.0-win32.zip)
2. Use steps 3-4 below for a simple self-contained install of LuaRocks, **-OR-** follow [LuaRocks' installation instructions for windows](https://github.com/keplerproject/luarocks/wiki/Installation-instructions-for-Windows).
3. Extract the downloaded .zip into a temporary directory, and open an elevated Command Prompt in this directory.
4. Run install.bat with the following arguments, replacing `C:\luarocks` with the location of your choice. Remove the /L if you already have Lua 5.1 installed on your system:

 `install.bat /SELFCONTAINED /P C:\luarocks /L`

5. Configure your Environment Variables for LUA. The LuaRocks installation will show you the correct directories for your PATH variables. If you used the self-contained install above, here's what you should append. Replace `C:\luarocks` with the location you chose previously:
 - **PATHEXT**
`.LUA;`
 - **PATH**
`C:\luarocks\2.2;C:\luarocks\systree\bin;`
 - **LUA_PATH**
`C:\luarocks\2.2\lua\?.lua;C:\luarocks\2.2\lua\?\init.lua;C:\luarocks\systree\share\lua\5.1\?.lua;C:\luarocks\systree\share\lua\5.1\?\init.lua;`
 - **LUA_CPATH**
`C:\luarocks\systree\lib\lua\5.1\?.dll;`

### Moonscript (Required) w/ LuaSocket ###
1. If you have Visual Studio installed, simply run the following two commands in your [Visual Studio Command Prompt](https://docs.microsoft.com/en-us/dotnet/framework/tools/developer-command-prompt-for-vs):

 ```
 luarocks install moonscript
 luarocks install LuaSocket
 ```

2. If you do NOT have Visual Studio installed, then download the latest [Moonscript binaries here](https://moonscript.org/#installation/windows-binaries). Extract the files into a folder within your %PATH%, like your LuaRocks bin folder: `C:\luarocks\systree\bin`, or add a new entry to %PATH%.

### Busted (Optional) ###
1. Open the [Visual Studio Command Prompt](https://docs.microsoft.com/en-us/dotnet/framework/tools/developer-command-prompt-for-vs) (Required) and use LuaRocks to install Busted:

 `luarocks install busted`

### Natural Docs (Optional) ###
1. [Download the latest release of Natural Docs here](https://www.naturaldocs.org/download/).
2. Extract it to a location that can be accessed via %PATH%, or add a new entry to %PATH%.

### PlantUML (Optional) ###
1. PlantUML requires the [Java Runtime Environment (JRE)](https://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html).
2. PlantUML also requires GraphViz. [Download the latest version here](https://graphviz.gitlab.io/_pages/Download/Download_windows.html), and extract it to a location that can be accessed via %PATH%, or add a new entry to %PATH%.
3. Add a new environment variable called `GRAPHVIZ_DOT`, and set it to point to dot.exe in your graphviz directory: `E:\graphviz\bin\dot.exe;`
4. [Download the latest version of PlantUML here](https://sourceforge.net/projects/plantuml/files/plantuml.jar/download).
5. Put PlantUML in a location that can be accessed via %PATH%, or add a new entry to %PATH%.
6. Create a `plantuml.bat` file in the same directory, and fill it with the following contents. Replace `E:\PlantUML` with the location you put it:

 ```
 @ECHO off
 java -jar E:\PlantUML\plantuml.jar %*
 ```
