import type { AuthResponse } from '~/types/auth'
import { getUserFromEvent } from '~/server/utils/auth'

export default defineEventHandler(async (event): Promise<AuthResponse> => {
  return getUserFromEvent(event)
})
