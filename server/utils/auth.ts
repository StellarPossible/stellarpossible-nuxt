import { deleteCookie, getCookie, setCookie, type H3Event } from 'h3'
import type { WordPressUser, User, AuthResponse, JWTPayload } from '~/types/auth'
import { getAvatarMap } from '~/server/utils/avatar'

export async function getUserFromEvent(event: H3Event): Promise<AuthResponse> {
  const token = getCookie(event, 'auth-token')
  const config = useRuntimeConfig()

  if (!token) {
    return { success: false, message: 'Not authenticated' }
  }

  try {
    if (token.includes('.') && config.jwtSecret) {
      return await validateJWTSession(token, config)
    }

    return await validateSessionToken(token, config, event)
  } catch (error: unknown) {
    console.error('Session validation error:', error)

    deleteCookie(event, 'auth-token', { path: '/' })
    deleteCookie(event, 'user-data', { path: '/' })

    return { success: false, message: 'Session validation failed' }
  }
}

async function validateJWTSession(token: string, config: ReturnType<typeof useRuntimeConfig>): Promise<AuthResponse> {
  try {
    const jwtSecret = config.jwtSecret
    if (!jwtSecret) {
      throw new Error('JWT secret not configured')
    }

    const jwt = await import('jsonwebtoken')
    const decoded = jwt.default.verify(token, jwtSecret) as JWTPayload
    const avatar = await resolveAvatarUrl(decoded.id, decoded.avatar ?? null)

    return {
      success: true,
      user: {
        id: decoded.id,
        username: decoded.username,
        email: decoded.email,
        name: decoded.name,
        roles: decoded.roles,
        avatar,
        description: decoded.description ?? null
      }
    }
  } catch (error: unknown) {
    const err = error as { name?: string }
    if (err.name === 'TokenExpiredError') {
      return { success: false, message: 'Session expired. Please log in again.' }
    }
    if (err.name === 'JsonWebTokenError') {
      return { success: false, message: 'Invalid session. Please log in again.' }
    }
    throw error
  }
}

async function validateSessionToken(
  token: string,
  config: ReturnType<typeof useRuntimeConfig>,
  event: H3Event
): Promise<AuthResponse> {
  try {
    const tokenData = Buffer.from(token, 'base64').toString('utf-8')
    const [username, timestamp] = tokenData.split(':')

    if (!username || !timestamp) {
      return { success: false, message: 'Invalid session format' }
    }

    const sessionAge = Date.now() - parseInt(timestamp)
    const maxAge = 7 * 24 * 60 * 60 * 1000

    if (sessionAge > maxAge) {
      return { success: false, message: 'Session expired. Please log in again.' }
    }

    const userData = getCookie(event, 'user-data')
    if (!userData) {
      return { success: false, message: 'Session data missing. Please log in again.' }
    }

    let user: User
    try {
      user = JSON.parse(userData)
    } catch (parseError) {
      console.error('Failed to parse user data:', parseError)
      return { success: false, message: 'Invalid session data. Please log in again.' }
    }

    if (username !== user.username) {
      return { success: false, message: 'Session mismatch. Please log in again.' }
    }

    const lastValidated = user.lastValidated ? new Date(user.lastValidated) : null
    const shouldRefresh = !lastValidated || (Date.now() - lastValidated.getTime()) > (24 * 60 * 60 * 1000)

    if (shouldRefresh) {
      try {
        const refreshedUser = await refreshUserFromWordPress(user.id, config)
        if (refreshedUser) {
          const avatar = await resolveAvatarUrl(refreshedUser.id, refreshedUser.avatar)
          const updatedUser = {
            ...refreshedUser,
            avatar,
            lastValidated: new Date().toISOString()
          }

          setCookie(event, 'user-data', JSON.stringify(updatedUser), {
            httpOnly: false,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            maxAge: 60 * 60 * 24 * 7,
            path: '/'
          })

          return {
            success: true,
            user: updatedUser
          }
        }
      } catch (refreshError) {
        console.warn('Failed to refresh user data, using cached data:', refreshError)
      }
    }

    const avatar = await resolveAvatarUrl(user.id, user.avatar)

    return {
      success: true,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        name: user.name,
        roles: user.roles,
        avatar,
        description: user.description ?? null,
        url: user.url ?? null,
        lastValidated: user.lastValidated ?? null
      }
    }
  } catch (error: unknown) {
    console.error('Session validation error:', error)
    return { success: false, message: 'Session validation failed. Please log in again.' }
  }
}

async function resolveAvatarUrl(userId: number, wpAvatar: string | null): Promise<string | null> {
  try {
    const map = await getAvatarMap()
    if (map[String(userId)]) {
      const config = useRuntimeConfig()
      const siteUrl = (config.public.siteUrl as string)?.replace(/\/$/, '') || ''
      return `${siteUrl}/api/avatars/${userId}`
    }
  } catch {
    // fall through to WP avatar
  }
  return wpAvatar ?? null
}

async function refreshUserFromWordPress(
  userId: number,
  config: ReturnType<typeof useRuntimeConfig>
): Promise<User | null> {
  try {
    if (!config.public.wpUser || !config.wpAppPassword) {
      throw new Error('WordPress credentials not configured')
    }

    const wpEndpoint = config.public.wpRestEndpoint || 'https://stellarpossible.com/wp-json'

    const wpUser = await $fetch<WordPressUser>(`${wpEndpoint}/wp/v2/users/${userId}`, {
      headers: {
        Authorization: `Basic ${Buffer.from(`${config.public.wpUser}:${config.wpAppPassword}`).toString('base64')}`,
        'Content-Type': 'application/json'
      }
    })

    if (wpUser && wpUser.id === userId) {
      const avatar = await resolveAvatarUrl(userId, wpUser.avatar_urls?.['96'] ?? null)
      return {
        id: wpUser.id,
        username: wpUser.username,
        email: wpUser.email,
        name: wpUser.name || wpUser.username,
        roles: wpUser.roles,
        avatar,
        description: wpUser.description ?? null,
        url: wpUser.url ?? null
      }
    }

    return null
  } catch (error) {
    console.error('Failed to refresh user from WordPress:', error)
    return null
  }
}
