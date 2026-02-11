<template>
  <section class="services-page">
    <!-- Tabs: zero scroll, one panel at a time -->
    <div class="services-tabs" role="tablist" aria-label="Service categories">
      <button
        type="button"
        role="tab"
        :aria-selected="activeTab === 'design'"
        :class="['tab-trigger', { active: activeTab === 'design' }]"
        @click="activeTab = 'design'"
      >
        <ClientOnly>
          <Icon icon="mdi:palette-outline" aria-hidden />
          <template #fallback><span aria-hidden>◆</span></template>
        </ClientOnly>
        <span>Design</span>
      </button>
      <button
        type="button"
        role="tab"
        :aria-selected="activeTab === 'software'"
        :class="['tab-trigger', { active: activeTab === 'software' }]"
        @click="activeTab = 'software'"
      >
        <ClientOnly>
          <Icon icon="mdi:code-tags" aria-hidden />
          <template #fallback><span aria-hidden>◆</span></template>
        </ClientOnly>
        <span>Tool Development</span>
      </button>
      <button
        type="button"
        role="tab"
        :aria-selected="activeTab === 'hosting'"
        :class="['tab-trigger', { active: activeTab === 'hosting' }]"
        @click="activeTab = 'hosting'"
      >
        <ClientOnly>
          <Icon icon="mdi:server" aria-hidden />
          <template #fallback><span aria-hidden>◆</span></template>
        </ClientOnly>
        <span>Web Management</span>
      </button>
    </div>

    <div class="tab-panels">
      <!-- Design panel -->
      <div
        v-show="activeTab === 'design'"
        role="tabpanel"
        class="tab-panel"
      >
        <div class="services-section">
          <h2 class="section-title">Design</h2>
      <p class="section-subtitle">One fixed price. No surprises. Final files ready for print and web.</p>
      <div class="design-deliverables">
        <h3 class="design-deliverables-title">Included with design</h3>
        <ul class="design-deliverables-list">
          <li>Unlimited revisions</li>
          <li>Optimized files + custom color palette with hex keys</li>
          <li>Multiple versions + file types</li>
          <li>Original PSD file (all commissioned designs)</li>
        </ul>
      </div>
      <div class="services-grid design-grid">
        <article
          v-for="service in designServices"
          :key="service.id"
          class="service-card"
          :class="{ 'service-card-book-cover': service.id === 'book-cover' }"
        >
          <h3 class="service-name">{{ service.name }}</h3>
          <p v-if="service.price" class="service-price">{{ service.price }}</p>
          <p class="service-description">{{ service.description }}</p>
          <div v-if="service.id === 'book-cover'" class="service-card-gallery-wrap">
            <BookCoverGallery :items="bookCovers" />
          </div>
          <NuxtLink
            v-if="service.orderLink && !user"
            to="/login?tab=register"
            class="cta-button cta-primary"
          >
            Get yours
          </NuxtLink>
          <a
            v-else-if="service.orderLink"
            :href="service.orderLink"
            class="cta-button cta-primary"
            target="_blank"
            rel="noopener noreferrer"
          >
            Get yours
          </a>
          <button
            v-else
            type="button"
            class="cta-button cta-primary"
            @click="openContact"
          >
            {{ service.cta }}
          </button>
        </article>
      </div>
        </div>
      </div>

      <!-- Tool Development panel -->
      <div
        v-show="activeTab === 'software'"
        role="tabpanel"
        class="tab-panel"
      >
        <div class="services-section software-section">
          <h2 class="section-title">Tool Development</h2>
      <p class="section-subtitle">
        Custom software, scripts, tools, and integrations. From one-off automations to full applications—built to your specs.
      </p>
      <div class="included-block included-web-software">
        <h3 class="included-block-title">Included for web & software clients</h3>
        <ul class="included-list">
          <li>30-minute get-to-know-you consult with Marine—in person or via Google Meet</li>
          <li>Rapid response and communication via StellarPossible Slack</li>
        </ul>
      </div>
      <div class="software-cta-block">
        <p class="software-intro">
          Need a script, internal tool, API, or something else? We scope the project, agree on a fixed price, and deliver with the same “every service includes” benefits.
        </p>
        <button type="button" class="cta-button cta-primary cta-software" @click="openContact">
          Discuss your project
        </button>
      </div>
        </div>
      </div>

      <!-- Web Management panel -->
      <div
        v-show="activeTab === 'hosting'"
        role="tabpanel"
        class="tab-panel"
      >
        <div class="services-section hosting-section">
          <h2 class="section-title">Web Management</h2>
      <p class="section-subtitle">
        Reliable hosting for your site. Monthly billing.
      </p>
      <div class="included-block included-web-software">
        <h3 class="included-block-title">Included for web & software clients</h3>
        <ul class="included-list">
          <li>30-minute get-to-know-you consult with Marine—in person or via Google Meet</li>
          <li>Rapid response and communication via StellarPossible Slack</li>
        </ul>
      </div>
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
          <template v-if="plan.id !== 'addon'">
            <NuxtLink
              v-if="!user"
              to="/login?tab=register"
              class="cta-button cta-primary"
            >
              Get started
            </NuxtLink>
            <button
              v-else
              type="button"
              class="cta-button cta-primary"
              :class="{ 'cta-featured': plan.featured }"
              :disabled="loadingPlan === plan.id"
              @click="goToCheckout(plan.id)"
            >
              {{ loadingPlan === plan.id ? 'Redirecting…' : 'Get started' }}
            </button>
          </template>
        </article>
      </div>

      <!-- Website builds: fixed-price offerings -->
      <div class="builds-section">
        <h3 class="builds-heading">Website builds</h3>
        <p class="builds-subheading">Fixed-price options for new sites</p>
      </div>
      <div class="builds-grid">
        <article class="plan-card build-card">
          <h3 class="plan-name">Single-page site</h3>
          <div class="plan-price">
            <span class="amount">$550</span>
            <span class="period"></span>
          </div>
          <p class="build-description">Simple, one-page site build. Ideal for portfolios, landing pages, or a focused business presence.</p>
        </article>
        <article class="plan-card build-card">
          <h3 class="plan-name">Additional pages</h3>
          <div class="plan-price">
            <span class="amount">$400</span>
            <span class="period">/page</span>
          </div>
          <p class="build-description">Add more pages to your site. Priced per page for clarity and scalability.</p>
        </article>
        <article
          class="plan-card build-card build-card-nuxt build-card-cta"
          aria-labelledby="nuxt-card-title"
          aria-describedby="nuxt-card-desc"
        >
          <span class="build-card-badge">Starting at $2,500</span>
          <h3 id="nuxt-card-title" class="plan-name build-card-nuxt-title">Nuxt.js sites & platforms</h3>
          <div class="build-card-pricing-tiers" id="nuxt-card-desc">
            <div class="pricing-tier">
              <span class="pricing-tier-label">Headless CMS</span>
              <span class="pricing-tier-amount">$4,500</span>
              <span class="pricing-tier-desc">Nuxt + WordPress or other CMS. Editable content, SEO-friendly, built to scale.</span>
            </div>
            <div class="pricing-tier">
              <span class="pricing-tier-label">Frontend-only</span>
              <span class="pricing-tier-amount">$2,500</span>
              <span class="pricing-tier-desc">Nuxt.js only—no CMS. Ideal when content is static or managed elsewhere.</span>
            </div>
          </div>
          <button
            type="button"
            class="cta-button cta-primary build-card-nuxt-cta"
            aria-label="Discuss your Nuxt.js project with Stellar Possible"
            @click="openContact"
          >
            Discuss your project
          </button>
        </article>
      </div>
        </div>
      </div>
    </div>

    <!-- Slack highlight hero card: below services, above See our work -->
    <section class="slack-hero-card" aria-label="StellarPossible Slack Hub">
      <div class="slack-hero-inner">
        <div class="slack-hero-content">
          <h2 class="slack-hero-title">Stay connected</h2>
          <p class="slack-hero-text">
            Every client gets access to the StellarPossible Slack Hub for fast updates, file sharing, and direct communication.
          </p>
          <a
            href="https://stellarpossible.slack.com"
            target="_blank"
            rel="noopener noreferrer"
            class="slack-hero-cta"
          >
            Join the Welcome channel
            <ClientOnly>
              <Icon icon="mdi:open-in-new" aria-hidden />
              <template #fallback><span aria-hidden>↗</span></template>
            </ClientOnly>
          </a>
        </div>
        <div class="slack-hero-visual">
          <img
            src="/images/primary/SPSlackSS.png"
            alt="StellarPossible Slack Hub — #github channel"
            class="slack-hero-img"
          />
        </div>
      </div>
    </section>

    <!-- Cross-page CTA: See our work -->
    <section class="cross-cta-section" aria-label="Explore our work">
      <h2 class="cross-cta-title">See our work</h2>
      <p class="cross-cta-subtitle">View client projects and featured case studies.</p>
      <NuxtLink to="/products" class="cross-cta-button">
        View client portfolio
        <ClientOnly>
          <Icon icon="mdi:arrow-right" />
          <template #fallback><span>→</span></template>
        </ClientOnly>
      </NuxtLink>
    </section>
  </section>
</template>

<script setup lang="ts">
import type { User } from '~/types/auth'
import { servicesHeaderHeroKey } from '~/composables/usePageHero'

type PlanId = 'monthly' | 'addon'

const user = useState<User | null>('auth.user', () => null)

type TabId = 'design' | 'software' | 'hosting'
const activeTab = ref<TabId>('hosting')

const servicesHeaderHero = useState<{ title: string; subtitle: string } | null>(servicesHeaderHeroKey, () => null)

const tabHeroContent: Record<TabId, { title: string; subtitle: string }> = {
  design: {
    title: 'Design',
    subtitle: 'One fixed price. No surprises. Final files ready for print and web.'
  },
  software: {
    title: 'Tool Development',
    subtitle: 'Custom software, scripts, tools, and integrations. From one-off automations to full applications—built to your specs.'
  },
  hosting: {
    title: 'Web Management',
    subtitle: 'Reliable hosting for your site. Monthly billing.'
  }
}

watch(activeTab, (tab) => {
  servicesHeaderHero.value = tabHeroContent[tab] ?? null
}, { immediate: true })

onBeforeUnmount(() => {
  servicesHeaderHero.value = null
})

const bookCovers = [
  {
    src: '/images/media/ScentOfLiesAmazonCover.png',
    alt: 'Scent of Lies — book cover, Amazon/KDP',
    title: 'Scent of Lies'
  }
]

const designServices = [
  {
    id: 'custom-logo',
    name: 'Custom logo',
    price: '$450',
    orderLink: '#' as string,
    description: 'A distinctive logo tailored to your brand—concept, refinement, and final files ready for print and web.',
    cta: 'Get a quote'
  },
  {
    id: 'book-cover',
    name: 'Book cover (KDP + Amazon optimized)',
    price: '$1,350',
    orderLink: '#' as string,
    description: 'Professional book cover design sized and formatted for Kindle Direct Publishing and Amazon—front, spine, and back; ebook and print.',
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
      'Cancel anytime'
    ],
    cta: 'Signup'
  },
  {
    id: 'addon' as PlanId,
    name: 'Additional changes',
    priceDisplay: '$37.50',
    period: '/quarter hour',
    savings: null as string | null,
    badge: null as string | null,
    featured: false,
    features: [
      'Site changes & updates',
      'Billed in 15‑minute increments',
      'Invoiced prior to work'
    ],
    cta: 'Get a quote'
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
      content: 'Custom logo and book cover design (KDP + Amazon)—plus managed site hosting. Every service includes unlimited revisions, a consult with Marine, and optimized files.'
    }
  ]
})
</script>

<style scoped lang="scss">
.services-page {
  padding: 2.75rem 1.25rem 3.5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #fff;
  background: rgba(0, 0, 0, 0.32);
  backdrop-filter: blur(3px);
  text-align: center;
  width: 100%;
  max-width: 100%;
  min-width: 0;
  overflow-x: hidden;
  box-sizing: border-box;
}

.services-tabs {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 0.375rem;
  margin-bottom: 1.25rem;
  padding: 0.35rem;
  background: linear-gradient(145deg, rgba(18, 49, 70, 0.5) 0%, rgba(24, 58, 82, 0.35) 100%);
  border: 1px solid rgba(120, 180, 220, 0.2);
  border-radius: 14px;
  width: 100%;
  max-width: 36rem;
  box-shadow: 0 0 24px rgba(60, 120, 180, 0.06);
}

.tab-trigger {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.5rem 0.875rem;
  font-size: 0.9375rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.85);
  background: transparent;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: background 0.25s ease, color 0.25s ease, box-shadow 0.25s ease;
  white-space: nowrap;
  flex: 1 1 auto;
  min-width: min(7.5rem, 100%);
  overflow: hidden;
  text-overflow: ellipsis;
}

.tab-trigger:hover {
  background: rgba(255, 255, 255, 0.08);
  color: #fff;
}

.tab-trigger.active {
  background: rgba(255, 255, 255, 0.12);
  color: #fff;
  box-shadow: 0 0 20px rgba(120, 180, 255, 0.12), 0 2px 8px rgba(0, 0, 0, 0.15);
  border: 1px solid rgba(160, 200, 255, 0.2);
}

.tab-trigger:focus-visible {
  outline: 2px solid rgba(255, 255, 255, 0.6);
  outline-offset: 2px;
}

.tab-trigger svg {
  font-size: 1.125rem;
  flex-shrink: 0;
  opacity: 0.9;
}

/* Stack tabs vertically on tablet and mobile to prevent overlap */
@media (max-width: 880px) {
  .services-tabs {
    flex-direction: column;
    flex-wrap: nowrap;
    gap: 0.375rem;
    padding: 0.375rem;
    margin-bottom: 1.25rem;
    max-width: 100%;
  }

  .tab-trigger {
    width: 100%;
    min-width: 0;
    min-height: 2.75rem;
    padding: 0.75rem 1rem;
    font-size: 0.875rem;
    justify-content: center;
    white-space: normal;
    text-align: center;
    line-height: 1.25;
    flex: none;
    overflow: visible;
    text-overflow: clip;
  }

  .tab-trigger span {
    flex: 1;
  }
}

@media (max-width: 640px) {
  .services-page {
    padding: 2rem 1rem 3rem;
  }

  .included-block {
    padding: 1rem 1.25rem;
    margin-bottom: 1.5rem;
  }

  .included-list {
    font-size: 0.875rem;
  }

  .services-section {
    margin-bottom: 2rem;
    padding: 0 0.25rem;
  }

  .section-title {
    font-size: 1.25rem;
  }

  .section-subtitle {
    font-size: 0.9375rem;
  }

  .plan-card,
  .service-card {
    padding: 1.25rem 1rem;
  }

  .cross-cta-section {
    margin-top: 2rem;
    padding: 2rem 1rem;
  }

  .cross-cta-title {
    font-size: 1.25rem;
  }
}

.tab-panels {
  width: 100%;
  max-width: 900px;
}

.tab-panel {
  margin-bottom: 0;
}

.included-block {
  max-width: 38rem;
  width: 100%;
  min-width: 0;
  margin-bottom: 1.5rem;
  padding: 1.15rem 1.5rem;
  background: linear-gradient(145deg, rgba(18, 49, 70, 0.55) 0%, rgba(24, 58, 82, 0.4) 100%);
  border: 1px solid rgba(100, 160, 220, 0.22);
  border-radius: 14px;
  text-align: left;
  box-shadow: 0 0 20px rgba(60, 120, 180, 0.06), 0 4px 16px rgba(0, 0, 0, 0.12);
  box-sizing: border-box;
  overflow-wrap: break-word;
  word-break: break-word;
}

.included-title {
  font-size: 1rem;
  font-weight: 600;
  margin-bottom: 0.75rem;
  letter-spacing: -0.01em;
  color: rgba(255, 255, 255, 0.95);
}

.included-block-title {
  font-size: 0.9375rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
  letter-spacing: -0.01em;
  color: rgba(255, 255, 255, 0.95);
}

.included-web-software {
  margin-bottom: 1.25rem;
  margin-left: auto;
  margin-right: auto;
}

.included-list {
  list-style: none;
  padding: 0;
  margin: 0;
  font-size: 0.9375rem;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.88);
  overflow-wrap: break-word;
  word-break: break-word;
  min-width: 0;

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

/* Slack highlight hero card: below services, above See our work */
.slack-hero-card {
  width: 100%;
  max-width: 42rem;
  margin: 1.75rem auto 2rem;
  padding: 1.15rem 1.35rem;
  background: linear-gradient(145deg, rgba(18, 49, 70, 0.5) 0%, rgba(24, 58, 82, 0.35) 100%);
  border: 1px solid rgba(100, 160, 220, 0.2);
  border-radius: 16px;
  backdrop-filter: blur(8px);
  box-shadow: 0 0 24px rgba(60, 120, 180, 0.06), 0 4px 20px rgba(0, 0, 0, 0.12);
  overflow: hidden;
  box-sizing: border-box;
}

.slack-hero-inner {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 1.25rem;
  min-width: 0;
}

.slack-hero-content {
  flex: 1;
  min-width: 0;
}

.slack-hero-title {
  font-size: 1.125rem;
  font-weight: 700;
  color: #fff;
  margin: 0 0 0.375rem;
  letter-spacing: -0.01em;
}

.slack-hero-text {
  font-size: 0.9375rem;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.82);
  margin: 0 0 1rem;
}

.slack-hero-cta {
  display: inline-flex;
  align-items: center;
  gap: 0.375rem;
  padding: 0.5rem 1rem;
  font-size: 0.9375rem;
  font-weight: 600;
  color: #123146;
  background: #fff;
  border-radius: 10px;
  text-decoration: none;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.slack-hero-cta:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 14px rgba(0, 0, 0, 0.2);
}

.slack-hero-cta svg {
  font-size: 1rem;
  opacity: 0.85;
}

.slack-hero-visual {
  flex: 0 1 auto;
  width: 100%;
  max-width: 220px;
  max-height: 200px;
  min-width: 0;
  border-radius: 10px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.15);
}

.slack-hero-img {
  display: block;
  width: 100%;
  height: auto;
  max-height: 200px;
  object-fit: cover;
  object-position: top left;
  vertical-align: middle;
}

@media (max-width: 520px) {
  .slack-hero-inner {
    flex-direction: column;
    text-align: center;
  }
  .slack-hero-visual {
    max-width: 100%;
    max-height: 220px;
  }
  .slack-hero-img {
    max-height: 220px;
  }
}

.services-section {
  width: 100%;
  max-width: 900px;
  margin-bottom: 2rem;
}

.software-section {
  .software-cta-block {
    max-width: 36rem;
    margin: 0 auto;
    padding: 1.75rem 1.5rem;
    background: rgba(18, 49, 70, 0.5);
    border: 1px solid rgba(84, 117, 128, 0.35);
    border-radius: 14px;
    text-align: center;
  }

  .software-intro {
    font-size: 1rem;
    line-height: 1.6;
    color: rgba(255, 255, 255, 0.88);
    margin: 0 0 1.5rem;
  }

  .cta-software {
    margin-top: 0;
  }
}

.section-title {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
  letter-spacing: -0.02em;
  color: #fff;
}

.section-subtitle {
  font-size: 1rem;
  color: rgba(255, 255, 255, 0.85);
  margin-bottom: 1rem;
  max-width: 36rem;
  margin-left: auto;
  margin-right: auto;
}

.design-deliverables {
  max-width: 28rem;
  margin: 0 auto 1.5rem;
  padding: 1rem 1.25rem;
  background: rgba(18, 49, 70, 0.4);
  border: 1px solid rgba(84, 117, 128, 0.25);
  border-radius: 12px;
  text-align: left;
}

.design-deliverables-title {
  font-size: 0.9375rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.95);
  margin: 0 0 0.5rem;
  letter-spacing: -0.01em;
}

.design-deliverables-list {
  list-style: none;
  padding: 0;
  margin: 0;
  font-size: 0.875rem;
  line-height: 1.55;
  color: rgba(255, 255, 255, 0.88);

  li {
    padding: 0.2rem 0;
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

.design-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1.5rem;
  margin-top: 1rem;
}

@media (max-width: 640px) {
  .design-grid {
    grid-template-columns: 1fr;
  }
}

.service-card {
  background: linear-gradient(145deg, rgba(18, 49, 70, 0.6) 0%, rgba(22, 54, 78, 0.5) 100%);
  border: 1px solid rgba(100, 160, 220, 0.22);
  border-radius: 14px;
  padding: 1.5rem 1.35rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  transition: border-color 0.25s, box-shadow 0.25s, background 0.25s, transform 0.2s;

  &:hover {
    border-color: rgba(120, 180, 220, 0.35);
    box-shadow: 0 0 24px rgba(80, 140, 200, 0.08), 0 8px 28px rgba(0, 0, 0, 0.2);
    background: linear-gradient(145deg, rgba(20, 54, 78, 0.7) 0%, rgba(26, 60, 86, 0.6) 100%);
    transform: translateY(-2px);
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
  gap: 1.25rem;
  max-width: 640px;
  width: 100%;
  margin-top: 0.75rem;
}

@media (max-width: 560px) {
  .plans-grid {
    grid-template-columns: 1fr;
  }
}

.builds-section {
  margin-top: 2rem;
  padding-top: 1.75rem;
  border-top: 1px solid rgba(120, 180, 220, 0.15);
  width: 100%;
  max-width: 900px;
}

.builds-heading {
  font-size: 1.2rem;
  font-weight: 700;
  color: #fff;
  margin: 0 0 0.2rem;
  letter-spacing: -0.02em;
}

.builds-subheading {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.7);
  margin: 0 0 1rem;
}

.builds-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr));
  gap: 1.25rem;
  width: 100%;
  max-width: 900px;
  margin-top: 0;
}

.build-card {
  transition: transform 0.2s ease;
  &:hover {
    transform: translateY(-1px);
  }
  .plan-price .period {
    font-size: 0.9375rem;
    color: rgba(255, 255, 255, 0.7);
  }
}

.build-description {
  font-size: 0.9375rem;
  line-height: 1.55;
  color: rgba(255, 255, 255, 0.82);
  margin: 0 0 1.25rem;
  text-align: center;
  flex: 1;
}

.build-card-cta .build-description {
  margin-bottom: 1rem;
}

/* Nuxt card: high-end, conversion-optimized */
.build-card-nuxt {
  grid-column: 1 / -1;
  max-width: 28rem;
  margin-left: auto;
  margin-right: auto;
  padding: 2rem 1.75rem;
  background: linear-gradient(145deg, rgba(18, 49, 70, 0.75) 0%, rgba(24, 58, 82, 0.6) 100%);
  border: 1px solid rgba(120, 180, 220, 0.25);
  box-shadow: 0 0 32px rgba(80, 140, 200, 0.08), 0 8px 32px rgba(0, 0, 0, 0.2);

  &:hover {
    border-color: rgba(140, 200, 255, 0.35);
    box-shadow: 0 0 40px rgba(100, 160, 220, 0.12), 0 12px 40px rgba(0, 0, 0, 0.22);
    background: linear-gradient(145deg, rgba(20, 54, 78, 0.8) 0%, rgba(28, 62, 88, 0.65) 100%);
  }
}

.build-card-badge {
  display: inline-block;
  font-size: 0.6875rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: rgba(200, 230, 255, 0.95);
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(160, 200, 255, 0.25);
  padding: 0.3rem 0.65rem;
  border-radius: 100px;
  margin-bottom: 0.75rem;
}

.build-card-nuxt-title {
  font-size: 1.5rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  margin-bottom: 1.25rem;
  color: #fff;
}

.build-card-pricing-tiers {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  width: 100%;
  margin-bottom: 1.5rem;
  text-align: left;
}

.build-card-nuxt .pricing-tier {
  display: flex;
  flex-direction: column;
  gap: 0.2rem;
  padding: 0.75rem 1rem;
  background: rgba(0, 0, 0, 0.15);
  border-radius: 10px;
  border: 1px solid rgba(255, 255, 255, 0.06);
}

.build-card-nuxt .pricing-tier-label {
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: rgba(200, 230, 255, 0.9);
}

.build-card-nuxt .pricing-tier-amount {
  font-size: 1.5rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: #fff;
}

.build-card-nuxt .pricing-tier-desc {
  font-size: 0.875rem;
  line-height: 1.45;
  color: rgba(220, 235, 255, 0.85);
}

.build-card-nuxt-cta {
  min-width: 12rem;
  padding: 0.6rem 1.25rem;
  font-weight: 700;
  font-size: 1rem;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);

  &:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.25);
  }
}

@media (max-width: 640px) {
  .build-card-nuxt {
    padding: 1.5rem 1.25rem;
    max-width: 100%;
  }
  .build-card-nuxt-title {
    font-size: 1.3rem;
  }
  .build-card-nuxt .pricing-tier-amount {
    font-size: 1.35rem;
  }
}

.plan-card {
  position: relative;
  background: linear-gradient(145deg, rgba(18, 49, 70, 0.6) 0%, rgba(22, 54, 78, 0.5) 100%);
  border: 1px solid rgba(100, 160, 220, 0.22);
  border-radius: 14px;
  padding: 1.5rem 1.35rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  transition: border-color 0.25s, box-shadow 0.25s, background 0.25s, transform 0.2s;

  &:hover {
    border-color: rgba(120, 180, 220, 0.35);
    box-shadow: 0 0 24px rgba(80, 140, 200, 0.08), 0 6px 24px rgba(0, 0, 0, 0.18);
    background: linear-gradient(145deg, rgba(20, 54, 78, 0.7) 0%, rgba(26, 60, 86, 0.6) 100%);
    transform: translateY(-1px);
  }

  &.featured {
    border-color: rgba(140, 200, 255, 0.28);
    box-shadow: 0 0 28px rgba(100, 160, 220, 0.1), 0 6px 24px rgba(0, 0, 0, 0.2);
    background: linear-gradient(145deg, rgba(22, 54, 78, 0.7) 0%, rgba(28, 62, 88, 0.6) 100%);
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
    background: #fff;
    color: #123146;
    font-size: 0.7rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    padding: 0.25rem 0.65rem;
    border-radius: 999px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
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
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  text-decoration: none;
  transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
  text-align: center;

  &:hover:not(:disabled) {
    transform: translateY(-2px);
  }

  &:disabled {
    opacity: 0.8;
    cursor: not-allowed;
  }

  &.cta-primary {
    background: #fff;
    color: #123146;
    font-weight: 700;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.12);

    &:hover:not(:disabled) {
      background: #f0f4f8;
      box-shadow: 0 6px 24px rgba(0, 0, 0, 0.22);
    }

    &:focus-visible {
      outline: 2px solid rgba(255, 255, 255, 0.8);
      outline-offset: 3px;
    }
  }

  &.cta-featured {
    background: #fff;
    color: #123146;
    font-weight: 700;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);

    &:hover:not(:disabled) {
      background: #f0f4f8;
      box-shadow: 0 8px 28px rgba(0, 0, 0, 0.25);
    }
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

/* Cross-page CTA: See our work — conversion-focused */
.cross-cta-section {
  margin-top: 2.5rem;
  padding: 2rem 1.35rem;
  text-align: center;
  background: linear-gradient(145deg, rgba(18, 49, 70, 0.45) 0%, rgba(24, 58, 82, 0.3) 100%);
  border: 1px solid rgba(120, 180, 220, 0.2);
  border-radius: 20px;
  backdrop-filter: blur(8px);
  max-width: 36rem;
  box-shadow: 0 0 28px rgba(60, 120, 180, 0.06);
}

.cross-cta-title {
  font-size: 1.3rem;
  font-weight: 700;
  color: #fff;
  margin: 0 0 0.35rem;
  letter-spacing: -0.02em;
}

.cross-cta-subtitle {
  font-size: 0.9375rem;
  color: rgba(255, 255, 255, 0.78);
  margin: 0 0 1.25rem;
}

.cross-cta-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.7rem 1.35rem;
  font-size: 1rem;
  font-weight: 700;
  color: #123146;
  background: #fff;
  border-radius: 10px;
  text-decoration: none;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.12);
}

.cross-cta-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 24px rgba(0, 0, 0, 0.22);
}

.cross-cta-button svg {
  font-size: 1.1rem;
  transition: transform 0.2s ease;
}

.cross-cta-button:hover svg {
  transform: translateX(3px);
}
</style>
