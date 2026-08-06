export type BookStatus = 'published' | 'preorder' | 'upcoming'

export type AuthorBookConfig = {
  id: string
  amazonUrl: string
  asin?: string
  arcOpen?: boolean
  series?: string
  seriesOrder?: number
  /** Fallback when Amazon page fetch is unavailable */
  title?: string
  coverSrc?: string
  coverAlt?: string
  releaseDate?: string
  status?: BookStatus
}

export type AuthorBookDisplay = {
  id: string
  amazonUrl: string
  title: string
  series?: string
  seriesOrder?: number
  coverSrc?: string
  coverAlt?: string
  status: BookStatus
  releaseDate?: string
  arcOpen?: boolean
}

export const authorBookConfigs: AuthorBookConfig[] = [
  {
    id: 'what-the-cold-keeps',
    amazonUrl: 'https://a.co/d/0eZgZ2OC',
    series: 'Aurora Peak Mysteries',
    seriesOrder: 1,
    releaseDate: 'Feb 28',
    arcOpen: true,
    title: 'What the Cold Keeps',
    coverSrc: '/images/media/what-the-cold-keeps-cover.png',
    coverAlt:
      'What the Cold Keeps — An Aurora Peak Mystery by Marine Stompsword. A dignified Alaskan malamute silhouette standing on a rock outcrop above a black spruce treeline against a cobalt-blue field, with the hand-lettered white brush title stacked across the lower half.',
    status: 'preorder'
  },
  {
    id: 'the-starblood-tithe',
    amazonUrl: 'https://a.co/d/085j8GJl',
    title: 'The Starblood Tithe',
    status: 'published'
  },
  {
    id: 'a-vow-of-blood-and-ash',
    amazonUrl: 'https://a.co/d/0bOYCCIN',
    title: 'A Vow of Blood and Ash',
    status: 'published'
  },
  {
    id: 'nine-lives',
    amazonUrl: 'https://a.co/d/0aY2znSr',
    series: 'Wayfinder Chronicles',
    title: 'Nine Lives',
    coverSrc: '/images/media/nine-lives-cover.png',
    coverAlt: 'Nine Lives — Wayfinder Chronicles by Marine Stompsword',
    status: 'published'
  }
]

/** @deprecated Use authorBookConfigs on server; client should use /api/author-books */
export const authorBooks = authorBookConfigs

export function getAuthorBookConfigById(id: string): AuthorBookConfig | undefined {
  return authorBookConfigs.find((book) => book.id === id)
}

export function getAmazonCtaLabel(status: BookStatus): string {
  if (status === 'preorder') return 'Pre-order on Amazon'
  if (status === 'upcoming') return 'Coming soon'
  return 'Buy on Amazon'
}

export function formatSeriesLabel(book: Pick<AuthorBookDisplay, 'series' | 'seriesOrder'>): string | undefined {
  if (!book.series) return undefined
  if (book.seriesOrder != null) return `${book.series} · Book ${book.seriesOrder}`
  return book.series
}

export function toDisplayTitle(config: AuthorBookConfig): string {
  return config.title || config.id.replace(/-/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase())
}
