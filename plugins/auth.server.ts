import type { User } from '~/types/auth'
import { getUserFromEvent } from '~/server/utils/auth'

export default defineNuxtPlugin(async () => {
  const user = useState<User | null>('auth.user', () => null)

  if (user.value) {
    return
  }

  const event = useRequestEvent()
  if (!event) {
    return
  }

  const result = await getUserFromEvent(event)
  if (result.success && result.user) {
    user.value = result.user
  }
})
