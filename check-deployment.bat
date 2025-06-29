@echo off
echo 🔍 Checking Deployment Status
echo =============================

set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106

echo Current time: %date% %time%
echo Tomcat path: %TOMCAT_PATH%
echo.

echo 📁 Checking Tomcat webapps folder...
if exist "%TOMCAT_PATH%\webapps" (
    echo ✅ Webapps folder exists
    
    echo.
    echo 📋 Contents of webapps:
    dir "%TOMCAT_PATH%\webapps" /B
    
    echo.
    if exist "%TOMCAT_PATH%\webapps\himami.war" (
        echo ✅ himami.war found
        
        REM Check file size and date
        echo 📊 WAR file details:
        dir "%TOMCAT_PATH%\webapps\himami.war"
        
        if exist "%TOMCAT_PATH%\webapps\himami" (
            echo ✅ himami folder exists (deployed)
            echo.
            echo 📁 Contents of himami folder:
            dir "%TOMCAT_PATH%\webapps\himami" /B
            
            echo.
            echo 📋 Checking for key files:
            if exist "%TOMCAT_PATH%\webapps\himami\index.html" (
                echo ✅ index.html found
            ) else (
                echo ❌ index.html missing
            )
            
            if exist "%TOMCAT_PATH%\webapps\himami\WEB-INF" (
                echo ✅ WEB-INF folder found
                
                if exist "%TOMCAT_PATH%\webapps\himami\WEB-INF\web.xml" (
                    echo ✅ web.xml found
                ) else (
                    echo ❌ web.xml missing
                )
                
                if exist "%TOMCAT_PATH%\webapps\himami\WEB-INF\classes" (
                    echo ✅ classes folder found
                    echo.
                    echo 📋 Java classes:
                    dir /S /B "%TOMCAT_PATH%\webapps\himami\WEB-INF\classes\*.class" 2>nul
                ) else (
                    echo ❌ classes folder missing
                )
            ) else (
                echo ❌ WEB-INF folder missing
            )
            
        ) else (
            echo ⚠️ himami folder not found - WAR not extracted yet
            echo 💡 Tomcat may still be extracting the WAR file
        )
        
    ) else (
        echo ❌ himami.war not found in webapps
    )
    
) else (
    echo ❌ Webapps folder not found!
    echo Check TOMCAT_PATH: %TOMCAT_PATH%
)

echo.
echo 🔍 Checking Tomcat process...
tasklist /FI "IMAGENAME eq java.exe" | find "java.exe" >nul
if errorlevel 1 (
    echo ❌ Tomcat not running (no java.exe process found)
    echo 💡 Start Tomcat: %TOMCAT_PATH%\bin\startup.bat
) else (
    echo ✅ Java process found (Tomcat likely running)
)

echo.
echo 📝 Checking Tomcat logs...
if exist "%TOMCAT_PATH%\logs\catalina.out" (
    echo ✅ Catalina log exists
    echo.
    echo 📋 Last 10 lines of catalina.out:
    powershell "Get-Content '%TOMCAT_PATH%\logs\catalina.out' -Tail 10"
) else (
    echo ⚠️ catalina.out not found
)

echo.
echo 🎯 DIAGNOSIS & SOLUTIONS:
echo =========================

if not exist "%TOMCAT_PATH%\webapps\himami.war" (
    echo ❌ PROBLEM: WAR file not deployed
    echo 💡 SOLUTION: Run deploy-now.bat again
)

if exist "%TOMCAT_PATH%\webapps\himami.war" (
    if not exist "%TOMCAT_PATH%\webapps\himami" (
        echo ⚠️ PROBLEM: WAR file exists but not extracted
        echo 💡 SOLUTION: Wait 30 seconds or restart Tomcat
    )
)

if exist "%TOMCAT_PATH%\webapps\himami" (
    if not exist "%TOMCAT_PATH%\webapps\himami\index.html" (
        echo ❌ PROBLEM: Application deployed but missing files
        echo 💡 SOLUTION: Check WAR content or redeploy
    )
)

echo.
pause
