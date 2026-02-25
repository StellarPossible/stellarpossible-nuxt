import { readFile, writeFile, mkdir } from 'node:fs/promises'
import { existsSync } from 'node:fs'
import { join } from 'node:path'

const MAX_SIZE = 1024 * 1024 // 1MB
const ALLOWED_TYPES = ['image/png', 'image/jpeg', 'image/jpg']
const ALLOWED_EXT = ['.png', '.jpg', '.jpeg']

export function getStoragePath(): string {
  return join(process.cwd(), 'storage', 'avatars')
}

export function getMapPath(): string {
  return join(process.cwd(), 'storage', 'avatar-map.json')
}

export async function getAvatarMap(): Promise<Record<string, string>> {
  const mapPath = getMapPath()
  try {
    const data = await readFile(mapPath, 'utf-8')
    const parsed = JSON.parse(data)
    return typeof parsed === 'object' && parsed !== null ? parsed : {}
  } catch {
    return {}
  }
}

export async function setAvatarMap(map: Record<string, string>): Promise<void> {
  const mapPath = getMapPath()
  await writeFile(mapPath, JSON.stringify(map, null, 2), 'utf-8')
}

export function validateAvatarFile(
  data: { data: Buffer; filename?: string; type?: string }
): { ok: true } | { ok: false; error: string } {
  if (data.data.length > MAX_SIZE) {
    return { ok: false, error: 'File must be under 1MB' }
  }
  const mime = data.type?.toLowerCase()
  if (!mime || !ALLOWED_TYPES.includes(mime)) {
    return { ok: false, error: 'Only PNG or JPG images are allowed' }
  }
  const name = data.filename?.toLowerCase() || ''
  const hasValidExt = ALLOWED_EXT.some((ext) => name.endsWith(ext))
  if (!hasValidExt) {
    return { ok: false, error: 'File must be .png or .jpg' }
  }
  return { ok: true }
}

export async function ensureStorageDir(): Promise<void> {
  const dir = getStoragePath()
  if (!existsSync(dir)) {
    await mkdir(dir, { recursive: true })
  }
}
