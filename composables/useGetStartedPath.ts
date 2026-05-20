import type { User } from '~/types/auth'

/**
 * Path for "Get started" CTA: dashboard if logged in, otherwise login/register.
 * Use for any site-wide Get started button/link.
 */
export function useGetStartedPath() {
  const user = useState<User | null>('auth.user', () => null)
  return computed(() => (user.value ? '/dashboard' : '/login?tab=register'))
}
