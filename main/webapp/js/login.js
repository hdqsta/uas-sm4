// Login specific JavaScript
let currentTheme
let currentLanguage
const translations = {
  en: {
    processing: "Processing...",
    loginButton: "Login",
    loginSuccess: "Login successful!",
    systemError: "System error occurred.",
    noAccount: "Don't have an account?",
    registerHere: "Register here",
  },
  es: {
    processing: "Procesando...",
    loginButton: "Iniciar sesión",
    loginSuccess: "Inicio de sesión exitoso!",
    systemError: "Ocurrió un error del sistema.",
  },
  id: {
    processing: "Memproses...",
    loginButton: "Masuk",
    loginSuccess: "Login berhasil!",
    systemError: "Terjadi kesalahan sistem.",
    noAccount: "Belum punya akun?",
    registerHere: "Daftar di sini",
  },
  // Add more languages as needed
}

document.addEventListener("DOMContentLoaded", () => {
  initializeLogin()
})

function initializeLogin() {
  // Load saved preferences
  loadLoginPreferences()

  // Apply theme
  applyTheme()

  // Update language
  updateLanguage()
}

function loadLoginPreferences() {
  // Load theme preference
  const savedTheme = localStorage.getItem("theme")
  if (savedTheme) {
    currentTheme = savedTheme
    const themeToggle = document.getElementById("themeToggle")
    if (themeToggle) {
      themeToggle.checked = currentTheme === "dark"
    }
  } else {
    currentTheme = "light"
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
  } else {
    currentLanguage = "id"
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
  const loginButton = document.getElementById("loginButton")
  const errorMessage = document.getElementById("errorMessage")

  if (loginButton) {
    loginButton.textContent = translations[currentLanguage].loginButton
  }

  if (errorMessage) {
    errorMessage.textContent = translations[currentLanguage].systemError
  }
}

function submitLogin(event) {
  event.preventDefault()

  const form = document.getElementById("loginForm")
  const formData = new FormData(form)
  const errorMessage = document.getElementById("errorMessage")
  const loginButton = document.getElementById("loginButton")

  const loginData = {
    username: formData.get("username"),
    password: formData.get("password"),
    language: currentLanguage,
  }

  // Hide previous error
  if (errorMessage) {
    errorMessage.style.display = "none"
  }

  // Update button state
  if (loginButton) {
    loginButton.disabled = true
    loginButton.textContent = translations[currentLanguage].processing
  }

  // Submit to server
  fetch("api/auth", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(loginData),
  })
    .then((response) => response.json())
    .then((data) => {
      if (loginButton) {
        loginButton.disabled = false
        loginButton.textContent = translations[currentLanguage].loginButton
      }

      if (data.success) {
        // Store session data
        localStorage.setItem("sessionToken", data.data.token)
        localStorage.setItem("userData", JSON.stringify(data.data.user))
        localStorage.setItem("userRole", data.data.user.role)

        alert(translations[currentLanguage].loginSuccess)

        // Redirect to main page
        window.location.href = "index.html"
      } else {
        showLoginError(data.error)
      }
    })
    .catch((error) => {
      if (loginButton) {
        loginButton.disabled = false
        loginButton.textContent = translations[currentLanguage].loginButton
      }

      console.error("Login error:", error)

      // For demo purposes, allow admin/admin123 login
      if (loginData.username === "admin" && loginData.password === "admin123") {
        const mockUser = {
          id: 1,
          username: "admin",
          email: "admin@hima-mi.polsri.ac.id",
          fullName: "Administrator HIMA MI",
          role: "admin",
        }

        localStorage.setItem("sessionToken", "demo_session_" + Date.now())
        localStorage.setItem("userData", JSON.stringify(mockUser))
        localStorage.setItem("userRole", "admin")

        alert(translations[currentLanguage].loginSuccess)
        window.location.href = "index.html"
      } else {
        showLoginError(translations[currentLanguage].systemError)
      }
    })
}

function showLoginError(message) {
  const errorMessage = document.getElementById("errorMessage")
  if (errorMessage) {
    errorMessage.textContent = message
    errorMessage.style.display = "block"
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

// Export function for global access
window.submitLogin = submitLogin
window.toggleTheme = toggleTheme
