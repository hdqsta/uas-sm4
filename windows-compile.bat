@echo off
echo 🪟 Windows Compilation Script for HIMA MI
echo ==========================================

REM Set your Tomcat path here
set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106
set SERVLET_JAR=%TOMCAT_PATH%\lib\servlet-api.jar

REM Check if servlet-api.jar exists
if not exist "%SERVLET_JAR%" (
    echo ❌ Error: servlet-api.jar not found at %SERVLET_JAR%
    echo.
    echo 📝 Please:
    echo 1. Install Apache Tomcat
    echo 2. Update TOMCAT_PATH in this script
    echo 3. Or download servlet-api.jar separately
    echo.
    pause
    exit /b 1
)

echo ✅ Found servlet-api.jar at: %SERVLET_JAR%
echo.

REM Create compiled-classes directory
if not exist "compiled-classes" mkdir compiled-classes
cd compiled-classes

echo 🔄 Compiling Java files...
echo.

REM Compile model classes
echo 📦 Compiling model classes...
javac -cp "%SERVLET_JAR%" -d . ..\src\main\java\com\himami\model\Participant.java
javac -cp "%SERVLET_JAR%" -d . ..\src\main\java\com\himami\model\User.java

REM Compile util classes
echo 🛠️ Compiling util classes...
javac -cp "%SERVLET_JAR%" -d . ..\src\main\java\com\himami\util\JsonUtil.java
javac -cp "%SERVLET_JAR%" -d . ..\src\main\java\com\himami\util\ResponseUtil.java
javac -cp "%SERVLET_JAR%" -d . ..\src\main\java\com\himami\util\PasswordUtil.java
javac -cp "%SERVLET_JAR%" -d . ..\src\main\java\com\himami\util\SessionUtil.java
javac -cp "%SERVLET_JAR%" -d . ..\src\main\java\com\himami\util\ValidationUtil.java

REM Compile storage classes
echo 💾 Compiling storage classes...
javac -cp "%SERVLET_JAR%" -d . ..\src\main\java\com\himami\storage\DataStorage.java

REM Compile filter classes
echo 🔍 Compiling filter classes...
javac -cp "%SERVLET_JAR%" -d . ..\src\main\java\com\himami\filter\CharacterEncodingFilter.java

REM Compile servlet classes
echo 🌐 Compiling servlet classes...
javac -cp "%SERVLET_JAR%" -d . ..\src\main\java\com\himami\servlet\ParticipantServlet.java
javac -cp "%SERVLET_JAR%" -d . ..\src\main\java\com\himami\servlet\AuthServlet.java
javac -cp "%SERVLET_JAR%" -d . ..\src\main\java\com\himami\servlet\RegisterServlet.java

if errorlevel 1 (
    echo ❌ Compilation failed!
    pause
    exit /b 1
)

echo.
echo ✅ Compilation successful!
echo 📁 Compiled classes are in: %CD%\com\himami\
echo.

REM Show compiled structure
echo 📋 Compiled class structure:
dir /S com

echo.
echo 📝 Next steps:
echo 1. Copy the 'com' folder to your WAR's WEB-INF\classes\
echo 2. Or run the full deployment script
echo.

pause
