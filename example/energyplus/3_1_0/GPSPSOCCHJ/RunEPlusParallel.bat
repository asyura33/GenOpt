@echo off
 if Not "%2" == "" goto :NoErr
 echo This is a modified version of the file RunEPlus.bat that is distributed
 echo with EnergyPlus. The modifications allow running multiple EnergyPlus
 echo simulations in parallel. To use EnergyPlus with GenOpt, this file need
 echo to be used instead of the original RunEPlus.bat file.
 echo The GenOpt configuration file for EnergyPlus (cfg\EnergyPlusWinXP.cfg)
 echo automatically invokes the RunEPlus.bat file from the directory that contains
 echo the GenOpt initialization file.
 echo Therefore, this version of RunEPlus.bat can co-exist with the original version
 echo as long as they are in different directories.
 echo
 echo Modifications done by Michael Wetter, 2009-03-03:
 echo - Updated file to reflect changes in RunEPlus.bat 
 echo   between EnergyPlus 3.0.0 and 3.1.0
 echo Modifications done by Michael Wetter, 2009-03-03:
 echo - Set directory names so that multiple EnergyPlus versions can run in
 echo   parallel.
 echo - Hard-coded path to EnergyPlus.exe. This is needed since there is no
 echo   environment variable, such as the ENERGYPLUS_DIR variable on Mac.
 echo
 echo usage: %0 InputFileName (req) WeatherFileName (opt)
 echo Current Parameters:
 echo Program         : %program_path%%program_name%
 echo Input Path      : %input_path%
 echo Output Path     : %output_path%
 echo PostProcess Path: %post_proc%
 echo Weather Path    : %weather_path%
 echo Pausing         : %pausing%
 echo MaxCol          : %maxcol%
 goto :done

:NoErr
:Instructions:
:  Complete the following path and program names.
:  path names must have a following \ or errors will happen
:  does not have the capability to run input macro files (yet)
:   %program_path% contains the path to the executable as well as IDD and is
:                  the root directory
:   %program_name% contains the name of the executable (normally EnergyPlus.exe)
:   %input_path%   contains the path to the input file (passed in as first argument)
:                  if the extension is imf -- will run epmacro to process before
:                  executing energyplus
:   %output_path%  contains the path where the result files should be stored
:   %post_proc%    contains the path to the post processing program (ReadVarsESO)
:   %weather_path% contains the path to the weather files (used with optional argument 2)
:   %pausing%      contains Y if pause should occur between major portions of
:                  batch file (mostly commented out)
:   %maxcol%       contains "250" if limited to 250 columns otherwise contains
:                  "nolimit" if unlimited (used when calling readVarsESO)
 echo ===== %0 (Run EnergyPlus) %1 %2 ===== Start =====
: Currently, there is no environment variable that points to the E+ directory.
: We hard-code it here.  
 set program_path=C:\Program Files\EnergyPlusV3-1-0\
 set program_name=EnergyPlus.exe
: Set the input_path to the current working directory
 for /F %%x in ('CHDIR') do set input_path=%%x\
 set output_path=%input_path%
 set post_proc=%program_path%PostProcess\
 set weather_path=%program_path%WeatherData\
 set pausing=N
 set maxcol=250
 
:  This batch file will perform the following steps:
:
:   1.  Clean up directory by deleting old working files from prior run
:   2.  Clean up target directory
:   3.  Copy %1.idf (input) into In.idf (or %1.imf to in.imf)
:   4.  Copy %2 (weather) into In.epw
:   5.  Execute EnergyPlus
:   6.  If available Copy %1.rvi (post processor commands) into Eplusout.inp
:   7.  Execute ReadVarsESO.exe (the Post Processing Program)
:   8.  If available Copy %1.mvi (post processor commands) into test.mvi
:       or create appropriate input to get meter output from eplusout.mtr
:   9.  Execute ReadVarsESO.exe (the Post Processing Program) for meter output
:  10.  Copy Eplusout.* to %1.*
:  11.  Clean up working directory.
:
:  1. Clean up working directory
IF EXIST eplusout.inp   DEL eplusout.inp
IF EXIST eplusout.end   DEL eplusout.end
IF EXIST eplusout.eso   DEL eplusout.eso
IF EXIST eplusout.rdd   DEL eplusout.rdd
IF EXIST eplusout.mdd   DEL eplusout.mdd
IF EXIST eplusout.dbg   DEL eplusout.dbg
IF EXIST eplusout.eio   DEL eplusout.eio
IF EXIST eplusout.err   DEL eplusout.err
IF EXIST eplusout.dxf   DEL eplusout.dxf
IF EXIST eplusout.csv   DEL eplusout.csv
IF EXIST eplusout.tab   DEL eplusout.tab
IF EXIST eplusout.txt   DEL eplusout.txt
IF EXIST eplusmtr.csv   DEL eplusmtr.csv
IF EXIST eplusmtr.tab   DEL eplusmtr.tab
IF EXIST eplusmtr.txt   DEL eplusmtr.txt
IF EXIST eplusout.sln   DEL eplusout.sln
IF EXIST epluszsz.csv   DEL epluszsz.csv
IF EXIST epluszsz.tab   DEL epluszsz.tab
IF EXIST epluszsz.txt   DEL epluszsz.txt
IF EXIST eplusssz.csv   DEL eplusssz.csv
IF EXIST eplusssz.tab   DEL eplusssz.tab
IF EXIST eplusssz.txt   DEL eplusssz.txt
IF EXIST eplusout.mtr   DEL eplusout.mtr
IF EXIST eplusout.mtd   DEL eplusout.mtd
IF EXIST eplusout.bnd   DEL eplusout.bnd
IF EXIST eplusout.dbg   DEL eplusout.dbg
IF EXIST eplusout.sci   DEL eplusout.sci
IF EXIST eplusmap.csv   DEL eplusmap.csv
IF EXIST eplusmap.txt   DEL eplusmap.txt
IF EXIST eplusmap.tab   DEL eplusmap.tab
IF EXIST eplustbl.csv   DEL eplustbl.csv
IF EXIST eplustbl.txt   DEL eplustbl.txt
IF EXIST eplustbl.tab   DEL eplustbl.tab
IF EXIST eplustbl.htm   DEL eplustbl.htm
IF EXIST eplusout.log   DEL eplusout.log
IF EXIST eplusout.svg   DEL eplusout.svg
IF EXIST eplusout.shd   DEL eplusout.shd
IF EXIST eplusout.wrl   DEL eplusout.wrl
IF EXIST eplusout.delightin   DEL eplusout.delightin
IF EXIST eplusout.delightout  DEL eplusout.delightout
IF EXIST eplusout.delighteldmp  DEL eplusout.delighteldmp
IF EXIST eplusout.delightdfdmp  DEL eplusout.delightdfdmp
IF EXIST eplusout.sparklog  DEL eplusout.sparklog
IF EXIST eplusscreen.csv  DEL eplusscreen.csv
IF EXIST in.imf         DEL in.imf
IF EXIST in.idf         DEL in.idf
IF EXIST out.idf        DEL out.idf
IF EXIST audit.out      DEL audit.out
IF EXIST in.epw         DEL in.epw
IF EXIST in.stat        DEL in.stat
IF EXIST eplusout.audit DEL eplusout.audit
IF EXIST test.mvi       DEL test.mvi
IF EXIST audit.out DEL audit.out
IF EXIST expanded.idf   DEL expanded.idf
IF EXIST expandedidf.err   DEL expandedidf.err
IF EXIST readvars.audit   DEL readvars.audit
IF EXIST eplusout.sql  DEL eplusout.sql
IF EXIST sqlite.err  DEL sqlite.err
:if %pausing%==Y pause

:  2. Clean up target directory
IF NOT EXIST "%output_path%". MKDIR "%output_path%"

IF EXIST "%output_path%%1.epmidf" DEL "%output_path%%1.epmidf"
IF EXIST "%output_path%%1.epmdet" DEL "%output_path%%1.epmdet"
IF EXIST "%output_path%%1.eso" DEL "%output_path%%1.eso"
IF EXIST "%output_path%%1.rdd" DEL "%output_path%%1.rdd"
IF EXIST "%output_path%%1.mdd" DEL "%output_path%%1.mdd"
IF EXIST "%output_path%%1.eio" DEL "%output_path%%1.eio"
IF EXIST "%output_path%%1.err" DEL "%output_path%%1.err"
IF EXIST "%output_path%%1.dxf" DEL "%output_path%%1.dxf"
IF EXIST "%output_path%%1.csv" DEL "%output_path%%1.csv"
IF EXIST "%output_path%%1.tab" DEL "%output_path%%1.tab"
IF EXIST "%output_path%%1.txt" DEL "%output_path%%1.txt"
IF EXIST "%output_path%%1Meter.csv" DEL "%output_path%%1Meter.csv"
IF EXIST "%output_path%%1Meter.tab" DEL "%output_path%%1Meter.tab"
IF EXIST "%output_path%%1Meter.txt" DEL "%output_path%%1Meter.txt"
IF EXIST "%output_path%%1.det" DEL "%output_path%%1.det"
IF EXIST "%output_path%%1.sln" DEL "%output_path%%1.sln"
IF EXIST "%output_path%%1.Zsz" DEL "%output_path%%1.Zsz"
IF EXIST "%output_path%%1Zsz.csv" DEL "%output_path%%1Zsz.csv"
IF EXIST "%output_path%%1Zsz.tab" DEL "%output_path%%1Zsz.tab"
IF EXIST "%output_path%%1Zsz.txt" DEL "%output_path%%1Zsz.txt"
IF EXIST "%output_path%%1.ssz" DEL "%output_path%%1.ssz"
IF EXIST "%output_path%%1Ssz.csv" DEL "%output_path%%1Ssz.csv"
IF EXIST "%output_path%%1Ssz.tab" DEL "%output_path%%1Ssz.tab"
IF EXIST "%output_path%%1Ssz.txt" DEL "%output_path%%1Ssz.txt"
IF EXIST "%output_path%%1.mtr" DEL "%output_path%%1.mtr"
IF EXIST "%output_path%%1.mtd" DEL "%output_path%%1.mtd"
IF EXIST "%output_path%%1.bnd" DEL "%output_path%%1.bnd"
IF EXIST "%output_path%%1.dbg" DEL "%output_path%%1.dbg"
IF EXIST "%output_path%%1.sci" DEL "%output_path%%1.sci"
IF EXIST "%output_path%%1.svg" DEL "%output_path%%1.svg"
IF EXIST "%output_path%%1.shd" DEL "%output_path%%1.shd"
IF EXIST "%output_path%%1.wrl" DEL "%output_path%%1.wrl"
IF EXIST "%output_path%%1Screen.csv" DEL "%output_path%%1Screen.csv"
IF EXIST "%output_path%%1Map.csv" DEL "%output_path%%1Map.csv"
IF EXIST "%output_path%%1Map.tab" DEL "%output_path%%1Map.tab"
IF EXIST "%output_path%%1Map.txt" DEL "%output_path%%1Map.txt"
IF EXIST "%output_path%%1.audit" DEL "%output_path%%1.audit"
IF EXIST "%output_path%%1Table.csv" DEL "%output_path%%1Table.csv"
IF EXIST "%output_path%%1Table.tab" DEL "%output_path%%1Table.tab"
IF EXIST "%output_path%%1Table.txt" DEL "%output_path%%1Table.txt"
IF EXIST "%output_path%%1Table.html" DEL "%output_path%%1Table.html"
IF EXIST "%output_path%%1Table.htm" DEL "%output_path%%1Table.htm"
IF EXIST "%output_path%%1DElight.in" DEL "%output_path%%1DElight.in"
IF EXIST "%output_path%%1DElight.out" DEL "%output_path%%1DElight.out"
IF EXIST "%output_path%%1DElight.dfdmp" DEL "%output_path%%1DElight.dfdmp"
IF EXIST "%output_path%%1DElight.eldmp" DEL "%output_path%%1DElight.eldmp"
IF EXIST "%output_path%%1Spark.log" DEL "%output_path%%1Spark.log"
IF EXIST "%output_path%%1.expidf" DEL "%output_path%%1.expidf"
IF EXIST "%output_path%%1.rvaudit" DEL "%output_path%%1.rvaudit"
IF EXIST "%output_path%%1.sql" DEL "%output_path%%1.sql"

:  3. Copy input data file to working directory
copy "%program_path%Energy+.idd" "Energy+.idd"
copy "%program_path%Energy+.ini" "Energy+.ini"
if exist "%1.imf" copy "%1.imf" in.imf
if exist in.imf "%program_path%EPMacro"
if exist out.idf copy out.idf "%output_path%%1.epmidf"
if exist audit.out copy audit.out "%output_path%%1.epmdet"
if exist audit.out erase audit.out
if exist out.idf MOVE out.idf in.idf
if not exist in.idf copy "%1.idf" In.idf
if exist in.idf "%program_path%ExpandObjects"
if exist expandedidf.err COPY expandedidf.err eplusout.end
if exist expanded.idf COPY expanded.idf "%output_path%%1.expidf"
if exist expanded.idf MOVE expanded.idf in.idf
if not exist in.idf copy "%1.idf" In.idf

:  4. Test for weather file parameter and copy to working directory
 if "%2" == ""  goto exe
 if EXIST "%weather_path%%2.epw" copy "%weather_path%%2.epw" in.epw
 if EXIST "%weather_path%%2.stat"  copy "%weather_path%%2.stat" in.stat

:  5. Execute the program
:exe
 : Display basic parameters of the run
 echo Running "%program_path%%program_name%"
 cd 
 echo Program path: %program_path%
 echo Input File  : %input_path%%1.idf
 echo Output Files: %output_path%
 echo IDD file    : %program_path%Energy+.idd
 if NOT "%2" == "" echo Weather File: %weather_path%%2.epw
dir
 if %pausing%==Y pause
 
 ECHO Begin EnergyPlus processing . . . 
 IF NOT EXIST expandedidf.err  "%program_path%%program_name%"
 if %pausing%==Y pause
 

:  6&8. Copy Post Processing Program command file(s) to working directory
 IF EXIST "%1.rvi" copy "%1.rvi" eplusout.inp
 IF EXIST "%1.mvi" copy "%1.mvi" eplusmtr.inp

:  7&9. Run Post Processing Program(s)
if %maxcol%==250     SET rvset=
if %maxcol%==nolimit SET rvset=unlimited
: readvars creates audit in append mode.  start it off
echo %date% %time% ReadVars >readvars.audit

IF EXIST eplusout.inp "%post_proc%ReadVarsESO.exe" eplusout.inp %rvset%
IF NOT EXIST eplusout.inp "%post_proc%ReadVarsESO.exe" " " %rvset%
IF EXIST eplusmtr.inp "%post_proc%ReadVarsESO.exe" eplusmtr.inp %rvset%
IF NOT EXIST eplusmtr.inp echo eplusout.mtr >test.mvi
IF NOT EXIST eplusmtr.inp echo eplusmtr.csv >>test.mvi
IF NOT EXIST eplusmtr.inp "%post_proc%ReadVarsESO.exe" test.mvi %rvset%
IF EXIST eplusout.bnd "%post_proc%HVAC-Diagram.exe"

:  10. Move output files to output path
 IF EXIST eplusout.eso MOVE eplusout.eso "%output_path%%1.eso"
 IF EXIST eplusout.rdd MOVE eplusout.rdd "%output_path%%1.rdd"
 IF EXIST eplusout.mdd MOVE eplusout.mdd "%output_path%%1.mdd"
 IF EXIST eplusout.eio MOVE eplusout.eio "%output_path%%1.eio"
 IF EXIST eplusout.err MOVE eplusout.err "%output_path%%1.err"
 IF EXIST eplusout.dxf MOVE eplusout.dxf "%output_path%%1.dxf"
 IF EXIST eplusout.csv MOVE eplusout.csv "%output_path%%1.csv"
 IF EXIST eplusout.tab MOVE eplusout.tab "%output_path%%1.tab"
 IF EXIST eplusout.txt MOVE eplusout.txt "%output_path%%1.txt"
 IF EXIST eplusmtr.csv MOVE eplusmtr.csv "%output_path%%1Meter.csv"
 IF EXIST eplusmtr.tab MOVE eplusmtr.tab "%output_path%%1Meter.tab"
 IF EXIST eplusmtr.txt MOVE eplusmtr.txt "%output_path%%1Meter.txt"
 IF EXIST eplusout.sln MOVE eplusout.sln "%output_path%%1.sln"
 IF EXIST epluszsz.csv MOVE epluszsz.csv "%output_path%%1Zsz.csv"
 IF EXIST epluszsz.tab MOVE epluszsz.tab "%output_path%%1Zsz.tab"
 IF EXIST epluszsz.txt MOVE epluszsz.txt "%output_path%%1Zsz.txt"
 IF EXIST eplusssz.csv MOVE eplusssz.csv "%output_path%%1Ssz.csv"
 IF EXIST eplusssz.tab MOVE eplusssz.tab "%output_path%%1Ssz.tab"
 IF EXIST eplusssz.txt MOVE eplusssz.txt "%output_path%%1Ssz.txt"
 IF EXIST eplusout.mtr MOVE eplusout.mtr "%output_path%%1.mtr"
 IF EXIST eplusout.mtd MOVE eplusout.mtd "%output_path%%1.mtd"
 IF EXIST eplusout.bnd MOVE eplusout.bnd "%output_path%%1.bnd"
 IF EXIST eplusout.dbg MOVE eplusout.dbg "%output_path%%1.dbg"
 IF EXIST eplusout.sci MOVE eplusout.sci "%output_path%%1.sci"
 IF EXIST eplusmap.csv MOVE eplusmap.csv "%output_path%%1Map.csv"
 IF EXIST eplusmap.tab MOVE eplusmap.tab "%output_path%%1Map.tab"
 IF EXIST eplusmap.txt MOVE eplusmap.txt "%output_path%%1Map.txt"
 IF EXIST eplusout.audit MOVE eplusout.audit "%output_path%%1.audit"
 IF EXIST eplustbl.csv MOVE eplustbl.csv "%output_path%%1Table.csv"
 IF EXIST eplustbl.tab MOVE eplustbl.tab "%output_path%%1Table.tab"
 IF EXIST eplustbl.txt MOVE eplustbl.txt "%output_path%%1Table.txt"
 IF EXIST eplustbl.htm MOVE eplustbl.htm "%output_path%%1Table.html"
 IF EXIST eplusout.delightin MOVE eplusout.delightin "%output_path%%1DElight.in"
 IF EXIST eplusout.delightout  MOVE eplusout.delightout "%output_path%%1DElight.out"
 IF EXIST eplusout.delighteldmp  MOVE eplusout.delighteldmp "%output_path%%1DElight.eldmp"
 IF EXIST eplusout.delightdfdmp  MOVE eplusout.delightdfdmp "%output_path%%1DElight.dfdmp"
 IF EXIST eplusout.svg MOVE eplusout.svg "%output_path%%1.svg"
 IF EXIST eplusout.shd MOVE eplusout.shd "%output_path%%1.shd"
 IF EXIST eplusout.wrl MOVE eplusout.wrl "%output_path%%1.wrl"
 IF EXIST eplusscreen.csv MOVE eplusscreen.csv "%output_path%%1Screen.csv"
 IF EXIST eplusout.sparklog MOVE eplusout.sparklog "%output_path%%1Spark.log"
 IF EXIST expandedidf.err copy expandedidf.err+eplusout.err "%output_path%%1.err"
 IF EXIST readvars.audit MOVE readvars.audit "%output_path%%1.rvaudit"
 IF EXIST eplusout.sql MOVE eplusout.sql "%output_path%%1.sql"

:   11.  Clean up directory.
 ECHO Removing extra files . . .
 IF EXIST eplusout.inp DEL eplusout.inp
 IF EXIST eplusmtr.inp DEL eplusmtr.inp
 IF EXIST in.idf       DEL in.idf
 IF EXIST in.imf       DEL in.imf
 IF EXIST in.epw       DEL in.epw
 IF EXIST in.stat      DEL in.stat
 IF EXIST eplusout.dbg DEL eplusout.dbg
 IF EXIST test.mvi DEL test.mvi
 IF EXIST expandedidf.err DEL expandedidf.err
 IF EXIST readvars.audit DEL readvars.audit
 IF EXIST sqlite.err  DEL sqlite.err
 
 :done
 echo ===== %0 %1 %2 ===== Complete =====
exit