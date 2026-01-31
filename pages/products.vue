<template>
  <section class="products-page">
    <div class="products-page-inner">
      <header class="hero">
        <h1 class="hero-title">Products</h1>
        <p class="hero-subtitle">
          Selected projects and platforms we’ve built and maintained.
        </p>
        <div class="hero-line" aria-hidden="true" />
      </header>

      <div class="products-grid">
        <article
          v-for="item in productItems"
          :key="item.id"
          class="products-card"
          :class="{ highlight: item.highlight }"
        >
          <div class="products-card-brand">
            <div v-if="item.logo" class="products-logo-wrap">
              <img
                v-if="item.logoAbove"
                :src="item.logoAbove"
                :alt="''"
                class="products-logo-above"
                aria-hidden="true"
              />
              <img :src="item.logo" :alt="item.title" class="products-logo" />
            </div>
            <ClientOnly v-else-if="item.icon">
              <div class="products-icon">
                <Icon :icon="item.icon" />
              </div>
              <template #fallback>
                <div class="products-icon products-icon-placeholder" aria-hidden="true">◆</div>
              </template>
            </ClientOnly>
          </div>
          <div class="products-card-body">
            <h2 class="products-title">{{ item.title }}</h2>
            <p v-if="item.tagline" class="products-tagline">{{ item.tagline }}</p>
            <p class="products-description">{{ item.description }}</p>
            <ul v-if="item.features?.length" class="products-features">
              <li v-for="feature in item.features" :key="feature">{{ feature }}</li>
            </ul>
          </div>
          <a
            v-if="item.url"
            :href="item.url"
            class="products-cta"
            target="_blank"
            rel="noopener noreferrer"
          >
            Visit site
          </a>
        </article>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
interface ProductItem {
  id: string
  title: string
  tagline?: string
  description: string
  features?: string[]
  url?: string
  logo?: string
  logoAbove?: string
  icon?: string
  highlight?: boolean
}

const productItems: ProductItem[] = [
  {
    id: 'hipaa-education',
    title: 'HIPAA Education Platform',
    tagline: 'Compliance education for mental health professionals',
    description:
      'Full-stack platform for HIPAA compliance education: site architecture, security hardening, custom dashboard tools, and ongoing hosting and monitoring.',
    features: [
      'WordPress rehab & legacy plugin modernization',
      'DevOps, performance tuning, and CI/CD',
      'Hosting and uptime monitoring',
      'API development & third-party integrations',
      'Secure email and newsletter systems',
      'UI/UX and accessibility improvements'
    ],
    icon: 'mdi:shield-lock-outline',
    highlight: true
  },
  {
    id: 'kavoossi',
    title: 'Kavoossi',
    tagline: 'kavoossi.com',
    description: 'Website design, development, and hosting.',
    url: 'https://kavoossi.com',
    logoAbove: '/images/primary/BLUE GUY transparent.png',
    logo: '/images/primary/kavoossi logo.avif'
  },
  {
    id: 'vivarium-salon',
    title: 'Vivarium Salon',
    tagline: 'vivariumsalon.com',
    description:
      'Headless WordPress site on Nuxt—fast, managed web presence for stylists and marketing.',
    url: 'https://vivariumsalon.com',
    logo: '/images/primary/vivariumlogo.png'
  },
  {
    id: 'cascabel-event-company',
    title: 'Cascabel Event Company',
    tagline: 'cascabeleventcompany.com',
    description: 'Event company website—branding, build, and hosting.',
    url: 'https://cascabeleventcompany.com',
    logo: '/images/primary/cascabellogo.png'
  }
]

useHead({
  title: 'Products | StellarPossible',
  meta: [
    {
      name: 'description',
      content:
        'Selected products—Kavoossi, Vivarium Salon, Cascabel Event Company, and HIPAA education platforms.'
    }
  ]
})
</script>

<style scoped lang="scss">
.products-page {
  min-height: 100%;
  padding: 4rem 1.5rem 5rem;
  color: #fff;
  background: rgba(0, 0, 0, 0.28);
  backdrop-filter: blur(8px);
}

.products-page-inner {
  max-width: 1000px;
  margin: 0 auto;
}

.hero {
  text-align: center;
  margin-bottom: 3rem;
}

.hero-title {
  font-size: clamp(2.25rem, 5vw, 3rem);
  font-weight: 700;
  letter-spacing: -0.03em;
  margin: 0 0 0.5rem;
  color: #fff;
}

.hero-subtitle {
  font-size: 1.0625rem;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.78);
  margin: 0 0 1.25rem;
  max-width: 28rem;
  margin-left: auto;
  margin-right: auto;
}

.hero-line {
  width: 3rem;
  height: 2px;
  margin: 0 auto;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(84, 117, 128, 0.5) 50%,
    transparent 100%
  );
  border-radius: 1px;
}

.products-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1.5rem;
  width: 100%;
}

@media (max-width: 680px) {
  .products-grid {
    grid-template-columns: 1fr;
  }
}

.products-card {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  padding: 2rem 1.5rem;
  border-radius: 16px;
  background: linear-gradient(
    165deg,
    rgba(18, 49, 70, 0.5) 0%,
    rgba(18, 49, 70, 0.35) 100%
  );
  border: 1px solid rgba(84, 117, 128, 0.25);
  box-shadow:
    0 4px 24px rgba(0, 0, 0, 0.15),
    inset 0 1px 0 rgba(255, 255, 255, 0.04);
  transition: transform 0.25s ease, box-shadow 0.25s ease, border-color 0.2s ease;

  &:hover {
    transform: translateY(-2px);
    border-color: rgba(84, 117, 128, 0.4);
    box-shadow:
      0 12px 32px rgba(0, 0, 0, 0.2),
      0 0 0 1px rgba(84, 117, 128, 0.1),
      inset 0 1px 0 rgba(255, 255, 255, 0.06);
  }

  &.highlight {
    border-color: rgba(84, 117, 128, 0.35);
    background: linear-gradient(
      165deg,
      rgba(18, 49, 70, 0.6) 0%,
      rgba(18, 49, 70, 0.42) 100%
    );
    box-shadow:
      0 6px 28px rgba(0, 0, 0, 0.18),
      inset 0 1px 0 rgba(255, 255, 255, 0.05);
  }

  &.highlight:hover {
    border-color: rgba(84, 117, 128, 0.45);
    box-shadow:
      0 14px 36px rgba(0, 0, 0, 0.22),
      0 0 0 1px rgba(84, 117, 128, 0.12),
      inset 0 1px 0 rgba(255, 255, 255, 0.06);
  }
}

.products-card-brand {
  flex-shrink: 0;
  margin-bottom: 1.25rem;
  padding: 0.75rem;
  border-radius: 12px;
  background: rgba(0, 0, 0, 0.15);
  border: 1px solid rgba(84, 117, 128, 0.15);
}

.products-logo-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.products-logo-above {
  max-height: 52px;
  width: auto;
  object-fit: contain;
}

.products-logo {
  max-height: 44px;
  width: auto;
  object-fit: contain;
}

.products-icon {
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 2.25rem;
  color: rgba(132, 165, 175, 0.95);

  &.products-icon-placeholder {
    font-size: 1.5rem;
    opacity: 0.75;
  }
}

.products-card-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  width: 100%;
  min-width: 0;
}

.products-title {
  font-size: 1.3125rem;
  font-weight: 600;
  letter-spacing: -0.02em;
  margin: 0 0 0.25rem;
  color: #fff;
}

.products-tagline {
  font-size: 0.8125rem;
  color: rgba(255, 255, 255, 0.65);
  font-style: italic;
  margin: 0 0 0.75rem;
}

.products-description {
  font-size: 0.9375rem;
  line-height: 1.58;
  color: rgba(255, 255, 255, 0.88);
  margin: 0 0 1rem;
  text-align: center;
  max-width: 28rem;
}

.products-features {
  list-style: none;
  padding: 0;
  margin: 0 0 1.25rem;
  text-align: left;
  width: 100%;
  max-width: 20rem;
  margin-left: auto;
  margin-right: auto;

  li {
    padding: 0.3rem 0;
    padding-left: 1.35rem;
    position: relative;
    font-size: 0.875rem;
    color: rgba(255, 255, 255, 0.86);
    line-height: 1.4;

    &::before {
      content: '✓';
      position: absolute;
      left: 0;
      color: rgba(132, 165, 175, 0.95);
      font-weight: 700;
      font-size: 0.8em;
    }
  }
}

.products-cta {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin-top: auto;
  padding: 0.65rem 1.4rem;
  font-size: 0.9375rem;
  font-weight: 600;
  color: #fff;
  background: rgba(84, 117, 128, 0.5);
  border: 1px solid rgba(84, 117, 128, 0.4);
  border-radius: 10px;
  text-decoration: none;
  transition: background 0.2s ease, border-color 0.2s ease, transform 0.15s ease;

  &:hover {
    background: rgba(84, 117, 128, 0.65);
    border-color: rgba(84, 117, 128, 0.55);
    transform: translateY(-1px);
  }
}
</style>
