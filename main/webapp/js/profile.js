// Profile page JavaScript
let currentUser = null
let currentLanguage = "id"

const translations = {
  id: {
    personalInfo: "Informasi Pribadi",
    accountSettings: "Pengaturan Akun",
    recentActivity: "Aktivitas Terbaru",
    fullName: "Nama Lengkap",
    username: "Username",
    email: "Email",
    role: "Role",
    accountStatus: "Status Akun",
    lastLogin: "Login Terakhir",
    memberSince: "Member Sejak",
    editProfile: "Edit Profil",
    backToHome: "← Kembali ke Beranda",
    active: "Aktif",
    admin: "Administrator",
    member: "Member",
    loading: "Memuat...",
    error: "Terjadi kesalahan",
    notLoggedIn: "Anda belum login",
  },
  en: {
    personalInfo: "Personal Information",
    accountSettings: "Account Settings",
    recentActivity: "Recent Activity",
    fullName: "Full Name",
    username: "Username",
    email: "Email",
    role: "Role",
    accountStatus: "Account Status",
    lastLogin: "Last Login",
    memberSince: "Member Since",
    editProfile: "Edit Profile",
    backToHome: "← Back to Home",
    active: "Active",
    admin: "Administrator",
    member: "Member",
    loading: "Loading...",
    error: "An error occurred",
    notLoggedIn: "You are not logged in",
  },
}

document.addEventListener("DOMContentLoaded", () => {
  initializeProfile()
})

function initializeProfile() {
  // Load language preference
  const savedLanguage = localStorage.getItem("language")
  if (savedLanguage) {
    currentLanguage = savedLanguage
  }

  // Check if user is logged in
  const sessionToken = localStorage.getItem("sessionToken")
  if (!sessionToken) {
    alert(translations[currentLanguage].notLoggedIn)
    window.location.href = "login.html"
    return
  }

  // Load user profile
  loadUserProfile()
  updateLanguage()
}

function loadUserProfile() {
  // Get user data from localStorage (in real app, fetch from server)
  const userData = localStorage.getItem("userData")
  if (userData) {
    currentUser = JSON.parse(userData)
    displayUserProfile(currentUser)
  } else {
    // Fetch from server if not in localStorage
    fetchUserProfile()
  }
}

function fetchUserProfile() {
  const sessionToken = localStorage.getItem("sessionToken")

  // Mock user data for demo
  const mockUser = {
    id: 1,
    username: "admin",
    email: "admin@hima-mi.polsri.ac.id",
    fullName: "Administrator HIMA MI",
    role: "admin",
    isActive: true,
    createdAt: "2024-01-01T00:00:00Z",
    lastLogin: new Date().toISOString(),
  }

  // Simulate API call delay
  setTimeout(() => {
    currentUser = mockUser
    localStorage.setItem("userData", JSON.stringify(mockUser))
    displayUserProfile(mockUser)
  }, 500)
}

function displayUserProfile(user) {
  // Generate avatar URL
  const avatarUrl = generateAvatarUrl(user.fullName)

  // Update profile header
  document.getElementById("profileAvatarLarge").src = avatarUrl
  document.getElementById("profileFullName").textContent = user.fullName
  document.getElementById("profileRole").textContent = translations[currentLanguage][user.role] || user.role

  const joinDate = new Date(user.createdAt).toLocaleDateString(currentLanguage === "id" ? "id-ID" : "en-US")
  document.getElementById("profileJoinDate").textContent =
    `${currentLanguage === "id" ? "Bergabung pada" : "Joined on"}: ${joinDate}`

  // Update personal information
  document.getElementById("infoFullName").textContent = user.fullName
  document.getElementById("infoUsername").textContent = user.username
  document.getElementById("infoEmail").textContent = user.email
  document.getElementById("infoRole").textContent = translations[currentLanguage][user.role] || user.role

  // Update account settings
  document.getElementById("accountStatus").textContent = user.isActive
    ? translations[currentLanguage].active
    : "Inactive"

  const lastLogin = user.lastLogin
    ? new Date(user.lastLogin).toLocaleString(currentLanguage === "id" ? "id-ID" : "en-US")
    : "-"
  document.getElementById("lastLogin").textContent = lastLogin
  document.getElementById("memberSince").textContent = joinDate
}

function generateAvatarUrl(name) {
  // Generate avatar based on initials
  const initials = name
    .split(" ")
    .map((n) => n[0])
    .join("")
    .toUpperCase()
  const colors = ["#3B82F6", "#10B981", "#F59E0B", "#EF4444", "#8B5CF6", "#06B6D4"]
  const color = colors[name.length % colors.length]

  return `data:image/svg+xml;base64,${btoa(`
    <svg width="120" height="120" viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg">
      <circle cx="60" cy="60" r="60" fill="${color}"/>
      <text x="60" y="75" font-family="Arial, sans-serif" font-size="40" font-weight="bold" 
            text-anchor="middle" fill="white">${initials}</text>
    </svg>
  `)}`
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
}

function editProfile() {
  // Redirect to edit profile page (to be implemented)
  alert("Edit profile functionality will be implemented soon!")
}

// Export functions for global access
window.editProfile = editProfile
