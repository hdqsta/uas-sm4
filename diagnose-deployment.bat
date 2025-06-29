@echo off
echo 🔍 DIAGNOSE DEPLOYMENT ISSUE
echo ============================

set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106

echo Step 1: Check Tomcat Status
echo ==========================
tasklist /FI "IMAGENAME eq java.exe" | find "java.exe" >nul
if %errorlevel% == 0 (
    echo ✅ Tomcat is running
) else (
    echo ❌ Tomcat is NOT running
    echo Starting Tomcat...
    start "" "%TOMCAT_PATH%\bin\startup.bat"
    timeout /t 10 /nobreak >nul
)

echo.
echo Step 2: Check WAR File
echo =====================
if exist "%TOMCAT_PATH%\webapps\himami.war" (
    echo ✅ himami.war exists in webapps
    dir "%TOMCAT_PATH%\webapps\himami.war"
) else (
    echo ❌ himami.war NOT found in webapps
)

echo.
echo Step 3: Check Extracted Application
echo ==================================
if exist "%TOMCAT_PATH%\webapps\himami" (
    echo ✅ himami folder exists
    echo Contents:
    dir "%TOMCAT_PATH%\webapps\himami" /B
    echo.
    echo HTML files:
    dir "%TOMCAT_PATH%\webapps\himami\*.html" /B 2>nul
    if %errorlevel% == 0 (
        echo ✅ HTML files found
    ) else (
        echo ❌ No HTML files found
    )
) else (
    echo ❌ himami folder NOT found - WAR not extracted
)

echo.
echo Step 4: Check Tomcat Logs
echo =========================
if exist "%TOMCAT_PATH%\logs\catalina.out" (
    echo Last 10 lines of catalina.out:
    powershell -Command "Get-Content '%TOMCAT_PATH%\logs\catalina.out' -Tail 10"
) else (
    echo ❌ No catalina.out log found
)

echo.
echo Step 5: Manual Check URLs
echo ========================
echo Testing URLs:
echo - Main: http://localhost:8080/himami/
echo - Login: http://localhost:8080/himami/login.html
echo.

pause
