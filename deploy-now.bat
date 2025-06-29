@echo off
echo 🚀 Deploy Now - Complete Process
echo ================================

set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106

echo Step 1: Final compilation...
call final-fix-compile.bat

echo.
echo Step 2: Creating deployment package...

REM Clean previous deployment
if exist "himami-war" rmdir /S /Q himami-war
if exist "himami.war" del himami.war

REM Create WAR structure
mkdir himami-war\WEB-INF\classes

echo 📋 Copying files...

REM Copy compiled classes
if exist "compiled-classes\com" (
    xcopy /E /I compiled-classes\com himami-war\WEB-INF\classes\com\
    echo ✅ Copied compiled classes
) else (
    echo ❌ No compiled classes found!
    pause
    exit /b 1
)

REM Copy webapp files
if exist "main\webapp" (
    xcopy /E /I main\webapp\* himami-war\
    echo ✅ Copied webapp files
) else (
    echo ⚠️ Creating basic webapp structure...
    
    REM Create web.xml
    call :create_webxml
    
    REM Copy HTML files if they exist
    for %%f in (*.html) do (
        if exist "%%f" (
            copy "%%f" himami-war\
            echo ✅ Copied %%f
        )
    )
    
    REM Copy folders
    if exist "css" xcopy /E /I css himami-war\css\
    if exist "js" xcopy /E /I js himami-war\js\
)

echo 🗜️ Creating WAR file...
cd himami-war
jar -cvf ..\himami.war *
cd ..

echo 🚀 Deploying to Tomcat...
if exist "himami.war" (
    copy himami.war "%TOMCAT_PATH%\webapps\"
    
    if exist "%TOMCAT_PATH%\webapps\himami.war" (
        echo.
        echo ✅ DEPLOYMENT SUCCESSFUL!
        echo ========================
        echo.
        echo 🎯 Next Steps:
        echo 1. Start Tomcat: %TOMCAT_PATH%\bin\startup.bat
        echo 2. Wait 30 seconds for deployment
        echo 3. Check: %TOMCAT_PATH%\webapps\himami\ folder exists
        echo 4. Access: http://localhost:8080/himami/
        echo.
        echo 🧪 Test URLs:
        echo - Main: http://localhost:8080/himami/
        echo - API: http://localhost:8080/himami/api/participants
        echo.
        echo 📝 If issues, check: %TOMCAT_PATH%\logs\catalina.out
        
    ) else (
        echo ❌ Failed to copy to Tomcat
    )
) else (
    echo ❌ WAR file not created
)

REM Cleanup
echo 🧹 Cleaning up...
rmdir /S /Q compiled-classes 2>nul
rmdir /S /Q himami-war 2>nul

echo.
echo 🎉 Process completed!
pause
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
