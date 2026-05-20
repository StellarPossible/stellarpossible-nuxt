<template>
  <section class="services-page">
    <!-- Tabs: zero scroll, one panel at a time -->
    <div
      class="services-tabs"
      role="tablist"
      aria-label="Service categories"
      @keydown.left.prevent="navigateTab(-1)"
      @keydown.right.prevent="navigateTab(1)"
    >
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
        :aria-selected="activeTab === 'nuxt'"
        :class="['tab-trigger', { active: activeTab === 'nuxt' }]"
        @click="activeTab = 'nuxt'"
      >
        <ClientOnly>
          <Icon icon="simple-icons:nuxtdotjs" aria-hidden />
          <template #fallback><span aria-hidden>◆</span></template>
        </ClientOnly>
        <span>Nuxt.js</span>
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
      <Transition name="tab-fade" mode="out-in">
        <div
          :key="activeTab"
          role="tabpanel"
          class="tab-panel"
          :aria-hidden="false"
        >
          <!-- Tool Development panel content -->
          <div v-if="activeTab === 'software'" class="services-section software-section">
            <div class="included-row">
              <ClientOnly>
                <Icon icon="mdi:video" aria-hidden />
                <template #fallback><span>▶</span></template>
              </ClientOnly>
              <span>30-min consult with Marine</span>
              <span class="sep" aria-hidden>·</span>
              <ClientOnly>
                <Icon icon="mdi:message-text" aria-hidden />
                <template #fallback><span>💬</span></template>
              </ClientOnly>
              <span>Slack Hub</span>
            </div>
            <div class="software-cta-block">
              <p class="software-intro">
                Scripts, internal tools, APIs, automations—we scope, agree on a fixed price, and deliver.
              </p>
              <button type="button" class="cta-button cta-primary cta-software" @click="openContact">
                Contact
              </button>
            </div>
          </div>
          <!-- Nuxt.js panel: custom platforms, fullstack vs frontend-only -->
          <div v-else-if="activeTab === 'nuxt'" class="services-section nuxt-section">
            <p class="nuxt-intro">
              Custom web apps and platforms built to your needs—scoped from the start, designed to scale as you grow.
            </p>
            <div class="nuxt-scenarios">
              <div class="nuxt-scenario-card">
                <h3 class="nuxt-scenario-title">Fullstack (Nuxt + CMS)</h3>
                <p class="nuxt-scenario-desc">When you need editable content, SEO control, and a content team that can update copy and pages without code. Ideal for marketing sites, blogs, and product launches that evolve over time.</p>
                <p class="nuxt-scenario-price"><strong>$4,500</strong> starting</p>
              </div>
              <div class="nuxt-scenario-card">
                <h3 class="nuxt-scenario-title">Frontend-only</h3>
                <p class="nuxt-scenario-desc">When your content is static, from an external API, or managed elsewhere. Faster to ship, lower cost—still fully customized and scalable when you’re ready to add features or integrate more tools.</p>
                <p class="nuxt-scenario-price"><strong>$2,500</strong> starting</p>
              </div>
            </div>
            <p class="nuxt-scale-note">Every project is scoped to your exact needs and can grow with you—new pages, integrations, or a move to fullstack when the time is right.</p>
            <button
              type="button"
              class="cta-button cta-primary nuxt-cta"
              aria-label="Contact Stellar Possible about your Nuxt.js project"
              @click="openContact"
            >
              Contact
            </button>
          </div>
          <!-- Web Management panel: two-column layout -->
          <div v-else-if="activeTab === 'hosting'" class="services-section hosting-section">
            <div class="included-row">
              <ClientOnly>
                <Icon icon="mdi:video" aria-hidden />
                <template #fallback><span>▶</span></template>
              </ClientOnly>
              <span>30-min consult</span>
              <span class="sep" aria-hidden>·</span>
              <ClientOnly>
                <Icon icon="mdi:message-text" aria-hidden />
                <template #fallback><span>💬</span></template>
              </ClientOnly>
              <span>Slack Hub</span>
            </div>
            <div class="hosting-two-col">
              <div class="hosting-col hosting-plans">
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
              :to="primaryCtaPath"
              class="cta-button cta-primary"
              :class="{ 'cta-featured': plan.featured }"
            >
              {{ primaryCtaLabel }}
            </NuxtLink>
          </template>
        </article>
                </div>
              </div>
              <div class="hosting-col hosting-builds">
                <h3 class="builds-heading">Website builds</h3>
                <div class="builds-grid builds-grid-compact">
                  <article class="plan-card build-card">
                    <h3 class="plan-name">Single-page site</h3>
                    <div class="plan-price">
                      <span class="amount">$550</span>
                      <span class="period"></span>
                    </div>
                    <p class="build-description">One-page site for portfolios, landing pages, or focused business presence.</p>
                  </article>
                  <article class="plan-card build-card">
                    <h3 class="plan-name">Additional pages</h3>
                    <div class="plan-price">
                      <span class="amount">$400</span>
                      <span class="period">/page</span>
                    </div>
                    <p class="build-description">Add pages per need. Priced per page.</p>
                  </article>
                </div>
              </div>
            </div>
          </div>
        </div>
      </Transition>
    </div>

    <!-- Slim strip: primary CTA + contact + Slack + Our Work -->
    <div class="services-strip" role="complementary" aria-label="Quick links">
      <NuxtLink :to="primaryCtaPath" class="strip-link">
        {{ primaryCtaLabel }}
        <ClientOnly>
          <Icon icon="mdi:arrow-right" aria-hidden />
          <template #fallback><span aria-hidden>→</span></template>
        </ClientOnly>
      </NuxtLink>
      <span class="strip-sep" aria-hidden>·</span>
      <button type="button" class="strip-link strip-link-button" @click="openContact">
        Contact
        <ClientOnly>
          <Icon icon="mdi:message-text-outline" aria-hidden />
          <template #fallback><span aria-hidden>✉</span></template>
        </ClientOnly>
      </button>
      <span class="strip-sep" aria-hidden>·</span>
      <a
        href="https://stellarpossible.slack.com"
        target="_blank"
        rel="noopener noreferrer"
        class="strip-link"
      >
        Slack Hub
        <ClientOnly>
          <Icon icon="mdi:open-in-new" aria-hidden />
          <template #fallback><span aria-hidden>↗</span></template>
        </ClientOnly>
      </a>
      <span class="strip-sep" aria-hidden>·</span>
      <NuxtLink to="/products" class="strip-link">
        Our Work
        <ClientOnly>
          <Icon icon="mdi:arrow-right" aria-hidden />
          <template #fallback><span aria-hidden>→</span></template>
        </ClientOnly>
      </NuxtLink>
    </div>
  </section>
</template>

<script setup lang="ts">
import { servicesHeaderHeroKey } from '~/composables/usePageHero'

type PlanId = 'monthly' | 'addon'

const { path: primaryCtaPath, label: primaryCtaLabel } = usePrimaryCta()

type TabId = 'software' | 'nuxt' | 'hosting'
const activeTab = ref<TabId>('hosting')

const servicesHeaderHero = useState<{ title: string; subtitle: string } | null>(servicesHeaderHeroKey, () => null)

const tabHeroContent: Record<TabId, { title: string; subtitle: string }> = {
  software: {
    title: 'Tool Development',
    subtitle: 'Custom software, scripts, tools, and integrations. From one-off automations to full applications—built to your specs.'
  },
  nuxt: {
    title: 'Nuxt.js platforms',
    subtitle: 'Custom web apps scoped to your needs—fullstack or frontend-only, built to scale over time.'
  },
  hosting: {
    title: 'Web Management',
    subtitle: 'Reliable hosting for your site. Monthly billing.'
  }
}

const tabOrder: TabId[] = ['software', 'nuxt', 'hosting']
function navigateTab(delta: number) {
  const i = tabOrder.indexOf(activeTab.value)
  const next = (i + delta + tabOrder.length) % tabOrder.length
  activeTab.value = tabOrder[next]
}

watch(activeTab, (tab) => {
  servicesHeaderHero.value = tabHeroContent[tab] ?? null
}, { immediate: true })

onBeforeUnmount(() => {
  servicesHeaderHero.value = null
})

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

const { open: openContactModal } = useContactModal()

function openContact() {
  openContactModal()
}

useHead({
  title: 'Services | StellarPossible',
  meta: [
    {
      name: 'description',
      content: 'Managed hosting, website builds, custom tools and integrations, and Nuxt.js platforms—scoped with clarity. Includes consult with Marine, Slack Hub collaboration, and clear pricing.'
    }
  ]
})
</script>

<style scoped lang="scss">
/* No-scroll: constrain to viewport (desktop) — high-end, polished */
.services-page {
  --services-height: calc(100dvh - var(--site-header-height, 5rem) - var(--site-footer-height, 3rem));
  --accent-glow: rgba(140, 200, 255, 0.15);
  --card-glass: linear-gradient(160deg, rgba(18, 45, 65, 0.72) 0%, rgba(14, 38, 55, 0.58) 100%);
  --card-border: 1px solid rgba(120, 180, 255, 0.18);
  padding: 0.5rem 1.5rem 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #fff;
  background: rgba(0, 0, 0, 0.28);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  text-align: center;
  width: 100%;
  max-width: 100%;
  min-width: 0;
  overflow-x: hidden;
  box-sizing: border-box;
  height: var(--services-height);
  max-height: var(--services-height);
  overflow-y: hidden;
}

/* Tab transition */
.tab-fade-enter-active,
.tab-fade-leave-active {
  transition: opacity 0.2s ease;
}
.tab-fade-enter-from,
.tab-fade-leave-to {
  opacity: 0;
}

/* Included row: compact 1-line */
.included-row {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: center;
  gap: 0.3rem 0.5rem;
  font-size: 0.8rem;
  color: rgba(255, 255, 255, 0.86);
  margin-bottom: 0.65rem;
  flex-shrink: 0;
}

.included-row .sep {
  opacity: 0.5;
}

.included-row svg {
  font-size: 1rem;
  opacity: 0.9;
}

/* Hosting: two-column, compact — fits viewport, no scroll */
.hosting-two-col {
  display: grid;
  grid-template-columns: 1fr 1.4fr;
  gap: 1rem;
  width: 100%;
  max-width: 960px;
  margin: 0 auto;
  flex: 1;
  min-height: 0;
  align-content: start;
}

.hosting-col {
  min-width: 0;
}

.hosting-builds .builds-heading {
  font-size: 0.875rem;
  font-weight: 600;
  letter-spacing: 0.02em;
  margin: 0 0 0.5rem;
  color: rgba(255, 255, 255, 0.9);
}

.builds-grid-compact {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 0.85rem;
}

.builds-grid-compact .build-card {
  padding: 0.85rem 1rem;
}

.builds-grid-compact .build-description {
  font-size: 0.75rem;
  line-height: 1.4;
  margin-bottom: 0.6rem;
}

/* Slim strip: refined quick links */
.services-strip {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.4rem 0.6rem;
  padding: 0.4rem 1rem;
  flex-shrink: 0;
  min-height: 2.25rem;
  border-top: 1px solid rgba(255, 255, 255, 0.06);
}

.strip-link {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  font-size: 0.8rem;
  font-weight: 600;
  letter-spacing: 0.02em;
  color: rgba(255, 255, 255, 0.82);
  text-decoration: none;
  transition: color 0.2s ease;
}

.strip-link:hover {
  color: #fff;
}

.strip-link-button {
  background: transparent;
  border: none;
  cursor: pointer;
  font-family: inherit;
}

.strip-link:focus-visible {
  outline: 2px solid rgba(255, 255, 255, 0.45);
  outline-offset: 2px;
}

.strip-sep {
  opacity: 0.35;
  font-size: 0.7rem;
}

.services-tabs {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 0.3rem;
  margin-bottom: 0.6rem;
  padding: 0.3rem;
  background: var(--card-glass);
  border: var(--card-border);
  border-radius: 12px;
  width: 100%;
  max-width: 34rem;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.12), 0 0 1px rgba(255, 255, 255, 0.06);
  flex-shrink: 0;
}

.tab-trigger {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.4rem;
  padding: 0.45rem 0.8rem;
  font-size: 0.875rem;
  font-weight: 600;
  letter-spacing: 0.01em;
  color: rgba(255, 255, 255, 0.82);
  background: transparent;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: background 0.2s ease, color 0.2s ease, box-shadow 0.2s ease;
  white-space: nowrap;
  flex: 1 1 auto;
  min-width: min(7rem, 100%);
  overflow: hidden;
  text-overflow: ellipsis;
}

.tab-trigger:hover {
  background: rgba(255, 255, 255, 0.06);
  color: rgba(255, 255, 255, 0.95);
}

.tab-trigger.active {
  background: rgba(255, 255, 255, 0.14);
  color: #fff;
  box-shadow: 0 0 24px var(--accent-glow), 0 2px 12px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(160, 210, 255, 0.25);
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

  .plan-card {
    padding: 1.25rem 1rem;
  }
}

.tab-panels {
  width: 100%;
  max-width: 960px;
  flex: 1;
  min-height: 0;
  overflow-y: hidden;
  overflow-x: hidden;
  display: flex;
  flex-direction: column;
}

.tab-panel {
  margin-bottom: 0;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  overflow: hidden;
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

.services-section {
  width: 100%;
  max-width: 960px;
  margin-bottom: 0;
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.software-section {
  .software-cta-block {
    max-width: 34rem;
    margin: 0 auto;
    padding: 1.25rem 1.5rem;
    background: var(--card-glass);
    border: var(--card-border);
    border-radius: 12px;
    text-align: center;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  }

  .software-intro {
    font-size: 0.9375rem;
    line-height: 1.55;
    color: rgba(255, 255, 255, 0.88);
    margin: 0 0 1.25rem;
  }

  .cta-software {
    margin-top: 0;
  }
}

/* Nuxt.js panel: scenario cards + scale message */
.nuxt-section {
  max-width: 52rem;
}

.nuxt-intro {
  font-size: 0.9375rem;
  line-height: 1.55;
  color: rgba(255, 255, 255, 0.9);
  margin: 0 0 1rem;
  max-width: 36rem;
}

.nuxt-scenarios {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
  width: 100%;
  margin-bottom: 1rem;
}

.nuxt-scenario-card {
  background: var(--card-glass);
  border: var(--card-border);
  border-radius: 12px;
  padding: 1rem 1.15rem;
  text-align: left;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  transition: border-color 0.2s, box-shadow 0.2s;

  &:hover {
    border-color: rgba(120, 180, 220, 0.28);
    box-shadow: 0 0 20px var(--accent-glow);
  }
}

.nuxt-scenario-title {
  font-size: 1rem;
  font-weight: 700;
  letter-spacing: -0.01em;
  color: #fff;
  margin: 0 0 0.5rem;
}

.nuxt-scenario-desc {
  font-size: 0.8125rem;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.85);
  margin: 0 0 0.65rem;
}

.nuxt-scenario-price {
  font-size: 0.875rem;
  color: rgba(200, 230, 255, 0.95);
  margin: 0;
}

.nuxt-scale-note {
  font-size: 0.8125rem;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.8);
  margin: 0 0 1rem;
  max-width: 40rem;
}

.nuxt-cta {
  flex-shrink: 0;
}

@media (max-width: 640px) {
  .nuxt-scenarios {
    grid-template-columns: 1fr;
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

.plans-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 0.85rem;
  width: 100%;
  min-width: 0;
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

/* Nuxt card: compact, conversion-optimized */
.build-card-nuxt {
  grid-column: 1 / -1;
  padding: 1rem 1.25rem;
  background: var(--card-glass);
  border: var(--card-border);
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.15), 0 0 1px rgba(255, 255, 255, 0.08);

  &:hover {
    border-color: rgba(140, 200, 255, 0.3);
    box-shadow: 0 0 28px var(--accent-glow), 0 8px 28px rgba(0, 0, 0, 0.18);
  }
}

.build-card-badge {
  display: inline-block;
  font-size: 0.65rem;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: rgba(200, 230, 255, 0.95);
  background: rgba(255, 255, 255, 0.06);
  border: 1px solid rgba(160, 200, 255, 0.2);
  padding: 0.25rem 0.5rem;
  border-radius: 100px;
  margin-bottom: 0.5rem;
}

.build-card-nuxt-title {
  font-size: 1.1rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  margin-bottom: 0.5rem;
  color: #fff;
}

.build-card-pricing-tiers {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 0.5rem;
  width: 100%;
  margin-bottom: 0.75rem;
  text-align: left;
}

.build-card-nuxt .pricing-tier {
  flex: 1;
  min-width: 8rem;
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
  padding: 0.5rem 0.75rem;
  background: rgba(0, 0, 0, 0.12);
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.build-card-nuxt .pricing-tier-label {
  font-size: 0.65rem;
  font-weight: 700;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: rgba(200, 230, 255, 0.9);
}

.build-card-nuxt .pricing-tier-amount {
  font-size: 1.25rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: #fff;
}

.build-card-nuxt .pricing-tier-desc {
  font-size: 0.75rem;
  line-height: 1.4;
  color: rgba(220, 235, 255, 0.82);
}

.build-card-nuxt-cta {
  min-width: 10rem;
  padding: 0.5rem 1rem;
  font-weight: 700;
  font-size: 0.875rem;
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
  background: var(--card-glass);
  border: var(--card-border);
  border-radius: 12px;
  padding: 1rem 1.1rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  transition: border-color 0.2s, box-shadow 0.2s, background 0.2s, transform 0.2s;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);

  &:hover {
    border-color: rgba(120, 180, 220, 0.3);
    box-shadow: 0 0 20px var(--accent-glow), 0 6px 20px rgba(0, 0, 0, 0.15);
    transform: translateY(-1px);
  }

  &.featured {
    border-color: rgba(140, 200, 255, 0.28);
    box-shadow: 0 0 24px var(--accent-glow), 0 6px 20px rgba(0, 0, 0, 0.15);
  }

  .plan-name {
    font-size: 1.1rem;
    font-weight: 600;
    margin-bottom: 0.25rem;
    letter-spacing: -0.01em;
  }

  .plan-badge {
    position: absolute;
    top: -0.35rem;
    left: 50%;
    transform: translateX(-50%);
    background: #fff;
    color: #123146;
    font-size: 0.65rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    padding: 0.2rem 0.5rem;
    border-radius: 999px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  }

  .plan-price {
    margin-bottom: 0.1rem;

    .amount {
      font-size: 1.5rem;
      font-weight: 700;
      letter-spacing: -0.02em;
    }

    .period {
      font-size: 0.875rem;
      color: rgba(255, 255, 255, 0.68);
    }
  }

  .savings {
    font-size: 0.75rem;
    color: rgba(255, 255, 255, 0.88);
    margin-bottom: 0.5rem;
    font-weight: 500;
  }

  .plan-features {
    list-style: none;
    padding: 0;
    margin: 0 0 0.85rem;
    text-align: left;
    width: 100%;

    li {
      padding: 0.2rem 0;
      padding-left: 1.1rem;
      position: relative;
      font-size: 0.8125rem;
      color: rgba(255, 255, 255, 0.86);

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

.hosting-section {
  width: 100%;
}

.cta-button {
  display: inline-block;
  margin-top: auto;
  padding: 0.55rem 1.15rem;
  font-size: 0.9rem;
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

/* Mobile: allow scroll, min-height fallback */
@media (max-width: 768px) {
  .services-page {
    height: auto;
    min-height: var(--services-height);
    max-height: none;
    overflow-y: auto;
    padding-left: max(0.75rem, env(safe-area-inset-left));
    padding-right: max(0.75rem, env(safe-area-inset-right));
  }

  .tab-panels {
    overflow-y: auto;
    flex: 1 1 auto;
  }

  .services-strip {
    flex-wrap: wrap;
    justify-content: center;
    row-gap: 0.35rem;
    column-gap: 0.45rem;
    padding-left: max(0.5rem, env(safe-area-inset-left));
    padding-right: max(0.5rem, env(safe-area-inset-right));
    padding-bottom: max(0.35rem, env(safe-area-inset-bottom));
  }

  .services-strip .strip-link {
    font-size: clamp(0.72rem, 3.5vw, 0.78rem);
  }
}

/* Short viewport fallback */
@media (max-height: 700px) {
  .services-page {
    overflow-y: auto;
  }

  .tab-panels {
    overflow-y: auto;
  }
}

@media (max-width: 900px) {
  .hosting-two-col {
    grid-template-columns: 1fr;
  }

  .builds-grid-compact {
    grid-template-columns: 1fr;
  }

  .build-card-nuxt .pricing-tier {
    min-width: 100%;
  }
}
</style>
