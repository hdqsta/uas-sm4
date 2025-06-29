@echo off
echo 🚀 Complete Deployment with Fixed Compilation
echo ============================================

REM Set Tomcat path
set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106
set SERVLET_JAR=%TOMCAT_PATH%\lib\servlet-api.jar

echo Using Tomcat: %TOMCAT_PATH%
echo.

REM Step 1: Clean and compile
echo 🔧 Step 1: Compiling Java files...
call fixed-compile.bat

if not exist "compiled-classes\com\himami\servlet" (
    echo ❌ Compilation failed! Cannot continue.
    pause
    exit /b 1
)

REM Step 2: Create WAR structure
echo 📁 Step 2: Creating WAR structure...
if exist "himami-war" rmdir /S /Q himami-war
mkdir himami-war\WEB-INF\classes

REM Step 3: Copy webapp files
echo 📋 Step 3: Copying webapp files...
if exist "main\webapp" (
    xcopy /E /I main\webapp\* himami-war\
    echo ✅ Copied from main\webapp\
) else (
    echo ⚠️ main\webapp not found, creating basic structure...
    
    REM Create basic web.xml
    call :create_webxml
    
    REM Copy any HTML files from current directory
    for %%f in (*.html) do (
        copy "%%f" himami-war\
        echo ✅ Copied %%f
    )
    
    REM Copy CSS and JS folders if they exist
    if exist "css" (
        xcopy /E /I css himami-war\css\
        echo ✅ Copied CSS folder
    )
    
    if exist "js" (
        xcopy /E /I js himami-war\js\
        echo ✅ Copied JS folder
    )
)

REM Step 4: Copy compiled classes
echo 📦 Step 4: Copying compiled classes...
xcopy /E /I compiled-classes\com himami-war\WEB-INF\classes\com\
echo ✅ Copied compiled classes

REM Step 5: Create WAR file
echo 🗜️ Step 5: Creating WAR file...
cd himami-war
jar -cvf ..\himami.war *
cd ..

REM Step 6: Deploy to Tomcat
echo 🚀 Step 6: Deploying to Tomcat...
if exist "himami.war" (
    copy himami.war "%TOMCAT_PATH%\webapps\"
    echo ✅ Deployed to Tomcat!
    
    echo.
    echo 🎯 Deployment Complete!
    echo ========================
    echo 1. Start Tomcat: %TOMCAT_PATH%\bin\startup.bat
    echo 2. Wait for deployment (check webapps\himami folder)
    echo 3. Access: http://localhost:8080/himami/
    echo 4. Check logs: %TOMCAT_PATH%\logs\catalina.out
    echo.
    echo 📝 Test URLs:
    echo - Main page: http://localhost:8080/himami/
    echo - API test: http://localhost:8080/himami/api/participants
    
) else (
    echo ❌ Failed to create WAR file
)

REM Step 7: Cleanup
echo 🧹 Step 7: Cleaning up...
rmdir /S /Q compiled-classes
rmdir /S /Q himami-war

echo.
pause
goto :eof

:create_webxml
mkdir himami-war\WEB-INF
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
echo     ^<servlet^> >> himami-war\WEB-INF\web.xml
echo         ^<servlet-name^>ParticipantServlet^</servlet-name^> >> himami-war\WEB-INF\web.xml
echo         ^<servlet-class^>com.himami.servlet.ParticipantServlet^</servlet-class^> >> himami-war\WEB-INF\web.xml
echo     ^</servlet^> >> himami-war\WEB-INF\web.xml
echo     ^<servlet-mapping^> >> himami-war\WEB-INF\web.xml
echo         ^<servlet-name^>ParticipantServlet^</servlet-name^> >> himami-war\WEB-INF\web.xml
echo         ^<url-pattern^>/api/participants^</url-pattern^> >> himami-war\WEB-INF\web.xml
echo     ^</servlet-mapping^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo     ^<servlet^> >> himami-war\WEB-INF\web.xml
echo         ^<servlet-name^>AuthServlet^</servlet-name^> >> himami-war\WEB-INF\web.xml
echo         ^<servlet-class^>com.himami.servlet.AuthServlet^</servlet-class^> >> himami-war\WEB-INF\web.xml
echo     ^</servlet^> >> himami-war\WEB-INF\web.xml
echo     ^<servlet-mapping^> >> himami-war\WEB-INF\web.xml
echo         ^<servlet-name^>AuthServlet^</servlet-name^> >> himami-war\WEB-INF\web.xml
echo         ^<url-pattern^>/api/auth^</url-pattern^> >> himami-war\WEB-INF\web.xml
echo     ^</servlet-mapping^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo     ^<servlet^> >> himami-war\WEB-INF\web.xml
echo         ^<servlet-name^>RegisterServlet^</servlet-name^> >> himami-war\WEB-INF\web.xml
echo         ^<servlet-class^>com.himami.servlet.RegisterServlet^</servlet-class^> >> himami-war\WEB-INF\web.xml
echo     ^</servlet^> >> himami-war\WEB-INF\web.xml
echo     ^<servlet-mapping^> >> himami-war\WEB-INF\web.xml
echo         ^<servlet-name^>RegisterServlet^</servlet-name^> >> himami-war\WEB-INF\web.xml
echo         ^<url-pattern^>/api/register^</url-pattern^> >> himami-war\WEB-INF\web.xml
echo     ^</servlet-mapping^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo ^</web-app^> >> himami-war\WEB-INF\web.xml
echo ✅ Created web.xml with servlet mappings
goto :eof
