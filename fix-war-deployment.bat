@echo off
echo 🔧 Fixing WAR Deployment Issue
echo ==============================

set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106

echo Problem: himami.war is a directory, not a proper WAR file
echo Solution: Create proper WAR file and redeploy
echo.

echo Step 1: Stop Tomcat
echo ===================
taskkill /F /IM java.exe 2>nul
echo Waiting for Tomcat to stop...
timeout /t 3 /nobreak >nul

echo.
echo Step 2: Clean corrupted deployment
echo ==================================
if exist "%TOMCAT_PATH%\webapps\himami.war" (
    echo Removing corrupted himami.war directory...
    rmdir /S /Q "%TOMCAT_PATH%\webapps\himami.war"
    echo ✅ Removed corrupted himami.war
)

if exist "%TOMCAT_PATH%\webapps\himami" (
    echo Removing himami folder...
    rmdir /S /Q "%TOMCAT_PATH%\webapps\himami"
    echo ✅ Removed himami folder
)

echo.
echo Step 3: Create proper WAR file
echo ==============================

REM Clean local build
if exist "himami-war" rmdir /S /Q himami-war
if exist "himami.war" del himami.war

REM Create WAR structure
mkdir himami-war
mkdir himami-war\WEB-INF
mkdir himami-war\WEB-INF\classes

echo 📝 Creating web application files...

REM Create index.html
call :create_index

REM Create web.xml
call :create_webxml

REM Copy compiled classes if available
if exist "compiled-classes\com" (
    xcopy /E /I compiled-classes\com himami-war\WEB-INF\classes\com\
    echo ✅ Copied Java classes
) else (
    echo ⚠️ No compiled classes found - creating demo version
)

REM Copy static files if they exist
if exist "css" (
    xcopy /E /I css himami-war\css\
    echo ✅ Copied CSS files
)

if exist "js" (
    xcopy /E /I js himami-war\js\
    echo ✅ Copied JS files
)

REM Copy HTML files
for %%f in (login.html register.html profile.html) do (
    if exist "%%f" (
        copy "%%f" himami-war\
        echo ✅ Copied %%f
    )
)

echo.
echo Step 4: Create proper WAR file using jar command
echo ================================================
cd himami-war

REM Use jar command to create proper WAR file
jar -cvf ..\himami.war *

cd ..

echo.
echo Step 5: Verify WAR file
echo =======================
if exist "himami.war" (
    echo ✅ WAR file created successfully
    
    REM Check if it's a proper file (not directory)
    dir himami.war
    
    REM Check file size
    for %%A in (himami.war) do (
        if %%~zA GTR 0 (
            echo ✅ WAR file has content (%%~zA bytes)
        ) else (
            echo ❌ WAR file is empty!
        )
    )
) else (
    echo ❌ Failed to create WAR file
    pause
    exit /b 1
)

echo.
echo Step 6: Deploy to Tomcat
echo ========================
copy himami.war "%TOMCAT_PATH%\webapps\"

if exist "%TOMCAT_PATH%\webapps\himami.war" (
    echo ✅ WAR file deployed to Tomcat
    
    REM Verify it's a file, not directory
    dir "%TOMCAT_PATH%\webapps\himami.war"
) else (
    echo ❌ Failed to deploy WAR file
    pause
    exit /b 1
)

echo.
echo Step 7: Start Tomcat
echo ====================
echo Starting Tomcat...
start "" "%TOMCAT_PATH%\bin\startup.bat"

echo.
echo ✅ Deployment process completed!
echo.
echo 🕐 Please wait 30-60 seconds for Tomcat to:
echo    1. Start up completely
echo    2. Extract the WAR file
echo    3. Deploy the application
echo.
echo 🌐 Then access: http://localhost:8080/himami/
echo.
echo 📝 To check deployment status: check-deployment.bat

REM Cleanup
rmdir /S /Q himami-war
del himami.war

pause
goto :eof

:create_index
echo ^<!DOCTYPE html^> > himami-war\index.html
echo ^<html lang="id"^> >> himami-war\index.html
echo ^<head^> >> himami-war\index.html
echo     ^<meta charset="UTF-8"^> >> himami-war\index.html
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> himami-war\index.html
echo     ^<title^>HIMA MI - Deployment Test^</title^> >> himami-war\index.html
echo     ^<style^> >> himami-war\index.html
echo         body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background: linear-gradient(135deg, #ebf4ff 0%%, #e0e7ff 100%%); min-height: 100vh; } >> himami-war\index.html
echo         .container { max-width: 900px; margin: 0 auto; padding: 40px 20px; } >> himami-war\index.html
echo         .header { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); margin-bottom: 30px; text-align: center; } >> himami-war\index.html
echo         h1 { color: #2563eb; margin: 0; font-size: 2.5rem; } >> himami-war\index.html
echo         .subtitle { color: #6b7280; margin: 10px 0 0 0; } >> himami-war\index.html
echo         .success { background: #d1fae5; color: #065f46; padding: 20px; border-radius: 10px; margin: 20px 0; border-left: 5px solid #10b981; } >> himami-war\index.html
echo         .info { background: #dbeafe; color: #1e40af; padding: 20px; border-radius: 10px; margin: 20px 0; border-left: 5px solid #3b82f6; } >> himami-war\index.html
echo         .warning { background: #fef3c7; color: #92400e; padding: 20px; border-radius: 10px; margin: 20px 0; border-left: 5px solid #f59e0b; } >> himami-war\index.html
echo         .btn { background: #2563eb; color: white; padding: 12px 24px; text-decoration: none; border-radius: 8px; display: inline-block; margin: 10px 5px; font-weight: 500; transition: all 0.3s; } >> himami-war\index.html
echo         .btn:hover { background: #1d4ed8; transform: translateY(-2px); } >> himami-war\index.html
echo         .btn-secondary { background: #6b7280; } >> himami-war\index.html
echo         .btn-secondary:hover { background: #4b5563; } >> himami-war\index.html
echo         .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin: 30px 0; } >> himami-war\index.html
echo         .card { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); } >> himami-war\index.html
echo         .status { font-weight: bold; color: #10b981; } >> himami-war\index.html
echo         ul { padding-left: 20px; } >> himami-war\index.html
echo         li { margin: 8px 0; } >> himami-war\index.html
echo     ^</style^> >> himami-war\index.html
echo ^</head^> >> himami-war\index.html
echo ^<body^> >> himami-war\index.html
echo     ^<div class="container"^> >> himami-war\index.html
echo         ^<div class="header"^> >> himami-war\index.html
echo             ^<h1^>🎉 HIMA MI^</h1^> >> himami-war\index.html
echo             ^<p class="subtitle"^>Himpunan Mahasiswa Manajemen Informatika^</p^> >> himami-war\index.html
echo         ^</div^> >> himami-war\index.html
echo. >> himami-war\index.html
echo         ^<div class="success"^> >> himami-war\index.html
echo             ^<h3^>✅ Deployment Successful!^</h3^> >> himami-war\index.html
echo             ^<p^>Your HIMA MI application has been successfully deployed to Apache Tomcat.^</p^> >> himami-war\index.html
echo             ^<p class="status"^>Status: RUNNING^</p^> >> himami-war\index.html
echo         ^</div^> >> himami-war\index.html
echo. >> himami-war\index.html
echo         ^<div class="grid"^> >> himami-war\index.html
echo             ^<div class="card"^> >> himami-war\index.html
echo                 ^<h3^>📊 System Info^</h3^> >> himami-war\index.html
echo                 ^<p^>^<strong^>Server:^</strong^> Apache Tomcat^</p^> >> himami-war\index.html
echo                 ^<p^>^<strong^>Application:^</strong^> HIMA MI^</p^> >> himami-war\index.html
echo                 ^<p^>^<strong^>Deployed:^</strong^> ^<script^>document.write(new Date().toLocaleString());^</script^>^</p^> >> himami-war\index.html
echo                 ^<p^>^<strong^>URL:^</strong^> /himami/^</p^> >> himami-war\index.html
echo             ^</div^> >> himami-war\index.html
echo. >> himami-war\index.html
echo             ^<div class="card"^> >> himami-war\index.html
echo                 ^<h3^>🧪 Test Features^</h3^> >> himami-war\index.html
echo                 ^<p^>^<a href="api/participants" class="btn"^>Test API^</a^>^</p^> >> himami-war\index.html
echo                 ^<p^>^<a href="login.html" class="btn btn-secondary"^>Login Page^</a^>^</p^> >> himami-war\index.html
echo                 ^<p^>^<a href="register.html" class="btn btn-secondary"^>Register Page^</a^>^</p^> >> himami-war\index.html
echo             ^</div^> >> himami-war\index.html
echo         ^</div^> >> himami-war\index.html
echo. >> himami-war\index.html
echo         ^<div class="info"^> >> himami-war\index.html
echo             ^<h3^>🔧 Next Steps^</h3^> >> himami-war\index.html
echo             ^<ul^> >> himami-war\index.html
echo                 ^<li^>Test the API endpoints^</li^> >> himami-war\index.html
echo                 ^<li^>Verify all servlets are working^</li^> >> himami-war\index.html
echo                 ^<li^>Check database connectivity (if applicable)^</li^> >> himami-war\index.html
echo                 ^<li^>Test user registration and login^</li^> >> himami-war\index.html
echo             ^</ul^> >> himami-war\index.html
echo         ^</div^> >> himami-war\index.html
echo. >> himami-war\index.html
echo         ^<div class="warning"^> >> himami-war\index.html
echo             ^<h3^>⚠️ Important Notes^</h3^> >> himami-war\index.html
echo             ^<p^>This is a test deployment page. Replace with your actual application files.^</p^> >> himami-war\index.html
echo             ^<p^>Make sure all Java classes are properly compiled and deployed.^</p^> >> himami-war\index.html
echo         ^</div^> >> himami-war\index.html
echo     ^</div^> >> himami-war\index.html
echo ^</body^> >> himami-war\index.html
echo ^</html^> >> himami-war\index.html
goto :eof

:create_webxml
echo ^<?xml version="1.0" encoding="UTF-8"?^> > himami-war\WEB-INF\web.xml
echo ^<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" >> himami-war\WEB-INF\web.xml
echo          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >> himami-war\WEB-INF\web.xml
echo          xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee >> himami-war\WEB-INF\web.xml
echo          http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd" >> himami-war\WEB-INF\web.xml
echo          version="4.0"^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo     ^<display-name^>HIMA MI Web Application^</display-name^> >> himami-war\WEB-INF\web.xml
echo     ^<description^>Himpunan Mahasiswa Manajemen Informatika^</description^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo     ^<welcome-file-list^> >> himami-war\WEB-INF\web.xml
echo         ^<welcome-file^>index.html^</welcome-file^> >> himami-war\WEB-INF\web.xml
echo     ^</welcome-file-list^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo     ^<!-- Servlet mappings will be added here when Java classes are available --^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo ^</web-app^> >> himami-war\WEB-INF\web.xml
goto :eof
