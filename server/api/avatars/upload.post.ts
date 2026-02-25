import { writeFile, unlink } from 'node:fs/promises'
import { join } from 'node:path'
import { readMultipartFormData } from 'h3'
import type { User } from '~/types/auth'
import {
  getStoragePath,
  getAvatarMap,
  setAvatarMap,
  validateAvatarFile,
  ensureStorageDir
} from '~/server/utils/avatar'

export default defineEventHandler(async (event) => {
  const userCookie = getCookie(event, 'user-data')
  if (!userCookie) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }

  let user: User
  try {
    user = JSON.parse(userCookie)
  } catch {
    throw createError({ statusCode: 401, statusMessage: 'Invalid session' })
  }

  const form = await readMultipartFormData(event)
  if (!form || !Array.isArray(form)) {
    throw createError({
      statusCode: 400,
      statusMessage: 'No file provided. Use multipart form with "avatar" field.'
    })
  }

  const file = form.find((f) => f.name === 'avatar' && f.data)
  if (!file || !file.data) {
    throw createError({
      statusCode: 400,
      statusMessage: 'No avatar file in upload.'
    })
  }

  const validation = validateAvatarFile(file)
  if (!validation.ok) {
    throw createError({ statusCode: 400, statusMessage: validation.error })
  }

  await ensureStorageDir()

  const ext = file.filename?.toLowerCase().endsWith('.png') ? '.png' : '.jpg'
  const filename = `${user.id}${ext}`
  const storagePath = getStoragePath()
  const filePath = join(storagePath, filename)

  const map = await getAvatarMap()
  const oldFilename = map[String(user.id)]
  if (oldFilename) {
    try {
      await unlink(join(storagePath, oldFilename))
    } catch {
      // ignore if file missing
    }
  }

  await writeFile(filePath, file.data)
  map[String(user.id)] = filename
  await setAvatarMap(map)

  const config = useRuntimeConfig()
  const siteUrl = (config.public.siteUrl as string)?.replace(/\/$/, '') || ''
  const avatarUrl = `${siteUrl}/api/avatars/${user.id}`

  return { avatarUrl }
})
