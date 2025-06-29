// Register specific JavaScript
let currentTheme = "light"
let currentLanguage = "id"

const translations = {
  id: {
    register: "Daftar Akun",
    registerSubtitle: "Buat akun baru untuk bergabung dengan HIMA MI",
    fullName: "Nama Lengkap",
    username: "Username",
    email: "Email",
    password: "Password",
    confirmPassword: "Konfirmasi Password",
    enterFullName: "Masukkan nama lengkap",
    enterUsername: "Masukkan username",
    enterPassword: "Masukkan password",
    registerButton: "Daftar Akun",
    processing: "Memproses...",
    alreadyHaveAccount: "Sudah punya akun?",
    loginHere: "Login di sini",
    backToHome: "← Kembali ke Beranda",

    // Validation messages
    fullNameRequired: "Nama lengkap harus diisi",
    fullNameMinLength: "Nama lengkap minimal 2 karakter",
    usernameRequired: "Username harus diisi",
    usernameMinLength: "Username minimal 3 karakter",
    usernameInvalid: "Username hanya boleh mengandung huruf, angka, dan underscore",
    emailRequired: "Email harus diisi",
    emailInvalid: "Format email tidak valid",
    passwordRequired: "Password harus diisi",
    passwordWeak: "Password terlalu lemah",
    passwordMedium: "Password cukup kuat",
    passwordStrong: "Password kuat",
    confirmPasswordRequired: "Konfirmasi password harus diisi",
    passwordMismatch: "Password tidak cocok",

    // Success/Error messages
    registerSuccess: "Registrasi berhasil! Silakan login dengan akun Anda.",
    registerError: "Gagal mendaftar. Silakan coba lagi.",
    usernameExists: "Username sudah digunakan",
    emailExists: "Email sudah terdaftar",
    systemError: "Terjadi kesalahan sistem. Silakan coba lagi.",
  },
  en: {
    register: "Register Account",
    registerSubtitle: "Create a new account to join HIMA MI",
    fullName: "Full Name",
    username: "Username",
    email: "Email",
    password: "Password",
    confirmPassword: "Confirm Password",
    enterFullName: "Enter full name",
    enterUsername: "Enter username",
    enterPassword: "Enter password",
    registerButton: "Register Account",
    processing: "Processing...",
    alreadyHaveAccount: "Already have an account?",
    loginHere: "Login here",
    backToHome: "← Back to Home",

    // Validation messages
    fullNameRequired: "Full name is required",
    fullNameMinLength: "Full name must be at least 2 characters",
    usernameRequired: "Username is required",
    usernameMinLength: "Username must be at least 3 characters",
    usernameInvalid: "Username can only contain letters, numbers, and underscores",
    emailRequired: "Email is required",
    emailInvalid: "Invalid email format",
    passwordRequired: "Password is required",
    passwordWeak: "Password is too weak",
    passwordMedium: "Password is moderately strong",
    passwordStrong: "Password is strong",
    confirmPasswordRequired: "Confirm password is required",
    passwordMismatch: "Passwords do not match",

    // Success/Error messages
    registerSuccess: "Registration successful! Please login with your account.",
    registerError: "Registration failed. Please try again.",
    usernameExists: "Username already exists",
    emailExists: "Email already registered",
    systemError: "System error occurred. Please try again.",
  },
}

document.addEventListener("DOMContentLoaded", () => {
  initializeRegister()
})

function initializeRegister() {
  loadRegisterPreferences()
  applyTheme()
  updateLanguage()
  setupValidation()
}

function loadRegisterPreferences() {
  // Load theme preference
  const savedTheme = localStorage.getItem("theme")
  if (savedTheme) {
    currentTheme = savedTheme
    const themeToggle = document.getElementById("themeToggle")
    if (themeToggle) {
      themeToggle.checked = currentTheme === "dark"
    }
  }
  applyTheme()

  // Load language preference
  const savedLanguage = localStorage.getItem("language")
  if (savedLanguage) {
    currentLanguage = savedLanguage
    const languageSelect = document.getElementById("languageSelect")
    if (languageSelect) {
      languageSelect.value = currentLanguage
    }
  }
  updateLanguage()
}

function applyTheme() {
  if (currentTheme === "dark") {
    document.body.classList.add("dark-theme")
  } else {
    document.body.classList.remove("dark-theme")
  }
}

function updateLanguage() {
  const languageSelect = document.getElementById("languageSelect")
  if (languageSelect) {
    languageSelect.addEventListener("change", () => {
      currentLanguage = languageSelect.value
      localStorage.setItem("language", currentLanguage)
      updateLanguageText()
    })
  }
  updateLanguageText()
}

function updateLanguageText() {
  // Update all elements with data-translate attribute
  const elements = document.querySelectorAll("[data-translate]")
  elements.forEach((element) => {
    const key = element.getAttribute("data-translate")
    if (translations[currentLanguage] && translations[currentLanguage][key]) {
      element.textContent = translations[currentLanguage][key]
    }
  })

  // Update placeholders
  const placeholderElements = document.querySelectorAll("[data-translate-placeholder]")
  placeholderElements.forEach((element) => {
    const key = element.getAttribute("data-translate-placeholder")
    if (translations[currentLanguage] && translations[currentLanguage][key]) {
      element.placeholder = translations[currentLanguage][key]
    }
  })

  // Update subtitle
  const subtitle = document.getElementById("registerSubtitle")
  if (subtitle) {
    subtitle.textContent =
      currentLanguage === "id"
        ? "Himpunan Mahasiswa Manajemen Informatika"
        : "Management Informatics Student Association"
  }
}

function setupValidation() {
  const form = document.getElementById("registerForm")
  const inputs = form.querySelectorAll("input")

  inputs.forEach((input) => {
    input.addEventListener("blur", () => validateField(input))
    input.addEventListener("input", () => clearFieldError(input.id))
  })

  // Password strength checker
  const passwordInput = document.getElementById("password")
  passwordInput.addEventListener("input", checkPasswordStrength)

  // Confirm password checker
  const confirmPasswordInput = document.getElementById("confirmPassword")
  confirmPasswordInput.addEventListener("input", checkPasswordMatch)
}

function validateField(input) {
  const fieldName = input.name
  const value = input.value.trim()

  switch (fieldName) {
    case "fullName":
      return validateFullName(value)
    case "username":
      return validateUsername(value)
    case "email":
      return validateEmail(value)
    case "password":
      return validatePassword(value)
    case "confirmPassword":
      return validateConfirmPassword(value)
    default:
      return true
  }
}

function validateFullName(value) {
  const errorElement = document.getElementById("fullNameError")

  if (!value) {
    showFieldError("fullNameError", translations[currentLanguage].fullNameRequired)
    return false
  }

  if (value.length < 2) {
    showFieldError("fullNameError", translations[currentLanguage].fullNameMinLength)
    return false
  }

  clearFieldError("fullName")
  return true
}

function validateUsername(value) {
  if (!value) {
    showFieldError("usernameError", translations[currentLanguage].usernameRequired)
    return false
  }

  if (value.length < 3) {
    showFieldError("usernameError", translations[currentLanguage].usernameMinLength)
    return false
  }

  if (!/^[a-zA-Z0-9_]{3,20}$/.test(value)) {
    showFieldError("usernameError", translations[currentLanguage].usernameInvalid)
    return false
  }

  clearFieldError("username")
  return true
}

function validateEmail(value) {
  if (!value) {
    showFieldError("emailError", translations[currentLanguage].emailRequired)
    return false
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!emailRegex.test(value)) {
    showFieldError("emailError", translations[currentLanguage].emailInvalid)
    return false
  }

  clearFieldError("email")
  return true
}

function validatePassword(value) {
  if (!value) {
    showFieldError("passwordError", translations[currentLanguage].passwordRequired)
    return false
  }

  if (value.length < 6) {
    showFieldError("passwordError", translations[currentLanguage].passwordWeak)
    return false
  }

  clearFieldError("password")
  return true
}

function validateConfirmPassword(value) {
  const password = document.getElementById("password").value

  if (!value) {
    showFieldError("confirmPasswordError", translations[currentLanguage].confirmPasswordRequired)
    return false
  }

  if (value !== password) {
    showFieldError("confirmPasswordError", translations[currentLanguage].passwordMismatch)
    return false
  }

  clearFieldError("confirmPassword")
  return true
}

function checkPasswordStrength() {
  const password = document.getElementById("password").value
  const strengthElement = document.getElementById("passwordStrength")

  if (!password) {
    strengthElement.textContent = ""
    return
  }

  let strength = 0

  // Length check
  if (password.length >= 8) strength++
  if (password.length >= 12) strength++

  // Character variety checks
  if (/[a-z]/.test(password)) strength++
  if (/[A-Z]/.test(password)) strength++
  if (/[0-9]/.test(password)) strength++
  if (/[^A-Za-z0-9]/.test(password)) strength++

  if (strength < 3) {
    strengthElement.textContent = translations[currentLanguage].passwordWeak
    strengthElement.className = "password-strength strength-weak"
  } else if (strength < 5) {
    strengthElement.textContent = translations[currentLanguage].passwordMedium
    strengthElement.className = "password-strength strength-medium"
  } else {
    strengthElement.textContent = translations[currentLanguage].passwordStrong
    strengthElement.className = "password-strength strength-strong"
  }
}

function checkPasswordMatch() {
  const password = document.getElementById("password").value
  const confirmPassword = document.getElementById("confirmPassword").value

  if (confirmPassword && password !== confirmPassword) {
    showFieldError("confirmPasswordError", translations[currentLanguage].passwordMismatch)
  } else {
    clearFieldError("confirmPassword")
  }
}

function showFieldError(errorElementId, message) {
  const errorElement = document.getElementById(errorElementId)
  if (errorElement) {
    errorElement.textContent = message
    errorElement.style.display = "block"
  }
}

function clearFieldError(fieldName) {
  const errorElement = document.getElementById(fieldName + "Error")
  if (errorElement) {
    errorElement.textContent = ""
    errorElement.style.display = "none"
  }
}

function submitRegister(event) {
  event.preventDefault()

  const form = document.getElementById("registerForm")
  const formData = new FormData(form)
  const errorMessage = document.getElementById("errorMessage")
  const successMessage = document.getElementById("successMessage")
  const registerButton = document.getElementById("registerButton")

  // Clear previous messages
  errorMessage.style.display = "none"
  successMessage.style.display = "none"

  // Validate all fields
  const isValid = validateAllFields()
  if (!isValid) {
    return
  }

  const registerData = {
    username: formData.get("username"),
    email: formData.get("email"),
    password: formData.get("password"),
    confirmPassword: formData.get("confirmPassword"),
    fullName: formData.get("fullName"),
    language: currentLanguage,
  }

  // Update button state
  registerButton.disabled = true
  registerButton.textContent = translations[currentLanguage].processing

  // Submit to server
  fetch("api/register", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(registerData),
  })
    .then((response) => response.json())
    .then((data) => {
      registerButton.disabled = false
      registerButton.textContent = translations[currentLanguage].registerButton

      if (data.success) {
        successMessage.textContent = data.message || translations[currentLanguage].registerSuccess
        successMessage.style.display = "block"
        form.reset()

        // Redirect to login after 2 seconds
        setTimeout(() => {
          window.location.href = "login.html"
        }, 2000)
      } else {
        if (data.validationErrors) {
          // Show field-specific errors
          for (const [field, error] of Object.entries(data.validationErrors)) {
            showFieldError(field + "Error", error)
          }
        } else {
          errorMessage.textContent = data.error || translations[currentLanguage].registerError
          errorMessage.style.display = "block"
        }
      }
    })
    .catch((error) => {
      registerButton.disabled = false
      registerButton.textContent = translations[currentLanguage].registerButton

      console.error("Registration error:", error)
      errorMessage.textContent = translations[currentLanguage].systemError
      errorMessage.style.display = "block"
    })
}

function validateAllFields() {
  const form = document.getElementById("registerForm")
  const inputs = form.querySelectorAll("input[required]")
  let isValid = true

  inputs.forEach((input) => {
    if (!validateField(input)) {
      isValid = false
    }
  })

  return isValid
}

function togglePassword(fieldId) {
  const passwordInput = document.getElementById(fieldId)
  const toggleIcon = document.getElementById(fieldId + "ToggleIcon")

  if (passwordInput && toggleIcon) {
    if (passwordInput.type === "password") {
      passwordInput.type = "text"
      toggleIcon.classList.remove("fa-eye")
      toggleIcon.classList.add("fa-eye-slash")
    } else {
      passwordInput.type = "password"
      toggleIcon.classList.remove("fa-eye-slash")
      toggleIcon.classList.add("fa-eye")
    }
  }
}

function toggleTheme() {
  const themeToggle = document.getElementById("themeToggle")
  if (themeToggle && themeToggle.checked) {
    currentTheme = "dark"
    document.body.classList.add("dark-theme")
  } else {
    currentTheme = "light"
    document.body.classList.remove("dark-theme")
  }
  localStorage.setItem("theme", currentTheme)
}

// Export functions for global access
window.submitRegister = submitRegister
window.togglePassword = togglePassword
window.toggleTheme = toggleTheme
