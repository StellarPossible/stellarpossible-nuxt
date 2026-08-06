import {
  authorBookConfigs,
  toDisplayTitle,
  type AuthorBookConfig,
  type AuthorBookDisplay,
  type BookStatus
} from '~/data/author-books'
import {
  fetchAmazonProductMetadata,
  inferStatusFromAvailability,
  type AmazonProductMetadata
} from '~/server/utils/amazon-page'
import {
  fetchAmazonProductsByAsin,
  isPaapiConfigured,
  mergeAmazonMetadata
} from '~/server/utils/amazon-paapi'

export type EnrichedAuthorBook = AuthorBookDisplay

function mergeBook(config: AuthorBookConfig, amazon?: AmazonProductMetadata): EnrichedAuthorBook {
  const inferredStatus = inferStatusFromAvailability(amazon?.availabilityType)
  const status: BookStatus = config.status || inferredStatus || 'published'
  const title = amazon?.title || config.title || toDisplayTitle(config)
  const coverSrc = amazon?.coverUrl || config.coverSrc

  return {
    id: config.id,
    amazonUrl: config.amazonUrl,
    title,
    series: config.series,
    seriesOrder: config.seriesOrder,
    coverSrc,
    coverAlt: config.coverAlt || `${title} by Marine Stompsword`,
    status,
    releaseDate: config.releaseDate,
    arcOpen: config.arcOpen
  }
}

async function fetchMetadataForBook(
  config: AuthorBookConfig,
  paapiCredentials: Parameters<typeof isPaapiConfigured>[0]
): Promise<AmazonProductMetadata | undefined> {
  const pageMetadata = await fetchAmazonProductMetadata(config.amazonUrl, config.asin)

  if (!isPaapiConfigured(paapiCredentials)) {
    return pageMetadata
  }

  const asin = pageMetadata?.asin || config.asin?.toUpperCase()
  if (!asin) return pageMetadata

  const paapiResults = await fetchAmazonProductsByAsin([asin], paapiCredentials)
  const paapiMetadata = paapiResults.get(asin)

  return mergeAmazonMetadata(pageMetadata, paapiMetadata)
}

export async function enrichAuthorBooks(): Promise<EnrichedAuthorBook[]> {
  const runtimeConfig = useRuntimeConfig()
  const paapiCredentials = {
    accessKey: runtimeConfig.amazonAccessKey,
    secretKey: runtimeConfig.amazonSecretKey,
    partnerTag: runtimeConfig.amazonPartnerTag,
    marketplace: runtimeConfig.amazonMarketplace
  }

  const metadataByConfigId = new Map<string, AmazonProductMetadata>()
  await Promise.all(
    authorBookConfigs.map(async (book) => {
      const metadata = await fetchMetadataForBook(book, paapiCredentials)
      if (metadata) metadataByConfigId.set(book.id, metadata)
    })
  )

  return authorBookConfigs.map((book) => mergeBook(book, metadataByConfigId.get(book.id)))
}

export function getArcOpenBooksFromEnriched(books: EnrichedAuthorBook[]): EnrichedAuthorBook[] {
  return books.filter((book) => book.arcOpen)
}

export function getEnrichedBookById(
  books: EnrichedAuthorBook[],
  id: string
): EnrichedAuthorBook | undefined {
  return books.find((book) => book.id === id)
}

export async function getEnrichedBookByIdFresh(id: string): Promise<EnrichedAuthorBook | undefined> {
  const books = await enrichAuthorBooks()
  return getEnrichedBookById(books, id)
}
