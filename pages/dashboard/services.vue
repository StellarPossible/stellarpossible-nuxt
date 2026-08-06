<template>
  <div class="dashboard-services dashboard-page">
    <header class="page-hero">
      <h1>Hosting</h1>
      <p>Manage your site hosting subscription</p>
    </header>

    <p v-if="actionError" class="dashboard-error" role="alert">{{ actionError }}</p>

    <div class="services-grid">
      <section class="dashboard-card status-card">
        <h2 class="card-title">
          <Icon icon="mdi:account-check" class="card-icon" />
          Subscription Status
        </h2>
        <div v-if="statusLoading" class="status-loading">Checking…</div>
        <div v-else-if="hasSubscription" class="status-active">
          <span class="status-badge status-badge-active">
            <Icon icon="mdi:check-circle" />
            Active
          </span>
          <p class="status-desc">
            Your hosting subscription is active.
            <template v-if="nextBillingDate">Next billing: {{ formatDate(nextBillingDate) }}</template>
          </p>
          <button
            type="button"
            class="link-button"
            :disabled="portalLoading"
            @click="openPortal"
          >
            <Icon icon="mdi:open-in-new" />
            {{ portalLoading ? 'Opening…' : 'Manage billing' }}
          </button>
        </div>
        <div v-else class="status-inactive">
          <span class="status-badge status-badge-inactive">
            <Icon icon="mdi:clock-outline" />
            Not subscribed
          </span>
          <p class="status-desc">Subscribe below to get started with managed hosting.</p>
        </div>
      </section>

      <section class="dashboard-card services-card">
        <h2 class="card-title">
          <Icon icon="mdi:server" class="card-icon" />
          Hosting Plans
        </h2>
        <p class="services-subtitle">Reliable managed hosting for your site. Cancel anytime.</p>

        <div class="plans-row">
          <article class="plan-card">
            <h3 class="plan-name">Monthly</h3>
            <div class="plan-price">
              <span class="amount">$30</span>
              <span class="period">/month</span>
            </div>
            <ul class="plan-features">
              <li>Managed hosting</li>
              <li>Billed every month</li>
              <li>Cancel anytime</li>
            </ul>
            <button
              type="button"
              class="cta-button"
              :disabled="loading"
              @click="goToCheckout('monthly')"
            >
              {{ loading === 'monthly' ? 'Redirecting…' : 'Subscribe' }}
            </button>
          </article>

          <article class="plan-card plan-card-featured">
            <span class="plan-badge">Save 2 months</span>
            <h3 class="plan-name">Annual</h3>
            <div class="plan-price">
              <span class="amount">$300</span>
              <span class="period">/year</span>
            </div>
            <ul class="plan-features">
              <li>Managed hosting</li>
              <li>Billed yearly</li>
              <li>Cancel anytime</li>
            </ul>
            <button
              type="button"
              class="cta-button"
              :disabled="loading"
              @click="goToCheckout('annual')"
            >
              {{ loading === 'annual' ? 'Redirecting…' : 'Subscribe' }}
            </button>
          </article>
        </div>

        <p class="services-footer">
          You’ll be redirected to Stripe to complete your subscription. After signup, you can manage billing in your Stripe customer portal.
        </p>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: 'auth'
})

const user = useState<{ email?: string } | null>('auth.user')
const loading = ref<'monthly' | 'annual' | null>(null)
const statusLoading = ref(true)
const portalLoading = ref(false)
const hasSubscription = ref(false)
const nextBillingDate = ref<string | null>(null)
const actionError = ref('')

async function fetchStatus() {
  const email = user.value?.email
  if (!email) {
    statusLoading.value = false
    return
  }
  try {
    const data = await $fetch<{ hasSubscription: boolean; nextBillingDate: string | null }>(
      `/api/stripe/subscription-status?email=${encodeURIComponent(email)}`
    )
    hasSubscription.value = data.hasSubscription
    nextBillingDate.value = data.nextBillingDate
  } catch {
    hasSubscription.value = false
  } finally {
    statusLoading.value = false
  }
}

onMounted(fetchStatus)

function formatDate(iso: string) {
  try {
    return new Date(iso).toLocaleDateString(undefined, { month: 'short', day: 'numeric', year: 'numeric' })
  } catch {
    return iso
  }
}

async function openPortal() {
  const email = user.value?.email
  if (!email) return
  portalLoading.value = true
  actionError.value = ''
  try {
    const { url } = await $fetch<{ url: string }>('/api/stripe/create-portal', {
      method: 'POST',
      body: { email }
    })
    if (url) window.location.href = url
  } catch (e: unknown) {
    const err = e as { data?: { statusMessage?: string }; message?: string }
    actionError.value = err?.data?.statusMessage || err?.message || 'Could not open billing portal.'
  } finally {
    portalLoading.value = false
  }
}

async function goToCheckout(plan: 'monthly' | 'annual') {
  loading.value = plan
  actionError.value = ''
  try {
    const { url } = await $fetch<{ url: string }>('/api/stripe/create-checkout', {
      method: 'POST',
      body: {
        plan,
        customer_email: user.value?.email
      }
    })
    if (url) window.location.href = url
  } catch (e: unknown) {
    const err = e as { data?: { statusMessage?: string }; message?: string }
    console.error('Checkout error:', err)
    actionError.value = err?.data?.statusMessage || err?.message || 'Something went wrong. Please try again.'
  } finally {
    loading.value = null
  }
}

useHead({
  title: 'Hosting | Dashboard | StellarPossible',
  meta: [{ name: 'description', content: 'Subscribe to monthly hosting for your site.' }]
})
</script>

<style scoped lang="scss">
.dashboard-error {
  margin: 0 0 1rem;
  padding: 0.75rem 1rem;
  border-radius: 10px;
  background: rgba(192, 57, 43, 0.1);
  color: #c0392b;
  font-size: 0.9375rem;
}

.services-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
  margin-bottom: 1.5rem;
}

@media (max-width: 900px) {
  .services-grid {
    grid-template-columns: 1fr;
  }
}

.status-badge {
  margin-bottom: 0.75rem;
}

.status-loading {
  font-size: 0.9rem;
  color: #868e96;
}

.status-desc {
  margin: 0 0 0.75rem;
  font-size: 0.9rem;
  color: #495057;
  line-height: 1.5;
}

.services-subtitle {
  margin: 0 0 1rem;
  font-size: 0.9rem;
  color: #6c757d;
  line-height: 1.5;
}

.plans-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-bottom: 1rem;
}

@media (max-width: 640px) {
  .plans-row {
    grid-template-columns: 1fr;
  }
}

.plan-card {
  position: relative;
}

.plan-badge {
  position: absolute;
  top: -0.5rem;
  right: 0.75rem;
  color: #16a34a;
  background: rgba(34, 197, 94, 0.12);
}

.plan-name {
  margin: 0 0 0.5rem;
  font-size: 1.1rem;
  color: #212529;
}

.plan-price {
  margin-bottom: 0.75rem;

  .amount {
    font-size: 1.75rem;
    font-weight: 700;
    color: #212529;
  }

  .period {
    font-size: 0.95rem;
    color: #6c757d;
    font-weight: 400;
  }
}

.plan-features {
  margin: 0 0 1rem;
  padding-left: 1.25rem;
  color: #495057;
  font-size: 0.9rem;
  line-height: 1.6;

  li {
    margin-bottom: 0.3rem;
  }
}

:deep(.cta-button) {
  width: 100%;
}

.services-footer {
  margin: 0;
  font-size: 0.8rem;
  color: #868e96;
}
</style>
