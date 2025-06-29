@echo off
echo 🔍 Checking Project Structure
echo =============================

echo Current directory: %CD%
echo.

echo 📁 Looking for Java files...
echo.

REM Check current directory structure
if exist "src" (
    echo ✅ Found 'src' folder
    if exist "src\main" (
        echo ✅ Found 'src\main' folder
        if exist "src\main\java" (
            echo ✅ Found 'src\main\java' folder
            if exist "src\main\java\com" (
                echo ✅ Found 'src\main\java\com' folder
                if exist "src\main\java\com\himami" (
                    echo ✅ Found 'src\main\java\com\himami' folder
                    echo.
                    echo 📋 Java files found:
                    dir /S /B src\main\java\*.java
                ) else (
                    echo ❌ 'src\main\java\com\himami' folder not found
                )
            ) else (
                echo ❌ 'src\main\java\com' folder not found
            )
        ) else (
            echo ❌ 'src\main\java' folder not found
        )
    ) else (
        echo ❌ 'src\main' folder not found
    )
) else (
    echo ❌ 'src' folder not found in current directory
)

echo.
echo 🔍 Checking alternative locations...

REM Check if Java files are in current directory
if exist "*.java" (
    echo ✅ Found Java files in current directory:
    dir /B *.java
)

REM Check if there's a different structure
if exist "main" (
    echo ✅ Found 'main' folder (alternative structure)
    dir /S /B main\*.java
)

if exist "java" (
    echo ✅ Found 'java' folder (alternative structure)
    dir /S /B java\*.java
)

if exist "com" (
    echo ✅ Found 'com' folder (alternative structure)
    dir /S /B com\*.java
)

echo.
echo 📝 Current folder contents:
dir /B

echo.
echo 💡 Solutions:
echo 1. Make sure you're in the correct directory
echo 2. Check if Java files exist in the expected location
echo 3. Use the flexible compile script below

pause
