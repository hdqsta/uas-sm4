@echo off
echo 🎯 Compiling Java Files for Your Structure
echo ==========================================

REM Set Tomcat path
set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106
set SERVLET_JAR=%TOMCAT_PATH%\lib\servlet-api.jar

echo Using servlet-api.jar: %SERVLET_JAR%
echo Current directory: %CD%
echo.

REM Create output directory
if not exist "compiled-classes" mkdir compiled-classes

echo 🔄 Compiling Java files from main\java\...
echo.

REM Compile model classes
echo 📦 Compiling model classes...
javac -cp "%SERVLET_JAR%" -d compiled-classes main\java\com\himami\model\Participant.java
if errorlevel 1 (echo ❌ Failed: Participant.java) else (echo ✅ Success: Participant.java)

javac -cp "%SERVLET_JAR%" -d compiled-classes main\java\com\himami\model\User.java
if errorlevel 1 (echo ❌ Failed: User.java) else (echo ✅ Success: User.java)

REM Compile util classes (dependencies first)
echo 🛠️ Compiling util classes...
javac -cp "%SERVLET_JAR%" -d compiled-classes main\java\com\himami\util\JsonUtil.java
if errorlevel 1 (echo ❌ Failed: JsonUtil.java) else (echo ✅ Success: JsonUtil.java)

javac -cp "%SERVLET_JAR%" -d compiled-classes main\java\com\himami\util\ResponseUtil.java
if errorlevel 1 (echo ❌ Failed: ResponseUtil.java) else (echo ✅ Success: ResponseUtil.java)

javac -cp "%SERVLET_JAR%" -d compiled-classes main\java\com\himami\util\PasswordUtil.java
if errorlevel 1 (echo ❌ Failed: PasswordUtil.java) else (echo ✅ Success: PasswordUtil.java)

javac -cp "%SERVLET_JAR%" -d compiled-classes main\java\com\himami\util\SessionUtil.java
if errorlevel 1 (echo ❌ Failed: SessionUtil.java) else (echo ✅ Success: SessionUtil.java)

javac -cp "%SERVLET_JAR%" -d compiled-classes main\java\com\himami\util\ValidationUtil.java
if errorlevel 1 (echo ❌ Failed: ValidationUtil.java) else (echo ✅ Success: ValidationUtil.java)

REM Compile storage classes
echo 💾 Compiling storage classes...
javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes main\java\com\himami\storage\DataStorage.java
if errorlevel 1 (echo ❌ Failed: DataStorage.java) else (echo ✅ Success: DataStorage.java)

REM Compile filter classes
echo 🔍 Compiling filter classes...
javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes main\java\com\himami\filter\CharacterEncodingFilter.java
if errorlevel 1 (echo ❌ Failed: CharacterEncodingFilter.java) else (echo ✅ Success: CharacterEncodingFilter.java)

REM Compile servlet classes (need all dependencies)
echo 🌐 Compiling servlet classes...
javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes main\java\com\himami\servlet\ParticipantServlet.java
if errorlevel 1 (echo ❌ Failed: ParticipantServlet.java) else (echo ✅ Success: ParticipantServlet.java)

javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes main\java\com\himami\servlet\AuthServlet.java
if errorlevel 1 (echo ❌ Failed: AuthServlet.java) else (echo ✅ Success: AuthServlet.java)

javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes main\java\com\himami\servlet\RegisterServlet.java
if errorlevel 1 (echo ❌ Failed: RegisterServlet.java) else (echo ✅ Success: RegisterServlet.java)

echo.
echo 📁 Checking compilation results...

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
    echo 2. Or run the full deployment script
) else (
    echo ❌ Compilation failed!
    echo Check the error messages above
)

echo.
pause
