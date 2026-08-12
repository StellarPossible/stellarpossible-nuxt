<template>
  <PageShell flush-top class="landing">
    <HomeHero />

    <SectionShell id="offerings">
      <Reveal>
        <div class="offerings-grid">
          <Reveal v-for="(offering, i) in offerings" :key="offering.to" :delay="i * 80">
            <GlassCard :to="offering.to" class="offering-card">
              <ClientOnly><Icon :icon="offering.icon" class="offering-icon" aria-hidden /></ClientOnly>
              <h3>{{ offering.title }}</h3>
              <p>{{ offering.description }}</p>
              <span class="offering-link">Learn more →</span>
            </GlassCard>
          </Reveal>
        </div>
      </Reveal>
    </SectionShell>

    <SectionShell narrow>
      <Reveal>
        <GlassCard class="final-cta__card" :hover="false">
          <h2>Ready to build something stellar?</h2>
          <p>Get started with a free account or reach out to discuss your project.</p>
          <div class="final-cta__actions">
            <AppButton :to="primaryCtaPath" variant="primary" size="lg">{{ primaryCtaLabel }}</AppButton>
            <AppButton variant="ghost" size="lg" @click="openContact">Contact us</AppButton>
          </div>
        </GlassCard>
      </Reveal>
    </SectionShell>
  </PageShell>
</template>

<script setup lang="ts">
const offerings = [
  {
    to: '/services#software',
    icon: 'mdi:code-tags',
    title: 'Tool Development',
    description: 'Scripts, internal tools, APIs, and automations — scoped, fixed-price, delivered.'
  },
  {
    to: '/services#nuxt',
    icon: 'simple-icons:nuxtdotjs',
    title: 'Nuxt.js Platforms',
    description: 'Custom web apps from $2,500 — fullstack or frontend-only, built to grow.'
  },
  {
    to: '/services#hosting',
    icon: 'mdi:server',
    title: 'Web Management',
    description: 'Managed hosting from $30/mo plus website builds — consult and Slack Hub included.'
  }
]
const config = useRuntimeConfig()
const siteUrl = (config.public.siteUrl as string) || 'https://stellarpossible.com'
const { path: primaryCtaPath, label: primaryCtaLabel } = usePrimaryCta()
const { open: openContact } = useContactModal()

useSeo({
  title: 'StellarPossible | Your Ideas. Our Tech. Infinite Possibility.',
  description: 'Human-focused technology solutions for creatives, educators, and visionaries. Managed hosting, custom tools, and Nuxt.js platforms.',
  path: '/',
  jsonLd: [organizationJsonLd(siteUrl), websiteJsonLd(siteUrl)]
})
</script>

<style scoped lang="scss">
.landing {
  padding-bottom: var(--space-4);
}

.offerings-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr));
  gap: var(--space-6);

  > .reveal {
    display: flex;
    min-height: 100%;
  }
}

.offering-card {
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
  text-decoration: none;
  color: inherit;
  min-height: 100%;

  h3 {
    font-family: var(--font-display);
    font-size: var(--fs-400);
    margin: 0;
    color: var(--color-text);
  }

  p {
    font-size: var(--fs-200);
    color: var(--color-text-muted);
    margin: 0;
    line-height: 1.5;
    flex: 1;
  }
}

.offering-icon {
  font-size: 1.75rem;
  color: var(--color-accent);
}

.offering-link {
  font-size: var(--fs-100);
  font-weight: 600;
  color: var(--color-accent);
}

.final-cta__card {
  text-align: center;
  padding: var(--space-10) !important;

  h2 {
    font-family: var(--font-display);
    font-size: var(--fs-600);
    margin: 0 0 var(--space-4);
  }

  p {
    color: var(--color-text-muted);
    margin: 0 0 var(--space-8);
    font-size: var(--fs-300);
  }
}

.final-cta__actions {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: var(--space-3);
}

@media (max-width: 480px) {
  .offerings-grid {
    grid-template-columns: 1fr;
  }

  .final-cta__card {
    padding: var(--space-6) !important;
  }

  .final-cta__actions {
    flex-direction: column;
    align-items: stretch;
  }

  .final-cta__actions :deep(.app-btn) {
    width: 100%;
  }
}
</style>
