@echo off
echo 🔄 Compile Java Classes and Deploy Full Application
echo ==================================================

echo Step 1: Compile Java classes
echo ============================
call final-fix-compile.bat

echo.
echo Step 2: Deploy full application
echo ===============================
call deploy-full-application.bat

echo.
echo ✅ Complete deployment finished!
echo.
echo 🌐 Your HIMA MI application is now running at:
echo    http://localhost:8080/himami/
echo.
echo 📋 Available features:
echo - ✅ Complete UI with proper styling
echo - ✅ Registration form with servlet backend
echo - ✅ Login system
echo - ✅ Responsive design
echo - ✅ API endpoints for data management
echo.

pause
