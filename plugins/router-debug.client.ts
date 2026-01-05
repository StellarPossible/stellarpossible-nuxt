import { useRouter } from 'vue-router'

export default () => {
  if (process.client) {
    const router = useRouter()
    router.afterEach((to, from) => {
      // Helpful for debugging client-side navigation
      // eslint-disable-next-line no-console
      console.log('[router-debug] navigated to', to.fullPath, 'from', from.fullPath)
    })

    window.addEventListener('click', (e) => {
      const t = e.target as HTMLElement | null
      const link = t?.closest && t.closest('a')
      if (link && link instanceof HTMLAnchorElement) {
        // eslint-disable-next-line no-console
        console.log('[router-debug] anchor click', link.href)
      }
    }, true)
  }
}
