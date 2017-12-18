@Echo off
SetLocal EnableDelayedExpansion
Cd Files
cls
Title Advanced GUI Calculator by Kvc - v.1.0
Mode 80,25

:top
Set _Count=1
Set _String=

For /L %%X in (1,4,12) do (
	For /L %%Y in (1,6,18) do (
		Call Getlen "!_Count!"
		Set "_String=!_String! %%Y %%X F0 "!_Count!" "
		Set /a _Count+=1
		Set _X=%%Y
		Set _Y=%%X
		)
	)

Set /a _Y+=4
Set _X=1
For %%A in ("+" "0" "x") do (
	Set "_String=!_String! !_X! !_Y! F0 "%%~A" " 
	Set /a _X+=6
	)

Set /a _Y+=4
Set _X=1
For %%A in ("-" "D" "E") do (
	Set "_String=!_String! !_X! !_Y! F0 "%%~A" " 
	Set /a _X+=6
	)

Set "_String=!_String! X _Var _Hover"

Set _Count=1
Set _ID_10=+
Set _ID_12=x
Set _ID_13=-
Set _ID_14=D
Set _ID_15=E
Call Box.bat 20 1 8 55 - - 0F 1 
Call Button !_String!


:Loop
GetInput /I 500 /M %_Var% /H %_Hover%

If %Errorlevel% LEQ 9 (Set "_number_%_Count%=!_number_%_Count%!!Errorlevel!")
If %Errorlevel% EQU 11 (Set "_number_%_Count%=!_number_%_Count%!0")

If %Errorlevel% EQU 10 (Set "_operation_%_Count%=+"&&Set /A _Count+=1)
If %Errorlevel% EQU 12 (Set "_operation_%_Count%=*"&&Set /A _Count+=1)
If %Errorlevel% EQU 13 (Set "_operation_%_Count%=-"&&Set /A _Count+=1)
If %Errorlevel% EQU 14 (Set "_operation_%_Count%=/"&&Set /A _Count+=1)
If %Errorlevel% EQU 15 (goto :result)

Set __y=3
For /l %%A in (1,1,%_Count%) do (
	Batbox /g 22 !__Y! /d "!_number_%%A!" 
	Set /a __y+=1
	)
Goto :Loop

:result
Set _result=%_number_1%
For /l %%A in (2,1,%_Count%) do (
	Set /a _op=%%A - 1
	For %%X in ("!_op!") do (Set /A _result=!_result! !_operation_%%~X! !_number_%%A!)
	)
title %_result%
Goto :top