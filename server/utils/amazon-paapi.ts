import { createRequire } from 'node:module'
import type { AmazonProductMetadata } from '~/server/utils/amazon-page'
import { inferStatusFromAvailability } from '~/server/utils/amazon-page'

export type { AmazonProductMetadata }
export { inferStatusFromAvailability }

const require = createRequire(import.meta.url)

type PaapiCredentials = {
  accessKey: string
  secretKey: string
  partnerTag: string
  marketplace: string
}

const MARKETPLACE_HOSTS: Record<string, { host: string; region: string }> = {
  'www.amazon.com': { host: 'webservices.amazon.com', region: 'us-east-1' },
  'www.amazon.co.uk': { host: 'webservices.amazon.co.uk', region: 'eu-west-1' },
  'www.amazon.ca': { host: 'webservices.amazon.ca', region: 'us-east-1' }
}

const GET_ITEMS_RESOURCES = [
  'Images.Primary.Large',
  'ItemInfo.Title',
  'Offers.Listings.Availability.Type'
]

function getMarketplaceConfig(marketplace: string) {
  return MARKETPLACE_HOSTS[marketplace] || MARKETPLACE_HOSTS['www.amazon.com']
}

function promisifyGetItems(api: any, request: any): Promise<any> {
  return new Promise((resolve, reject) => {
    api.getItems(request, (error: Error | null, data: unknown) => {
      if (error) reject(error)
      else resolve(data)
    })
  })
}

export function isPaapiConfigured(credentials: Partial<PaapiCredentials>): credentials is PaapiCredentials {
  return Boolean(credentials.accessKey && credentials.secretKey && credentials.partnerTag)
}

/** Optional upgrade path when Associates PA-API credentials are available. */
export async function fetchAmazonProductsByAsin(
  asins: string[],
  credentials: Partial<PaapiCredentials>
): Promise<Map<string, AmazonProductMetadata>> {
  const results = new Map<string, AmazonProductMetadata>()

  if (!isPaapiConfigured(credentials) || asins.length === 0) {
    return results
  }

  const uniqueAsins = [...new Set(asins.map((a) => a.toUpperCase()))]
  const { host, region } = getMarketplaceConfig(credentials.marketplace || 'www.amazon.com')

  try {
    const ProductAdvertisingAPIv1 = require('paapi5-nodejs-sdk')
    const defaultClient = ProductAdvertisingAPIv1.ApiClient.instance
    defaultClient.accessKey = credentials.accessKey
    defaultClient.secretKey = credentials.secretKey
    defaultClient.host = host
    defaultClient.region = region

    const api = new ProductAdvertisingAPIv1.DefaultApi()
    const request = new ProductAdvertisingAPIv1.GetItemsRequest()
    request.PartnerTag = credentials.partnerTag
    request.PartnerType = 'Associates'
    request.Marketplace = credentials.marketplace || 'www.amazon.com'
    request.ItemIds = uniqueAsins
    request.ItemIdType = 'ASIN'
    request.Resources = GET_ITEMS_RESOURCES

    const data = await promisifyGetItems(api, request)
    const items = data?.ItemsResult?.Items || []

    for (const item of items) {
      const asin = item?.ASIN?.toUpperCase()
      if (!asin) continue

      results.set(asin, {
        asin,
        title: item?.ItemInfo?.Title?.DisplayValue,
        coverUrl: item?.Images?.Primary?.Large?.URL,
        availabilityType: item?.Offers?.Listings?.[0]?.Availability?.Type
      })
    }
  } catch (error) {
    console.warn('[amazon-paapi] GetItems failed:', error)
  }

  return results
}

function mergeMetadata(
  primary?: AmazonProductMetadata,
  secondary?: AmazonProductMetadata
): AmazonProductMetadata | undefined {
  if (!primary && !secondary) return undefined

  return {
    asin: primary?.asin || secondary?.asin,
    title: primary?.title || secondary?.title,
    coverUrl: primary?.coverUrl || secondary?.coverUrl,
    availabilityType: primary?.availabilityType || secondary?.availabilityType
  }
}

export { mergeMetadata as mergeAmazonMetadata }
