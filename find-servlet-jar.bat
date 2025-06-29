@echo off
echo 🔍 Finding servlet-api.jar on your system...
echo ============================================

echo Searching common locations...
echo.

REM Check common Tomcat locations
for %%d in (C D E F) do (
    if exist "%%d:\apache-tomcat*\lib\servlet-api.jar" (
        echo ✅ Found Tomcat servlet-api.jar:
        dir /B "%%d:\apache-tomcat*\lib\servlet-api.jar"
        echo Full path: %%d:\apache-tomcat*\lib\servlet-api.jar
        echo.
    )
)

REM Check Program Files
if exist "C:\Program Files\Apache Software Foundation\Tomcat*\lib\servlet-api.jar" (
    echo ✅ Found in Program Files:
    dir /B "C:\Program Files\Apache Software Foundation\Tomcat*\lib\servlet-api.jar"
    echo.
)

REM Check current directory
if exist "servlet-api.jar" (
    echo ✅ Found in current directory:
    echo %CD%\servlet-api.jar
    echo.
)

echo 📝 If not found, you can:
echo 1. Download from: https://mvnrepository.com/artifact/javax.servlet/javax.servlet-api
echo 2. Install Apache Tomcat
echo 3. Use Maven/Gradle for dependency management
echo.

pause
