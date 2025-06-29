@echo off
setlocal enabledelayedexpansion

echo 🧠 Smart Java Compilation Script
echo =================================

REM Set Tomcat path
set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106
set SERVLET_JAR=%TOMCAT_PATH%\lib\servlet-api.jar

echo Using servlet-api.jar: %SERVLET_JAR%
echo Current directory: %CD%
echo.

REM Create output directory
if not exist "compiled-classes" mkdir compiled-classes

echo 🔍 Auto-detecting project structure...
echo.

REM Try different possible structures
set FOUND_JAVA=0

REM Check standard Maven structure
if exist "src\main\java" (
    echo ✅ Found Maven structure: src\main\java
    set JAVA_PATH=src\main\java
    set FOUND_JAVA=1
    goto :compile
)

REM Check if Java files are in current directory
for %%f in (*.java) do (
    echo ✅ Found Java files in current directory
    set JAVA_PATH=.
    set FOUND_JAVA=1
    goto :compile
)

REM Check if there's a java folder
if exist "java" (
    echo ✅ Found java folder
    set JAVA_PATH=java
    set FOUND_JAVA=1
    goto :compile
)

REM Check if there's a main folder
if exist "main\java" (
    echo ✅ Found main\java structure
    set JAVA_PATH=main\java
    set FOUND_JAVA=1
    goto :compile
)

if %FOUND_JAVA%==0 (
    echo ❌ No Java files found!
    echo.
    echo 📝 Please ensure your Java files are in one of these locations:
    echo 1. src\main\java\com\himami\...
    echo 2. Current directory
    echo 3. java\com\himami\...
    echo 4. main\java\com\himami\...
    echo.
    echo Run create-java-files.bat to create the proper structure
    pause
    exit /b 1
)

:compile
echo.
echo 🔄 Compiling Java files from: %JAVA_PATH%
echo.

REM Compile all Java files recursively
for /R "%JAVA_PATH%" %%f in (*.java) do (
    echo Compiling: %%~nxf
    javac -cp "%SERVLET_JAR%" -d compiled-classes "%%f"
    if errorlevel 1 (
        echo ❌ Failed: %%~nxf
        set COMPILE_ERROR=1
    ) else (
        echo ✅ Success: %%~nxf
    )
)

echo.
echo 📁 Checking results...

if exist "compiled-classes\com\himami" (
    echo ✅ Compilation successful!
    echo.
    echo 📋 Compiled classes:
    dir /S /B compiled-classes\*.class
    echo.
    echo 📁 Structure:
    tree compiled-classes /F
    echo.
    echo 🎯 Next steps:
    echo 1. Copy 'compiled-classes\com' folder to your WAR's WEB-INF\classes\
    echo 2. Or use the deployment script to create a complete WAR file
) else (
    echo ❌ Compilation failed or no classes generated
    echo.
    echo 🔍 Troubleshooting:
    echo 1. Check compilation errors above
    echo 2. Verify Java files exist and have correct package declarations
    echo 3. Make sure servlet-api.jar path is correct
)

echo.
pause
