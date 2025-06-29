@echo off
echo 🚀 Full Deployment Script for Your Project
echo ==========================================

REM Set Tomcat path
set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106
set SERVLET_JAR=%TOMCAT_PATH%\lib\servlet-api.jar

echo Using Tomcat: %TOMCAT_PATH%
echo Current directory: %CD%
echo.

REM Step 1: Clean previous builds
echo 🧹 Cleaning previous builds...
if exist "compiled-classes" rmdir /S /Q compiled-classes
if exist "himami-war" rmdir /S /Q himami-war
if exist "himami.war" del himami.war

REM Step 2: Create directories
echo 📁 Creating directories...
mkdir compiled-classes
mkdir himami-war\WEB-INF\classes

REM Step 3: Compile Java files
echo 🔄 Compiling Java files...
call compile-for-your-structure.bat

if not exist "compiled-classes\com\himami" (
    echo ❌ Compilation failed! Cannot continue.
    pause
    exit /b 1
)

REM Step 4: Copy webapp files
echo 📋 Copying webapp files...
if exist "main\webapp" (
    xcopy /E /I main\webapp\* himami-war\
    echo ✅ Copied from main\webapp\
) else (
    echo ❌ main\webapp folder not found!
    echo Creating basic structure...
    
    REM Copy HTML files if they exist in current directory
    if exist "*.html" (
        copy *.html himami-war\
        echo ✅ Copied HTML files
    )
    
    REM Copy CSS files
    if exist "css" (
        xcopy /E /I css himami-war\css\
        echo ✅ Copied CSS folder
    )
    
    REM Copy JS files
    if exist "js" (
        xcopy /E /I js himami-war\js\
        echo ✅ Copied JS folder
    )
    
    REM Create basic web.xml if not exists
    if not exist "himami-war\WEB-INF\web.xml" (
        echo Creating basic web.xml...
        call :create_webxml
    )
)

REM Step 5: Copy compiled classes
echo 📦 Copying compiled classes...
xcopy /E /I compiled-classes\com himami-war\WEB-INF\classes\com\
echo ✅ Copied compiled classes

REM Step 6: Create WAR file
echo 🗜️ Creating WAR file...
cd himami-war
jar -cvf ..\himami.war *
cd ..

if exist "himami.war" (
    echo ✅ WAR file created successfully!
    
    REM Step 7: Deploy to Tomcat
    echo 🚀 Deploying to Tomcat...
    copy himami.war "%TOMCAT_PATH%\webapps\"
    
    if exist "%TOMCAT_PATH%\webapps\himami.war" (
        echo ✅ Deployed to Tomcat successfully!
        echo.
        echo 🎯 Next steps:
        echo 1. Start Tomcat: %TOMCAT_PATH%\bin\startup.bat
        echo 2. Wait for deployment (check webapps\himami folder)
        echo 3. Access: http://localhost:8080/himami/
        echo 4. Check logs: %TOMCAT_PATH%\logs\catalina.out
    ) else (
        echo ❌ Failed to copy to Tomcat webapps
    )
) else (
    echo ❌ Failed to create WAR file
)

REM Step 8: Cleanup
echo 🧹 Cleaning up temporary files...
rmdir /S /Q compiled-classes
rmdir /S /Q himami-war

echo.
echo ✅ Deployment process completed!
pause
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
echo. >> himami-war\WEB-INF\web.xml
echo     ^<welcome-file-list^> >> himami-war\WEB-INF\web.xml
echo         ^<welcome-file^>index.html^</welcome-file^> >> himami-war\WEB-INF\web.xml
echo     ^</welcome-file-list^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo ^</web-app^> >> himami-war\WEB-INF\web.xml
echo ✅ Created basic web.xml
goto :eof
