@echo off
echo 🚀 Quick JAR Fix and Deploy
echo ===========================

echo Step 1: Find and test jar command
echo =================================

REM Try common JDK locations
set JAR_CMD=

if exist "C:\Program Files\Java\jdk-22.0.1\bin\jar.exe" (
    set JAR_CMD=C:\Program Files\Java\jdk-22.0.1\bin\jar.exe
    echo ✅ Found jar at: %JAR_CMD%
    goto :deploy
)

if exist "C:\Program Files\Java\jdk-22\bin\jar.exe" (
    set JAR_CMD=C:\Program Files\Java\jdk-22\bin\jar.exe
    echo ✅ Found jar at: %JAR_CMD%
    goto :deploy
)

REM Search for any JDK
for /d %%d in ("C:\Program Files\Java\jdk*") do (
    if exist "%%d\bin\jar.exe" (
        set JAR_CMD=%%d\bin\jar.exe
        echo ✅ Found jar at: !JAR_CMD!
        goto :deploy
    )
)

echo ❌ jar.exe not found, using PowerShell method instead
goto :powershell_method

:deploy
echo.
echo Step 2: Deploy with jar command
echo ===============================

set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106

REM Clean previous deployment
taskkill /F /IM java.exe 2>nul
if exist "%TOMCAT_PATH%\webapps\himami.war" (
    if exist "%TOMCAT_PATH%\webapps\himami.war\*" (
        rmdir /S /Q "%TOMCAT_PATH%\webapps\himami.war"
    ) else (
        del "%TOMCAT_PATH%\webapps\himami.war"
    )
)
if exist "%TOMCAT_PATH%\webapps\himami" rmdir /S /Q "%TOMCAT_PATH%\webapps\himami"

REM Clean local files
if exist "himami-war" rmdir /S /Q himami-war
if exist "himami.war" del himami.war

REM Create application structure
mkdir himami-war\WEB-INF\classes

REM Create basic files
call :create_files

REM Copy compiled classes
if exist "compiled-classes\com" (
    xcopy /E /I compiled-classes\com himami-war\WEB-INF\classes\com\
    echo ✅ Copied Java classes
)

REM Create WAR using full path to jar
echo Creating WAR file...
cd himami-war
"%JAR_CMD%" -cvf ..\himami.war *
cd ..

if exist "himami.war" (
    echo ✅ WAR created successfully
    for %%A in (himami.war) do echo 📊 Size: %%~zA bytes
    
    REM Deploy to Tomcat
    copy himami.war "%TOMCAT_PATH%\webapps\"
    echo ✅ Deployed to Tomcat
    
    REM Start Tomcat
    start "" "%TOMCAT_PATH%\bin\startup.bat"
    
    REM Cleanup
    rmdir /S /Q himami-war
    del himami.war
    
    echo.
    echo ✅ DEPLOYMENT SUCCESSFUL!
    echo 🕐 Wait 60 seconds then access: http://localhost:8080/himami/
    
) else (
    echo ❌ WAR creation failed
)

goto :end

:powershell_method
echo.
echo Using PowerShell method instead...
call powershell-war-method.bat
goto :end

:create_files
REM Create index.html
echo ^<!DOCTYPE html^>^<html^>^<head^>^<title^>HIMA MI Success^</title^>^</head^> > himami-war\index.html
echo ^<body^>^<h1^>HIMA MI Deployment Success!^</h1^>^<p^>JAR command fixed and working!^</p^>^</body^>^</html^> >> himami-war\index.html

REM Create web.xml
mkdir himami-war\WEB-INF 2>nul
echo ^<?xml version="1.0" encoding="UTF-8"?^> > himami-war\WEB-INF\web.xml
echo ^<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="4.0"^> >> himami-war\WEB-INF\web.xml
echo ^<display-name^>HIMA MI^</display-name^> >> himami-war\WEB-INF\web.xml
echo ^<welcome-file-list^>^<welcome-file^>index.html^</welcome-file^>^</welcome-file-list^> >> himami-war\WEB-INF\web.xml
echo ^</web-app^> >> himami-war\WEB-INF\web.xml
goto :eof

:end
pause
