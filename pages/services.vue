<template>
  <section class="services-page">
    <div class="hero">
      <h1>Services</h1>
      <p>
        Managed hosting for your site. One plan, three ways to pay—choose monthly, save 10% with annual, or 20% with a 3-year commitment.
      </p>
    </div>

    <div class="plans-grid">
      <article
        v-for="plan in plans"
        :key="plan.id"
        class="plan-card"
        :class="{ featured: plan.featured }"
      >
        <div v-if="plan.badge" class="plan-badge">{{ plan.badge }}</div>
        <h2>{{ plan.name }}</h2>
        <div class="plan-price">
          <span class="amount">{{ plan.priceDisplay }}</span>
          <span class="period">{{ plan.period }}</span>
        </div>
        <p v-if="plan.savings" class="savings">{{ plan.savings }}</p>
        <ul class="plan-features">
          <li v-for="feature in plan.features" :key="feature">{{ feature }}</li>
        </ul>
        <button
          type="button"
          class="cta-button"
          :disabled="loadingPlan === plan.id"
          @click="goToCheckout(plan.id)"
        >
          {{ loadingPlan === plan.id ? 'Redirecting…' : plan.cta }}
        </button>
      </article>
    </div>

    <div class="fine-print">
      <p>Subscriptions are billed securely via Stripe. Cancel or change your plan anytime from your Stripe customer portal or by contacting us.</p>
    </div>
  </section>
</template>

<script setup lang="ts">
type PlanId = 'monthly' | 'annual' | '3year'

const plans = [
  {
    id: 'monthly' as PlanId,
    name: 'Monthly',
    priceDisplay: '$30',
    period: '/month',
    savings: null as string | null,
    badge: null as string | null,
    featured: false,
    features: [
      'Managed hosting',
      'Billed every month',
      'Cancel anytime'
    ],
    cta: 'Subscribe monthly'
  },
  {
    id: 'annual' as PlanId,
    name: 'Annual',
    priceDisplay: '$324',
    period: '/year',
    savings: 'Save 10%',
    badge: 'Popular',
    featured: true,
    features: [
      'Everything in Monthly',
      'Billed once per year',
      'Equivalent to $27/month'
    ],
    cta: 'Subscribe annually'
  },
  {
    id: '3year' as PlanId,
    name: '3-Year',
    priceDisplay: '$864',
    period: 'total',
    savings: 'Save 20%',
    badge: 'Best value',
    featured: false,
    features: [
      'Everything in Annual',
      'One payment every 3 years',
      'Equivalent to $24/month'
    ],
    cta: 'Subscribe for 3 years'
  }
]

const loadingPlan = ref<PlanId | null>(null)

async function goToCheckout(planId: PlanId) {
  loadingPlan.value = planId
  try {
    const { url } = await $fetch<{ url: string }>('/api/stripe/create-checkout', {
      method: 'POST',
      body: { plan: planId }
    })
    if (url) window.location.href = url
  } catch (e: any) {
    console.error('Checkout error:', e)
    alert(e?.data?.statusMessage || e?.message || 'Something went wrong. Please try again.')
  } finally {
    loadingPlan.value = null
  }
}

useHead({
  title: 'Services | StellarPossible',
  meta: [
    { name: 'description', content: 'Managed site hosting—$30/month, or save 10% with annual and 20% with a 3-year subscription.' }
  ]
})
</script>

<style scoped lang="scss">
.services-page {
  padding: 4rem 1.5rem 5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #fff;
  background: rgba(0, 0, 0, 0.32);
  backdrop-filter: blur(3px);
  text-align: center;
}

.hero {
  max-width: 42rem;
  margin-bottom: 3rem;

  h1 {
    font-size: clamp(2rem, 4vw, 2.75rem);
    margin-bottom: 0.75rem;
    font-weight: 700;
  }

  p {
    font-size: 1.1rem;
    line-height: 1.6;
    color: rgba(255, 255, 255, 0.88);
  }
}

.plans-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
  max-width: 960px;
  width: 100%;
  margin-bottom: 2.5rem;
}

.plan-card {
  position: relative;
  background: rgba(18, 49, 70, 0.6);
  border: 1px solid rgba(84, 117, 128, 0.35);
  border-radius: 12px;
  padding: 2rem 1.5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  transition: border-color 0.2s, box-shadow 0.2s;

  &:hover {
    border-color: rgba(84, 117, 128, 0.6);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
  }

  &.featured {
    border-color: rgba(84, 117, 128, 0.6);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  }

  h2 {
    font-size: 1.5rem;
    margin-bottom: 0.5rem;
  }

  .plan-badge {
    position: absolute;
    top: -0.5rem;
    left: 50%;
    transform: translateX(-50%);
    background: var(--primary-medium, #2d4558);
    color: #fff;
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    padding: 0.25rem 0.75rem;
    border-radius: 999px;
  }

  .plan-price {
    margin-bottom: 0.25rem;

    .amount {
      font-size: 2rem;
      font-weight: 700;
    }

    .period {
      font-size: 1rem;
      color: rgba(255, 255, 255, 0.72);
    }
  }

  .savings {
    font-size: 0.9rem;
    color: rgba(255, 255, 255, 0.85);
    margin-bottom: 1rem;
  }

  .plan-features {
    list-style: none;
    padding: 0;
    margin: 0 0 1.5rem;
    text-align: left;
    width: 100%;

    li {
      padding: 0.35rem 0;
      padding-left: 1.25rem;
      position: relative;

      &::before {
        content: '✓';
        position: absolute;
        left: 0;
        color: rgba(84, 117, 128, 0.9);
      }
    }
  }

  .cta-button {
    display: inline-block;
    margin-top: auto;
    padding: 0.75rem 1.5rem;
    background: var(--primary-medium, #2d4558);
    color: #fff;
    font-weight: 600;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: background 0.2s, transform 0.15s;

    &:hover:not(:disabled) {
      background: var(--primary-light, #547580);
      transform: translateY(-1px);
    }

    &:disabled {
      opacity: 0.8;
      cursor: not-allowed;
    }
  }
}

.fine-print {
  max-width: 36rem;
  margin-top: 1rem;

  p {
    font-size: 0.875rem;
    color: rgba(255, 255, 255, 0.65);
    line-height: 1.5;
  }
}
</style>
