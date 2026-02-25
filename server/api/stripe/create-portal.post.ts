import Stripe from 'stripe'

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const body = await readBody(event).catch(() => ({}))
  const email = (body?.email as string)?.trim()

  if (!email) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Email is required.'
    })
  }

  const secretKey = config.stripeSecretKey
  if (!secretKey) {
    throw createError({
      statusCode: 500,
      statusMessage: 'Stripe is not configured.'
    })
  }

  const siteUrl = (config.public.siteUrl as string)?.replace(/\/$/, '') || ''
  const returnUrl = `${siteUrl}/dashboard/services`

  const stripe = new Stripe(secretKey)

  const customers = await stripe.customers.list({ email, limit: 1 })
  const customer = customers.data[0]

  if (!customer) {
    throw createError({
      statusCode: 404,
      statusMessage: 'No billing account found for this email. Subscribe first to manage billing.'
    })
  }

  const session = await stripe.billingPortal.sessions.create({
    customer: customer.id,
    return_url: returnUrl
  })

  if (!session.url) {
    throw createError({
      statusCode: 500,
      statusMessage: 'Stripe did not return a portal URL.'
    })
  }

  return { url: session.url }
})
