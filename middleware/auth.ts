export default defineNuxtRouteMiddleware((to) => {
  const user = useState('auth.user')
  
  if (!user.value) {
    return navigateTo('/login')
  }
})