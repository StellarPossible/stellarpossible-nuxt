import { readFile } from 'node:fs/promises'
import { existsSync } from 'node:fs'
import { join } from 'node:path'
import { getStoragePath, getAvatarMap } from '~/server/utils/avatar'

export default defineEventHandler(async (event) => {
  const userId = getRouterParam(event, 'userId')
  if (!userId) {
    throw createError({ statusCode: 404, statusMessage: 'Not found' })
  }

  const map = await getAvatarMap()
  const filename = map[userId]
  if (!filename) {
    throw createError({ statusCode: 404, statusMessage: 'Avatar not found' })
  }

  const filePath = join(getStoragePath(), filename)
  if (!existsSync(filePath)) {
    throw createError({ statusCode: 404, statusMessage: 'Avatar file missing' })
  }

  const buffer = await readFile(filePath)
  const ext = filename.endsWith('.png') ? 'png' : 'jpeg'
  setResponseHeaders(event, {
    'Content-Type': `image/${ext}`,
    'Cache-Control': 'public, max-age=86400'
  })
  return buffer
})
