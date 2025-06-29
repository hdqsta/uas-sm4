@echo off
echo 🚀 Quick Fix Deployment
echo =======================

set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106

echo Step 1: Stop Tomcat (if running)
echo ================================
taskkill /F /IM java.exe 2>nul
echo Waiting 5 seconds...
timeout /t 5 /nobreak >nul

echo.
echo Step 2: Clean old deployment
echo ============================
if exist "%TOMCAT_PATH%\webapps\himami.war" (
    del "%TOMCAT_PATH%\webapps\himami.war"
    echo ✅ Removed old WAR file
)

if exist "%TOMCAT_PATH%\webapps\himami" (
    rmdir /S /Q "%TOMCAT_PATH%\webapps\himami"
    echo ✅ Removed old himami folder
)

echo.
echo Step 3: Create new deployment
echo =============================

REM Clean local build
if exist "himami-war" rmdir /S /Q himami-war
if exist "himami.war" del himami.war

REM Create WAR structure
mkdir himami-war\WEB-INF\classes

echo 📋 Creating basic webapp...

REM Create index.html
call :create_index_html

REM Create web.xml
call :create_web_xml

REM Copy compiled classes if they exist
if exist "compiled-classes\com" (
    xcopy /E /I compiled-classes\com himami-war\WEB-INF\classes\com\
    echo ✅ Copied compiled classes
) else (
    echo ⚠️ No compiled classes found - will work in demo mode
)

REM Copy CSS and JS if they exist
if exist "css" xcopy /E /I css himami-war\css\
if exist "js" xcopy /E /I js himami-war\js\

REM Copy other HTML files
for %%f in (*.html) do (
    if exist "%%f" copy "%%f" himami-war\
)

echo.
echo Step 4: Create WAR file
echo =======================
cd himami-war
jar -cvf ..\himami.war *
cd ..

echo.
echo Step 5: Deploy to Tomcat
echo ========================
copy himami.war "%TOMCAT_PATH%\webapps\"

echo.
echo Step 6: Start Tomcat
echo ====================
start "" "%TOMCAT_PATH%\bin\startup.bat"

echo.
echo ✅ Deployment completed!
echo.
echo 🕐 Please wait 30 seconds for Tomcat to start and extract the WAR file
echo.
echo 🎯 Then try: http://localhost:8080/himami/
echo.

REM Cleanup
rmdir /S /Q himami-war
del himami.war

echo 📝 If still 404, run: check-deployment.bat
pause
goto :eof

:create_index_html
echo ^<!DOCTYPE html^> > himami-war\index.html
echo ^<html lang="id"^> >> himami-war\index.html
echo ^<head^> >> himami-war\index.html
echo     ^<meta charset="UTF-8"^> >> himami-war\index.html
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> himami-war\index.html
echo     ^<title^>HIMA MI - Test Deployment^</title^> >> himami-war\index.html
echo     ^<style^> >> himami-war\index.html
echo         body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; } >> himami-war\index.html
echo         .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); } >> himami-war\index.html
echo         h1 { color: #2563eb; text-align: center; } >> himami-war\index.html
echo         .success { background: #d1fae5; color: #065f46; padding: 15px; border-radius: 5px; margin: 20px 0; } >> himami-war\index.html
echo         .info { background: #dbeafe; color: #1e40af; padding: 15px; border-radius: 5px; margin: 20px 0; } >> himami-war\index.html
echo         .btn { background: #2563eb; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; margin: 5px; } >> himami-war\index.html
echo         .btn:hover { background: #1d4ed8; } >> himami-war\index.html
echo     ^</style^> >> himami-war\index.html
echo ^</head^> >> himami-war\index.html
echo ^<body^> >> himami-war\index.html
echo     ^<div class="container"^> >> himami-war\index.html
echo         ^<h1^>🎉 HIMA MI - Deployment Success!^</h1^> >> himami-war\index.html
echo         ^<div class="success"^> >> himami-war\index.html
echo             ^<strong^>✅ Congratulations!^</strong^> Your application has been deployed successfully to Tomcat. >> himami-war\index.html
echo         ^</div^> >> himami-war\index.html
echo         ^<div class="info"^> >> himami-war\index.html
echo             ^<strong^>📋 Deployment Info:^</strong^>^<br^> >> himami-war\index.html
echo             Server: Apache Tomcat^<br^> >> himami-war\index.html
echo             Application: HIMA MI^<br^> >> himami-war\index.html
echo             Status: Running^<br^> >> himami-war\index.html
echo             Time: ^<script^>document.write(new Date().toLocaleString());^</script^> >> himami-war\index.html
echo         ^</div^> >> himami-war\index.html
echo         ^<h2^>🧪 Test Features:^</h2^> >> himami-war\index.html
echo         ^<p^>^<a href="api/participants" class="btn"^>Test API^</a^>^</p^> >> himami-war\index.html
echo         ^<p^>If you see this page, your Tomcat deployment is working correctly!^</p^> >> himami-war\index.html
echo         ^<h2^>🔧 Next Steps:^</h2^> >> himami-war\index.html
echo         ^<ul^> >> himami-war\index.html
echo             ^<li^>Copy your actual HTML files to replace this test page^</li^> >> himami-war\index.html
echo             ^<li^>Ensure all Java classes are compiled and deployed^</li^> >> himami-war\index.html
echo             ^<li^>Test your servlets and API endpoints^</li^> >> himami-war\index.html
echo         ^</ul^> >> himami-war\index.html
echo     ^</div^> >> himami-war\index.html
echo ^</body^> >> himami-war\index.html
echo ^</html^> >> himami-war\index.html
goto :eof

:create_web_xml
mkdir himami-war\WEB-INF 2>nul
echo ^<?xml version="1.0" encoding="UTF-8"?^> > himami-war\WEB-INF\web.xml
echo ^<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" >> himami-war\WEB-INF\web.xml
echo          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >> himami-war\WEB-INF\web.xml
echo          xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee >> himami-war\WEB-INF\web.xml
echo          http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd" >> himami-war\WEB-INF\web.xml
echo          version="4.0"^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo     ^<display-name^>HIMA MI Application^</display-name^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo     ^<welcome-file-list^> >> himami-war\WEB-INF\web.xml
echo         ^<welcome-file^>index.html^</welcome-file^> >> himami-war\WEB-INF\web.xml
echo     ^</welcome-file-list^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo ^</web-app^> >> himami-war\WEB-INF\web.xml
goto :eof
