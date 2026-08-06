export interface PageHero {
  badge?: string
  title: string
  subtitle?: string
}

const heroByPath: Record<string, PageHero> = {
  '/services': {
    badge: 'Services',
    title: 'Scoped with clarity. Delivered with care.',
    subtitle: 'Managed hosting, website builds, custom tools, and Nuxt.js platforms — with a free 60-minute consult for new clients.'
  },
  '/products': {
    badge: 'Products',
    title: 'Crafted with Purpose',
    subtitle: 'We build performant, secure, and beautifully designed digital experiences that drive results.'
  },
  '/news': {
    title: 'Latest from Stellar Possible',
    subtitle: 'News, updates, and highlights from StellarPossible.'
  }
}

export function usePageHero() {
  const route = useRoute()
  const path = route.path
  const hero = computed<PageHero | null>(() => heroByPath[path] ?? null)
  return { hero }
}
