import type { WordPressUser, User, AuthResponse } from '~/types/auth'

export default defineEventHandler(async (event): Promise<AuthResponse> => {
  const { username, password } = await readBody(event)
  const config = useRuntimeConfig()
  
  // Input validation
  if (!username || !password) {
    return {
      success: false,
      message: 'Username and password are required'
    }
  }
  
  try {
    // Authenticate with WordPress
    const wpEndpoint = config.public.wpRestEndpoint || 'https://stellarpossible.com/wp-json'
    
    const response = await $fetch<WordPressUser>(`${wpEndpoint}/wp/v2/users/me`, {
      headers: {
        'Authorization': `Basic ${Buffer.from(`${username}:${password}`).toString('base64')}`,
        'Content-Type': 'application/json'
      }
    })
    
    if (response && response.id) {
      const user: User = {
        id: response.id,
        username: response.username,
        email: response.email,
        name: response.name,
        roles: response.roles,
        avatar: response.avatar_urls?.['96'] ?? null,
        description: response.description ?? null,
        url: response.url ?? null
      }
      
      // Choose token method based on configuration
      const useJWT = config.public.useJWT === 'true'
      let sessionToken: string
      
      if (useJWT && config.jwtSecret) {
        // Dynamic import for JWT
        const jwt = await import('jsonwebtoken')
        
        // Create JWT token (recommended for production)
        sessionToken = jwt.default.sign(
          {
            id: user.id,
            username: user.username,
            email: user.email,
            name: user.name,
            roles: user.roles,
            avatar: user.avatar,
            description: user.description,
            iat: Math.floor(Date.now() / 1000)
          },
          config.jwtSecret,
          { 
            expiresIn: '7d',
            issuer: 'stellarpossible-nuxt',
            subject: user.id.toString()
          }
        )
      } else {
        // Create simple session token
        sessionToken = Buffer.from(`${user.username}:${Date.now()}`).toString('base64')
      }
      
      // Set secure HTTP-only cookie
      setCookie(event, 'auth-token', sessionToken, {
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'strict',
        maxAge: 60 * 60 * 24 * 7, // 7 days
        path: '/'
      })
      
      // Store user data (only if not using JWT)
      if (!useJWT) {
        setCookie(event, 'user-data', JSON.stringify({
          ...user,
          lastValidated: new Date().toISOString()
        }), {
          httpOnly: false, // Allow client access for user state
          secure: process.env.NODE_ENV === 'production',
          sameSite: 'strict',
          maxAge: 60 * 60 * 24 * 7,
          path: '/'
        })
      }
      
      return {
        success: true,
        user,
        tokenType: useJWT ? 'jwt' : 'session'
      }
    }
  } catch (error: any) {
    console.error('Login error:', error)
    
    // Handle specific WordPress errors
    if (error.status === 401) {
      return {
        success: false,
        message: 'Invalid username or password'
      }
    }
    
    if (error.status === 403) {
      return {
        success: false,
        message: 'Account access denied. Please contact administrator.'
      }
    }
    
    if (error.code === 'ECONNREFUSED' || error.code === 'ENOTFOUND') {
      return {
        success: false,
        message: 'Unable to connect to authentication server. Please try again later.'
      }
    }
    
    return {
      success: false,
      message: 'Login failed. Please try again.'
    }
  }
  
  return {
    success: false,
    message: 'Authentication failed'
  }
})