@echo off
echo 🔧 Flexible Java Compilation Script
echo ===================================

REM Set Tomcat path
set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106
set SERVLET_JAR=%TOMCAT_PATH%\lib\servlet-api.jar

echo Using servlet-api.jar: %SERVLET_JAR%
echo.

REM Create output directory
if not exist "compiled-classes" mkdir compiled-classes

echo 🔍 Searching for Java files...
echo.

REM Find and compile Java files automatically
for /R . %%f in (*.java) do (
    echo Found: %%f
    echo Compiling: %%~nxf
    javac -cp "%SERVLET_JAR%" -d compiled-classes "%%f"
    if errorlevel 1 (
        echo ❌ Failed to compile: %%~nxf
    ) else (
        echo ✅ Compiled: %%~nxf
    )
    echo.
)

echo.
echo 📁 Checking compiled classes...
if exist "compiled-classes\com" (
    echo ✅ Compilation successful!
    echo 📋 Compiled structure:
    dir /S compiled-classes\com
) else (
    echo ❌ No classes compiled successfully
    echo.
    echo 🔍 Troubleshooting:
    echo 1. Make sure Java files exist
    echo 2. Check for compilation errors above
    echo 3. Verify servlet-api.jar path
)

echo.
pause
