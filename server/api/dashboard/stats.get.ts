import type { User } from '~/types/auth'

export default defineEventHandler(async (event) => {
  const userCookie = getCookie(event, 'user-data')
  if (!userCookie) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }

  let user: User | null = null
  try {
    user = JSON.parse(userCookie)
  } catch {
    throw createError({ statusCode: 400, statusMessage: 'Invalid user session' })
  }

  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }

  let totalPosts = 0
  let totalComments = 0

  const config = useRuntimeConfig()
  const wpRest = (config.public.wpRestEndpoint as string)?.replace(/\/$/, '')
  if (wpRest) {
    try {
      const [postsRes, commentsRes] = await Promise.all([
        $fetch.raw(`${wpRest}/wp/v2/posts?per_page=1`).catch(() => null),
        $fetch.raw(`${wpRest}/wp/v2/comments?per_page=1`).catch(() => null)
      ])
      const pt = postsRes?.headers?.get?.('x-wp-total')
      const ct = commentsRes?.headers?.get?.('x-wp-total')
      if (pt) totalPosts = parseInt(pt, 10) || 0
      if (ct) totalComments = parseInt(ct, 10) || 0
    } catch {
      // WP may require auth; keep defaults
    }
  }

  return {
    totalPosts,
    totalComments,
    lastLogin: user.lastValidated ?? null
  }
})
