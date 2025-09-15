import type { WordPressUser, User, AuthResponse, JWTPayload } from '~/types/auth'

export default defineEventHandler(async (event): Promise<AuthResponse> => {
  const token = getCookie(event, 'auth-token')
  const config = useRuntimeConfig()
  
  if (!token) {
    return { success: false, message: 'Not authenticated' }
  }

  try {
    // Method 1: JWT Token Validation (recommended for production)
    if (token.includes('.')) {
      return await validateJWTSession(token, config)
    }
    
    // Method 2: Session Token with WordPress Validation
    return await validateWordPressSession(token, config, event)
    
  } catch (error) {
    console.error('Session validation error:', error)
    return { success: false, message: 'Session validation failed' }
  }
})

async function validateJWTSession(token: string, config: any): Promise<AuthResponse> {
  try {
    const jwtSecret = config.jwtSecret
    if (!jwtSecret) {
      throw new Error('JWT secret not configured')
    }
    
    // Dynamic import for JWT
    const jwt = await import('jsonwebtoken')
    const decoded = jwt.default.verify(token, jwtSecret) as JWTPayload
    
    return {
      success: true,
      user: {
        id: decoded.id,
        username: decoded.username,
        email: decoded.email,
        name: decoded.name,
        roles: decoded.roles,
        avatar: decoded.avatar ?? null,
        description: decoded.description ?? null
      }
    }
  } catch (error: any) {
    if (error.name === 'TokenExpiredError') {
      return { success: false, message: 'Token expired' }
    }
    if (error.name === 'JsonWebTokenError') {
      return { success: false, message: 'Invalid token' }
    }
    throw error
  }
}

async function validateWordPressSession(token: string, config: any, event: any): Promise<AuthResponse> {
  try {
    // Decode the session token to get username and timestamp
    const tokenData = Buffer.from(token, 'base64').toString('utf-8')
    const [username, timestamp] = tokenData.split(':')
    
    if (!username || !timestamp) {
      return { success: false, message: 'Invalid token format' }
    }
    
    // Check if session is too old (7 days)
    const sessionAge = Date.now() - parseInt(timestamp)
    const maxAge = 7 * 24 * 60 * 60 * 1000 // 7 days in milliseconds
    
    if (sessionAge > maxAge) {
      return { success: false, message: 'Session expired' }
    }
    
    // Get user data from stored cookie
    const userData = getCookie(event, 'user-data')
    if (!userData) {
      return { success: false, message: 'Session data missing' }
    }
    
    const user: User = JSON.parse(userData)
    
    // Verify the token matches the user
    if (username !== user.username) {
      return { success: false, message: 'Token mismatch' }
    }
    
    // Validate with WordPress API
    const wpEndpoint = config.public.wpRestEndpoint || 'https://stellarpossible.com/wp-json'
    
    try {
      const wpUser = await $fetch<WordPressUser>(`${wpEndpoint}/wp/v2/users/${user.id}`, {
        headers: {
          'Authorization': `Basic ${Buffer.from(`${config.public.wpUser}:${config.wpAppPassword}`).toString('base64')}`,
          'Content-Type': 'application/json'
        }
      })
      
      if (wpUser && wpUser.id === user.id) {
        return {
          success: true,
          user: {
            id: wpUser.id,
            username: wpUser.username,
            email: wpUser.email,
            name: wpUser.name,
            roles: wpUser.roles,
            avatar: wpUser.avatar_urls?.['96'] ?? null,
            description: wpUser.description ?? null,
            url: wpUser.url ?? null,
            lastValidated: new Date().toISOString()
          }
        }
      }
    } catch (wpError) {
      // If WordPress API call fails, fall back to cached user data
      console.warn('WordPress validation failed, using cached data:', wpError)
      
      return {
        success: true,
        user: {
          id: user.id,
          username: user.username,
          email: user.email,
          name: user.name,
          roles: user.roles,
          avatar: user.avatar ?? null,
          description: user.description ?? null,
          lastValidated: user.lastValidated ?? null
        }
      }
    }
    
    return { success: false, message: 'User validation failed' }
    
  } catch (error) {
    console.error('WordPress session validation error:', error)
    return { success: false, message: 'Session validation error' }
  }
}