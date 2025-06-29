@echo off
REM Deployment script untuk Windows

echo 🚀 HIMA MI Deployment Script
echo ================================

REM Check if CATALINA_HOME is set
if "%CATALINA_HOME%"=="" (
    echo ❌ Error: CATALINA_HOME not set
    echo Please set CATALINA_HOME environment variable
    pause
    exit /b 1
)

REM Create directories
echo 📁 Creating directories...
mkdir compiled-classes 2>nul
mkdir himami-war\WEB-INF\classes 2>nul

REM Compile Java files
echo 🔄 Compiling Java files...
javac -cp "%CATALINA_HOME%\lib\servlet-api.jar" -d compiled-classes ^
    src\main\java\com\himami\model\*.java ^
    src\main\java\com\himami\storage\*.java ^
    src\main\java\com\himami\util\*.java ^
    src\main\java\com\himami\servlet\*.java ^
    src\main\java\com\himami\filter\*.java

if errorlevel 1 (
    echo ❌ Compilation failed!
    pause
    exit /b 1
)

echo ✅ Compilation successful!

REM Copy webapp files
echo 📋 Copying webapp files...
xcopy /E /I src\main\webapp\* himami-war\

REM Copy compiled classes
echo 📦 Copying compiled classes...
xcopy /E /I compiled-classes\com himami-war\WEB-INF\classes\com\

REM Create WAR file
echo 🗜️ Creating WAR file...
cd himami-war
jar -cvf ..\himami.war *
cd ..

REM Deploy to Tomcat
echo 🚀 Deploying to Tomcat...
copy himami.war "%CATALINA_HOME%\webapps\"

REM Clean up
echo 🧹 Cleaning up...
rmdir /S /Q compiled-classes
rmdir /S /Q himami-war
del himami.war

echo.
echo ✅ Deployment completed successfully!
echo 🌐 Access your application at: http://localhost:8080/himami/
echo.
echo 📝 Next steps:
echo 1. Start Tomcat: %CATALINA_HOME%\bin\startup.bat
echo 2. Check logs: type %CATALINA_HOME%\logs\catalina.out
echo 3. Access application in browser

pause
