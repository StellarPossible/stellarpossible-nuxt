import Stripe from 'stripe'

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const email = getQuery(event).email

  if (!email || typeof email !== 'string') {
    return { hasSubscription: false, nextBillingDate: null }
  }

  const secretKey = config.stripeSecretKey
  if (!secretKey) {
    return { hasSubscription: false, nextBillingDate: null }
  }

  const stripe = new Stripe(secretKey)

  try {
    const customers = await stripe.customers.list({ email: email.trim(), limit: 1 })
    const customer = customers.data[0]
    if (!customer) return { hasSubscription: false, nextBillingDate: null }

    const subscriptions = await stripe.subscriptions.list({
      customer: customer.id,
      status: 'active',
      limit: 1
    })

    const sub = subscriptions.data[0]
    if (!sub?.current_period_end) return { hasSubscription: false, nextBillingDate: null }

    return {
      hasSubscription: true,
      nextBillingDate: new Date(sub.current_period_end * 1000).toISOString()
    }
  } catch {
    return { hasSubscription: false, nextBillingDate: null }
  }
})
