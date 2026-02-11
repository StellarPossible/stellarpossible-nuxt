export interface PageHero {
  badge?: string
  title: string
  subtitle?: string
}

const heroByPath: Record<string, PageHero> = {
  '/products': {
    badge: 'Our Work',
    title: 'Crafted with Purpose',
    subtitle: 'We build performant, secure, and beautifully designed digital experiences that drive results.'
  },
  '/news': {
    title: 'Latest from Stellar Possible',
    subtitle: 'News, updates, and highlights from StellarPossible.'
  }
}

/** Set by the services page per tab; header uses this when route is /services */
export const servicesHeaderHeroKey = 'servicesHeaderHero'

export function usePageHero() {
  const route = useRoute()
  const path = route.path
  const hero = computed<PageHero | null>(() => heroByPath[path] ?? null)
  return { hero, servicesHeaderHeroKey }
}
