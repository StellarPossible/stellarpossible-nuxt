import Stripe from 'stripe'

const PLAN_IDS = ['monthly', 'annual', '3year'] as const
export type PlanId = (typeof PLAN_IDS)[number]

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const body = await readBody(event).catch(() => ({}))
  const plan = (body?.plan as string)?.toLowerCase()

  if (!plan || !PLAN_IDS.includes(plan as PlanId)) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Invalid plan. Use monthly, annual, or 3year.'
    })
  }

  const secretKey = config.stripeSecretKey
  const priceMonthly = config.stripePriceMonthly
  const priceAnnual = config.stripePriceAnnual
  const price3Year = config.stripePrice3Year

  if (!secretKey) {
    throw createError({
      statusCode: 500,
      statusMessage: 'Stripe is not configured (STRIPE_SECRET_KEY missing).'
    })
  }

  const priceId =
    plan === 'monthly'
      ? priceMonthly
      : plan === 'annual'
        ? priceAnnual
        : price3Year

  if (!priceId) {
    throw createError({
      statusCode: 500,
      statusMessage: `Stripe price not configured for plan: ${plan}. Set STRIPE_PRICE_MONTHLY, STRIPE_PRICE_ANNUAL, STRIPE_PRICE_3YEAR.`
    })
  }

  const siteUrl = config.public.siteUrl as string
  const successUrl = `${siteUrl.replace(/\/$/, '')}/services/success?session_id={CHECKOUT_SESSION_ID}`
  const cancelUrl = `${siteUrl.replace(/\/$/, '')}/services/cancel`

  const stripe = new Stripe(secretKey)

  const session = await stripe.checkout.sessions.create({
    mode: 'subscription',
    line_items: [
      {
        price: priceId,
        quantity: 1
      }
    ],
    success_url: successUrl,
    cancel_url: cancelUrl,
    subscription_data: {
      metadata: { plan }
    }
  })

  if (!session.url) {
    throw createError({
      statusCode: 500,
      statusMessage: 'Stripe did not return a checkout URL.'
    })
  }

  return { url: session.url }
})
