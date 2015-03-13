::Batch script to emulate MAKEFILE for Windows systems
::Takes one parameter for task.
@ECHO OFF
SET choice=%1

::Ask for make task if not specified
IF /I "%choice%"=="" (
SET didinput=1
echo.
echo Valid Tasks are:
echo    clean, lua, watch, lint, map, test, diagram, doc
echo.
SET /P choice="What would you like to make?: "
)


::Handle task input
IF /I "%choice%"=="" GOTO INVALID
IF /I %choice%==clean GOTO clean
IF /I %choice%==lua GOTO lua
IF /I %choice%==watch GOTO watch
IF /I %choice%==lint GOTO lint
IF /I %choice%==map GOTO map
IF /I %choice%==test GOTO test
IF /I %choice%==diagram GOTO diagram
IF /I %choice%==doc GOTO doc
GOTO INVALID


::Invalid task
:INVALID
echo.
echo Invalid Task.
IF NOT DEFINED %didinput% (
echo Valid Tasks are:
echo    clean, lua, watch, lint, map, test, diagram, doc
echo.
)
PAUSE
GOTO :EOF



::Makefile commands
:clean
echo "clean"
PAUSE
GOTO :EOF

:lua
echo "lua"
PAUSE
GOTO :EOF

:watch
echo "watch"
PAUSE
GOTO :EOF

:lint
echo "lint"
PAUSE
GOTO :EOF

:map
echo "map"
PAUSE
GOTO :EOF

:test
echo "test"
PAUSE
GOTO :EOF

:diagram
echo "diagram"
PAUSE
GOTO :EOF

:doc
echo "doc"
PAUSE
GOTO :EOF

