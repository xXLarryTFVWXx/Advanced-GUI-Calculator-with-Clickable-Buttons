@ECHO OFF
IF "%~1"=="/?" GOTO Syntax

IF "%~1"=="" (
	GOTO :Skip
) ELSE (
	SETLOCAL ENABLEDELAYEDEXPANSION
	FOR /F "tokens=*" %%A IN ('VER ^| TIME') DO (
		IF "!TimeBefore!"=="" (
			SET TimeBefore=%%A
			SET TimeBefore=!TimeBefore:,=.!
			FOR %%B IN (!TimeBefore!) DO (
				SET TimeBefore=%%B
			)
		)
	)
)

(SET CALL=)
:: Note the trailing space after CALL=CALL
IF /I "%~x1"==".bat" (SET CALL=CALL )
IF /I "%~x1"==".cmd" (SET CALL=CALL )
%CALL%%*
(SET CALL=)

:Skip
SET RC=%ErrorLevel%
IF NOT "%~1"=="" (
	FOR /F "tokens=*" %%A IN ('VER ^| TIME') DO (
		IF "!TimeAfter!"=="" (
			SET TimeAfter=%%A
			SET TimeAfter=!TimeAfter:,=.!
			FOR %%B IN (!TimeAfter!) DO (
				SET TimeAfter=%%B
			)
		)
	)
)

ECHO.
ECHO [RC=%RC%]
IF "%~1"=="" (
	SET RC=& EXIT /B %RC%
) ELSE (
	FOR /F "tokens=1-4 delims=:.," %%A IN ("%TimeBefore%") DO (
		SET HoursBefore=%%A
		SET MinutesBefore=%%B
		SET SecondsBefore=%%C
		SET FractBefore=%%D
	)
	FOR /F "tokens=1-4 delims=:.," %%A IN ("%TimeAfter%") DO (
		SET HoursAfter=%%A
		SET MinutesAfter=%%B
		SET SecondsAfter=%%C
		SET FractAfter=%%D
	)
	FOR %%A IN (HoursAfter MinutesAfter SecondsAfter FractAfter HoursBefore MinutesBefore SecondsBefore FractBefore) DO CALL :RemoveLeadingZero %%A
	SET /A Hours   = !HoursAfter!   - !HoursBefore!
	SET /A Minutes = !MinutesAfter! - !MinutesBefore!
	SET /A Seconds = !SecondsAfter! - !SecondsBefore!
	SET /A Fract   = !FractAfter!   - !FractBefore!
	SET /A TimeDif =  100 * !Hours!   + !Minutes!
	SET /A TimeDif =  100 * !TimeDif! + !Seconds!
	SET /A TimeDif = 1000 * !TimeDif! + 10 * !Fract!
	ECHO [Time=!TimeDif! ms]
	ENDLOCAL & EXIT /B %RC%
)


:RemoveLeadingZero
SET TempVar=!%1!
IF "%TempVar:~0,1%"=="0" SET TempVar=%TempVar:~1%
IF "%TempVar:~0,1%"==""  SET TempVar=0
SET %1=%TempVar%
GOTO:EOF


:Syntax
ECHO.
ECHO RC.bat,  Version 2.11 for Windows NT
ECHO Display a command's return code ("errorlevel") and execution time
ECHO.
ECHO Usage:  RC  command  parameters
ECHO    or:  command  parameters ^&  RC
ECHO.
ECHO Written by Rob van der Woude
ECHO http://www.robvanderwoude.com
