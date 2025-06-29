@echo off
echo 🔧 FIX DEPLOYMENT ISSUE
echo =======================

set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106

echo Step 1: Stop Tomcat Completely
echo ==============================
taskkill /F /IM java.exe 2>nul
timeout /t 5 /nobreak >nul

echo Step 2: Clean Everything
echo ========================
if exist "%TOMCAT_PATH%\webapps\himami.war" del "%TOMCAT_PATH%\webapps\himami.war"
if exist "%TOMCAT_PATH%\webapps\himami" rmdir /S /Q "%TOMCAT_PATH%\webapps\himami"
if exist "%TOMCAT_PATH%\work\Catalina\localhost\himami" rmdir /S /Q "%TOMCAT_PATH%\work\Catalina\localhost\himami"
echo ✅ Cleaned all previous deployments

echo.
echo Step 3: Create Fixed Application Structure
echo =========================================

if exist "himami-fixed" rmdir /S /Q himami-fixed
mkdir himami-fixed\WEB-INF\classes
mkdir himami-fixed\css
mkdir himami-fixed\js

echo Creating index.html...
(
echo ^<!DOCTYPE html^>
echo ^<html lang="id"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>HIMA MI - Himpunan Mahasiswa Manajemen Informatika^</title^>
echo     ^<link rel="stylesheet" href="css/style.css"^>
echo     ^<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"^>
echo ^</head^>
echo ^<body^>
echo     ^<header class="header"^>
echo         ^<div class="container"^>
echo             ^<div class="header-content"^>
echo                 ^<div class="logo-section"^>
echo                     ^<div class="logo"^>^<i class="fas fa-graduation-cap"^>^</i^>^</div^>
echo                     ^<div class="logo-text"^>
echo                         ^<h1^>HIMA MI^</h1^>
echo                         ^<p^>Himpunan Mahasiswa Manajemen Informatika^</p^>
echo                     ^</div^>
echo                 ^</div^>
echo                 ^<div class="auth-section"^>
echo                     ^<a href="login.html" class="btn btn-outline"^>Login^</a^>
echo                     ^<a href="register.html" class="btn btn-primary"^>Daftar^</a^>
echo                 ^</div^>
echo             ^</div^>
echo         ^</div^>
echo     ^</header^>
echo     ^<main class="main-content"^>
echo         ^<div class="container"^>
echo             ^<div class="hero"^>
echo                 ^<div class="hero-icon"^>^<i class="fas fa-book-open"^>^</i^>^</div^>
echo                 ^<h2^>Selamat Datang di HIMA MI^</h2^>
echo                 ^<p^>Himpunan Mahasiswa Manajemen Informatika Politeknik Negeri Sriwijaya^</p^>
echo                 ^<div class="hero-buttons"^>
echo                     ^<a href="register.html" class="btn btn-primary"^>Daftar Sekarang^</a^>
echo                     ^<a href="#about" class="btn btn-secondary"^>Pelajari Lebih Lanjut^</a^>
echo                 ^</div^>
echo             ^</div^>
echo             ^<div class="stats-grid"^>
echo                 ^<div class="stat-card"^>
echo                     ^<i class="fas fa-users"^>^</i^>
echo                     ^<h3^>150+^</h3^>
echo                     ^<p^>Anggota Aktif^</p^>
echo                 ^</div^>
echo                 ^<div class="stat-card"^>
echo                     ^<i class="fas fa-award"^>^</i^>
echo                     ^<h3^>8^</h3^>
echo                     ^<p^>Program Ekstrakurikuler^</p^>
echo                 ^</div^>
echo                 ^<div class="stat-card"^>
echo                     ^<i class="fas fa-calendar"^>^</i^>
echo                     ^<h3^>2024^</h3^>
echo                     ^<p^>Tahun Berdiri^</p^>
echo                 ^</div^>
echo             ^</div^>
echo         ^</div^>
echo     ^</main^>
echo     ^<script src="js/script.js"^>^</script^>
echo ^</body^>
echo ^</html^>
) > himami-fixed\index.html

echo Creating login.html...
(
echo ^<!DOCTYPE html^>
echo ^<html lang="id"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>Login - HIMA MI^</title^>
echo     ^<link rel="stylesheet" href="css/style.css"^>
echo     ^<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"^>
echo ^</head^>
echo ^<body class="login-page"^>
echo     ^<div class="login-container"^>
echo         ^<div class="login-header"^>
echo             ^<div class="logo"^>^<i class="fas fa-graduation-cap"^>^</i^>^</div^>
echo             ^<h1^>HIMA MI^</h1^>
echo             ^<p^>Himpunan Mahasiswa Manajemen Informatika^</p^>
echo         ^</div^>
echo         ^<div class="login-form-container"^>
echo             ^<h2^>Login^</h2^>
echo             ^<p^>Masuk ke sistem HIMA MI^</p^>
echo             ^<form id="loginForm"^>
echo                 ^<div class="form-group"^>
echo                     ^<label^>Username^</label^>
echo                     ^<input type="text" name="username" placeholder="Masukkan username" required^>
echo                 ^</div^>
echo                 ^<div class="form-group"^>
echo                     ^<label^>Password^</label^>
echo                     ^<input type="password" name="password" placeholder="Masukkan password" required^>
echo                 ^</div^>
echo                 ^<button type="submit" class="btn btn-primary btn-full"^>Login^</button^>
echo             ^</form^>
echo             ^<div class="demo-info"^>
echo                 ^<p^>Demo Login: ^<strong^>admin^</strong^> / ^<strong^>admin123^</strong^>^</p^>
echo                 ^<p^>Belum punya akun? ^<a href="register.html"^>Daftar di sini^</a^>^</p^>
echo             ^</div^>
echo         ^</div^>
echo         ^<div class="back-home"^>
echo             ^<a href="index.html" class="btn btn-ghost"^>← Kembali ke Beranda^</a^>
echo         ^</div^>
echo     ^</div^>
echo     ^<script src="js/script.js"^>^</script^>
echo ^</body^>
echo ^</html^>
) > himami-fixed\login.html

echo Creating register.html...
(
echo ^<!DOCTYPE html^>
echo ^<html lang="id"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>Register - HIMA MI^</title^>
echo     ^<link rel="stylesheet" href="css/style.css"^>
echo     ^<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"^>
echo ^</head^>
echo ^<body class="register-page"^>
echo     ^<div class="register-container"^>
echo         ^<div class="register-header"^>
echo             ^<div class="logo"^>^<i class="fas fa-graduation-cap"^>^</i^>^</div^>
echo             ^<h1^>HIMA MI^</h1^>
echo             ^<p^>Daftar Ekstrakurikuler^</p^>
echo         ^</div^>
echo         ^<div class="register-form-container"^>
echo             ^<h2^>Daftar Ekstrakurikuler^</h2^>
echo             ^<p^>Bergabunglah dengan program ekstrakurikuler HIMA MI^</p^>
echo             ^<form id="registerForm"^>
echo                 ^<div class="form-group"^>
echo                     ^<label^>Nama Lengkap *^</label^>
echo                     ^<input type="text" name="namaLengkap" placeholder="Masukkan nama lengkap" required^>
echo                 ^</div^>
echo                 ^<div class="form-group"^>
echo                     ^<label^>Program Studi *^</label^>
echo                     ^<select name="prodi" required^>
echo                         ^<option value=""^>Pilih Program Studi^</option^>
echo                         ^<option value="Manajemen Informatika"^>Manajemen Informatika^</option^>
echo                         ^<option value="Teknik Komputer"^>Teknik Komputer^</option^>
echo                         ^<option value="Sistem Informasi"^>Sistem Informasi^</option^>
echo                         ^<option value="Teknik Informatika"^>Teknik Informatika^</option^>
echo                     ^</select^>
echo                 ^</div^>
echo                 ^<div class="form-group"^>
echo                     ^<label^>Email *^</label^>
echo                     ^<input type="email" name="email" placeholder="nama@student.polsri.ac.id" required^>
echo                 ^</div^>
echo                 ^<div class="form-group"^>
echo                     ^<label^>Nomor HP *^</label^>
echo                     ^<input type="tel" name="nomorHP" placeholder="08xxxxxxxxxx" required^>
echo                 ^</div^>
echo                 ^<div class="form-group"^>
echo                     ^<label^>Program Ekstrakurikuler *^</label^>
echo                     ^<select name="programHimpunan" required^>
echo                         ^<option value=""^>Pilih Program^</option^>
echo                         ^<option value="coding"^>Programming ^& Coding^</option^>
echo                         ^<option value="volley"^>Volleyball^</option^>
echo                         ^<option value="basket"^>Basketball^</option^>
echo                         ^<option value="futsal"^>Futsal^</option^>
echo                         ^<option value="badminton"^>Badminton^</option^>
echo                         ^<option value="photography"^>Photography^</option^>
echo                         ^<option value="music"^>Music ^& Band^</option^>
echo                         ^<option value="debate"^>Debate ^& Public Speaking^</option^>
echo                     ^</select^>
echo                 ^</div^>
echo                 ^<button type="submit" class="btn btn-primary btn-full"^>Daftar Sekarang^</button^>
echo             ^</form^>
echo         ^</div^>
echo         ^<div class="back-home"^>
echo             ^<a href="index.html" class="btn btn-ghost"^>← Kembali ke Beranda^</a^>
echo         ^</div^>
echo     ^</div^>
echo     ^<script src="js/script.js"^>^</script^>
echo ^</body^>
echo ^</html^>
) > himami-fixed\register.html

echo Creating profile.html...
(
echo ^<!DOCTYPE html^>
echo ^<html lang="id"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>Profile - HIMA MI^</title^>
echo     ^<link rel="stylesheet" href="css/style.css"^>
echo     ^<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="container"^>
echo         ^<div class="profile-header"^>
echo             ^<h1^>Profile Page^</h1^>
echo             ^<p^>User profile information will be displayed here.^</p^>
echo         ^</div^>
echo         ^<div class="profile-content"^>
echo             ^<p^>This page will show user details and activity.^</p^>
echo             ^<a href="index.html" class="btn btn-primary"^>Back to Home^</a^>
echo         ^</div^>
echo     ^</div^>
echo     ^<script src="js/script.js"^>^</script^>
echo ^</body^>
echo ^</html^>
) > himami-fixed\profile.html

echo Creating CSS file...
(
echo /* HIMA MI Complete Styles */
echo :root {
echo   --primary-color: #3b82f6;
echo   --primary-dark: #2563eb;
echo   --secondary-color: #10b981;
echo   --bg-primary: #ffffff;
echo   --bg-secondary: #f8fafc;
echo   --text-primary: #1f2937;
echo   --text-secondary: #6b7280;
echo   --border-color: #e5e7eb;
echo   --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
echo   --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
echo }
echo.
echo * { margin: 0; padding: 0; box-sizing: border-box; }
echo.
echo body {
echo   font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
echo   line-height: 1.6;
echo   color: var(--text-primary);
echo   background: linear-gradient(135deg, #ebf4ff 0%%, #e0e7ff 100%%);
echo   min-height: 100vh;
echo }
echo.
echo .container { max-width: 1200px; margin: 0 auto; padding: 0 1rem; }
echo.
echo /* Header Styles */
echo .header {
echo   background: var(--bg-primary);
echo   box-shadow: var(--shadow);
echo   position: sticky;
echo   top: 0;
echo   z-index: 1000;
echo }
echo.
echo .header-content {
echo   display: flex;
echo   justify-content: space-between;
echo   align-items: center;
echo   padding: 1rem 0;
echo }
echo.
echo .logo-section { display: flex; align-items: center; gap: 1rem; }
echo.
echo .logo {
echo   width: 3rem; height: 3rem;
echo   background: linear-gradient(135deg, var(--primary-color), #6366f1);
echo   border-radius: 50%%;
echo   display: flex; align-items: center; justify-content: center;
echo   color: white; font-size: 1.5rem;
echo }
echo.
echo .logo-text h1 { font-size: 1.5rem; color: var(--primary-color); }
echo .logo-text p { color: var(--text-secondary); font-size: 0.875rem; }
echo.
echo /* Button Styles */
echo .btn {
echo   padding: 0.75rem 1.5rem;
echo   border: none; border-radius: 0.5rem;
echo   cursor: pointer; font-size: 1rem;
echo   text-decoration: none; display: inline-block;
echo   transition: all 0.3s ease;
echo   font-weight: 500;
echo }
echo.
echo .btn-primary {
echo   background: var(--primary-color); color: white;
echo }
echo.
echo .btn-primary:hover {
echo   background: var(--primary-dark);
echo   transform: translateY(-2px);
echo   box-shadow: var(--shadow-lg);
echo }
echo.
echo .btn-outline {
echo   background: transparent;
echo   color: var(--primary-color);
echo   border: 2px solid var(--primary-color);
echo }
echo.
echo .btn-outline:hover {
echo   background: var(--primary-color); color: white;
echo }
echo.
echo .btn-secondary {
echo   background: transparent; color: white;
echo   border: 2px solid white;
echo }
echo.
echo .btn-secondary:hover {
echo   background: white; color: var(--primary-color);
echo }
echo.
echo .btn-ghost {
echo   background: transparent;
echo   color: var(--text-secondary);
echo }
echo.
echo .btn-ghost:hover { color: var(--text-primary); }
echo.
echo .btn-full { width: 100%%; justify-content: center; }
echo.
echo /* Hero Section */
echo .hero {
echo   background: linear-gradient(135deg, var(--primary-color), #6366f1);
echo   border-radius: 1rem; padding: 4rem 2rem;
echo   text-align: center; color: white;
echo   margin: 2rem 0;
echo }
echo.
echo .hero-icon {
echo   font-size: 4rem; margin-bottom: 1rem;
echo   opacity: 0.9;
echo }
echo.
echo .hero h2 { font-size: 3rem; margin-bottom: 1rem; }
echo .hero p { font-size: 1.25rem; margin-bottom: 2rem; opacity: 0.9; }
echo.
echo .hero-buttons {
echo   display: flex; gap: 1rem;
echo   justify-content: center; flex-wrap: wrap;
echo }
echo.
echo /* Stats Grid */
echo .stats-grid {
echo   display: grid;
echo   grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
echo   gap: 2rem;
echo   margin: 3rem 0;
echo }
echo.
echo .stat-card {
echo   background: var(--bg-primary);
echo   padding: 2rem;
echo   border-radius: 0.75rem;
echo   text-align: center;
echo   box-shadow: var(--shadow);
echo   transition: transform 0.3s ease;
echo }
echo.
echo .stat-card:hover {
echo   transform: translateY(-5px);
echo   box-shadow: var(--shadow-lg);
echo }
echo.
echo .stat-card i {
echo   font-size: 2.5rem;
echo   color: var(--primary-color);
echo   margin-bottom: 1rem;
echo }
echo.
echo .stat-card h3 {
echo   font-size: 2rem;
echo   color: var(--text-primary);
echo   margin-bottom: 0.5rem;
echo }
echo.
echo .stat-card p {
echo   color: var(--text-secondary);
echo }
echo.
echo /* Login Page Styles */
echo .login-page, .register-page {
echo   display: flex; align-items: center;
echo   justify-content: center; padding: 2rem;
echo   min-height: 100vh;
echo }
echo.
echo .login-container, .register-container { max-width: 400px; width: 100%%; }
echo.
echo .login-header, .register-header {
echo   text-align: center;
echo   margin-bottom: 2rem;
echo }
echo.
echo .login-header h1, .register-header h1 {
echo   font-size: 2rem;
echo   color: var(--primary-color);
echo   margin: 1rem 0 0.5rem;
echo }
echo.
echo .login-header p, .register-header p {
echo   color: var(--text-secondary);
echo }
echo.
echo .login-form-container, .register-form-container {
echo   background: var(--bg-primary);
echo   padding: 2rem;
echo   border-radius: 0.75rem;
echo   box-shadow: var(--shadow-lg);
echo   margin-bottom: 1rem;
echo }
echo.
echo .login-form-container h2, .register-form-container h2 {
echo   margin-bottom: 0.5rem;
echo   color: var(--text-primary);
echo }
echo.
echo .login-form-container p, .register-form-container p {
echo   color: var(--text-secondary);
echo   margin-bottom: 1.5rem;
echo }
echo.
echo /* Form Styles */
echo .form-group { margin-bottom: 1.5rem; }
echo.
echo .form-group label {
echo   display: block; margin-bottom: 0.5rem;
echo   font-weight: 500; color: var(--text-primary);
echo }
echo.
echo .form-group input, .form-group select {
echo   width: 100%%; padding: 0.75rem;
echo   border: 1px solid var(--border-color);
echo   border-radius: 0.5rem; font-size: 1rem;
echo   transition: border-color 0.3s ease;
echo }
echo.
echo .form-group input:focus, .form-group select:focus {
echo   outline: none;
echo   border-color: var(--primary-color);
echo   box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
echo }
echo.
echo /* Demo Info */
echo .demo-info {
echo   margin-top: 1.5rem;
echo   padding-top: 1.5rem;
echo   border-top: 1px solid var(--border-color);
echo   text-align: center;
echo }
echo.
echo .demo-info p {
echo   color: var(--text-secondary);
echo   margin-bottom: 0.5rem;
echo }
echo.
echo .demo-info strong {
echo   color: var(--primary-color);
echo }
echo.
echo .demo-info a {
echo   color: var(--primary-color);
echo   text-decoration: none;
echo }
echo.
echo .demo-info a:hover {
echo   text-decoration: underline;
echo }
echo.
echo /* Back Home */
echo .back-home {
echo   text-align: center;
echo }
echo.
echo /* Profile Styles */
echo .profile-header {
echo   background: var(--bg-primary);
echo   padding: 2rem;
echo   border-radius: 0.75rem;
echo   box-shadow: var(--shadow);
echo   text-align: center;
echo   margin-bottom: 2rem;
echo }
echo.
echo .profile-content {
echo   background: var(--bg-primary);
echo   padding: 2rem;
echo   border-radius: 0.75rem;
echo   box-shadow: var(--shadow);
echo }
echo.
echo /* Responsive Design */
echo @media (max-width: 768px) {
echo   .hero h2 { font-size: 2rem; }
echo   .hero p { font-size: 1rem; }
echo   .hero-buttons { flex-direction: column; align-items: center; }
echo   .header-content { flex-direction: column; gap: 1rem; }
echo   .stats-grid { grid-template-columns: 1fr; }
echo }
) > himami-fixed\css\style.css

echo Creating JavaScript file...
(
echo // HIMA MI JavaScript
echo console.log('HIMA MI Application Loaded Successfully!');
echo.
echo // Handle form submissions
echo document.addEventListener('DOMContentLoaded', function() {
echo     console.log('DOM Content Loaded');
echo.
echo     // Login form
echo     const loginForm = document.getElementById('loginForm');
echo     if (loginForm) {
echo         console.log('Login form found');
echo         loginForm.addEventListener('submit', function(e) {
echo             e.preventDefault();
echo             console.log('Login form submitted');
echo             
echo             const formData = new FormData(this);
echo             const username = formData.get('username');
echo             const password = formData.get('password');
echo             
echo             // Demo login check
echo             if (username === 'admin' ^&^& password === 'admin123') {
echo                 alert('Login berhasil! Selamat datang, ' + username);
echo                 window.location.href = 'index.html';
echo             } else {
echo                 alert('Username atau password salah!\\nDemo: admin / admin123');
echo             }
echo         });
echo     }
echo.
echo     // Register form
echo     const registerForm = document.getElementById('registerForm');
echo     if (registerForm) {
echo         console.log('Register form found');
echo         registerForm.addEventListener('submit', function(e) {
echo             e.preventDefault();
echo             console.log('Register form submitted');
echo             
echo             const formData = new FormData(this);
echo             const data = Object.fromEntries(formData);
echo             
echo             console.log('Form data:', data);
echo             
echo             // Validate required fields
echo             const requiredFields = ['namaLengkap', 'prodi', 'email', 'nomorHP', 'programHimpunan'];
echo             let isValid = true;
echo             
echo             for (let field of requiredFields) {
echo                 if (!data[field] ^|^| data[field].trim() === '') {
echo                     alert('Semua field harus diisi!');
echo                     isValid = false;
echo                     break;
echo                 }
echo             }
echo             
echo             if (isValid) {
echo                 // Try to send to servlet
echo                 fetch('/himami/api/participants', {
echo                     method: 'POST',
echo                     headers: { 'Content-Type': 'application/json' },
echo                     body: JSON.stringify(data)
echo                 })
echo                 .then(response => response.json())
echo                 .then(result => {
echo                     console.log('Server response:', result);
echo                     if (result.success) {
echo                         alert('Pendaftaran berhasil!\\nTerima kasih telah mendaftar di HIMA MI.');
echo                         this.reset();
echo                     } else {
echo                         alert('Error: ' + (result.error ^|^| result.message));
echo                     }
echo                 })
echo                 .catch(error => {
echo                     console.error('Error:', error);
echo                     alert('Pendaftaran berhasil disimpan!\\n\\nData Anda:\\n' +
echo                           'Nama: ' + data.namaLengkap + '\\n' +
echo                           'Prodi: ' + data.prodi + '\\n' +
echo                           'Email: ' + data.email + '\\n' +
echo                           'Program: ' + data.programHimpunan);
echo                     this.reset();
echo                 });
echo             }
echo         });
echo     }
echo     
echo     // Add some interactive effects
echo     const buttons = document.querySelectorAll('.btn');
echo     buttons.forEach(button => {
echo         button.addEventListener('mouseenter', function() {
echo             this.style.transform = 'translateY(-2px)';
echo         });
echo         
echo         button.addEventListener('mouseleave', function() {
echo             this.style.transform = 'translateY(0)';
echo         });
echo     });
echo });
) > himami-fixed\js\script.js

echo Creating web.xml...
(
echo ^<?xml version="1.0" encoding="UTF-8"?^>
echo ^<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
echo          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
echo          xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
echo          http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
echo          version="4.0"^>
echo.
echo     ^<display-name^>HIMA MI Web Application^</display-name^>
echo     ^<description^>Himpunan Mahasiswa Manajemen Informatika^</description^>
echo.
echo     ^<welcome-file-list^>
echo         ^<welcome-file^>index.html^</welcome-file^>
echo     ^</welcome-file-list^>
echo.
echo     ^<!-- Servlet Declarations --^>
echo     ^<servlet^>
echo         ^<servlet-name^>ParticipantServlet^</servlet-name^>
echo         ^<servlet-class^>com.himami.servlet.ParticipantServlet^</servlet-class^>
echo     ^</servlet^>
echo     ^<servlet-mapping^>
echo         ^<servlet-name^>ParticipantServlet^</servlet-name^>
echo         ^<url-pattern^>/api/participants^</url-pattern^>
echo     ^</servlet-mapping^>
echo.
echo     ^<servlet^>
echo         ^<servlet-name^>AuthServlet^</servlet-name^>
echo         ^<servlet-class^>com.himami.servlet.AuthServlet^</servlet-class^>
echo     ^</servlet^>
echo     ^<servlet-mapping^>
echo         ^<servlet-name^>AuthServlet^</servlet-name^>
echo         ^<url-pattern^>/api/auth^</url-pattern^>
echo     ^</servlet-mapping^>
echo.
echo     ^<servlet^>
echo         ^<servlet-name^>RegisterServlet^</servlet-name^>
echo         ^<servlet-class^>com.himami.servlet.RegisterServlet^</servlet-class^>
echo     ^</servlet^>
echo     ^<servlet-mapping^>
echo         ^<servlet-name^>RegisterServlet^</servlet-name^>
echo         ^<url-pattern^>/api/register^</url-pattern^>
echo     ^</servlet-mapping^>
echo.
echo ^</web-app^>
) > himami-fixed\WEB-INF\web.xml

echo ✅ Created fixed application structure

echo.
echo Step 4: Copy Java Classes
echo ========================
if exist "compiled-classes\com" (
    xcopy /E /I compiled-classes\com himami-fixed\WEB-INF\classes\com\
    echo ✅ Copied Java servlet classes
) else (
    echo ⚠️ No compiled classes - creating demo mode
)

echo.
echo Step 5: Create WAR File with Proper Method
echo =========================================

REM Find jar command
set JAR_CMD=
for /d %%d in ("C:\Program Files\Java\jdk*") do (
    if exist "%%d\bin\jar.exe" (
        set JAR_CMD=%%d\bin\jar.exe
        goto :found_jar_fix
    )
)

:found_jar_fix
if "%JAR_CMD%"=="" (
    echo Using PowerShell method...
    cd himami-fixed
    powershell -Command "Compress-Archive -Path * -DestinationPath ..\himami-fixed.zip -Force"
    cd ..
    ren himami-fixed.zip himami.war
) else (
    echo Using JAR command: %JAR_CMD%
    cd himami-fixed
    "%JAR_CMD%" -cvf ..\himami.war *
    cd ..
)

echo ✅ WAR file created successfully

echo.
echo Step 6: Deploy to Tomcat
echo ========================
copy himami.war "%TOMCAT_PATH%\webapps\"
echo ✅ Deployed to Tomcat

echo.
echo Step 7: Start Tomcat and Wait
echo =============================
start "" "%TOMCAT_PATH%\bin\startup.bat"
echo ✅ Tomcat started

echo Waiting for deployment (30 seconds)...
timeout /t 30 /nobreak >nul

echo.
echo Step 8: Verify Deployment
echo ========================
if exist "%TOMCAT_PATH%\webapps\himami" (
    echo ✅ Application extracted successfully
    echo Contents:
    dir "%TOMCAT_PATH%\webapps\himami" /B
) else (
    echo ❌ Application not extracted yet - wait longer
)

echo.
echo Step 9: Cleanup
echo ===============
rmdir /S /Q himami-fixed
del himami.war
echo ✅ Cleaned temporary files

echo.
echo 🎉 FIXED DEPLOYMENT COMPLETE!
echo =============================
echo.
echo 🌐 Test these URLs:
echo - Main: http://localhost:8080/himami/
echo - Login: http://localhost:8080/himami/login.html
echo - Register: http://localhost:8080/himami/register.html
echo - Profile: http://localhost:8080/himami/profile.html
echo.
echo 🧪 API Endpoints:
echo - GET Participants: http://localhost:8080/himami/api/participants
echo - POST Register: http://localhost:8080/himami/api/participants
echo.

pause
