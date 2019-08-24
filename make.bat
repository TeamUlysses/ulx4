::Batch script to emulate MAKEFILE for Windows systems
::Takes one parameter for task. Otherwise, prompt user for input.
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
IF /I %choice%==watch GOTO :watch
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
FOR /D %%I IN ("lua\*") DO (
	IF /I NOT %%I==lua\lib (
		RMDIR /S /Q %%I
		ECHO Removed %%I
	)
)
FOR %%I IN ("lua\*") DO (
	DEL /Q %%I
	ECHO Removed %%I
)
IF EXIST map RMDIR /S /Q map
ECHO Cleanup finished.
GOTO :EOF


:lua
PUSHD moon & moonc -t ../lua * & POPD
GOTO :EOF


:watch
PUSHD moon & moonc -w -t ../lua * & POPD
GOTO :EOF


:lint
CALL moonc -l moon
GOTO :EOF


:map
SETLOCAL enabledelayedexpansion
PUSHD moon
::Create DIRs if they don't exist.
FOR /F %%D IN ('DIR /B /S /A:D %CD%') DO (
	SET _B=%%D
	SET _RELDIR=!_B:%CD%\=!
	IF NOT EXIST ..\maps\!_RELDIR! MKDIR ..\maps\!_RELDIR!
)
FOR /R %%I IN ("*.moon") DO (
	SET _B=%%I
	SET _RELFILE=!_B:%CD%\=!
	CALL moonc -X ^!_RELFILE^! > ..\maps\!_RELFILE!.map
	ECHO Mapped !_RELFILE!

)
POPD
GOTO :EOF


:test
CALL busted
GOTO :EOF


:diagram
CALL plantuml -tpng -o ../diagrams -nbthread auto doc/uml/*.iuml
ECHO Diagram finished.
GOTO :EOF


:doc
CALL naturaldocs -r -i . -o HTML doc -p doc/ndinfo
GOTO :EOF


:all
CALL :lua
CALL :map
CALL :doc
GOTO :EOF


:end
PAUSE
