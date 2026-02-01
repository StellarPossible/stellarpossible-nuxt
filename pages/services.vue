<template>
  <section class="services-page">
    <div class="hero">
      <h1>Services</h1>
      <p class="hero-subtitle">
        Custom design—logos, book covers, and graphics—plus managed hosting for your site.
      </p>
    </div>

    <!-- What's included with every service -->
    <div class="included-block">
      <h2 class="included-title">Every service includes</h2>
      <ul class="included-list">
        <li>Unlimited revisions</li>
        <li>30-minute get-to-know-you consult with Marine—in person or via Google Meet</li>
        <li>Rapid response and communication via StellarPossible Slack</li>
        <li>Optimized files + custom color palette with hex keys</li>
        <li>Multiple versions + file types</li>
      </ul>
    </div>

    <!-- StellarPossible Slack Hub -->
    <section class="slack-section">
      <h2 class="section-title">Stay connected</h2>
      <p class="slack-intro">
        Every client gets access to the StellarPossible Slack Hub for fast updates, file sharing, and direct communication.
      </p>
      <div class="slack-visual">
        <img
          src="/images/primary/SPSlackSS.png"
          alt="StellarPossible Slack Hub — desktop view of the SP Slack workspace"
          class="slack-screenshot"
        />
      </div>
    </section>

    <!-- Design services -->
    <div class="services-section">
      <h2 class="section-title">Design services</h2>
      <div class="services-grid design-grid">
        <article
          v-for="service in designServices"
          :key="service.id"
          class="service-card"
        >
          <h3 class="service-name">{{ service.name }}</h3>
          <p v-if="service.price" class="service-price">{{ service.price }}</p>
          <p class="service-description">{{ service.description }}</p>
          <NuxtLink
            v-if="service.orderLink && !user"
            to="/login?tab=register"
            class="cta-button"
          >
            Get Yours
          </NuxtLink>
          <a
            v-else-if="service.orderLink"
            :href="service.orderLink"
            class="cta-button"
            target="_blank"
            rel="noopener noreferrer"
          >
            Get Yours
          </a>
          <button
            v-else
            type="button"
            class="cta-button cta-outline"
            @click="openContact"
          >
            {{ service.cta }}
          </button>
        </article>
      </div>
    </div>

    <!-- Hosting plans -->
    <div class="services-section">
      <h2 class="section-title">Managed hosting</h2>
      <p class="section-subtitle">
        Reliable hosting for your site. Choose monthly or save with annual billing.
      </p>
      <div class="plans-grid">
        <article
          v-for="plan in plans"
          :key="plan.id"
          class="plan-card"
          :class="{ featured: plan.featured }"
        >
          <div v-if="plan.badge" class="plan-badge">{{ plan.badge }}</div>
          <h3 class="plan-name">{{ plan.name }}</h3>
          <div class="plan-price">
            <span class="amount">{{ plan.priceDisplay }}</span>
            <span class="period">{{ plan.period }}</span>
          </div>
          <p v-if="plan.savings" class="savings">{{ plan.savings }}</p>
          <ul class="plan-features">
            <li v-for="feature in plan.features" :key="feature">{{ feature }}</li>
          </ul>
          <NuxtLink
            v-if="!user"
            to="/login?tab=register"
            class="cta-button"
          >
            {{ plan.cta }}
          </NuxtLink>
          <button
            v-else
            type="button"
            class="cta-button"
            :disabled="loadingPlan === plan.id"
            @click="goToCheckout(plan.id)"
          >
            {{ loadingPlan === plan.id ? 'Redirecting…' : plan.cta }}
          </button>
        </article>
      </div>
    </div>

    <p class="fine-print">
      Hosting subscriptions are billed securely via Stripe. Cancel or change your plan anytime from your Stripe customer portal or by contacting us.
    </p>
  </section>
</template>

<script setup lang="ts">
import type { User } from '~/types/auth'

type PlanId = 'monthly' | 'annual'

const user = useState<User | null>('auth.user', () => null)

const designServices = [
  {
    id: 'custom-logo',
    name: 'Custom logo',
    price: '$450',
    orderLink: '#' as string, // Replace with your Stripe Payment Link for logo when ready
    description: 'A distinctive logo tailored to your brand—concept, refinement, and final files ready for print and web.',
    cta: 'Get a quote'
  },
  {
    id: 'book-cover',
    name: 'Book cover (KDP + Amazon optimized)',
    price: '$1,350',
    orderLink: '#' as string, // Replace with your Stripe Payment Link for book cover when ready
    description: 'Professional book cover design sized and formatted for Kindle Direct Publishing and Amazon—front, spine, and back; ebook and print.',
    cta: 'Get a quote'
  },
  {
    id: 'graphic-design',
    name: 'Graphic design',
    price: null as string | null,
    orderLink: null as string | null,
    description: 'Marketing visuals, social graphics, one-sheets, and other print or digital assets—on-brand and ready to use.',
    cta: 'Get a quote'
  }
]

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
      'Cancel anytime',
      'All “Every service includes” benefits'
    ],
    cta: 'Signup'
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
      'Billed once per year',
      'All “Every service includes” benefits'
    ],
    cta: 'Signup'
  }
]

const loadingPlan = ref<PlanId | null>(null)
const { open: openContactModal } = useContactModal()

function openContact() {
  openContactModal()
}

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
    {
      name: 'description',
      content: 'Custom logo, book cover (KDP + Amazon), and graphic design—plus managed site hosting. Every service includes unlimited revisions, a consult with Marine, and optimized files.'
    }
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
  max-width: 40rem;
  margin-bottom: 2rem;

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

.included-block {
  max-width: 36rem;
  width: 100%;
  margin-bottom: 3rem;
  padding: 1.5rem 1.75rem;
  background: rgba(18, 49, 70, 0.5);
  border: 1px solid rgba(84, 117, 128, 0.3);
  border-radius: 14px;
  text-align: left;
}

.included-title {
  font-size: 1rem;
  font-weight: 600;
  margin-bottom: 0.75rem;
  letter-spacing: -0.01em;
  color: rgba(255, 255, 255, 0.95);
}

.included-list {
  list-style: none;
  padding: 0;
  margin: 0;
  font-size: 0.9375rem;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.88);

  li {
    padding: 0.25rem 0;
    padding-left: 1.25rem;
    position: relative;

    &::before {
      content: '✓';
      position: absolute;
      left: 0;
      color: rgba(132, 165, 175, 0.95);
      font-weight: 600;
    }
  }
}

.slack-section {
  width: 100%;
  max-width: 900px;
  margin-bottom: 3rem;
}

.slack-intro {
  font-size: 1rem;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.82);
  max-width: 36rem;
  margin: 0 auto 1.5rem;
}

.slack-visual {
  width: 100%;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
  border: 1px solid rgba(84, 117, 128, 0.25);
}

.slack-screenshot {
  display: block;
  width: 100%;
  height: auto;
  object-fit: contain;
}

.services-section {
  width: 100%;
  max-width: 900px;
  margin-bottom: 3rem;
}

.section-title {
  font-size: 1.375rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
  letter-spacing: -0.02em;
}

.section-subtitle {
  font-size: 0.9375rem;
  color: rgba(255, 255, 255, 0.75);
  margin-bottom: 1.5rem;
}

.design-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
  margin-top: 1rem;
}

@media (max-width: 768px) {
  .design-grid {
    grid-template-columns: 1fr;
  }
}

.service-card {
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
}

.service-name {
  font-size: 1.125rem;
  font-weight: 600;
  margin-bottom: 0.375rem;
  letter-spacing: -0.01em;
  color: #fff;
}

.service-price {
  font-size: 1.5rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: rgba(255, 255, 255, 0.95);
  margin-bottom: 0.75rem;
}

.service-description {
  font-size: 0.9375rem;
  line-height: 1.55;
  color: rgba(255, 255, 255, 0.82);
  margin-bottom: 1.25rem;
  flex: 1;
}

.plans-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1.5rem;
  max-width: 640px;
  width: 100%;
  margin-top: 1rem;
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
  text-decoration: none;
  transition: background 0.2s, transform 0.15s;
  text-align: center;

  &:hover:not(:disabled) {
    background: var(--primary-light, #547580);
    transform: translateY(-1px);
  }

  &:disabled {
    opacity: 0.8;
    cursor: not-allowed;
  }

  &.cta-outline {
    background: transparent;
    border: 1px solid rgba(255, 255, 255, 0.5);
    color: #fff;

    &:hover {
      background: rgba(255, 255, 255, 0.1);
      border-color: rgba(255, 255, 255, 0.7);
    }
  }
}

.fine-print {
  max-width: 36rem;
  font-size: 0.8125rem;
  color: rgba(255, 255, 255, 0.6);
  line-height: 1.5;
}
</style>
