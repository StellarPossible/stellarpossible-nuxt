import Stripe from 'stripe'

const PLAN_IDS = ['monthly', 'annual'] as const
export type PlanId = (typeof PLAN_IDS)[number]

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const body = await readBody(event).catch(() => ({}))
  const plan = (body?.plan as string)?.toLowerCase()
  const customerEmail = (body?.customer_email as string)?.trim() || undefined

  if (!plan || !PLAN_IDS.includes(plan as PlanId)) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Invalid plan. Use monthly or annual.'
    })
  }

  const secretKey = config.stripeSecretKey
  const priceMonthly = config.stripePriceMonthly
  const priceAnnual = config.stripePriceAnnual

  if (!secretKey) {
    throw createError({
      statusCode: 500,
      statusMessage: 'Stripe is not configured (STRIPE_SECRET_KEY missing).'
    })
  }

  const priceId = (plan === 'monthly' ? priceMonthly : priceAnnual)?.trim()

  if (!priceId) {
    throw createError({
      statusCode: 500,
      statusMessage: `Stripe price not configured for plan: ${plan}. Set STRIPE_PRICE_MONTHLY and STRIPE_PRICE_ANNUAL in .env.`
    })
  }

  if (!priceId.startsWith('price_')) {
    throw createError({
      statusCode: 500,
      statusMessage: `STRIPE_PRICE_${plan === 'monthly' ? 'MONTHLY' : 'ANNUAL'} must be a Stripe Price ID (starts with price_), not a dollar amount. Create a recurring price in Stripe Dashboard → Product → Add price, then copy the Price ID.`
    })
  }

  const siteUrl = config.public.siteUrl as string
  const successUrl = `${siteUrl.replace(/\/$/, '')}/services/success?session_id={CHECKOUT_SESSION_ID}`
  const cancelUrl = `${siteUrl.replace(/\/$/, '')}/services/cancel`

  const stripe = new Stripe(secretKey)

  const sessionOptions: Stripe.Checkout.SessionCreateParams = {
    mode: 'subscription',
    line_items: [{ price: priceId, quantity: 1 }],
    success_url: successUrl,
    cancel_url: cancelUrl,
    subscription_data: { metadata: { plan } }
  }
  if (customerEmail) {
    sessionOptions.customer_email = customerEmail
  }
  const session = await stripe.checkout.sessions.create(sessionOptions)

  if (!session.url) {
    throw createError({
      statusCode: 500,
      statusMessage: 'Stripe did not return a checkout URL.'
    })
  }

  return { url: session.url }
})
