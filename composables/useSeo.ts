export type SeoOptions = {
  title: string
  description: string
  path?: string
  image?: string
  jsonLd?: Record<string, unknown> | Record<string, unknown>[]
}

export function useSeo(options: SeoOptions) {
  const config = useRuntimeConfig()
  const siteUrl = (config.public.siteUrl as string) || 'https://stellarpossible.com'
  const route = useRoute()
  const path = options.path ?? route.path
  const canonical = `${siteUrl.replace(/\/$/, '')}${path.startsWith('/') ? path : `/${path}`}`
  const image = options.image || `${siteUrl}/images/primary/spicon.png`

  const scripts = options.jsonLd
    ? (Array.isArray(options.jsonLd) ? options.jsonLd : [options.jsonLd]).map((item) => ({
        type: 'application/ld+json',
        innerHTML: JSON.stringify(item)
      }))
    : []

  useHead({
    title: options.title,
    link: [{ rel: 'canonical', href: canonical }],
    meta: [
      { name: 'description', content: options.description },
      { property: 'og:title', content: options.title },
      { property: 'og:description', content: options.description },
      { property: 'og:url', content: canonical },
      { property: 'og:type', content: 'website' },
      { property: 'og:image', content: image },
      { name: 'twitter:card', content: 'summary_large_image' },
      { name: 'twitter:title', content: options.title },
      { name: 'twitter:description', content: options.description }
    ],
    script: scripts
  })
}

export function organizationJsonLd(siteUrl: string) {
  return {
    '@context': 'https://schema.org',
    '@type': 'Organization',
    name: 'StellarPossible',
    url: siteUrl,
    description: 'Human-focused technology solutions for creatives, educators, and visionaries.',
    sameAs: ['https://www.instagram.com/stellarpossible/']
  }
}

export function websiteJsonLd(siteUrl: string) {
  return {
    '@context': 'https://schema.org',
    '@type': 'WebSite',
    name: 'StellarPossible',
    url: siteUrl
  }
}
