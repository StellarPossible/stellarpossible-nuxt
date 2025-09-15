import type { WordPressUser, AuthResponse } from '~/types/auth'

export default defineEventHandler(async (event): Promise<AuthResponse> => {
  const { username, email, password } = await readBody(event)
  const config = useRuntimeConfig()
  
  // Input validation
  if (!username || !email || !password) {
    return {
      success: false,
      message: 'Username, email, and password are required'
    }
  }
  
  if (password.length < 8) {
    return {
      success: false,
      message: 'Password must be at least 8 characters long'
    }
  }
  
  // Email validation
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!emailRegex.test(email)) {
    return {
      success: false,
      message: 'Please enter a valid email address'
    }
  }
  
  try {
    const wpEndpoint = config.public.wpRestEndpoint || 'https://stellarpossible.com/wp-json'
    
    const response = await $fetch<WordPressUser>(`${wpEndpoint}/wp/v2/users`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Basic ${Buffer.from(`${config.public.wpUser}:${config.wpAppPassword}`).toString('base64')}`
      },
      body: {
        username,
        email,
        password,
        roles: ['subscriber'] // Default role for new users
      }
    })
    
    return {
      success: true,
      message: 'Registration successful! You can now log in.',
      user: {
        id: response.id,
        username: response.username,
        email: response.email,
        name: response.name || response.username,
        roles: response.roles,
        avatar: response.avatar_urls?.['96'] || null,
        description: response.description || null,
        url: response.url || null
      }
    }
  } catch (error: any) {
    console.error('Registration error:', error)
    
    // Handle specific WordPress errors
    if (error.data?.code === 'existing_user_login') {
      return {
        success: false,
        message: 'Username already exists. Please choose a different username.'
      }
    }
    
    if (error.data?.code === 'existing_user_email') {
      return {
        success: false,
        message: 'Email address already registered. Please use a different email.'
      }
    }
    
    if (error.status === 403) {
      return {
        success: false,
        message: 'Registration is currently disabled. Please contact administrator.'
      }
    }
    
    return {
      success: false,
      message: error.data?.message || 'Registration failed. Please try again.'
    }
  }
})
