export default defineNuxtPlugin(async () => {
  const user = useState('auth.user', () => null)
  
  // Check if user is logged in on app start
  try {
    const response = await $fetch('/api/auth/me')
    if (response.success) {
      user.value = response.user
    }
  } catch (error) {
    // User not logged in, that's okay
    console.log('User not authenticated on app start')
  }
})