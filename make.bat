::Batch script to emulate MAKEFILE for Windows systems
::Takes one parameter for task.
@ECHO OFF
SET choice=%1
SET tasks=clean, lua, watch, lint, map, test, diagram, doc, all

::Ask for make task if not specified
IF /I "%choice%"=="" (
SET didinput=1
echo/
echo Valid Tasks are:
echo    %tasks%
echo/
SET /P choice="What would you like to make?: "
)


::Handle task input
IF /I "%choice%"=="" GOTO INVALID
IF /I %choice%==clean (CALL :clean & GOTO end)
IF /I %choice%==lua (CALL :lua & GOTO end)
IF /I %choice%==watch ( CALL :watch & GOTO end )
IF /I %choice%==lint ( CALL :lint & GOTO end )
IF /I %choice%==map ( CALL :map & GOTO end )
IF /I %choice%==test ( CALL :test & GOTO end )
IF /I %choice%==diagram ( CALL :diagram & GOTO end )
IF /I %choice%==doc ( CALL :doc & GOTO end )
IF /I %choice%==all ( CALL :all & GOTO end )
GOTO INVALID


::Invalid task
:INVALID
echo/
echo Invalid Task.
IF NOT DEFINED didinput (
	echo Valid Tasks are:
	echo    %tasks%
	echo/
)
GOTO end



::Makefile commands
:clean
echo "clean"
GOTO :EOF

:lua
echo "lua"
GOTO :EOF

:watch
echo "watch"
GOTO :EOF

:lint
echo "lint"
GOTO :EOF

:map
echo "map"
GOTO :EOF

:test
echo "test"
GOTO :EOF

:diagram
echo "diagram"
GOTO :EOF

:doc
echo "doc"
GOTO :EOF

:all
CALL :lua
CALL :map
CALL :doc
GOTO :EOF

:end
PAUSE
