<template>
  <section class="services-page">
    <div class="hero">
      <h1>Services</h1>
      <p class="hero-subtitle">
        Managed hosting for your site. Choose monthly or save with annual billing.
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
        <h2 class="plan-name">{{ plan.name }}</h2>
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

    <p class="fine-print">
      Subscriptions are billed securely via Stripe. Cancel or change your plan anytime from your Stripe customer portal or by contacting us.
    </p>
  </section>
</template>

<script setup lang="ts">
type PlanId = 'monthly' | 'annual'

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
    savings: 'Save $36 with annual billing',
    badge: 'Popular',
    featured: true,
    features: [
      'Everything in Monthly',
      'Billed once per year'
    ],
    cta: 'Subscribe annually'
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
    { name: 'description', content: 'Managed site hosting—$30/month, or save 10% with an annual subscription.' }
  ]
})
</script>

<style scoped lang="scss">
.services-page {
  padding: 3.5rem 1.5rem 4.5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #fff;
  background: rgba(0, 0, 0, 0.32);
  backdrop-filter: blur(3px);
  text-align: center;
}

.hero {
  max-width: 38rem;
  margin-bottom: 2.5rem;

  h1 {
    font-size: clamp(2rem, 4vw, 2.5rem);
    margin-bottom: 0.5rem;
    font-weight: 700;
    letter-spacing: -0.02em;
  }

  .hero-subtitle {
    font-size: 1rem;
    line-height: 1.55;
    color: rgba(255, 255, 255, 0.82);
  }
}

.plans-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1.5rem;
  max-width: 640px;
  width: 100%;
  margin-bottom: 2rem;
}

@media (max-width: 560px) {
  .plans-grid {
    grid-template-columns: 1fr;
  }
}

.plan-card {
  position: relative;
  background: rgba(18, 49, 70, 0.55);
  border: 1px solid rgba(84, 117, 128, 0.3);
  border-radius: 14px;
  padding: 1.75rem 1.5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;

  &:hover {
    border-color: rgba(84, 117, 128, 0.5);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.18);
    background: rgba(18, 49, 70, 0.65);
  }

  &.featured {
    border-color: rgba(84, 117, 128, 0.5);
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
    background: rgba(18, 49, 70, 0.6);
  }

  .plan-name {
    font-size: 1.25rem;
    font-weight: 600;
    margin-bottom: 0.375rem;
    letter-spacing: -0.01em;
  }

  .plan-badge {
    position: absolute;
    top: -0.375rem;
    left: 50%;
    transform: translateX(-50%);
    background: rgba(84, 117, 128, 0.5);
    color: #fff;
    font-size: 0.7rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    padding: 0.2rem 0.6rem;
    border-radius: 999px;
  }

  .plan-price {
    margin-bottom: 0.125rem;

    .amount {
      font-size: 1.75rem;
      font-weight: 700;
      letter-spacing: -0.02em;
    }

    .period {
      font-size: 0.9375rem;
      color: rgba(255, 255, 255, 0.7);
    }
  }

  .savings {
    font-size: 0.8125rem;
    color: rgba(255, 255, 255, 0.9);
    margin-bottom: 0.75rem;
    font-weight: 500;
  }

  .plan-features {
    list-style: none;
    padding: 0;
    margin: 0 0 1.25rem;
    text-align: left;
    width: 100%;

    li {
      padding: 0.3rem 0;
      padding-left: 1.25rem;
      position: relative;
      font-size: 0.9375rem;
      color: rgba(255, 255, 255, 0.88);

      &::before {
        content: '✓';
        position: absolute;
        left: 0;
        color: rgba(84, 117, 128, 0.95);
        font-weight: 600;
      }
    }
  }

  .cta-button {
    display: inline-block;
    margin-top: auto;
    padding: 0.65rem 1.35rem;
    font-size: 0.9375rem;
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
  max-width: 32rem;
  font-size: 0.8125rem;
  color: rgba(255, 255, 255, 0.6);
  line-height: 1.5;
}
</style>
