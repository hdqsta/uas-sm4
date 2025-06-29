@echo off
echo 🧪 Quick Test - Compile One File
echo =================================

set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106
set SERVLET_JAR=%TOMCAT_PATH%\lib\servlet-api.jar

echo Testing compilation with your structure...
echo.

REM Test compile one simple file
echo Testing Participant.java...
javac -cp "%SERVLET_JAR%" -d . main\java\com\himami\model\Participant.java

if exist "com\himami\model\Participant.class" (
    echo ✅ SUCCESS! Compilation works with your structure
    echo.
    echo 📁 Created:
    dir /S com\*.class
    echo.
    echo 🎯 You can now run: compile-for-your-structure.bat
    
    REM Cleanup test
    rmdir /S /Q com
) else (
    echo ❌ FAILED! Check for errors above
    echo.
    echo 🔍 Troubleshooting:
    echo 1. Make sure servlet-api.jar path is correct
    echo 2. Check if Participant.java has correct package declaration
    echo 3. Look for compilation errors above
)

echo.
pause
