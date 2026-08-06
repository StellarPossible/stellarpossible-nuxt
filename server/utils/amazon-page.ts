import { extractAsinFromUrl } from '~/server/utils/amazon-asin'

export type AmazonProductMetadata = {
  asin?: string
  title?: string
  coverUrl?: string
  availabilityType?: string
}

const FETCH_HEADERS = {
  'User-Agent':
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  Accept: 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
  'Accept-Language': 'en-US,en;q=0.9'
}

function decodeHtmlEntities(value: string): string {
  return value
    .replace(/&amp;/g, '&')
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
}

function parseMetaContent(html: string, key: string, attr: 'property' | 'name' = 'property'): string | undefined {
  const patterns = [
    new RegExp(`<meta[^>]+${attr}=["']${key}["'][^>]+content=["']([^"']+)["']`, 'i'),
    new RegExp(`<meta[^>]+content=["']([^"']+)["'][^>]+${attr}=["']${key}["']`, 'i')
  ]

  for (const pattern of patterns) {
    const match = html.match(pattern)
    if (match?.[1]) return decodeHtmlEntities(match[1].trim())
  }

  return undefined
}

export function cleanAmazonTitle(raw: string): string {
  let title = raw.trim()
  title = title.replace(/:\s*Amazon\.com.*$/i, '').trim()

  const parts = title.split(':').map((part) => part.trim()).filter(Boolean)
  if (parts.length > 1) return parts[0]

  return title
}

export function inferStatusFromAvailability(
  availabilityType?: string
): 'published' | 'preorder' | undefined {
  if (!availabilityType) return undefined
  const normalized = availabilityType.toLowerCase()
  if (normalized.includes('preorder') || normalized.includes('pre-order')) return 'preorder'
  if (normalized.includes('now') || normalized.includes('stock') || normalized.includes('available')) {
    return 'published'
  }
  return undefined
}

function inferAvailabilityFromHtml(html: string): string | undefined {
  if (/\bpre-?order\b/i.test(html)) return 'PreOrder'
  if (/\bin stock\b/i.test(html) || /\bbuy now\b/i.test(html)) return 'Now'
  return undefined
}

function parseCoverFromHtml(html: string): string | undefined {
  const ogImage = parseMetaContent(html, 'og:image')
  if (ogImage) return ogImage

  const landingImage = html.match(/id="landingImage"[^>]+data-a-dynamic-image="\{&quot;([^&]+)&quot;/i)
  if (landingImage?.[1]) return landingImage[1].replace(/&amp;/g, '&')

  const imgMatch = html.match(/class="[^"]*a-dynamic-image[^"]*"[^>]+src="([^"]+)"/i)
  if (imgMatch?.[1]) return decodeHtmlEntities(imgMatch[1])

  return undefined
}

function parseTitleFromHtml(html: string): string | undefined {
  const ogTitle = parseMetaContent(html, 'og:title')
  if (ogTitle) return cleanAmazonTitle(ogTitle)

  const productTitle = html.match(/id="productTitle"[^>]*>\s*([^<]+)\s*</i)
  if (productTitle?.[1]) return cleanAmazonTitle(productTitle[1])

  const metaTitle = parseMetaContent(html, 'title', 'name')
  if (metaTitle) return cleanAmazonTitle(metaTitle)

  return undefined
}

function parseAsinFromHtml(html: string, finalUrl: string): string | undefined {
  const fromUrl = extractAsinFromUrl(finalUrl)
  if (fromUrl) return fromUrl

  const metaAsin = parseMetaContent(html, 'ASIN', 'name')
  if (metaAsin) return metaAsin.toUpperCase()

  const jsonAsin = html.match(/"asin"\s*:\s*"([A-Z0-9]{10})"/i)
  if (jsonAsin?.[1]) return jsonAsin[1].toUpperCase()

  return undefined
}

export function parseAmazonPageMetadata(html: string, finalUrl: string): AmazonProductMetadata {
  const availabilityType = inferAvailabilityFromHtml(html)

  return {
    asin: parseAsinFromHtml(html, finalUrl),
    title: parseTitleFromHtml(html),
    coverUrl: parseCoverFromHtml(html),
    availabilityType
  }
}

export async function fetchAmazonProductMetadata(
  amazonUrl: string,
  asinOverride?: string
): Promise<AmazonProductMetadata | undefined> {
  if (asinOverride) {
    const asin = asinOverride.toUpperCase()
    const productUrl = `https://www.amazon.com/dp/${asin}`
    const page = await fetchAmazonProductPage(productUrl)
    if (!page) return { asin }
    return { asin, ...parseAmazonPageMetadata(page.html, page.finalUrl) }
  }

  const page = await fetchAmazonProductPage(amazonUrl)
  if (!page) return undefined

  return parseAmazonPageMetadata(page.html, page.finalUrl)
}

export async function fetchAmazonProductPage(
  amazonUrl: string
): Promise<{ html: string; finalUrl: string } | null> {
  try {
    const response = await fetch(amazonUrl, {
      method: 'GET',
      redirect: 'follow',
      headers: FETCH_HEADERS
    })

    if (!response.ok) {
      console.warn('[amazon-page] Non-OK response:', amazonUrl, response.status)
      return null
    }

    const html = await response.text()
    const finalUrl = response.url || amazonUrl

    if (/Robot Check|captcha/i.test(html)) {
      console.warn('[amazon-page] Blocked by Amazon bot check:', amazonUrl)
      return null
    }

    return { html, finalUrl }
  } catch (error) {
    console.warn('[amazon-page] Failed to fetch product page:', amazonUrl, error)
    return null
  }
}
