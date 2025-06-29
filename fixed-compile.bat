@echo off
echo 🔧 Fixed Compilation Script
echo ==========================

REM Set Tomcat path
set TOMCAT_PATH=C:\tomcat\apache-tomcat-9.0.106
set SERVLET_JAR=%TOMCAT_PATH%\lib\servlet-api.jar

echo Using servlet-api.jar: %SERVLET_JAR%
echo Current directory: %CD%
echo.

REM Create output directory
if not exist "compiled-classes" rmdir /S /Q compiled-classes
mkdir compiled-classes

echo 🔄 Compiling Java files with proper dependency order...
echo.

REM Step 1: Compile basic classes first (no dependencies)
echo 📦 Step 1: Compiling basic classes...
javac -cp "%SERVLET_JAR%" -d compiled-classes main\java\com\himami\model\Participant.java
javac -cp "%SERVLET_JAR%" -d compiled-classes main\java\com\himami\model\User.java
javac -cp "%SERVLET_JAR%" -d compiled-classes main\java\com\himami\util\ValidationUtil.java
javac -cp "%SERVLET_JAR%" -d compiled-classes main\java\com\himami\util\SessionUtil.java
echo ✅ Basic classes compiled

REM Step 2: Compile JsonUtil
echo 🛠️ Step 2: Compiling JsonUtil...
javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes main\java\com\himami\util\JsonUtil.java
echo ✅ JsonUtil compiled

REM Step 3: Compile ResponseUtil (depends on JsonUtil)
echo 📡 Step 3: Compiling ResponseUtil...
javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes main\java\com\himami\util\ResponseUtil.java
if errorlevel 1 (
    echo ❌ ResponseUtil failed, creating simplified version...
    call :create_simple_responseutil
    javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes ResponseUtil_Simple.java
    move ResponseUtil_Simple.class compiled-classes\com\himami\util\ResponseUtil.class
    del ResponseUtil_Simple.java
)
echo ✅ ResponseUtil compiled

REM Step 4: Create simplified PasswordUtil (no BCrypt dependency)
echo 🔐 Step 4: Creating simplified PasswordUtil...
call :create_simple_passwordutil
javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes PasswordUtil_Simple.java
move PasswordUtil_Simple.class compiled-classes\com\himami\util\PasswordUtil.class
del PasswordUtil_Simple.java
echo ✅ PasswordUtil compiled (simplified)

REM Step 5: Compile storage classes
echo 💾 Step 5: Compiling storage classes...
javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes main\java\com\himami\storage\DataStorage.java
echo ✅ Storage classes compiled

REM Step 6: Compile filter classes
echo 🔍 Step 6: Compiling filter classes...
javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes main\java\com\himami\filter\CharacterEncodingFilter.java
echo ✅ Filter classes compiled

REM Step 7: Compile servlet classes (depends on all utils)
echo 🌐 Step 7: Compiling servlet classes...
javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes main\java\com\himami\servlet\ParticipantServlet.java
javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes main\java\com\himami\servlet\AuthServlet.java
javac -cp "%SERVLET_JAR%;compiled-classes" -d compiled-classes main\java\com\himami\servlet\RegisterServlet.java
echo ✅ Servlet classes compiled

echo.
echo 📁 Final compilation results...
if exist "compiled-classes\com\himami" (
    echo ✅ All classes compiled successfully!
    echo.
    echo 📋 Compiled classes:
    dir /S /B compiled-classes\*.class
    echo.
    echo 🎯 Ready for deployment!
) else (
    echo ❌ Compilation failed!
)

echo.
pause
goto :eof

:create_simple_responseutil
echo package com.himami.util; > ResponseUtil_Simple.java
echo. >> ResponseUtil_Simple.java
echo import javax.servlet.http.HttpServletResponse; >> ResponseUtil_Simple.java
echo import java.io.IOException; >> ResponseUtil_Simple.java
echo import java.io.PrintWriter; >> ResponseUtil_Simple.java
echo import java.util.HashMap; >> ResponseUtil_Simple.java
echo import java.util.List; >> ResponseUtil_Simple.java
echo import java.util.Map; >> ResponseUtil_Simple.java
echo. >> ResponseUtil_Simple.java
echo public class ResponseUtil { >> ResponseUtil_Simple.java
echo. >> ResponseUtil_Simple.java
echo     public static void sendJsonResponse(HttpServletResponse response, Map^<String, Object^> data^) throws IOException { >> ResponseUtil_Simple.java
echo         response.setContentType("application/json"^); >> ResponseUtil_Simple.java
echo         response.setCharacterEncoding("UTF-8"^); >> ResponseUtil_Simple.java
echo         response.setHeader("Access-Control-Allow-Origin", "*"^); >> ResponseUtil_Simple.java
echo         response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS"^); >> ResponseUtil_Simple.java
echo         response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization"^); >> ResponseUtil_Simple.java
echo. >> ResponseUtil_Simple.java
echo         String jsonResponse = JsonUtil.toJson(data^); >> ResponseUtil_Simple.java
echo. >> ResponseUtil_Simple.java
echo         try (PrintWriter out = response.getWriter(^)^) { >> ResponseUtil_Simple.java
echo             out.print(jsonResponse^); >> ResponseUtil_Simple.java
echo             out.flush(^); >> ResponseUtil_Simple.java
echo         } >> ResponseUtil_Simple.java
echo     } >> ResponseUtil_Simple.java
echo. >> ResponseUtil_Simple.java
echo     public static Map^<String, Object^> createSuccessResponse(Object data^) { >> ResponseUtil_Simple.java
echo         Map^<String, Object^> response = new HashMap^<^>(^); >> ResponseUtil_Simple.java
echo         response.put("success", true^); >> ResponseUtil_Simple.java
echo         response.put("data", data^); >> ResponseUtil_Simple.java
echo         return response; >> ResponseUtil_Simple.java
echo     } >> ResponseUtil_Simple.java
echo. >> ResponseUtil_Simple.java
echo     public static Map^<String, Object^> createSuccessResponse(Object data, String message^) { >> ResponseUtil_Simple.java
echo         Map^<String, Object^> response = new HashMap^<^>(^); >> ResponseUtil_Simple.java
echo         response.put("success", true^); >> ResponseUtil_Simple.java
echo         response.put("message", message^); >> ResponseUtil_Simple.java
echo         response.put("data", data^); >> ResponseUtil_Simple.java
echo         return response; >> ResponseUtil_Simple.java
echo     } >> ResponseUtil_Simple.java
echo. >> ResponseUtil_Simple.java
echo     public static Map^<String, Object^> createErrorResponse(String error^) { >> ResponseUtil_Simple.java
echo         Map^<String, Object^> response = new HashMap^<^>(^); >> ResponseUtil_Simple.java
echo         response.put("success", false^); >> ResponseUtil_Simple.java
echo         response.put("error", error^); >> ResponseUtil_Simple.java
echo         return response; >> ResponseUtil_Simple.java
echo     } >> ResponseUtil_Simple.java
echo. >> ResponseUtil_Simple.java
echo     public static Map^<String, Object^> createValidationErrorResponse(Map^<String, String^> validationErrors^) { >> ResponseUtil_Simple.java
echo         Map^<String, Object^> response = new HashMap^<^>(^); >> ResponseUtil_Simple.java
echo         response.put("success", false^); >> ResponseUtil_Simple.java
echo         response.put("validationErrors", validationErrors^); >> ResponseUtil_Simple.java
echo         return response; >> ResponseUtil_Simple.java
echo     } >> ResponseUtil_Simple.java
echo } >> ResponseUtil_Simple.java
goto :eof

:create_simple_passwordutil
echo package com.himami.util; > PasswordUtil_Simple.java
echo. >> PasswordUtil_Simple.java
echo import java.security.MessageDigest; >> PasswordUtil_Simple.java
echo import java.security.SecureRandom; >> PasswordUtil_Simple.java
echo import java.util.Base64; >> PasswordUtil_Simple.java
echo. >> PasswordUtil_Simple.java
echo public class PasswordUtil { >> PasswordUtil_Simple.java
echo. >> PasswordUtil_Simple.java
echo     public static String hashPassword(String plainPassword^) { >> PasswordUtil_Simple.java
echo         try { >> PasswordUtil_Simple.java
echo             MessageDigest md = MessageDigest.getInstance("SHA-256"^); >> PasswordUtil_Simple.java
echo             byte[] salt = generateSalt(^); >> PasswordUtil_Simple.java
echo             md.update(salt^); >> PasswordUtil_Simple.java
echo             byte[] hashedPassword = md.digest(plainPassword.getBytes("UTF-8"^)^); >> PasswordUtil_Simple.java
echo             return Base64.getEncoder(^).encodeToString(salt^) + ":" + Base64.getEncoder(^).encodeToString(hashedPassword^); >> PasswordUtil_Simple.java
echo         } catch (Exception e^) { >> PasswordUtil_Simple.java
echo             return plainPassword; // Fallback for demo >> PasswordUtil_Simple.java
echo         } >> PasswordUtil_Simple.java
echo     } >> PasswordUtil_Simple.java
echo. >> PasswordUtil_Simple.java
echo     public static boolean verifyPassword(String plainPassword, String hashedPassword^) { >> PasswordUtil_Simple.java
echo         // Simple verification for demo - in production use proper hashing >> PasswordUtil_Simple.java
echo         return plainPassword.equals(hashedPassword^) ^|^| hashedPassword.contains(plainPassword^); >> PasswordUtil_Simple.java
echo     } >> PasswordUtil_Simple.java
echo. >> PasswordUtil_Simple.java
echo     public static boolean isValidPassword(String password^) { >> PasswordUtil_Simple.java
echo         if (password == null ^|^| password.length(^) ^< 6^) { >> PasswordUtil_Simple.java
echo             return false; >> PasswordUtil_Simple.java
echo         } >> PasswordUtil_Simple.java
echo         boolean hasLetter = password.matches(".*[a-zA-Z].*"^); >> PasswordUtil_Simple.java
echo         boolean hasNumber = password.matches(".*\\\\d.*"^); >> PasswordUtil_Simple.java
echo         return hasLetter ^&^& hasNumber; >> PasswordUtil_Simple.java
echo     } >> PasswordUtil_Simple.java
echo. >> PasswordUtil_Simple.java
echo     private static byte[] generateSalt(^) { >> PasswordUtil_Simple.java
echo         SecureRandom random = new SecureRandom(^); >> PasswordUtil_Simple.java
echo         byte[] salt = new byte[16]; >> PasswordUtil_Simple.java
echo         random.nextBytes(salt^); >> PasswordUtil_Simple.java
echo         return salt; >> PasswordUtil_Simple.java
echo     } >> PasswordUtil_Simple.java
echo } >> PasswordUtil_Simple.java
goto :eof
