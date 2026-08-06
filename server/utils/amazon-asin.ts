const ASIN_PATTERN = /(?:\/dp\/|\/gp\/product\/|\/ASIN\/|\/product\/)([A-Z0-9]{10})(?:[/?]|$)/i

export function extractAsinFromUrl(url: string): string | undefined {
  const match = url.match(ASIN_PATTERN)
  return match?.[1]?.toUpperCase()
}

export async function resolveAmazonAsin(amazonUrl: string, asinOverride?: string): Promise<string | undefined> {
  if (asinOverride) return asinOverride.toUpperCase()

  const direct = extractAsinFromUrl(amazonUrl)
  if (direct) return direct

  try {
    const response = await fetch(amazonUrl, {
      method: 'GET',
      redirect: 'follow',
      headers: {
        'User-Agent': 'Mozilla/5.0 (compatible; StellarPossible/1.0; +https://stellarpossible.com)',
        Accept: 'text/html,application/xhtml+xml'
      }
    })

    const finalUrl = response.url || amazonUrl
    const fromFinal = extractAsinFromUrl(finalUrl)
    if (fromFinal) return fromFinal

    if (response.ok) {
      const html = await response.text()
      const metaMatch = html.match(/name="ASIN"\s+content="([A-Z0-9]{10})"/i)
      if (metaMatch?.[1]) return metaMatch[1].toUpperCase()

      const dataMatch = html.match(/"asin"\s*:\s*"([A-Z0-9]{10})"/i)
      if (dataMatch?.[1]) return dataMatch[1].toUpperCase()
    }
  } catch (error) {
    console.warn('[amazon-asin] Failed to resolve ASIN from URL:', amazonUrl, error)
  }

  return undefined
}
