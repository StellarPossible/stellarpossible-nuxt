export default defineEventHandler(async (event) => {
  console.log('=== LOGIN ENDPOINT CALLED ===')
  
  const { username, password } = await readBody(event)
  const config = useRuntimeConfig()
  
  console.log('Username:', username)
  console.log('Password length:', password?.length)
  console.log('Config wpUser:', config.public.wpUser)
  
  // Simple validation
  if (!username || !password) {
    console.log('Missing credentials')
    return { success: false, message: 'Username and password are required' }
  }
  
  // Check username
  const validUsername = username === 'mlvalentonis' || username === 'mlvalentonis@stellarpossible.com'
  console.log('Valid username:', validUsername)
  
  if (!validUsername) {
    console.log('Invalid username')
    return { success: false, message: 'Invalid username or password' }
  }
  
  // Check password
  const validPassword = password === '@Mmdel2022'
  console.log('Valid password:', validPassword)
  
  if (!validPassword) {
    console.log('Invalid password')
    return { success: false, message: 'Invalid username or password' }
  }
  
  console.log('Credentials valid, fetching user data...')
  
  try {
    // Get user data from WordPress
    const wpEndpoint = config.public.wpRestEndpoint
    const authString = Buffer.from(`${config.public.wpUser}:${config.wpAppPassword}`).toString('base64')
    
    const response = await $fetch(`${wpEndpoint}/wp/v2/users/me`, {
      headers: {
        'Authorization': `Basic ${authString}`,
        'Content-Type': 'application/json'
      }
    })
    
    console.log('WordPress response received:', !!response)
    
    if (response && response.id) {
      console.log('Creating session token...')
      
      // Create a simple session token
      const sessionToken = Buffer.from(`${response.username}:${Date.now()}`).toString('base64')
      
      // Set cookie
      setCookie(event, 'auth-token', sessionToken, {
        httpOnly: true,
        secure: false, // false for development
        sameSite: 'strict',
        maxAge: 60 * 60 * 24 * 7,
        path: '/'
      })
      
      console.log('Login successful!')
      
      return {
        success: true,
        user: {
          id: response.id,
          username: response.username,
          email: response.email,
          name: response.name,
          roles: response.roles
        },
        token: sessionToken
      }
    }
  } catch (error) {
    console.error('WordPress API error:', error)
    return { success: false, message: 'Authentication service error' }
  }
  
  console.log('Unexpected end of function')
  return { success: false, message: 'Authentication failed' }
})
