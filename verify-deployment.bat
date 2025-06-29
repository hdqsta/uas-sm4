@echo off
echo 🔍 Verifying Deployment After Fix
echo =================================

set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106

echo Checking deployment status...
echo.

echo 📁 Checking webapps folder:
if exist "%TOMCAT_PATH%\webapps\himami.war" (
    echo ✅ himami.war exists
    
    REM Check if it's a file or directory
    dir "%TOMCAT_PATH%\webapps\himami.war" | find "<DIR>" >nul
    if errorlevel 1 (
        echo ✅ himami.war is a proper FILE (not directory)
        
        REM Show file size
        for %%A in ("%TOMCAT_PATH%\webapps\himami.war") do (
            echo 📊 File size: %%~zA bytes
        )
    ) else (
        echo ❌ himami.war is still a directory! Need to fix again.
    )
) else (
    echo ❌ himami.war not found
)

echo.
echo 📂 Checking extracted application:
if exist "%TOMCAT_PATH%\webapps\himami" (
    echo ✅ himami folder exists (application extracted)
    
    echo 📋 Contents:
    dir "%TOMCAT_PATH%\webapps\himami" /B
    
    echo.
    echo 🔍 Checking key files:
    if exist "%TOMCAT_PATH%\webapps\himami\index.html" (
        echo ✅ index.html found
    ) else (
        echo ❌ index.html missing
    )
    
    if exist "%TOMCAT_PATH%\webapps\himami\WEB-INF\web.xml" (
        echo ✅ web.xml found
    ) else (
        echo ❌ web.xml missing
    )
    
) else (
    echo ⏳ himami folder not found yet - Tomcat may still be extracting
    echo 💡 Wait 30 seconds and run this script again
)

echo.
echo 🌐 Testing URL access:
echo Attempting to access http://localhost:8080/himami/
echo.

REM Try to test the URL using curl or powershell
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/himami/' -TimeoutSec 10; Write-Host '✅ URL accessible - Status:' $response.StatusCode } catch { Write-Host '❌ URL not accessible:' $_.Exception.Message }"

echo.
echo 📝 Summary:
echo ===========
if exist "%TOMCAT_PATH%\webapps\himami\index.html" (
    echo ✅ Deployment appears successful!
    echo 🌐 Try: http://localhost:8080/himami/
) else (
    echo ⏳ Deployment in progress or failed
    echo 💡 Wait a bit longer or check Tomcat logs
)

echo.
pause
