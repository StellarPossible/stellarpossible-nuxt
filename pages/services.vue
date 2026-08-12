<template>
  <PageShell class="services-landing">
    <header class="services-hero">
      <h1 class="services-hero__title">Services</h1>
      <p class="services-hero__lead">Scoped with clarity. Delivered with care — hosting, builds, and custom tools for teams who value thoughtful engineering.</p>
    </header>

    <SectionShell class="services-content">
      <Reveal>
        <div class="services-grid">
          <GlassCard :hover="false" :pad="false" class="service-panel">
            <span class="services-label">Custom development</span>
            <p class="service-panel__lead">From one-off automations to full applications — built to your specs with transparent pricing.</p>
            <ul class="feature-list">
              <li v-for="item in toolFeatures" :key="item">
                <Icon icon="mdi:check-circle" aria-hidden="true" />
                <span>{{ item }}</span>
              </li>
            </ul>
            <AppButton variant="primary" @click="openContact">Contact for a quote</AppButton>
          </GlassCard>

          <div class="pricing-block">
            <div class="pricing-block__header">
              <span class="services-label">Website &amp; hosting</span>
            </div>

            <div class="pricing-grid">
              <GlassCard :hover="false" :pad="false" class="pricing-card pricing-card--featured">
                <div class="pricing-card__accent" aria-hidden="true" />
                <span class="pricing-card__badge">Most popular</span>
                <h3 class="pricing-card__title">{{ hostingPlan.name }}</h3>
                <p class="pricing-card__price">
                  <span class="pricing-card__amount">{{ hostingPlan.priceDisplay }}</span>
                  <span class="pricing-card__period">{{ hostingPlan.period }}</span>
                </p>
                <ul class="pricing-card__features">
                  <li v-for="f in hostingPlan.features" :key="f">{{ f }}</li>
                </ul>
                <p v-if="hostingPlan.maintenanceNote" class="pricing-card__note">{{ hostingPlan.maintenanceNote }}</p>
                <AppButton :to="primaryCtaPath" variant="primary" class="pricing-card__cta" block>
                  {{ primaryCtaLabel }}
                </AppButton>
              </GlassCard>

              <GlassCard
                v-for="build in siteBuilds"
                :key="build.name"
                :hover="false"
                :pad="false"
                class="pricing-card build-card"
              >
                <p class="build-card__price">{{ build.price }}</p>
                <p class="build-card__hosting">+ monthly hosting</p>
                <h3 class="build-card__name">{{ build.name }}</h3>
                <p class="build-card__desc">{{ build.description }}</p>
                <ul class="build-card__features">
                  <li v-for="f in build.features" :key="f">{{ f }}</li>
                </ul>
              </GlassCard>
            </div>

            <p class="pricing-block__domain-note">
              <Icon icon="mdi:web" class="pricing-block__domain-icon" aria-hidden="true" />
              {{ domainNote }}
            </p>
          </div>
        </div>

        <GlassCard :hover="false" :pad="false" class="cta-card">
          <h2 class="cta-card__title">Ready to get started?</h2>
          <p class="cta-card__lead">Pick a plan, scope a build, or tell us what you need — we'll respond with clear next steps.</p>
          <div class="cta-actions">
            <AppButton :to="primaryCtaPath" variant="primary" size="lg">{{ primaryCtaLabel }}</AppButton>
            <AppButton variant="ghost" size="lg" @click="openContact">Contact</AppButton>
          </div>
        </GlassCard>
      </Reveal>
    </SectionShell>
  </PageShell>
</template>

<script setup lang="ts">
const { path: primaryCtaPath, label: primaryCtaLabel } = usePrimaryCta()
const { open: openContactModal } = useContactModal()

function openContact() {
  openContactModal()
}

const toolFeatures = [
  'Internal tools, scripts, and API integrations',
  'Fixed-price quotes after scoping',
  'Documentation and handoff included',
  'Optional ongoing support via hosting plan'
]

const hostingPlan = {
  name: 'Managed hosting',
  priceDisplay: '$30',
  period: '/month',
  features: [
    'Managed hosting & platform updates',
    '1 maintenance hour per month',
    'Billed monthly',
    'Cancel anytime'
  ],
  maintenanceNote:
    'Maintenance only — not new development. Covers general site upkeep, asset updates, and minor copy changes.'
}

const siteBuilds = [
  {
    name: 'Single-page site',
    price: '$550',
    description: 'Portfolio, landing page, or focused business presence — built and launched on StellarPossible hosting.',
    features: [
      'Current site & domain migration included',
      'DNS setup on the StellarPossible server',
      'Responsive design tuned for your content'
    ]
  },
  {
    name: 'Additional pages',
    price: '$400',
    description: 'Per page, scoped to your content and design — added to your existing SP-hosted site.',
    features: [
      'Consistent with your site design system',
      'Content layout scoped with you',
      'Migration support for expanded sites'
    ]
  }
]

const domainNote =
  'Bring your domain, or get a brand new one with StellarPossible. We take care of it all. Domain registration fees vary.'

const config = useRuntimeConfig()
const siteUrl = ((config.public.siteUrl as string) || 'https://stellarpossible.com').replace(/\/$/, '')

useSeo({
  title: 'Services | StellarPossible',
  description: 'Managed hosting, website builds, and custom tools — scoped with clarity.',
  path: '/services',
  jsonLd: [
    organizationJsonLd(siteUrl),
    {
      '@context': 'https://schema.org',
      '@type': 'Service',
      name: 'StellarPossible Web Services',
      provider: { '@type': 'Organization', name: 'StellarPossible', url: siteUrl },
      description: 'Managed hosting, custom tools, and website builds.',
      areaServed: 'US',
      offers: [
        { '@type': 'Offer', name: 'Managed hosting', price: '30', priceCurrency: 'USD' }
      ]
    }
  ]
})
</script>

<style scoped lang="scss">
.services-landing {
  padding-bottom: var(--space-12);
}

.services-content {
  padding-top: 0 !important;
}

.services-hero {
  text-align: center;
  max-width: 42rem;
  margin: 0 auto var(--space-8);
  padding-inline: var(--space-4);
}

.services-hero__title {
  font-family: var(--font-display);
  font-size: var(--fs-700);
  font-weight: 500;
  letter-spacing: -0.02em;
  margin: 0 0 var(--space-4);
  line-height: 1.1;
}

.services-hero__lead {
  font-size: var(--fs-300);
  color: var(--color-text-muted);
  margin: 0;
  line-height: 1.55;
}

.services-label {
  display: block;
  font-family: var(--font-ui);
  font-size: var(--fs-100);
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--color-gold);
  margin-bottom: var(--space-3);
}

.services-grid {
  display: grid;
  gap: var(--space-8);
  margin-bottom: var(--space-8);
}

.service-panel {
  padding: var(--space-8);
  border-color: var(--color-border);
}

.service-panel__lead {
  font-size: var(--fs-300);
  color: var(--color-text-muted);
  line-height: 1.6;
  margin: 0 0 var(--space-6);
  max-width: 40rem;
}

.feature-list {
  list-style: none;
  margin: 0 0 var(--space-6);
  padding: 0;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(14rem, 1fr));
  gap: var(--space-3) var(--space-6);

  li {
    display: flex;
    align-items: flex-start;
    gap: var(--space-3);
    font-size: var(--fs-200);
    color: var(--color-text-muted);
    line-height: 1.5;

    svg {
      flex-shrink: 0;
      font-size: 1.125rem;
      color: var(--color-success);
      margin-top: 0.1rem;
    }
  }
}

.pricing-block__header {
  margin-bottom: var(--space-5);
}

.pricing-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--space-4);
  align-items: stretch;
}

.pricing-card {
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
  padding: var(--space-6);
  min-height: 100%;
}

.pricing-card--featured {
  border-color: var(--color-border-strong);
  box-shadow: var(--shadow-lg), var(--shadow-glow);
}

.pricing-card__accent {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(
    90deg,
    transparent 0%,
    var(--color-accent) 25%,
    var(--color-aurora) 50%,
    var(--color-accent) 75%,
    transparent 100%
  );
}

.pricing-card__badge {
  align-self: flex-start;
  font-family: var(--font-ui);
  font-size: var(--fs-100);
  font-weight: 700;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: var(--color-gold);
  background: var(--color-gold-soft);
  border: 1px solid var(--color-gold-border);
  border-radius: var(--radius-pill);
  padding: var(--space-1) var(--space-3);
}

.pricing-card__title {
  font-family: var(--font-display);
  font-size: var(--fs-400);
  margin: 0;
  line-height: 1.2;
}

.pricing-card__price {
  margin: var(--space-1) 0;
}

.pricing-card__amount {
  font-family: var(--font-display);
  font-size: var(--fs-600);
  color: var(--color-accent);
}

.pricing-card__period {
  font-size: var(--fs-200);
  color: var(--color-text-muted);
  margin-left: var(--space-1);
}

.pricing-card__features {
  margin: 0 0 var(--space-4);
  padding-left: var(--space-5);
  color: var(--color-text-muted);
  font-size: var(--fs-200);
  line-height: 1.6;
  flex: 1;

  li + li {
    margin-top: var(--space-1);
  }
}

.pricing-card__note {
  margin: 0 0 var(--space-4);
  font-size: var(--fs-100);
  color: var(--color-text-subtle);
  line-height: 1.55;
  text-align: left;
}

.pricing-card__cta {
  margin-top: auto;
}

.build-card {
  text-align: center;
  align-items: center;
}

.build-card__price {
  font-family: var(--font-display);
  font-size: var(--fs-600);
  font-weight: 600;
  color: var(--color-accent);
  margin: 0;
  line-height: 1;
}

.build-card__hosting {
  margin: var(--space-1) 0 var(--space-3);
  font-family: var(--font-ui);
  font-size: var(--fs-100);
  font-weight: 600;
  letter-spacing: 0.04em;
  color: var(--color-text-subtle);
}

.build-card__name {
  font-family: var(--font-display);
  font-size: var(--fs-300);
  margin: 0 0 var(--space-2);
  line-height: 1.2;
}

.build-card__desc {
  margin: 0;
  font-size: var(--fs-200);
  color: var(--color-text-muted);
  line-height: 1.55;
}

.build-card__features {
  margin: var(--space-3) 0 0;
  padding-left: var(--space-5);
  text-align: left;
  width: 100%;
  color: var(--color-text-muted);
  font-size: var(--fs-100);
  line-height: 1.55;

  li + li {
    margin-top: var(--space-1);
  }
}

.pricing-block__domain-note {
  display: flex;
  align-items: flex-start;
  gap: var(--space-3);
  margin: var(--space-6) 0 0;
  padding: var(--space-4) var(--space-5);
  font-size: var(--fs-200);
  color: var(--color-text-muted);
  line-height: 1.55;
  background: var(--color-accent-soft);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
}

.pricing-block__domain-icon {
  flex-shrink: 0;
  font-size: 1.25rem;
  color: var(--color-accent);
  margin-top: 0.1rem;
}

.cta-card {
  text-align: center;
  padding: var(--space-10) var(--space-8) !important;
  border-color: var(--color-border-strong);
}

.cta-card__title {
  font-family: var(--font-display);
  font-size: var(--fs-600);
  font-weight: 500;
  margin: 0 0 var(--space-4);
  letter-spacing: -0.01em;
}

.cta-card__lead {
  font-size: var(--fs-300);
  color: var(--color-text-muted);
  margin: 0 0 var(--space-8);
  max-width: 32rem;
  margin-inline: auto;
  line-height: 1.55;
}

.cta-actions {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: var(--space-3);
}

@media (max-width: 960px) {
  .pricing-grid {
    grid-template-columns: 1fr;
    max-width: 22rem;
    margin-inline: auto;
  }

  .feature-list {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .service-panel {
    padding: var(--space-6);
  }
}

@media (max-width: 480px) {
  .services-hero__title {
    font-size: var(--fs-600);
  }

  .cta-card {
    padding: var(--space-6) !important;
  }

  .cta-actions {
    flex-direction: column;
    align-items: stretch;
  }

  .cta-actions :deep(.app-btn) {
    width: 100%;
  }

  .pricing-card__amount,
  .build-card__price {
    font-size: var(--fs-500);
  }
}
</style>
