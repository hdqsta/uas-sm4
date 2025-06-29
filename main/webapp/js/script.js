// Global Variables
let currentLanguage = "id"
let currentTheme = "light"
let participants = []
let isServerMode = false

// Check if running on server or local file
function checkServerMode() {
  isServerMode = window.location.protocol === "http:" || window.location.protocol === "https:"
  console.log("Server mode:", isServerMode)
}

// Translations
const translations = {
  id: {
    // Navigation
    home: "Beranda",
    about: "Tentang Kami",
    register: "Daftar Ekstrakurikuler",
    participants: "Daftar Peserta",
    login: "Login",

    // Hero Section
    heroTitle: "Selamat Datang di HIMA MI",
    heroSubtitle: "Himpunan Mahasiswa Manajemen Informatika Politeknik Negeri Sriwijaya",
    registerNow: "Daftar Sekarang",
    learnMore: "Pelajari Lebih Lanjut",

    // Stats
    activeMembers: "Anggota Aktif",
    extracurricularPrograms: "Program Ekstrakurikuler",
    establishedYear: "Tahun Berdiri",

    // Features
    excellenceDesc: "Mengutamakan keunggulan dalam setiap kegiatan",
    achievementDesc: "Meraih prestasi di berbagai bidang",
    communityDesc: "Membangun komunitas yang solid",
    innovationDesc: "Mendorong inovasi dan kreativitas",

    // About Section
    aboutHima: "Tentang HIMA MI",
    aboutDescription1:
      "Himpunan Mahasiswa Manajemen Informatika (HIMA MI) adalah organisasi kemahasiswaan yang menaungi seluruh mahasiswa Jurusan Manajemen Informatika di Politeknik Negeri Sriwijaya.",
    aboutDescription2:
      "Kami berkomitmen untuk mengembangkan potensi mahasiswa melalui berbagai kegiatan akademik, non-akademik, dan pengembangan soft skills yang relevan dengan dunia kerja.",
    visionMission: "Visi & Misi",
    vision: "Visi:",
    visionText: "Menjadi wadah pengembangan mahasiswa MI yang unggul dan berkarakter.",
    mission: "Misi:",
    missionText1: "Mengembangkan potensi akademik mahasiswa",
    missionText2: "Memfasilitasi kegiatan ekstrakurikuler",
    missionText3: "Membangun networking dengan industri",

    // Department Info
    departmentTitle: "Jurusan Manajemen Informatika",
    departmentSubtitle: "Politeknik Negeri Sriwijaya",
    visitWebsite: "Kunjungi Website MI",

    // Registration Form
    registerTitle: "Daftar Ekstrakurikuler HIMA MI",
    registerDescription: "Bergabunglah dengan program ekstrakurikuler yang sesuai dengan minat dan bakat Anda",
    fullName: "Nama Lengkap",
    studyProgram: "Program Studi",
    email: "Email",
    phoneNumber: "Nomor HP",
    himProgram: "Program Himpunan",
    selectStudyProgram: "Pilih program studi",
    selectHimProgram: "Pilih program ekstrakurikuler",
    submitRegistration: "Daftar Sekarang",
    registrationSuccess: "Pendaftaran berhasil! Data Anda telah ditambahkan ke daftar peserta.",
    fillAllFields: "Mohon lengkapi semua field!",
    emailExists: "Email sudah terdaftar!",

    // Participants
    participantsList: "Daftar Peserta Terdaftar",
    totalParticipants: "Total peserta yang telah mendaftar",
    people: "orang",
    noParticipants: "Belum Ada Peserta",
    noParticipantsDesc: "Jadilah yang pertama mendaftar ekstrakurikuler HIMA MI!",

    // Footer
    contact: "Kontak",
    relatedLinks: "Link Terkait",
    allRightsReserved: "All rights reserved",

    // Programs
    programmingCoding: "Programming & Coding",
    volleyball: "Volleyball",
    basketball: "Basketball",
    futsal: "Futsal",
    badminton: "Badminton",
    photography: "Photography",
    musicBand: "Music & Band",
    debatePublicSpeaking: "Debate & Public Speaking",

    // Study Programs
    managementInformatics: "Manajemen Informatika",
    computerEngineering: "Teknik Komputer",
    informationSystems: "Sistem Informasi",
    informaticsEngineering: "Teknik Informatika",

    // Login
    login: "Login",
    loginSubtitle: "Masuk ke sistem HIMA MI",
    username: "Username",
    password: "Password",
    enterUsername: "Masukkan username",
    enterPassword: "Masukkan password",
    loginButton: "Login",
    processing: "Memproses...",
    loginSuccess: "Login berhasil! Selamat datang, Admin.",
    loginError: "Username atau password salah!",
    systemError: "Terjadi kesalahan saat login. Silakan coba lagi.",
    demoLogin: "Demo Login:",
    backToHome: "← Kembali ke Beranda",

    // Loading
    loading: "Memuat...",

    // Footer Description
    footerDesc: "Himpunan Mahasiswa Manajemen Informatika\nPoliteknik Negeri Sriwijaya",
    registerAccount: "Daftar Akun",
    createAccount: "Buat Akun",
    myProfile: "Profil Saya",
    logout: "Logout",
    logoutSuccess: "Logout berhasil!",
    noAccount: "Belum punya akun?",
    registerHere: "Daftar di sini",
    demoMode: "Mode Demo - Data disimpan sementara di browser",
  },
  en: {
    // Navigation
    home: "Home",
    about: "About Us",
    register: "Register Extracurricular",
    participants: "Participants List",
    login: "Login",

    // Hero Section
    heroTitle: "Welcome to HIMA MI",
    heroSubtitle: "Management Informatics Student Association of Sriwijaya State Polytechnic",
    registerNow: "Register Now",
    learnMore: "Learn More",

    // Stats
    activeMembers: "Active Members",
    extracurricularPrograms: "Extracurricular Programs",
    establishedYear: "Established Year",

    // Features
    excellenceDesc: "Prioritizing excellence in every activity",
    achievementDesc: "Achieving excellence in various fields",
    communityDesc: "Building a solid community",
    innovationDesc: "Encouraging innovation and creativity",

    // About Section
    aboutHima: "About HIMA MI",
    aboutDescription1:
      "Management Informatics Student Association (HIMA MI) is a student organization that oversees all students of the Management Informatics Department at Sriwijaya State Polytechnic.",
    aboutDescription2:
      "We are committed to developing student potential through various academic, non-academic activities, and soft skills development relevant to the working world.",
    visionMission: "Vision & Mission",
    vision: "Vision:",
    visionText: "To become a platform for developing excellent and characterized MI students.",
    mission: "Mission:",
    missionText1: "Develop students' academic potential",
    missionText2: "Facilitate extracurricular activities",
    missionText3: "Build networking with industry",

    // Department Info
    departmentTitle: "Management Informatics Department",
    departmentSubtitle: "Sriwijaya State Polytechnic",
    visitWebsite: "Visit MI Website",

    // Registration Form
    registerTitle: "Register HIMA MI Extracurricular",
    registerDescription: "Join extracurricular programs that match your interests and talents",
    fullName: "Full Name",
    studyProgram: "Study Program",
    email: "Email",
    phoneNumber: "Phone Number",
    himProgram: "Association Program",
    selectStudyProgram: "Select study program",
    selectHimProgram: "Select extracurricular program",
    submitRegistration: "Register Now",
    registrationSuccess: "Registration successful! Your data has been added to the participants list.",
    fillAllFields: "Please fill in all fields!",
    emailExists: "Email already registered!",

    // Participants
    participantsList: "Registered Participants List",
    totalParticipants: "Total registered participants",
    people: "people",
    noParticipants: "No Participants Yet",
    noParticipantsDesc: "Be the first to register for HIMA MI extracurricular!",

    // Footer
    contact: "Contact",
    relatedLinks: "Related Links",
    allRightsReserved: "All rights reserved",

    // Programs
    programmingCoding: "Programming & Coding",
    volleyball: "Volleyball",
    basketball: "Basketball",
    futsal: "Futsal",
    badminton: "Badminton",
    photography: "Photography",
    musicBand: "Music & Band",
    debatePublicSpeaking: "Debate & Public Speaking",

    // Study Programs
    managementInformatics: "Management Informatics",
    computerEngineering: "Computer Engineering",
    informationSystems: "Information Systems",
    informaticsEngineering: "Informatics Engineering",

    // Login
    login: "Login",
    loginSubtitle: "Sign in to HIMA MI system",
    username: "Username",
    password: "Password",
    enterUsername: "Enter username",
    enterPassword: "Enter password",
    loginButton: "Login",
    processing: "Processing...",
    loginSuccess: "Login successful! Welcome, Admin.",
    loginError: "Username or password is incorrect!",
    systemError: "An error occurred during login. Please try again.",
    demoLogin: "Demo Login:",
    backToHome: "← Back to Home",

    // Loading
    loading: "Loading...",

    // Footer Description
    footerDesc: "Management Informatics Student Association\nSriwijaya State Polytechnic",
    registerAccount: "Register Account",
    createAccount: "Create Account",
    myProfile: "My Profile",
    logout: "Logout",
    logoutSuccess: "Logout successful!",
    noAccount: "Don't have an account?",
    registerHere: "Register here",
    demoMode: "Demo Mode - Data stored temporarily in browser",
  },
}

// Program Options
const programOptions = {
  id: {
    coding: "Programming & Coding",
    volley: "Volleyball",
    basket: "Basketball",
    futsal: "Futsal",
    badminton: "Badminton",
    photography: "Photography",
    music: "Music & Band",
    debate: "Debate & Public Speaking",
  },
  en: {
    coding: "Programming & Coding",
    volley: "Volleyball",
    basket: "Basketball",
    futsal: "Futsal",
    badminton: "Badminton",
    photography: "Photography",
    music: "Music & Band",
    debate: "Debate & Public Speaking",
  },
}

// Initialize Application
document.addEventListener("DOMContentLoaded", () => {
  checkServerMode()
  initializeApp()
})

// Authentication state management
function checkAuthState() {
  const sessionToken = localStorage.getItem("sessionToken")
  const userData = localStorage.getItem("userData")

  if (sessionToken && userData) {
    const user = JSON.parse(userData)
    showUserProfile(user)
  } else {
    showGuestButtons()
  }
}

function showUserProfile(user) {
  const guestButtons = document.getElementById("guestButtons")
  const userProfile = document.getElementById("userProfile")

  if (guestButtons) guestButtons.style.display = "none"
  if (userProfile) {
    userProfile.style.display = "block"

    // Update profile info
    const profileName = document.getElementById("profileName")
    const profileAvatar = document.getElementById("profileAvatar")

    if (profileName) {
      profileName.textContent = user.fullName || user.username
    }

    if (profileAvatar) {
      profileAvatar.src = generateAvatarUrl(user.fullName || user.username)
    }
  }
}

function showGuestButtons() {
  const guestButtons = document.getElementById("guestButtons")
  const userProfile = document.getElementById("userProfile")

  if (guestButtons) guestButtons.style.display = "flex"
  if (userProfile) userProfile.style.display = "none"
}

function generateAvatarUrl(name) {
  const initials = name
    .split(" ")
    .map((n) => n[0])
    .join("")
    .toUpperCase()
  const colors = ["#3B82F6", "#10B981", "#F59E0B", "#EF4444", "#8B5CF6", "#06B6D4"]
  const color = colors[name.length % colors.length]

  return `data:image/svg+xml;base64,${btoa(`
    <svg width="32" height="32" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg">
      <circle cx="16" cy="16" r="16" fill="${color}"/>
      <text x="16" y="21" font-family="Arial, sans-serif" font-size="12" font-weight="bold" 
            text-anchor="middle" fill="white">${initials}</text>
    </svg>
  `)}`
}

function handleProfileClick() {
  const sessionToken = localStorage.getItem("sessionToken")

  if (!sessionToken) {
    // Not logged in, redirect to login
    window.location.href = "login.html"
    return
  }

  // Toggle dropdown
  const dropdown = document.getElementById("profileDropdown")
  const profileInfo = document.querySelector(".profile-info")

  if (dropdown && profileInfo) {
    const isVisible = dropdown.style.display === "block"
    dropdown.style.display = isVisible ? "none" : "block"
    profileInfo.classList.toggle("active", !isVisible)
  }
}

function logout() {
  // Clear session data
  localStorage.removeItem("sessionToken")
  localStorage.removeItem("userData")
  localStorage.removeItem("userRole")

  // Show guest buttons
  showGuestButtons()

  // Redirect to home
  window.location.href = "index.html"

  alert(translations[currentLanguage].logoutSuccess || "Logout berhasil!")
}

// Close dropdown when clicking outside
document.addEventListener("click", (event) => {
  const profileInfo = document.querySelector(".profile-info")
  const dropdown = document.getElementById("profileDropdown")

  if (profileInfo && dropdown && !profileInfo.contains(event.target)) {
    dropdown.style.display = "none"
    profileInfo.classList.remove("active")
  }
})

function initializeApp() {
  // Load saved preferences
  loadPreferences()

  // Apply theme
  applyTheme()

  // Update language
  updateLanguage()

  // Check authentication state
  checkAuthState()

  // Load participants
  loadParticipants()

  // Update member count
  updateMemberCount()

  // Set up event listeners
  setupEventListeners()

  // Show demo mode indicator if not on server
  showDemoModeIndicator()
}

function showDemoModeIndicator() {
  if (!isServerMode) {
    // Add demo mode indicator
    const header = document.querySelector(".header")
    if (header) {
      const demoIndicator = document.createElement("div")
      demoIndicator.style.cssText = `
        background: #f59e0b;
        color: white;
        text-align: center;
        padding: 0.5rem;
        font-size: 0.875rem;
        font-weight: 500;
      `
      demoIndicator.textContent = translations[currentLanguage].demoMode
      header.parentNode.insertBefore(demoIndicator, header)
    }
  }
}

function loadPreferences() {
  // Load theme preference
  const savedTheme = localStorage.getItem("theme")
  if (savedTheme) {
    currentTheme = savedTheme
    const themeToggle = document.getElementById("themeToggle")
    if (themeToggle) {
      themeToggle.checked = currentTheme === "dark"
    }
  } else {
    currentTheme = "light" // Default theme
  }

  // Load language preference
  const savedLanguage = localStorage.getItem("language")
  if (savedLanguage) {
    currentLanguage = savedLanguage
    const languageSelect = document.getElementById("languageSelect")
    if (languageSelect) {
      languageSelect.value = currentLanguage
    }
  } else {
    currentLanguage = "id" // Default language
  }
}

function setupEventListeners() {
  // Theme toggle
  const themeToggle = document.getElementById("themeToggle")
  if (themeToggle) {
    themeToggle.addEventListener("change", toggleTheme)
  }

  // Language select
  const languageSelect = document.getElementById("languageSelect")
  if (languageSelect) {
    languageSelect.addEventListener("change", changeLanguage)
  }
}

// Theme Functions
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

function applyTheme() {
  if (currentTheme === "dark") {
    document.body.classList.add("dark-theme")
  } else {
    document.body.classList.remove("dark-theme")
  }
}

// Language Functions
function changeLanguage() {
  const languageSelect = document.getElementById("languageSelect")
  if (languageSelect) {
    currentLanguage = languageSelect.value
    localStorage.setItem("language", currentLanguage)
    updateLanguage()
    updateParticipantsDisplay()
    showDemoModeIndicator()
  }
}

function updateLanguage() {
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

  // Update subtitle and footer description
  updateDynamicContent()
}

function updateDynamicContent() {
  const subtitle = document.getElementById("subtitle")
  const loginSubtitle = document.getElementById("loginSubtitle")
  const footerDesc = document.getElementById("footerDesc")

  if (subtitle) {
    subtitle.textContent =
      currentLanguage === "id"
        ? "Himpunan Mahasiswa Manajemen Informatika"
        : "Management Informatics Student Association"
  }

  if (loginSubtitle) {
    loginSubtitle.textContent =
      currentLanguage === "id"
        ? "Himpunan Mahasiswa Manajemen Informatika"
        : "Management Informatics Student Association"
  }

  if (footerDesc) {
    footerDesc.textContent = translations[currentLanguage].footerDesc
  }
}

// Navigation Functions
function showSection(sectionId) {
  // Hide all sections
  const sections = document.querySelectorAll(".section")
  sections.forEach((section) => {
    section.classList.remove("active")
  })

  // Show selected section
  const targetSection = document.getElementById(sectionId)
  if (targetSection) {
    targetSection.classList.add("active")
    targetSection.classList.add("fade-in")
  }

  // Update navigation buttons
  const navButtons = document.querySelectorAll(".nav-btn")
  navButtons.forEach((btn) => {
    btn.classList.remove("active")
  })

  const activeButton = document.querySelector(`[onclick="showSection('${sectionId}')"]`)
  if (activeButton) {
    activeButton.classList.add("active")
  }

  // Load section-specific data
  if (sectionId === "participants") {
    loadParticipants()
  }
}

// Local Storage Functions for Demo Mode
function saveParticipantsToLocal() {
  localStorage.setItem("himami_participants", JSON.stringify(participants))
}

function loadParticipantsFromLocal() {
  const saved = localStorage.getItem("himami_participants")
  if (saved) {
    try {
      participants = JSON.parse(saved)
    } catch (e) {
      console.error("Error parsing saved participants:", e)
      participants = getDefaultParticipants()
    }
  } else {
    participants = getDefaultParticipants()
  }
}

function getDefaultParticipants() {
  return [
    {
      id: 1,
      namaLengkap: "Ahmad Rizki Pratama",
      prodi: "Manajemen Informatika",
      email: "ahmad.rizki@student.polsri.ac.id",
      nomorHP: "081234567890",
      programHimpunan: "coding",
      tanggalDaftar: "2024-01-15",
    },
    {
      id: 2,
      namaLengkap: "Siti Nurhaliza",
      prodi: "Teknik Komputer",
      email: "siti.nurhaliza@student.polsri.ac.id",
      nomorHP: "081234567891",
      programHimpunan: "volley",
      tanggalDaftar: "2024-01-16",
    },
    {
      id: 3,
      namaLengkap: "Budi Santoso",
      prodi: "Sistem Informasi",
      email: "budi.santoso@student.polsri.ac.id",
      nomorHP: "081234567892",
      programHimpunan: "futsal",
      tanggalDaftar: "2024-01-17",
    },
  ]
}

// Registration Functions
function submitRegistration(event) {
  event.preventDefault()

  const form = document.getElementById("registrationForm")
  const formData = new FormData(form)

  const registrationData = {
    namaLengkap: formData.get("namaLengkap"),
    prodi: formData.get("prodi"),
    email: formData.get("email"),
    nomorHP: formData.get("nomorHP"),
    programHimpunan: formData.get("programHimpunan"),
  }

  console.log("Submitting registration data:", registrationData)

  // Validate form
  if (!validateRegistrationForm(registrationData)) {
    return
  }

  // Show loading
  showLoading()

  if (isServerMode) {
    // Try server first
    submitToServer(registrationData, form)
  } else {
    // Use local storage for demo mode
    submitToLocal(registrationData, form)
  }
}

function submitToServer(registrationData, form) {
  fetch("api/participants", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(registrationData),
  })
    .then((response) => {
      console.log("Response status:", response.status)

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }

      return response.text().then((text) => {
        console.log("Raw response:", text)
        try {
          return JSON.parse(text)
        } catch (e) {
          console.error("Failed to parse JSON:", e)
          throw new Error("Invalid JSON response")
        }
      })
    })
    .then((data) => {
      hideLoading()
      console.log("Parsed response data:", data)

      if (data.success) {
        alert(translations[currentLanguage].registrationSuccess)
        form.reset()
        loadParticipants()
        updateMemberCount()
        setTimeout(() => {
          showSection("participants")
        }, 1000)
      } else {
        alert(data.error || translations[currentLanguage].systemError)
      }
    })
    .catch((error) => {
      hideLoading()
      console.error("Server error, falling back to local storage:", error)
      // Fallback to local storage
      submitToLocal(registrationData, form)
    })
}

function submitToLocal(registrationData, form) {
  setTimeout(() => {
    hideLoading()

    // Check if email already exists
    const existingParticipant = participants.find((p) => p.email === registrationData.email)
    if (existingParticipant) {
      alert(translations[currentLanguage].emailExists)
      return
    }

    const newParticipant = {
      id: participants.length + 1,
      namaLengkap: registrationData.namaLengkap,
      prodi: registrationData.prodi,
      email: registrationData.email,
      nomorHP: registrationData.nomorHP,
      programHimpunan: registrationData.programHimpunan,
      tanggalDaftar: new Date().toISOString().split("T")[0],
    }

    participants.push(newParticipant)
    saveParticipantsToLocal()

    alert(translations[currentLanguage].registrationSuccess)
    form.reset()
    updateParticipantsDisplay()
    updateMemberCount()

    setTimeout(() => {
      showSection("participants")
    }, 1000)
  }, 500) // Simulate network delay
}

function validateRegistrationForm(data) {
  // Check if all fields are filled
  for (const key in data) {
    if (!data[key] || data[key].trim() === "") {
      alert(translations[currentLanguage].fillAllFields)
      return false
    }
  }

  return true
}

// Participants Functions
function loadParticipants() {
  if (isServerMode) {
    loadParticipantsFromServer()
  } else {
    loadParticipantsFromLocal()
    updateParticipantsDisplay()
    updateMemberCount()
  }
}

function loadParticipantsFromServer() {
  showLoading()

  fetch("api/participants")
    .then((response) => response.json())
    .then((data) => {
      hideLoading()
      if (data.success) {
        participants = data.data
        updateParticipantsDisplay()
        updateMemberCount()
      } else {
        console.error("Failed to load participants:", data.message)
        loadParticipantsFromLocal()
        updateParticipantsDisplay()
        updateMemberCount()
      }
    })
    .catch((error) => {
      hideLoading()
      console.error("Error loading participants from server, using local:", error)
      loadParticipantsFromLocal()
      updateParticipantsDisplay()
      updateMemberCount()
    })
}

function updateParticipantsDisplay() {
  const participantsGrid = document.getElementById("participantsGrid")
  const noParticipants = document.getElementById("noParticipants")
  const participantCount = document.getElementById("participantCount")

  if (!participantsGrid) return

  if (participants.length === 0) {
    participantsGrid.style.display = "none"
    if (noParticipants) noParticipants.style.display = "block"
  } else {
    participantsGrid.style.display = "grid"
    if (noParticipants) noParticipants.style.display = "none"

    participantsGrid.innerHTML = participants.map((participant) => createParticipantCard(participant)).join("")
  }

  if (participantCount) {
    participantCount.textContent = participants.length
  }
}

function createParticipantCard(participant) {
  const programName = programOptions[currentLanguage][participant.programHimpunan] || participant.programHimpunan
  const formattedDate = new Date(participant.tanggalDaftar).toLocaleDateString(
    currentLanguage === "id" ? "id-ID" : "en-US",
  )

  return `
        <div class="participant-card slide-in">
            <div class="participant-info">
                <h3>${participant.namaLengkap}</h3>
                <p class="prodi">${participant.prodi}</p>
            </div>
            <div class="participant-details">
                <div class="participant-detail">
                    <i class="fas fa-envelope"></i>
                    <span>${participant.email}</span>
                </div>
                <div class="participant-detail">
                    <i class="fas fa-phone"></i>
                    <span>${participant.nomorHP}</span>
                </div>
            </div>
            <div class="participant-footer">
                <span class="program-badge">${programName}</span>
                <span class="participant-date">${formattedDate}</span>
            </div>
        </div>
    `
}

function updateMemberCount() {
  const memberCountElement = document.getElementById("memberCount")
  if (memberCountElement) {
    // Animate counter
    animateCounter(memberCountElement, 0, participants.length, 1000)
  }
}

function animateCounter(element, start, end, duration) {
  const range = end - start
  const increment = range / (duration / 16)
  let current = start

  const timer = setInterval(() => {
    current += increment
    if (current >= end) {
      current = end
      clearInterval(timer)
    }
    element.textContent = Math.floor(current)
  }, 16)
}

// Utility Functions
function showLoading() {
  const loadingOverlay = document.getElementById("loadingOverlay")
  if (loadingOverlay) {
    loadingOverlay.style.display = "flex"
  }
}

function hideLoading() {
  const loadingOverlay = document.getElementById("loadingOverlay")
  if (loadingOverlay) {
    loadingOverlay.style.display = "none"
  }
}

// Password Toggle Function
function togglePassword() {
  const passwordInput = document.getElementById("password")
  const toggleIcon = document.getElementById("passwordToggleIcon")

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

// Export functions for global access
window.showSection = showSection
window.submitRegistration = submitRegistration
window.toggleTheme = toggleTheme
window.changeLanguage = changeLanguage
window.togglePassword = togglePassword
window.handleProfileClick = handleProfileClick
window.logout = logout
window.checkAuthState = checkAuthState
