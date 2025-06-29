@echo off
echo 📝 Creating Java Files Structure
echo =================================

echo Creating directory structure...

REM Create the full directory structure
mkdir src\main\java\com\himami\model 2>nul
mkdir src\main\java\com\himami\servlet 2>nul
mkdir src\main\java\com\himami\storage 2>nul
mkdir src\main\java\com\himami\util 2>nul
mkdir src\main\java\com\himami\filter 2>nul
mkdir src\main\webapp\WEB-INF 2>nul
mkdir src\main\webapp\css 2>nul
mkdir src\main\webapp\js 2>nul

echo ✅ Directory structure created!
echo.

echo 📁 Created structure:
tree src /F

echo.
echo 📝 Next steps:
echo 1. Copy your Java files to the appropriate folders:
echo    - Model classes → src\main\java\com\himami\model\
echo    - Servlet classes → src\main\java\com\himami\servlet\
echo    - Util classes → src\main\java\com\himami\util\
echo    - Storage classes → src\main\java\com\himami\storage\
echo    - Filter classes → src\main\java\com\himami\filter\
echo.
echo 2. Copy your web files to:
echo    - HTML files → src\main\webapp\
echo    - CSS files → src\main\webapp\css\
echo    - JS files → src\main\webapp\js\
echo    - web.xml → src\main\webapp\WEB-INF\
echo.
echo 3. Run the compilation script again

pause
