@echo off
echo 🔧 Fixing JAR Command Problem
echo =============================

echo Problem: 'jar' command not found
echo Solution: Use alternative methods to create WAR file
echo.

set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106

echo 🔍 Step 1: Check available tools
echo ================================

REM Check if jar command exists
jar --version >nul 2>&1
if errorlevel 1 (
    echo ❌ jar command not available
    set USE_JAR=false
) else (
    echo ✅ jar command available
    set USE_JAR=true
)

REM Check if 7zip exists
7z >nul 2>&1
if errorlevel 1 (
    echo ❌ 7zip not available
    set USE_7ZIP=false
) else (
    echo ✅ 7zip available
    set USE_7ZIP=true
)

REM Check PowerShell
powershell -Command "Get-Command Compress-Archive" >nul 2>&1
if errorlevel 1 (
    echo ❌ PowerShell Compress-Archive not available
    set USE_POWERSHELL=false
) else (
    echo ✅ PowerShell Compress-Archive available
    set USE_POWERSHELL=true
)

echo.
echo 🛠️ Step 2: Clean and prepare
echo ============================

REM Stop Tomcat
taskkill /F /IM java.exe 2>nul

REM Clean previous deployment
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

echo.
echo 📁 Step 3: Create application structure
echo =======================================

mkdir himami-war\WEB-INF\classes

REM Create index.html
call :create_index

REM Create web.xml
call :create_webxml

REM Copy compiled classes
if exist "compiled-classes\com" (
    xcopy /E /I compiled-classes\com himami-war\WEB-INF\classes\com\
    echo ✅ Copied Java classes
)

REM Copy static files
if exist "css" xcopy /E /I css himami-war\css\
if exist "js" xcopy /E /I js himami-war\js\
for %%f in (*.html) do if exist "%%f" copy "%%f" himami-war\

echo.
echo 🗜️ Step 4: Create WAR file using available method
echo =================================================

if "%USE_JAR%"=="true" (
    echo Using jar command...
    cd himami-war
    jar -cvf ..\himami.war *
    cd ..
) else if "%USE_7ZIP%"=="true" (
    echo Using 7zip...
    cd himami-war
    7z a -tzip ..\himami.war *
    cd ..
) else if "%USE_POWERSHELL%"=="true" (
    echo Using PowerShell...
    cd himami-war
    powershell -Command "Compress-Archive -Path * -DestinationPath ..\himami.zip"
    cd ..
    ren himami.zip himami.war
) else (
    echo Using manual copy method...
    call :manual_war_creation
)

echo.
echo 📊 Step 5: Verify WAR file
echo ==========================

if exist "himami.war" (
    echo ✅ WAR file created successfully
    for %%A in (himami.war) do (
        if %%~zA GTR 0 (
            echo ✅ WAR file has content (%%~zA bytes)
        ) else (
            echo ❌ WAR file is empty!
            goto :error
        )
    )
) else (
    echo ❌ WAR file creation failed!
    goto :error
)

echo.
echo 🚀 Step 6: Deploy to Tomcat
echo ===========================

copy himami.war "%TOMCAT_PATH%\webapps\"

if exist "%TOMCAT_PATH%\webapps\himami.war" (
    echo ✅ WAR file deployed to Tomcat
    
    REM Verify it's a file, not directory
    dir "%TOMCAT_PATH%\webapps\himami.war" | find "<DIR>" >nul
    if errorlevel 1 (
        echo ✅ Deployed as proper FILE
    ) else (
        echo ❌ Still deployed as directory!
    )
) else (
    echo ❌ Failed to deploy WAR file
    goto :error
)

echo.
echo 🧹 Step 7: Cleanup
echo ==================

rmdir /S /Q himami-war
del himami.war

echo.
echo 🚀 Step 8: Start Tomcat
echo =======================

start "" "%TOMCAT_PATH%\bin\startup.bat"

echo.
echo ✅ DEPLOYMENT SUCCESSFUL!
echo =========================
echo.
echo 🕐 Wait 60 seconds for Tomcat to start and extract WAR
echo 🌐 Then access: http://localhost:8080/himami/
echo.
echo 📝 To verify: run verify-deployment.bat
echo.

pause
goto :eof

:error
echo.
echo ❌ DEPLOYMENT FAILED!
echo ====================
echo.
echo 🔧 Try these solutions:
echo 1. Install Java JDK (includes jar command)
echo 2. Install 7-Zip
echo 3. Use manual deployment method
echo.
pause
goto :eof

:create_index
echo ^<!DOCTYPE html^> > himami-war\index.html
echo ^<html lang="id"^> >> himami-war\index.html
echo ^<head^> >> himami-war\index.html
echo     ^<meta charset="UTF-8"^> >> himami-war\index.html
echo     ^<title^>HIMA MI - Deployment Success^</title^> >> himami-war\index.html
echo     ^<style^> >> himami-war\index.html
echo         body { font-family: Arial, sans-serif; margin: 40px; background: #f0f8ff; } >> himami-war\index.html
echo         .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); } >> himami-war\index.html
echo         h1 { color: #2563eb; text-align: center; margin-bottom: 30px; } >> himami-war\index.html
echo         .success { background: #d1fae5; color: #065f46; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 5px solid #10b981; } >> himami-war\index.html
echo         .btn { background: #2563eb; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; display: inline-block; margin: 10px 5px; } >> himami-war\index.html
echo         .btn:hover { background: #1d4ed8; } >> himami-war\index.html
echo     ^</style^> >> himami-war\index.html
echo ^</head^> >> himami-war\index.html
echo ^<body^> >> himami-war\index.html
echo     ^<div class="container"^> >> himami-war\index.html
echo         ^<h1^>🎉 HIMA MI - Deployment Berhasil!^</h1^> >> himami-war\index.html
echo         ^<div class="success"^> >> himami-war\index.html
echo             ^<h3^>✅ Aplikasi Berhasil Di-Deploy!^</h3^> >> himami-war\index.html
echo             ^<p^>Aplikasi HIMA MI telah berhasil di-deploy ke Apache Tomcat dan berjalan dengan baik.^</p^> >> himami-war\index.html
echo         ^</div^> >> himami-war\index.html
echo         ^<h2^>🧪 Test Fitur:^</h2^> >> himami-war\index.html
echo         ^<p^>^<a href="api/participants" class="btn"^>Test API^</a^>^</p^> >> himami-war\index.html
echo         ^<h2^>📊 Info Deployment:^</h2^> >> himami-war\index.html
echo         ^<ul^> >> himami-war\index.html
echo             ^<li^>Server: Apache Tomcat^</li^> >> himami-war\index.html
echo             ^<li^>Aplikasi: HIMA MI^</li^> >> himami-war\index.html
echo             ^<li^>Status: Running^</li^> >> himami-war\index.html
echo             ^<li^>URL: /himami/^</li^> >> himami-war\index.html
echo         ^</ul^> >> himami-war\index.html
echo     ^</div^> >> himami-war\index.html
echo ^</body^> >> himami-war\index.html
echo ^</html^> >> himami-war\index.html
goto :eof

:create_webxml
mkdir himami-war\WEB-INF 2>nul
echo ^<?xml version="1.0" encoding="UTF-8"?^> > himami-war\WEB-INF\web.xml
echo ^<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" >> himami-war\WEB-INF\web.xml
echo          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >> himami-war\WEB-INF\web.xml
echo          xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee >> himami-war\WEB-INF\web.xml
echo          http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd" >> himami-war\WEB-INF\web.xml
echo          version="4.0"^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo     ^<display-name^>HIMA MI Application^</display-name^> >> himami-war\WEB-INF\web.xml
echo     ^<welcome-file-list^> >> himami-war\WEB-INF\web.xml
echo         ^<welcome-file^>index.html^</welcome-file^> >> himami-war\WEB-INF\web.xml
echo     ^</welcome-file-list^> >> himami-war\WEB-INF\web.xml
echo ^</web-app^> >> himami-war\WEB-INF\web.xml
goto :eof

:manual_war_creation
echo Creating WAR manually by copying to webapps...
mkdir "%TOMCAT_PATH%\webapps\himami"
xcopy /E /I himami-war\* "%TOMCAT_PATH%\webapps\himami\"
echo Manual deployment completed
goto :eof
