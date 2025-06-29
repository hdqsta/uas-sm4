@echo off
echo 🧪 TEST ALL PAGES
echo =================

echo Opening all pages in browser...

start "" "http://localhost:8080/himami/"
timeout /t 2 /nobreak >nul

start "" "http://localhost:8080/himami/login.html"
timeout /t 2 /nobreak >nul

start "" "http://localhost:8080/himami/register.html"
timeout /t 2 /nobreak >nul

start "" "http://localhost:8080/himami/profile.html"
timeout /t 2 /nobreak >nul

echo.
echo 📋 Testing API endpoints...
echo.

echo Testing GET /api/participants:
curl -X GET "http://localhost:8080/himami/api/participants" 2>nul
echo.
echo.

echo Testing POST /api/participants:
curl -X POST "http://localhost:8080/himami/api/participants" ^
     -H "Content-Type: application/json" ^
     -d "{\"namaLengkap\":\"Test User\",\"prodi\":\"Manajemen Informatika\",\"email\":\"test@polsri.ac.id\",\"nomorHP\":\"081234567890\",\"programHimpunan\":\"coding\"}" 2>nul
echo.
echo.

echo ✅ All tests completed!
pause
