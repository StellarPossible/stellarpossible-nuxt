import { getAuthorBookConfigById, toDisplayTitle } from '~/data/author-books'
import { getEnrichedBookByIdFresh } from '~/server/utils/author-books-enrich'
import { sendContactEmail } from '~/server/utils/email'

const DEFAULT_BOOK_ID = 'what-the-cold-keeps'

export default defineEventHandler(async (event) => {
  const body = await readBody<{
    name?: string
    email?: string
    agreedToReview?: boolean
    signupForUpdates?: boolean
    bookId?: string
  }>(event)

  const name = (body.name || '').trim()
  const email = (body.email || '').trim()
  const agreedToReview = body.agreedToReview === true
  const signupForUpdates = body.signupForUpdates === true
  const bookId = (body.bookId || DEFAULT_BOOK_ID).trim()

  const config = getAuthorBookConfigById(bookId)
  if (!config) {
    throw createError({ statusCode: 400, statusMessage: 'Invalid book selection.' })
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!name || !emailRegex.test(email)) {
    throw createError({ statusCode: 400, statusMessage: 'Please provide a valid name and email.' })
  }

  if (!agreedToReview) {
    throw createError({
      statusCode: 400,
      statusMessage: 'You must agree to leave an honest review on Amazon to receive the pre-release.'
    })
  }

  const enriched = await getEnrichedBookByIdFresh(bookId)
  const title = enriched?.title || config.title || toDisplayTitle(config)
  const series = enriched?.series ?? config.series
  const seriesOrder = enriched?.seriesOrder ?? config.seriesOrder

  const seriesLabel = series
    ? seriesOrder != null
      ? `${series}, Book ${seriesOrder}`
      : series
    : undefined

  const bookLabel = seriesLabel ? `${title} (${seriesLabel})` : title

  const message = [
    `ARC Reader Signup (mstompsword) — ${bookLabel}`,
    '',
    `Name: ${name}`,
    `Email: ${email}`,
    `Agreed to receive the free eBook pre-release of ${title} in exchange for an honest review on Amazon.`,
    `Sign up for latest from Marine Stompsword + more free ARC opportunities: ${signupForUpdates ? 'Yes' : 'No'}`
  ].join('\n')

  await sendContactEmail({
    name,
    email,
    subject: `ARC Reader Signup — ${title} (mstompsword)`,
    message
  })

  return { success: true }
})
