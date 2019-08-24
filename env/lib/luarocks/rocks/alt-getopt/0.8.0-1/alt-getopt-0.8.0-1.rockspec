package = "alt-getopt"
version = "0.8.0-1"
source = {
   url = "git+https://github.com/cheusov/lua-alt-getopt",
   tag = "0.8.0"
}
description = {
   summary = "Process application arguments the same way as getopt_long",
   detailed = [[
alt-getopt is a module for Lua programming language for processing
application's arguments the same way BSD/GNU getopt_long(3) functions do.
The main goal is compatibility with SUS "Utility Syntax Guidelines"
guidelines 3-13.
]],
   homepage = "https://github.com/cheusov/lua-alt-getopt",
   license = "MIT/X11"
}
dependencies = {
   "lua >= 5.1, < 5.4"
}
build = {
   type = "builtin",
   modules = {
      alt_getopt = "alt_getopt.lua"
   }
}
