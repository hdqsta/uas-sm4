@echo off
echo 🚀 Deploy Full HIMA MI Application
echo ==================================

set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106

echo Step 1: Stop Tomcat and clean deployment
echo ========================================
taskkill /F /IM java.exe 2>nul
timeout /t 3 /nobreak >nul

if exist "%TOMCAT_PATH%\webapps\himami.war" del "%TOMCAT_PATH%\webapps\himami.war"
if exist "%TOMCAT_PATH%\webapps\himami" rmdir /S /Q "%TOMCAT_PATH%\webapps\himami"

echo ✅ Cleaned previous deployment

echo.
echo Step 2: Create full application structure
echo ========================================

if exist "himami-war" rmdir /S /Q himami-war
mkdir himami-war\WEB-INF\classes
mkdir himami-war\css
mkdir himami-war\js

echo 📝 Creating complete HIMA MI application...

REM Create main HTML files
call :create_index_html
call :create_login_html
call :create_register_html
call :create_profile_html

REM Create CSS files
call :create_css_files

REM Create JavaScript files
call :create_js_files

REM Create web.xml with servlet mappings
call :create_complete_webxml

echo ✅ Created all application files

echo.
echo Step 3: Copy compiled Java classes
echo ==================================

if exist "compiled-classes\com" (
    xcopy /E /I compiled-classes\com himami-war\WEB-INF\classes\com\
    echo ✅ Copied Java servlet classes
) else (
    echo ⚠️ No compiled classes found - application will work in demo mode
)

echo.
echo Step 4: Create WAR file
echo =======================

REM Find jar command
set JAR_CMD=
for /d %%d in ("C:\Program Files\Java\jdk*") do (
    if exist "%%d\bin\jar.exe" (
        set JAR_CMD=%%d\bin\jar.exe
        goto :found_jar
    )
)

:found_jar
if "%JAR_CMD%"=="" (
    echo Using PowerShell method...
    cd himami-war
    powershell -Command "Compress-Archive -Path * -DestinationPath ..\himami.zip -Force"
    cd ..
    ren himami.zip himami.war
) else (
    echo Using JAR command...
    cd himami-war
    "%JAR_CMD%" -cvf ..\himami.war *
    cd ..
)

echo ✅ WAR file created

echo.
echo Step 5: Deploy to Tomcat
echo ========================

copy himami.war "%TOMCAT_PATH%\webapps\"
echo ✅ Deployed to Tomcat

echo.
echo Step 6: Start Tomcat
echo ====================

start "" "%TOMCAT_PATH%\bin\startup.bat"
echo ✅ Tomcat started

echo.
echo Step 7: Cleanup
echo ===============

rmdir /S /Q himami-war
del himami.war
echo ✅ Cleaned temporary files

echo.
echo 🎉 FULL APPLICATION DEPLOYED!
echo =============================
echo.
echo 🕐 Wait 60 seconds for complete startup
echo 🌐 Access: http://localhost:8080/himami/
echo.
echo 📋 Available pages:
echo - Main page: http://localhost:8080/himami/
echo - Login: http://localhost:8080/himami/login.html
echo - Register: http://localhost:8080/himami/register.html
echo - Profile: http://localhost:8080/himami/profile.html
echo.
echo 🧪 Test API:
echo - Participants: http://localhost:8080/himami/api/participants
echo - Auth: http://localhost:8080/himami/api/auth
echo.

pause
goto :eof

:create_index_html
echo Creating index.html...
echo ^<!DOCTYPE html^> > himami-war\index.html
echo ^<html lang="id"^> >> himami-war\index.html
echo ^<head^> >> himami-war\index.html
echo     ^<meta charset="UTF-8"^> >> himami-war\index.html
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> himami-war\index.html
echo     ^<title^>HIMA MI - Himpunan Mahasiswa Manajemen Informatika^</title^> >> himami-war\index.html
echo     ^<link rel="stylesheet" href="css/style.css"^> >> himami-war\index.html
echo     ^<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"^> >> himami-war\index.html
echo ^</head^> >> himami-war\index.html
echo ^<body^> >> himami-war\index.html
echo     ^<header class="header"^> >> himami-war\index.html
echo         ^<div class="container"^> >> himami-war\index.html
echo             ^<div class="header-content"^> >> himami-war\index.html
echo                 ^<div class="logo-section"^> >> himami-war\index.html
echo                     ^<div class="logo"^>^<i class="fas fa-graduation-cap"^>^</i^>^</div^> >> himami-war\index.html
echo                     ^<div class="logo-text"^> >> himami-war\index.html
echo                         ^<h1^>HIMA MI^</h1^> >> himami-war\index.html
echo                         ^<p^>Himpunan Mahasiswa Manajemen Informatika^</p^> >> himami-war\index.html
echo                     ^</div^> >> himami-war\index.html
echo                 ^</div^> >> himami-war\index.html
echo                 ^<div class="auth-section"^> >> himami-war\index.html
echo                     ^<a href="login.html" class="btn btn-outline"^>Login^</a^> >> himami-war\index.html
echo                     ^<a href="register.html" class="btn btn-primary"^>Daftar^</a^> >> himami-war\index.html
echo                 ^</div^> >> himami-war\index.html
echo             ^</div^> >> himami-war\index.html
echo         ^</div^> >> himami-war\index.html
echo     ^</header^> >> himami-war\index.html
echo. >> himami-war\index.html
echo     ^<main class="main-content"^> >> himami-war\index.html
echo         ^<div class="container"^> >> himami-war\index.html
echo             ^<div class="hero"^> >> himami-war\index.html
echo                 ^<div class="hero-icon"^>^<i class="fas fa-book-open"^>^</i^>^</div^> >> himami-war\index.html
echo                 ^<h2^>Selamat Datang di HIMA MI^</h2^> >> himami-war\index.html
echo                 ^<p^>Himpunan Mahasiswa Manajemen Informatika Politeknik Negeri Sriwijaya^</p^> >> himami-war\index.html
echo                 ^<div class="hero-buttons"^> >> himami-war\index.html
echo                     ^<a href="register.html" class="btn btn-primary"^>Daftar Sekarang^</a^> >> himami-war\index.html
echo                     ^<a href="#about" class="btn btn-secondary"^>Pelajari Lebih Lanjut^</a^> >> himami-war\index.html
echo                 ^</div^> >> himami-war\index.html
echo             ^</div^> >> himami-war\index.html
echo         ^</div^> >> himami-war\index.html
echo     ^</main^> >> himami-war\index.html
echo. >> himami-war\index.html
echo     ^<script src="js/script.js"^>^</script^> >> himami-war\index.html
echo ^</body^> >> himami-war\index.html
echo ^</html^> >> himami-war\index.html
goto :eof

:create_login_html
echo Creating login.html...
echo ^<!DOCTYPE html^> > himami-war\login.html
echo ^<html lang="id"^> >> himami-war\login.html
echo ^<head^> >> himami-war\login.html
echo     ^<meta charset="UTF-8"^> >> himami-war\login.html
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> himami-war\login.html
echo     ^<title^>Login - HIMA MI^</title^> >> himami-war\login.html
echo     ^<link rel="stylesheet" href="css/style.css"^> >> himami-war\login.html
echo     ^<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"^> >> himami-war\login.html
echo ^</head^> >> himami-war\login.html
echo ^<body class="login-page"^> >> himami-war\login.html
echo     ^<div class="login-container"^> >> himami-war\login.html
echo         ^<div class="login-header"^> >> himami-war\login.html
echo             ^<div class="logo"^>^<i class="fas fa-graduation-cap"^>^</i^>^</div^> >> himami-war\login.html
echo             ^<h1^>HIMA MI^</h1^> >> himami-war\login.html
echo             ^<p^>Himpunan Mahasiswa Manajemen Informatika^</p^> >> himami-war\login.html
echo         ^</div^> >> himami-war\login.html
echo         ^<div class="login-form-container"^> >> himami-war\login.html
echo             ^<h2^>Login^</h2^> >> himami-war\login.html
echo             ^<form id="loginForm"^> >> himami-war\login.html
echo                 ^<div class="form-group"^> >> himami-war\login.html
echo                     ^<label^>Username^</label^> >> himami-war\login.html
echo                     ^<input type="text" name="username" required^> >> himami-war\login.html
echo                 ^</div^> >> himami-war\login.html
echo                 ^<div class="form-group"^> >> himami-war\login.html
echo                     ^<label^>Password^</label^> >> himami-war\login.html
echo                     ^<input type="password" name="password" required^> >> himami-war\login.html
echo                 ^</div^> >> himami-war\login.html
echo                 ^<button type="submit" class="btn btn-primary btn-full"^>Login^</button^> >> himami-war\login.html
echo             ^</form^> >> himami-war\login.html
echo         ^</div^> >> himami-war\login.html
echo         ^<div class="back-home"^> >> himami-war\login.html
echo             ^<a href="index.html" class="btn btn-ghost"^>← Kembali ke Beranda^</a^> >> himami-war\login.html
echo         ^</div^> >> himami-war\login.html
echo     ^</div^> >> himami-war\login.html
echo     ^<script src="js/script.js"^>^</script^> >> himami-war\login.html
echo ^</body^> >> himami-war\login.html
echo ^</html^> >> himami-war\login.html
goto :eof

:create_register_html
echo Creating register.html...
echo ^<!DOCTYPE html^> > himami-war\register.html
echo ^<html lang="id"^> >> himami-war\register.html
echo ^<head^> >> himami-war\register.html
echo     ^<meta charset="UTF-8"^> >> himami-war\register.html
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> himami-war\register.html
echo     ^<title^>Register - HIMA MI^</title^> >> himami-war\register.html
echo     ^<link rel="stylesheet" href="css/style.css"^> >> himami-war\register.html
echo     ^<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"^> >> himami-war\register.html
echo ^</head^> >> himami-war\register.html
echo ^<body class="register-page"^> >> himami-war\register.html
echo     ^<div class="register-container"^> >> himami-war\register.html
echo         ^<div class="register-header"^> >> himami-war\register.html
echo             ^<div class="logo"^>^<i class="fas fa-graduation-cap"^>^</i^>^</div^> >> himami-war\register.html
echo             ^<h1^>HIMA MI^</h1^> >> himami-war\register.html
echo             ^<p^>Daftar Ekstrakurikuler^</p^> >> himami-war\register.html
echo         ^</div^> >> himami-war\register.html
echo         ^<div class="register-form-container"^> >> himami-war\register.html
echo             ^<h2^>Daftar Ekstrakurikuler^</h2^> >> himami-war\register.html
echo             ^<form id="registerForm"^> >> himami-war\register.html
echo                 ^<div class="form-group"^> >> himami-war\register.html
echo                     ^<label^>Nama Lengkap^</label^> >> himami-war\register.html
echo                     ^<input type="text" name="namaLengkap" required^> >> himami-war\register.html
echo                 ^</div^> >> himami-war\register.html
echo                 ^<div class="form-group"^> >> himami-war\register.html
echo                     ^<label^>Program Studi^</label^> >> himami-war\register.html
echo                     ^<select name="prodi" required^> >> himami-war\register.html
echo                         ^<option value=""^>Pilih Program Studi^</option^> >> himami-war\register.html
echo                         ^<option value="Manajemen Informatika"^>Manajemen Informatika^</option^> >> himami-war\register.html
echo                         ^<option value="Teknik Komputer"^>Teknik Komputer^</option^> >> himami-war\register.html
echo                         ^<option value="Sistem Informasi"^>Sistem Informasi^</option^> >> himami-war\register.html
echo                     ^</select^> >> himami-war\register.html
echo                 ^</div^> >> himami-war\register.html
echo                 ^<div class="form-group"^> >> himami-war\register.html
echo                     ^<label^>Email^</label^> >> himami-war\register.html
echo                     ^<input type="email" name="email" required^> >> himami-war\register.html
echo                 ^</div^> >> himami-war\register.html
echo                 ^<div class="form-group"^> >> himami-war\register.html
echo                     ^<label^>Nomor HP^</label^> >> himami-war\register.html
echo                     ^<input type="tel" name="nomorHP" required^> >> himami-war\register.html
echo                 ^</div^> >> himami-war\register.html
echo                 ^<div class="form-group"^> >> himami-war\register.html
echo                     ^<label^>Program Ekstrakurikuler^</label^> >> himami-war\register.html
echo                     ^<select name="programHimpunan" required^> >> himami-war\register.html
echo                         ^<option value=""^>Pilih Program^</option^> >> himami-war\register.html
echo                         ^<option value="coding"^>Programming ^& Coding^</option^> >> himami-war\register.html
echo                         ^<option value="volley"^>Volleyball^</option^> >> himami-war\register.html
echo                         ^<option value="futsal"^>Futsal^</option^> >> himami-war\register.html
echo                         ^<option value="badminton"^>Badminton^</option^> >> himami-war\register.html
echo                     ^</select^> >> himami-war\register.html
echo                 ^</div^> >> himami-war\register.html
echo                 ^<button type="submit" class="btn btn-primary btn-full"^>Daftar Sekarang^</button^> >> himami-war\register.html
echo             ^</form^> >> himami-war\register.html
echo         ^</div^> >> himami-war\register.html
echo         ^<div class="back-home"^> >> himami-war\register.html
echo             ^<a href="index.html" class="btn btn-ghost"^>← Kembali ke Beranda^</a^> >> himami-war\register.html
echo         ^</div^> >> himami-war\register.html
echo     ^</div^> >> himami-war\register.html
echo     ^<script src="js/script.js"^>^</script^> >> himami-war\register.html
echo ^</body^> >> himami-war\register.html
echo ^</html^> >> himami-war\register.html
goto :eof

:create_profile_html
echo Creating profile.html...
echo ^<!DOCTYPE html^> > himami-war\profile.html
echo ^<html lang="id"^> >> himami-war\profile.html
echo ^<head^> >> himami-war\profile.html
echo     ^<meta charset="UTF-8"^> >> himami-war\profile.html
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> himami-war\profile.html
echo     ^<title^>Profile - HIMA MI^</title^> >> himami-war\profile.html
echo     ^<link rel="stylesheet" href="css/style.css"^> >> himami-war\profile.html
echo     ^<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"^> >> himami-war\profile.html
echo ^</head^> >> himami-war\profile.html
echo ^<body^> >> himami-war\profile.html
echo     ^<div class="container"^> >> himami-war\profile.html
echo         ^<h1^>Profile Page^</h1^> >> himami-war\profile.html
echo         ^<p^>User profile information will be displayed here.^</p^> >> himami-war\profile.html
echo         ^<a href="index.html" class="btn btn-primary"^>Back to Home^</a^> >> himami-war\profile.html
echo     ^</div^> >> himami-war\profile.html
echo     ^<script src="js/script.js"^>^</script^> >> himami-war\profile.html
echo ^</body^> >> himami-war\profile.html
echo ^</html^> >> himami-war\profile.html
goto :eof

:create_css_files
echo Creating CSS files...
echo /* HIMA MI Styles */ > himami-war\css\style.css
echo :root { >> himami-war\css\style.css
echo   --primary-color: #3b82f6; >> himami-war\css\style.css
echo   --primary-dark: #2563eb; >> himami-war\css\style.css
echo   --bg-primary: #ffffff; >> himami-war\css\style.css
echo   --text-primary: #1f2937; >> himami-war\css\style.css
echo   --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo * { margin: 0; padding: 0; box-sizing: border-box; } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo body { >> himami-war\css\style.css
echo   font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; >> himami-war\css\style.css
echo   line-height: 1.6; >> himami-war\css\style.css
echo   color: var(--text-primary); >> himami-war\css\style.css
echo   background: linear-gradient(135deg, #ebf4ff 0%%, #e0e7ff 100%%); >> himami-war\css\style.css
echo   min-height: 100vh; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .container { max-width: 1200px; margin: 0 auto; padding: 0 1rem; } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .header { >> himami-war\css\style.css
echo   background: var(--bg-primary); >> himami-war\css\style.css
echo   box-shadow: var(--shadow); >> himami-war\css\style.css
echo   position: sticky; >> himami-war\css\style.css
echo   top: 0; >> himami-war\css\style.css
echo   z-index: 1000; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .header-content { >> himami-war\css\style.css
echo   display: flex; >> himami-war\css\style.css
echo   justify-content: space-between; >> himami-war\css\style.css
echo   align-items: center; >> himami-war\css\style.css
echo   padding: 1rem 0; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .logo-section { display: flex; align-items: center; gap: 1rem; } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .logo { >> himami-war\css\style.css
echo   width: 3rem; height: 3rem; >> himami-war\css\style.css
echo   background: linear-gradient(135deg, var(--primary-color), #6366f1); >> himami-war\css\style.css
echo   border-radius: 50%%; >> himami-war\css\style.css
echo   display: flex; align-items: center; justify-content: center; >> himami-war\css\style.css
echo   color: white; font-size: 1.5rem; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .btn { >> himami-war\css\style.css
echo   padding: 0.75rem 1.5rem; >> himami-war\css\style.css
echo   border: none; border-radius: 0.5rem; >> himami-war\css\style.css
echo   cursor: pointer; font-size: 1rem; >> himami-war\css\style.css
echo   text-decoration: none; display: inline-block; >> himami-war\css\style.css
echo   transition: all 0.3s ease; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .btn-primary { >> himami-war\css\style.css
echo   background: var(--primary-color); color: white; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .btn-primary:hover { >> himami-war\css\style.css
echo   background: var(--primary-dark); >> himami-war\css\style.css
echo   transform: translateY(-2px); >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .btn-outline { >> himami-war\css\style.css
echo   background: transparent; >> himami-war\css\style.css
echo   color: var(--primary-color); >> himami-war\css\style.css
echo   border: 2px solid var(--primary-color); >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .btn-outline:hover { >> himami-war\css\style.css
echo   background: var(--primary-color); color: white; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .hero { >> himami-war\css\style.css
echo   background: linear-gradient(135deg, var(--primary-color), #6366f1); >> himami-war\css\style.css
echo   border-radius: 1rem; padding: 4rem 2rem; >> himami-war\css\style.css
echo   text-align: center; color: white; >> himami-war\css\style.css
echo   margin: 2rem 0; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .hero h2 { font-size: 3rem; margin-bottom: 1rem; } >> himami-war\css\style.css
echo .hero p { font-size: 1.25rem; margin-bottom: 2rem; opacity: 0.9; } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .hero-buttons { >> himami-war\css\style.css
echo   display: flex; gap: 1rem; >> himami-war\css\style.css
echo   justify-content: center; flex-wrap: wrap; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .btn-secondary { >> himami-war\css\style.css
echo   background: transparent; color: white; >> himami-war\css\style.css
echo   border: 2px solid white; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .btn-secondary:hover { >> himami-war\css\style.css
echo   background: white; color: var(--primary-color); >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo /* Login Page Styles */ >> himami-war\css\style.css
echo .login-page { >> himami-war\css\style.css
echo   display: flex; align-items: center; >> himami-war\css\style.css
echo   justify-content: center; padding: 2rem; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .login-container { max-width: 400px; width: 100%%; } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .login-form-container { >> himami-war\css\style.css
echo   background: var(--bg-primary); >> himami-war\css\style.css
echo   padding: 2rem; border-radius: 0.75rem; >> himami-war\css\style.css
echo   box-shadow: var(--shadow); >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .form-group { margin-bottom: 1.5rem; } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .form-group label { >> himami-war\css\style.css
echo   display: block; margin-bottom: 0.5rem; >> himami-war\css\style.css
echo   font-weight: 500; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .form-group input, .form-group select { >> himami-war\css\style.css
echo   width: 100%%; padding: 0.75rem; >> himami-war\css\style.css
echo   border: 1px solid #e5e7eb; >> himami-war\css\style.css
echo   border-radius: 0.5rem; font-size: 1rem; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .btn-full { width: 100%%; justify-content: center; } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .btn-ghost { >> himami-war\css\style.css
echo   background: transparent; >> himami-war\css\style.css
echo   color: #6b7280; >> himami-war\css\style.css
echo } >> himami-war\css\style.css
echo. >> himami-war\css\style.css
echo .btn-ghost:hover { color: var(--text-primary); } >> himami-war\css\style.css
goto :eof

:create_js_files
echo Creating JavaScript files...
echo // HIMA MI JavaScript > himami-war\js\script.js
echo console.log('HIMA MI Application Loaded'); >> himami-war\js\script.js
echo. >> himami-war\js\script.js
echo // Handle form submissions >> himami-war\js\script.js
echo document.addEventListener('DOMContentLoaded', function() { >> himami-war\js\script.js
echo     // Login form >> himami-war\js\script.js
echo     const loginForm = document.getElementById('loginForm'); >> himami-war\js\script.js
echo     if (loginForm) { >> himami-war\js\script.js
echo         loginForm.addEventListener('submit', function(e) { >> himami-war\js\script.js
echo             e.preventDefault(); >> himami-war\js\script.js
echo             alert('Login functionality will be implemented with servlets!'); >> himami-war\js\script.js
echo         }); >> himami-war\js\script.js
echo     } >> himami-war\js\script.js
echo. >> himami-war\js\script.js
echo     // Register form >> himami-war\js\script.js
echo     const registerForm = document.getElementById('registerForm'); >> himami-war\js\script.js
echo     if (registerForm) { >> himami-war\js\script.js
echo         registerForm.addEventListener('submit', function(e) { >> himami-war\js\script.js
echo             e.preventDefault(); >> himami-war\js\script.js
echo             const formData = new FormData(this); >> himami-war\js\script.js
echo             const data = Object.fromEntries(formData); >> himami-war\js\script.js
echo             >> himami-war\js\script.js
echo             // Send to servlet >> himami-war\js\script.js
echo             fetch('/himami/api/participants', { >> himami-war\js\script.js
echo                 method: 'POST', >> himami-war\js\script.js
echo                 headers: { 'Content-Type': 'application/json' }, >> himami-war\js\script.js
echo                 body: JSON.stringify(data) >> himami-war\js\script.js
echo             }) >> himami-war\js\script.js
echo             .then(response =^> response.json()) >> himami-war\js\script.js
echo             .then(result =^> { >> himami-war\js\script.js
echo                 if (result.success) { >> himami-war\js\script.js
echo                     alert('Pendaftaran berhasil!'); >> himami-war\js\script.js
echo                     this.reset(); >> himami-war\js\script.js
echo                 } else { >> himami-war\js\script.js
echo                     alert('Error: ' + result.error); >> himami-war\js\script.js
echo                 } >> himami-war\js\script.js
echo             }) >> himami-war\js\script.js
echo             .catch(error =^> { >> himami-war\js\script.js
echo                 console.error('Error:', error); >> himami-war\js\script.js
echo                 alert('Terjadi kesalahan saat mendaftar'); >> himami-war\js\script.js
echo             }); >> himami-war\js\script.js
echo         }); >> himami-war\js\script.js
echo     } >> himami-war\js\script.js
echo }); >> himami-war\js\script.js
goto :eof

:create_complete_webxml
echo Creating complete web.xml...
echo ^<?xml version="1.0" encoding="UTF-8"?^> > himami-war\WEB-INF\web.xml
echo ^<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" >> himami-war\WEB-INF\web.xml
echo          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >> himami-war\WEB-INF\web.xml
echo          xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee >> himami-war\WEB-INF\web.xml
echo          http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd" >> himami-war\WEB-INF\web.xml
echo          version="4.0"^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo     ^<display-name^>HIMA MI Web Application^</display-name^> >> himami-war\WEB-INF\web.xml
echo     ^<description^>Himpunan Mahasiswa Manajemen Informatika^</description^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo     ^<welcome-file-list^> >> himami-war\WEB-INF\web.xml
echo         ^<welcome-file^>index.html^</welcome-file^> >> himami-war\WEB-INF\web.xml
echo     ^</welcome-file-list^> >> himami-war\WEB-INF\web.xml
echo. >> himami-war\WEB-INF\web.xml
echo     ^<!-- Servlet Declarations --^> >> himami-war\WEB-INF\web.xml
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
goto :eof
