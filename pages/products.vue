<template>
  <PageShell class="products-landing">
    <SectionShell id="products">
      <Reveal>
        <div class="product-list">
          <GlassCard
            v-for="product in products"
            :key="product.id"
            :href="product.url"
            external
            :pad="false"
            class="product-card"
            :class="{ 'product-card--featured': product.featured, 'product-card--dark': product.darkTheme }"
          >
            <div v-if="product.image || product.video" class="product-card__media">
              <video
                v-if="product.video"
                class="product-card__video"
                :src="product.video"
                autoplay
                muted
                loop
                playsinline
                preload="metadata"
                :aria-label="`${product.title} mobile site preview`"
              />
              <NuxtImg
                v-else-if="product.image"
                :src="product.image"
                :alt="`${product.title} app preview`"
                class="product-card__image"
                loading="lazy"
              />
            </div>
            <div class="product-card__body">
              <div class="product-card__brand">
                <img
                  v-if="product.logo"
                  :src="product.logo"
                  :alt="`${product.title} logo`"
                  class="product-card__logo"
                />
                <span v-if="product.badge" class="product-card__badge">{{ product.badge }}</span>
              </div>
              <p class="product-card__type">{{ product.type }}</p>
              <h3 class="product-card__title">{{ product.title }}</h3>
              <p class="product-card__desc">{{ product.description }}</p>
              <p v-if="product.comingSoon" class="product-card__soon">
                <Icon icon="mdi:cellphone-arrow-down" aria-hidden="true" />
                {{ product.comingSoon }}
              </p>
              <span class="product-card__cta">{{ product.ctaLabel || 'Visit site' }} ↗</span>
            </div>
          </GlassCard>
        </div>
      </Reveal>
    </SectionShell>

    <SectionShell id="stack">
      <Reveal>
        <div class="tools-grid">
          <GlassCard
            v-for="tool in toolsWeUse"
            :key="tool.name"
            :href="tool.url"
            external
            class="tool-card"
          >
            <Icon :icon="tool.icon" class="tool-icon" aria-hidden />
            <span class="tool-text">
              <strong>{{ tool.name }}</strong>
              <span class="tool-desc">{{ tool.description }}</span>
            </span>
          </GlassCard>
        </div>
      </Reveal>
    </SectionShell>

    <SectionShell narrow>
      <Reveal>
        <GlassCard :hover="false" class="cta-card">
          <h2>Let's build your next project</h2>
          <div class="cta-actions">
            <AppButton :to="primaryCtaPath" variant="primary" size="lg">{{ primaryCtaLabel }}</AppButton>
            <AppButton variant="ghost" size="lg" @click="openContact">Contact</AppButton>
            <AppButton to="/services" variant="ghost" size="lg">Services</AppButton>
          </div>
        </GlassCard>
      </Reveal>
    </SectionShell>
  </PageShell>
</template>

<script setup lang="ts">
const { path: primaryCtaPath, label: primaryCtaLabel } = usePrimaryCta()
const { open: openContact } = useContactModal()

const toolsWeUse = [
  { name: 'Nuxt.js', description: 'Vue-based framework for fast, modern web apps.', icon: 'simple-icons:nuxtdotjs', url: 'https://nuxt.com' },
  { name: 'Visual Studio Code', description: 'Code editor we use for development.', icon: 'simple-icons:visualstudiocode', url: 'https://code.visualstudio.com' },
  { name: 'GitHub', description: 'Version control and collaboration.', icon: 'simple-icons:github', url: 'https://github.com' },
  { name: 'Slack', description: 'Client communication and file sharing.', icon: 'simple-icons:slack', url: 'https://slack.com' },
  { name: 'WordPress', description: 'Content management and headless CMS.', icon: 'simple-icons:wordpress', url: 'https://wordpress.org' },
  { name: 'Hostinger', description: 'Reliable hosting for client sites.', icon: 'simple-icons:hostinger', url: 'https://www.hostinger.com' }
]

const products = [
  {
    id: 'rollcall',
    title: 'RollCall',
    type: 'StellarPossible Product · Tabletop RPG',
    badge: 'Featured app',
    description: 'Start a game. Build your hero. Build characters, organize parties, learn the ropes, or run your campaign — all in one place.',
    comingSoon: 'Coming soon on Android, Google Play, and iOS.',
    url: 'https://rollcall.stellarpossible.com',
    image: '/images/primary/rollcall-app.png',
    ctaLabel: 'Open RollCall',
    featured: true,
    darkTheme: true
  },
  {
    id: 'vivarium',
    title: 'Vivarium Salon',
    type: 'Beauty & Wellness · Annapolis, MD',
    description: 'Headless WordPress on Nuxt — lightning-fast, modern web presence for a boutique salon in Annapolis.',
    url: 'https://vivariumsalon.com',
    logo: '/images/primary/vivariumlogo.png',
    video: '/videos/vivarium-app.webm',
    featured: true,
    darkTheme: true
  },
  {
    id: 'kavoossi',
    title: 'Kavoossi',
    type: 'Indie Rock · Annapolis, MD',
    description: 'Website design, development, and hosting for the Annapolis-based indie-rock band.',
    url: 'https://kavoossi.com',
    logo: '/images/primary/kavoossi.png',
    video: '/videos/kavoossi-app.webm',
    featured: true,
    darkTheme: true
  }
]

const config = useRuntimeConfig()
const siteUrl = ((config.public.siteUrl as string) || 'https://stellarpossible.com').replace(/\/$/, '')

useSeo({
  title: 'Products | StellarPossible',
  description: 'Performant, secure digital experiences — StellarPossible products and client platforms.',
  path: '/products',
  jsonLd: [organizationJsonLd(siteUrl), websiteJsonLd(siteUrl)]
})
</script>

<style scoped lang="scss">
.products-landing {
  padding-bottom: var(--space-12);
}

.product-list {
  display: flex;
  flex-direction: column;
  gap: var(--space-8);
}

.product-card {
  display: grid;
  grid-template-columns: 1fr;
  text-decoration: none;
  color: inherit;
  overflow: hidden;
}

.product-card--featured {
  border-color: var(--color-border-strong);
  box-shadow: var(--shadow-lg), var(--shadow-glow);

  @media (min-width: 768px) {
    grid-template-columns: minmax(12rem, 16rem) 1fr;
  }
}

.product-card--featured:nth-child(even) {
  @media (min-width: 768px) {
    grid-template-columns: 1fr minmax(12rem, 16rem);

    .product-card__media {
      order: 2;
    }

    .product-card__body {
      order: 1;
    }
  }
}

.product-card--featured .product-card__media {
  @media (min-width: 768px) {
    min-height: 100%;
  }
}

.product-card--dark {
  background: linear-gradient(160deg, rgba(8, 14, 24, 0.92) 0%, rgba(12, 22, 38, 0.88) 100%);
  border-color: rgba(255, 255, 255, 0.1);

  .product-card__desc {
    color: rgba(255, 255, 255, 0.68);
  }
}

.product-card__media {
  background: rgba(0, 0, 0, 0.35);
  display: flex;
  align-items: flex-end;
  justify-content: center;
  padding: var(--space-6) var(--space-6) 0;
  overflow: hidden;
}

.product-card__image,
.product-card__video {
  width: min(100%, 280px);
  height: auto;
  display: block;
  object-fit: contain;
  object-position: bottom center;
  filter: drop-shadow(0 12px 32px rgba(0, 0, 0, 0.45));
}

.product-card__video {
  border-radius: var(--radius-md) var(--radius-md) 0 0;
  background: #000;
}

.product-card__body {
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
  padding: var(--space-6);
  min-height: 100%;
}

.product-card__brand {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  flex-wrap: wrap;
}

.product-card__logo {
  max-height: 2.75rem;
  width: auto;
  object-fit: contain;
}

.product-card__badge {
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

.product-card__type {
  font-size: var(--fs-100);
  color: var(--color-accent);
  margin: 0;
  font-weight: 600;
  letter-spacing: 0.04em;
}

.product-card__title {
  font-family: var(--font-display);
  font-size: var(--fs-500);
  margin: 0;
  line-height: 1.15;
}

.product-card__desc {
  font-size: var(--fs-200);
  color: var(--color-text-muted);
  margin: 0;
  flex: 1;
  line-height: 1.55;
}

.product-card__soon {
  display: inline-flex;
  align-items: center;
  gap: var(--space-2);
  font-size: var(--fs-100);
  font-weight: 600;
  color: var(--color-accent);
  margin: 0;
  padding: var(--space-2) var(--space-3);
  background: var(--color-accent-soft);
  border-radius: var(--radius-md);
  width: fit-content;
}

.product-card__cta {
  font-size: var(--fs-200);
  font-weight: 600;
  color: var(--color-accent);
  margin-top: var(--space-2);
}


.tools-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr));
  gap: var(--space-4);
}

.tool-card {
  display: flex;
  align-items: flex-start;
  gap: var(--space-4);
  text-decoration: none;
  color: inherit;
}

.tool-icon {
  font-size: 1.75rem;
  flex-shrink: 0;
  color: var(--color-accent);
}

.tool-text strong {
  display: block;
  font-family: var(--font-ui);
  margin-bottom: var(--space-1);
}

.tool-desc {
  font-size: var(--fs-100);
  color: var(--color-text-muted);
}

.cta-card {
  text-align: center;
  padding: var(--space-10) !important;

  h2 {
    font-family: var(--font-display);
    font-size: var(--fs-600);
    margin: 0 0 var(--space-6);
  }
}

.cta-actions {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: var(--space-3);
}

@media (max-width: 768px) {
  .tools-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .product-card__body {
    padding: var(--space-5);
  }

  .product-card__media {
    padding: var(--space-4) var(--space-4) 0;
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
}
</style>
