/**
 * Primary conversion action: dashboard when signed in, register tab when logged out.
 */
export function usePrimaryCta() {
  const path = useGetStartedPath()

  /** Button / link label for the primary CTA path */
  const label = computed(() => (path.value === '/dashboard' ? 'Dashboard' : 'Create Account'))

  return { path, label }
}
