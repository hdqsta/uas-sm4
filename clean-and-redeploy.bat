@echo off
echo 🧹 Clean and Proper Redeploy
echo ============================

set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106

echo Step 1: Clean ALL temporary files
echo =================================
if exist "himami-war" (
    echo Removing temporary himami-war folder from src...
    rmdir /S /Q himami-war
    echo ✅ Removed himami-war from src
)

if exist "himami.war" (
    echo Removing temporary himami.war file from src...
    del himami.war
    echo ✅ Removed himami.war from src
)

echo.
echo Step 2: Clean webapps deployment
echo ================================
taskkill /F /IM java.exe 2>nul
timeout /t 3 /nobreak >nul

if exist "%TOMCAT_PATH%\webapps\himami.war" (
    echo Removing himami.war from webapps...
    if exist "%TOMCAT_PATH%\webapps\himami.war\*" (
        rmdir /S /Q "%TOMCAT_PATH%\webapps\himami.war"
    ) else (
        del "%TOMCAT_PATH%\webapps\himami.war"
    )
    echo ✅ Removed himami.war from webapps
)

if exist "%TOMCAT_PATH%\webapps\himami" (
    echo Removing himami folder from webapps...
    rmdir /S /Q "%TOMCAT_PATH%\webapps\himami"
    echo ✅ Removed himami folder from webapps
)

echo.
echo Step 3: Create proper deployment
echo ================================

REM Create temporary build folder
mkdir himami-war
mkdir himami-war\WEB-INF
mkdir himami-war\WEB-INF\classes

echo 📝 Creating application files...

REM Create index.html
call :create_index

REM Create web.xml  
call :create_webxml

REM Copy compiled classes if available
if exist "compiled-classes\com" (
    xcopy /E /I compiled-classes\com himami-war\WEB-INF\classes\com\
    echo ✅ Added Java classes
)

REM Copy static files
if exist "css" xcopy /E /I css himami-war\css\
if exist "js" xcopy /E /I js himami-war\js\
for %%f in (*.html) do if exist "%%f" copy "%%f" himami-war\

echo.
echo Step 4: Create proper WAR FILE
echo ==============================
cd himami-war
jar -cvf ..\himami.war *
cd ..

echo ✅ Created himami.war FILE (not folder)

echo.
echo Step 5: Deploy to webapps
echo =========================
copy himami.war "%TOMCAT_PATH%\webapps\"

echo ✅ Deployed himami.war to webapps

echo.
echo Step 6: Clean temporary files
echo =============================
rmdir /S /Q himami-war
del himami.war

echo ✅ Cleaned temporary files from src

echo.
echo Step 7: Start Tomcat
echo ====================
start "" "%TOMCAT_PATH%\bin\startup.bat"

echo.
echo ✅ PROPER DEPLOYMENT COMPLETED!
echo ===============================
echo.
echo 📁 FINAL STRUCTURE:
echo src/                     ← Clean (no temporary files)
echo webapps/himami.war       ← WAR FILE for deployment  
echo webapps/himami/          ← RUNNING APPLICATION (after extraction)
echo.
echo 🕐 Wait 60 seconds, then access: http://localhost:8080/himami/
echo.

pause
goto :eof

:create_index
echo ^<!DOCTYPE html^> > himami-war\index.html
echo ^<html^>^<head^>^<title^>HIMA MI^</title^>^</head^> >> himami-war\index.html
echo ^<body^>^<h1^>HIMA MI Deployment Success!^</h1^> >> himami-war\index.html
echo ^<p^>Application is running properly.^</p^>^</body^>^</html^> >> himami-war\index.html
goto :eof

:create_webxml
echo ^<?xml version="1.0" encoding="UTF-8"?^> > himami-war\WEB-INF\web.xml
echo ^<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="4.0"^> >> himami-war\WEB-INF\web.xml
echo ^<display-name^>HIMA MI^</display-name^> >> himami-war\WEB-INF\web.xml
echo ^<welcome-file-list^>^<welcome-file^>index.html^</welcome-file^>^</welcome-file-list^> >> himami-war\WEB-INF\web.xml
echo ^</web-app^> >> himami-war\WEB-INF\web.xml
goto :eof
