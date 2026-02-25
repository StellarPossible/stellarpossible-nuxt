<template>
  <div class="dashboard-services">
    <header class="page-hero">
      <h1>Hosting</h1>
      <p>Manage your site hosting subscription</p>
    </header>

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
  try {
    const { url } = await $fetch<{ url: string }>('/api/stripe/create-portal', {
      method: 'POST',
      body: { email }
    })
    if (url) window.location.href = url
  } catch (e: unknown) {
    const err = e as { data?: { statusMessage?: string }; message?: string }
    alert(err?.data?.statusMessage || err?.message || 'Could not open billing portal.')
  } finally {
    portalLoading.value = false
  }
}

async function goToCheckout(plan: 'monthly' | 'annual') {
  loading.value = plan
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
    alert(err?.data?.statusMessage || err?.message || 'Something went wrong. Please try again.')
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
.dashboard-services {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.page-hero {
  margin-bottom: 1.5rem;
  color: white;

  h1 {
    font-size: clamp(1.5rem, 2.5vw, 1.9rem);
    font-family: 'Evermore', 'Inter', sans-serif;
    margin: 0 0 0.35rem;
    font-weight: 400;
  }

  p {
    font-size: 0.95rem;
    opacity: 0.9;
    margin: 0;
  }
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

.dashboard-card {
  background: rgba(255, 255, 255, 0.98);
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08), 0 0 0 1px rgba(255, 255, 255, 0.5);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.dashboard-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12), 0 0 0 1px rgba(255, 255, 255, 0.5);
}

.card-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin: 0 0 1rem;
  font-size: 1rem;
  font-weight: 600;
  color: #1a1a2e;
}

.card-icon {
  width: 20px;
  height: 20px;
  color: #4c5fd5;
}

.status-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.85rem;
  font-weight: 600;
  padding: 0.4rem 0.75rem;
  border-radius: 8px;
  margin-bottom: 0.75rem;
}

.status-badge-active {
  background: rgba(34, 197, 94, 0.12);
  color: #16a34a;
}

.status-badge-inactive {
  background: rgba(102, 126, 234, 0.1);
  color: #4c5fd5;
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

.link-button {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.9rem;
  color: #4c5fd5;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;

  &:disabled {
    color: #adb5bd;
    cursor: default;
  }

  :deep(svg) {
    width: 16px;
    height: 16px;
  }
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
  border: 1px solid #e9ecef;
  border-radius: 12px;
  padding: 1.25rem;
  position: relative;
}

.plan-card-featured {
  border-color: rgba(102, 126, 234, 0.3);
  background: rgba(102, 126, 234, 0.04);
}

.plan-badge {
  position: absolute;
  top: -0.5rem;
  right: 0.75rem;
  font-size: 0.7rem;
  font-weight: 600;
  color: #16a34a;
  background: rgba(34, 197, 94, 0.12);
  padding: 0.2rem 0.5rem;
  border-radius: 6px;
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

.cta-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  padding: 0.75rem 1.25rem;
  font-size: 1rem;
  font-weight: 600;
  color: #fff;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: opacity 0.2s, transform 0.15s;

  &:hover:not(:disabled) {
    opacity: 0.95;
    transform: translateY(-1px);
  }

  &:disabled {
    opacity: 0.7;
    cursor: not-allowed;
  }
}

.services-footer {
  margin: 0;
  font-size: 0.8rem;
  color: #6c757d;
  line-height: 1.5;
}
</style>
