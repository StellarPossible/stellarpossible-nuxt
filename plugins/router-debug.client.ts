import { useRouter } from 'vue-router'

export default defineNuxtPlugin(() => {
  if (!import.meta.dev || !import.meta.client) {
    return
  }

  const router = useRouter()
  router.afterEach((to, from) => {
    // eslint-disable-next-line no-console
    console.log('[router-debug] navigated to', to.fullPath, 'from', from.fullPath)
  })

  window.addEventListener(
    'click',
    (e) => {
      const t = e.target as HTMLElement | null
      const link = t?.closest?.('a')
      if (link instanceof HTMLAnchorElement) {
        // eslint-disable-next-line no-console
        console.log('[router-debug] anchor click', link.href)
      }
    },
    true
  )
})
