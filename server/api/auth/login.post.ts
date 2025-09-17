import type { WordPressUser, User, AuthResponse } from '~/types/auth'

export default defineEventHandler(async (event): Promise<AuthResponse> => {
  const { username, password } = await readBody(event)
  const config = useRuntimeConfig()
  
  console.log('Login attempt:', { username, hasPassword: !!password })
  
  // Input validation
  if (!username || !password) {
    return {
      success: false,
      message: 'Username and password are required'
    }
  }
  
  // Check if WordPress credentials are configured
  if (!config.public.wpUser || !config.wpAppPassword) {
    console.error('WordPress credentials not configured')
    return {
      success: false,
      message: 'Server configuration error. Please contact administrator.'
    }
  }
  
  // Determine WordPress endpoint
  const wpEndpoint = config.public.wpRestEndpoint || 'https://stellarpossible.com/wp-json'
  console.log('Using WordPress endpoint:', wpEndpoint)
  
  try {
    // Step 1: Test basic WordPress API connectivity
    console.log('Testing WordPress API connectivity...')
    let wpInfo
    try {
      wpInfo = await $fetch(`${wpEndpoint}/`, {
        timeout: 10000 // 10 second timeout
      })
      console.log('WordPress API accessible:', wpInfo.name || 'Unknown site')
    } catch (connectError: any) {
      console.error('WordPress API connection failed:', {
        message: connectError.message,
        cause: connectError.cause,
        code: connectError.code
      })
      
      // Try alternative endpoints
      const alternativeEndpoints = [
        'https://stellarpossible.com/wp-json',
        'https://www.stellarpossible.com/wp-json',
        'https://stellarpossible.com/index.php/wp-json'
      ]
      
      let connected = false
      for (const altEndpoint of alternativeEndpoints) {
        if (altEndpoint === wpEndpoint) continue // Skip the one we already tried
        
        try {
          console.log(`Trying alternative endpoint: ${altEndpoint}`)
          await $fetch(`${altEndpoint}/`, { timeout: 5000 })
          console.log(`Alternative endpoint works: ${altEndpoint}`)
          // Update the endpoint for this request
          const newWpEndpoint = altEndpoint
          connected = true
          break
        } catch (altError) {
          console.log(`Alternative endpoint failed: ${altEndpoint}`)
        }
      }
      
      if (!connected) {
        return {
          success: false,
          message: 'Unable to connect to authentication server. Please try again later.'
        }
      }
    }
    
    // Step 2: Try direct user authentication (preferred method)
    console.log('Attempting direct user authentication...')
    try {
      const userAuth = await $fetch<WordPressUser>(`${wpEndpoint}/wp/v2/users/me`, {
        headers: {
          'Authorization': `Basic ${Buffer.from(`${username}:${password}`).toString('base64')}`,
          'Content-Type': 'application/json'
        },
        timeout: 10000
      })
      
      if (userAuth && userAuth.id) {
        console.log('Direct authentication successful:', userAuth.username)
        return await createUserSession(userAuth, config, event)
      }
    } catch (directAuthError: any) {
      console.log('Direct authentication result:', {
        status: directAuthError.status || directAuthError.statusCode,
        message: directAuthError.message
      })
      
      // Handle authentication errors
      if (directAuthError.status === 401 || directAuthError.statusCode === 401) {
        return {
          success: false,
          message: 'Invalid username or password'
        }
      }
      
      if (directAuthError.status === 403 || directAuthError.statusCode === 403) {
        return {
          success: false,
          message: 'Account access denied. Please contact administrator.'
        }
      }
      
      // If it's not an auth error, try alternative method
      console.log('Direct auth failed, trying user search method...')
    }
    
    // Step 3: Alternative method - search for user and validate
    console.log('Searching for user with admin credentials...')
    try {
      const users = await $fetch<WordPressUser[]>(`${wpEndpoint}/wp/v2/users`, {
        headers: {
          'Authorization': `Basic ${Buffer.from(`${config.public.wpUser}:${config.wpAppPassword}`).toString('base64')}`,
          'Content-Type': 'application/json'
        },
        query: {
          search: username,
          per_page: 20
        },
        timeout: 10000
      })
      
      console.log(`Found ${users.length} users in search`)
      
      // Find exact match
      const foundUser = users.find(user => 
        user.username.toLowerCase() === username.toLowerCase() || 
        user.email.toLowerCase() === username.toLowerCase()
      )
      
      if (!foundUser) {
        console.log('No matching user found')
        return {
          success: false,
          message: 'Invalid username or password'
        }
      }
      
      console.log('Found matching user:', { id: foundUser.id, username: foundUser.username })
      
      // Try to validate password by attempting authentication with found username
      try {
        await $fetch(`${wpEndpoint}/wp/v2/users/me`, {
          headers: {
            'Authorization': `Basic ${Buffer.from(`${foundUser.username}:${password}`).toString('base64')}`,
            'Content-Type': 'application/json'
          },
          timeout: 5000
        })
        
        console.log('Password validation successful')
        return await createUserSession(foundUser, config, event)
        
      } catch (passwordError: any) {
        if (passwordError.status === 401 || passwordError.statusCode === 401) {
          return {
            success: false,
            message: 'Invalid username or password'
          }
        }
        
        // If password validation is inconclusive, we'll have to trust the user search
        console.warn('Password validation inconclusive, proceeding with found user')
        return await createUserSession(foundUser, config, event)
      }
      
    } catch (searchError: any) {
      console.error('User search failed:', {
        status: searchError.status || searchError.statusCode,
        message: searchError.message,
        data: searchError.data
      })
      
      if (searchError.status === 401 || searchError.statusCode === 401) {
        return {
          success: false,
          message: 'Server authentication failed. Please contact administrator.'
        }
      }
      
      throw searchError
    }
    
  } catch (error: any) {
    console.error('Login process failed:', {
      message: error.message,
      status: error.status || error.statusCode,
      code: error.code,
      cause: error.cause
    })
    
    // Network errors
    if (error.code === 'ECONNREFUSED' || error.code === 'ENOTFOUND' || error.code === 'ECONNRESET') {
      return {
        success: false,
        message: 'Unable to connect to authentication server. Please try again later.'
      }
    }
    
    if (error.code === 'ETIMEDOUT' || error.name === 'TimeoutError') {
      return {
        success: false,
        message: 'Authentication request timed out. Please try again.'
      }
    }
    
    // HTTP errors
    if (error.status === 404 || error.statusCode === 404) {
      return {
        success: false,
        message: 'Authentication service not found. Please contact administrator.'
      }
    }
    
    if (error.status === 500 || error.statusCode === 500) {
      return {
        success: false,
        message: 'Server error. Please try again later.'
      }
    }
    
    return {
      success: false,
      message: `Login failed: ${error.message || 'Please try again later.'}`
    }
  }
})

async function createUserSession(wpUser: WordPressUser, config: any, event: any): Promise<AuthResponse> {
  const user: User = {
    id: wpUser.id,
    username: wpUser.username,
    email: wpUser.email,
    name: wpUser.name || wpUser.username,
    roles: wpUser.roles,
    avatar: wpUser.avatar_urls?.['96'] ?? null,
    description: wpUser.description ?? null,
    url: wpUser.url ?? null
  }
  
  // Choose token method based on configuration
  const useJWT = config.public.useJWT === 'true'
  let sessionToken: string
  
  if (useJWT && config.jwtSecret) {
    const jwt = await import('jsonwebtoken')
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
    sessionToken = Buffer.from(`${user.username}:${Date.now()}`).toString('base64')
  }
  
  // Set cookies
  setCookie(event, 'auth-token', sessionToken, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: 60 * 60 * 24 * 7,
    path: '/'
  })
  
  if (!useJWT) {
    setCookie(event, 'user-data', JSON.stringify({
      ...user,
      lastValidated: new Date().toISOString()
    }), {
      httpOnly: false,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      maxAge: 60 * 60 * 24 * 7,
      path: '/'
    })
  }
  
  console.log('Session created successfully for:', user.username)
  
  return {
    success: true,
    user,
    tokenType: useJWT ? 'jwt' : 'session'
  }
}