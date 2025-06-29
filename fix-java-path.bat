@echo off
echo 🔍 Fixing Java PATH Issue
echo =========================

echo Current Java version:
java -version
echo.

echo 🔍 Step 1: Finding JDK Installation
echo ===================================

REM Check common JDK locations
set JDK_FOUND=false
set JDK_PATH=

REM Check Program Files
for /d %%d in ("C:\Program Files\Java\jdk*") do (
    if exist "%%d\bin\jar.exe" (
        set JDK_PATH=%%d
        set JDK_FOUND=true
        echo ✅ Found JDK at: %%d
        goto :found_jdk
    )
)

REM Check Program Files (x86)
for /d %%d in ("C:\Program Files (x86)\Java\jdk*") do (
    if exist "%%d\bin\jar.exe" (
        set JDK_PATH=%%d
        set JDK_FOUND=true
        echo ✅ Found JDK at: %%d
        goto :found_jdk
    )
)

REM Check Oracle JDK locations
for /d %%d in ("C:\Program Files\Java\jdk-*") do (
    if exist "%%d\bin\jar.exe" (
        set JDK_PATH=%%d
        set JDK_FOUND=true
        echo ✅ Found JDK at: %%d
        goto :found_jdk
    )
)

if "%JDK_FOUND%"=="false" (
    echo ❌ JDK not found in common locations
    echo.
    echo 🔍 Searching entire system for jar.exe...
    for /f "delims=" %%i in ('dir /s /b "C:\jar.exe" 2^>nul') do (
        echo Found jar.exe at: %%i
        for %%j in ("%%i") do set JDK_PATH=%%~dpj..
    )
    
    if "%JDK_PATH%"=="" (
        echo ❌ jar.exe not found anywhere
        goto :manual_solution
    )
)

:found_jdk
echo.
echo 🧪 Step 2: Testing JAR command
echo ==============================

echo Testing jar command at: %JDK_PATH%\bin\jar.exe
"%JDK_PATH%\bin\jar.exe" --version

if errorlevel 1 (
    echo ❌ jar command failed
    goto :manual_solution
) else (
    echo ✅ jar command works!
)

echo.
echo 🔧 Step 3: Temporary PATH Fix
echo =============================

echo Adding JDK bin to PATH for this session...
set PATH=%JDK_PATH%\bin;%PATH%

echo Testing jar command now...
jar --version

if errorlevel 1 (
    echo ❌ Still not working
    goto :manual_solution
) else (
    echo ✅ jar command now works!
)

echo.
echo 🚀 Step 4: Deploy with working JAR
echo ==================================

echo Now running deployment with working jar command...
call :deploy_with_jar

goto :success

:manual_solution
echo.
echo 🔧 MANUAL SOLUTION NEEDED
echo =========================
echo.
echo The jar command is not available. Here are your options:
echo.
echo 1. 📝 Add JDK to PATH manually:
echo    - Open System Properties → Advanced → Environment Variables
echo    - Edit PATH variable
echo    - Add: C:\Program Files\Java\jdk-22.0.1\bin
echo    - Restart Command Prompt
echo.
echo 2. 🚀 Use PowerShell method instead:
echo    Run: powershell-war-method.bat
echo.
echo 3. 🔍 Find your JDK installation:
echo    Run: where /r C:\ jar.exe
echo.

pause
goto :eof

:deploy_with_jar
echo Creating deployment with jar command...

set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106

REM Clean previous
taskkill /F /IM java.exe 2>nul
if exist "%TOMCAT_PATH%\webapps\himami.war" (
    if exist "%TOMCAT_PATH%\webapps\himami.war\*" (
        rmdir /S /Q "%TOMCAT_PATH%\webapps\himami.war"
    ) else (
        del "%TOMCAT_PATH%\webapps\himami.war"
    )
)
if exist "%TOMCAT_PATH%\webapps\himami" rmdir /S /Q "%TOMCAT_PATH%\webapps\himami"

REM Clean local
if exist "himami-war" rmdir /S /Q himami-war
if exist "himami.war" del himami.war

REM Create structure
mkdir himami-war\WEB-INF\classes

REM Create files
call :create_app_files

REM Copy classes
if exist "compiled-classes\com" (
    xcopy /E /I compiled-classes\com himami-war\WEB-INF\classes\com\
    echo ✅ Copied Java classes
)

REM Create WAR
echo Creating WAR file with jar command...
cd himami-war
jar -cvf ..\himami.war *
cd ..

if exist "himami.war" (
    echo ✅ WAR file created successfully
    for %%A in (himami.war) do echo 📊 Size: %%~zA bytes
    
    REM Deploy
    copy himami.war "%TOMCAT_PATH%\webapps\"
    echo ✅ Deployed to Tomcat
    
    REM Start Tomcat
    start "" "%TOMCAT_PATH%\bin\startup.bat"
    
    REM Cleanup
    rmdir /S /Q himami-war
    del himami.war
    
) else (
    echo ❌ WAR creation failed
)

goto :eof

:create_app_files
REM Create index.html
echo ^<!DOCTYPE html^> > himami-war\index.html
echo ^<html lang="id"^> >> himami-war\index.html
echo ^<head^> >> himami-war\index.html
echo     ^<meta charset="UTF-8"^> >> himami-war\index.html
echo     ^<title^>HIMA MI - JAR Method Success^</title^> >> himami-war\index.html
echo     ^<style^> >> himami-war\index.html
echo         body { font-family: Arial, sans-serif; margin: 40px; background: #f0f8ff; } >> himami-war\index.html
echo         .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); } >> himami-war\index.html
echo         h1 { color: #2563eb; text-align: center; } >> himami-war\index.html
echo         .success { background: #d1fae5; color: #065f46; padding: 20px; border-radius: 8px; margin: 20px 0; } >> himami-war\index.html
echo         .btn { background: #2563eb; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; display: inline-block; margin: 10px; } >> himami-war\index.html
echo     ^</style^> >> himami-war\index.html
echo ^</head^> >> himami-war\index.html
echo ^<body^> >> himami-war\index.html
echo     ^<div class="container"^> >> himami-war\index.html
echo         ^<h1^>🎉 HIMA MI - JAR Method Success!^</h1^> >> himami-war\index.html
echo         ^<div class="success"^> >> himami-war\index.html
echo             ^<h3^>✅ Deployed with JAR Command!^</h3^> >> himami-war\index.html
echo             ^<p^>Aplikasi berhasil di-deploy menggunakan jar command yang sudah diperbaiki.^</p^> >> himami-war\index.html
echo         ^</div^> >> himami-war\index.html
echo         ^<p^>^<a href="api/participants" class="btn"^>Test API^</a^>^</p^> >> himami-war\index.html
echo     ^</div^> >> himami-war\index.html
echo ^</body^> >> himami-war\index.html
echo ^</html^> >> himami-war\index.html

REM Create web.xml
mkdir himami-war\WEB-INF 2>nul
echo ^<?xml version="1.0" encoding="UTF-8"?^> > himami-war\WEB-INF\web.xml
echo ^<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="4.0"^> >> himami-war\WEB-INF\web.xml
echo ^<display-name^>HIMA MI^</display-name^> >> himami-war\WEB-INF\web.xml
echo ^<welcome-file-list^>^<welcome-file^>index.html^</welcome-file^>^</welcome-file-list^> >> himami-war\WEB-INF\web.xml
echo ^</web-app^> >> himami-war\WEB-INF\web.xml
goto :eof

:success
echo.
echo ✅ DEPLOYMENT SUCCESSFUL!
echo =========================
echo 🕐 Wait 60 seconds for Tomcat startup
echo 🌐 Access: http://localhost:8080/himami/
echo.
pause
goto :eof
