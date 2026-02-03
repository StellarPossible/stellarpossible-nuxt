<template>
  <section class="products-page">
    <div class="products-inner">
      <!-- Hero Section -->
      <header class="hero">
        <span class="hero-badge">Our Work</span>
        <h1 class="hero-title">Crafted with Purpose</h1>
        <p class="hero-subtitle">
          We build performant, secure, and beautifully designed digital experiences that drive results.
        </p>
      </header>

      <!-- Client Portfolio Section -->
      <section class="portfolio">
        <div class="portfolio-header">
          <h2 class="portfolio-title">Client Portfolio</h2>
          <p class="portfolio-subtitle">Trusted by businesses to deliver exceptional web experiences</p>
        </div>
        
        <div class="portfolio-grid">
          <a
            v-for="client in clients"
            :key="client.id"
            :href="client.url"
            target="_blank"
            rel="noopener noreferrer"
            class="client-card"
            :class="{ 'client-card-dark': client.darkTheme }"
          >
            <div class="client-logo-wrap">
              <img
                v-if="client.logoAbove"
                :src="client.logoAbove"
                :alt="''"
                class="client-logo-above"
                aria-hidden="true"
              />
              <img :src="client.logo" :alt="client.title" class="client-logo" />
            </div>
            <div class="client-info">
              <h3 class="client-name">{{ client.title }}</h3>
              <p class="client-type">{{ client.type }}</p>
              <p class="client-description">{{ client.description }}</p>
            </div>
            <span class="client-cta">
              View Site
              <ClientOnly>
                <Icon icon="mdi:open-in-new" />
                <template #fallback><span>↗</span></template>
              </ClientOnly>
            </span>
          </a>
        </div>
      </section>

      <!-- Featured Project -->
      <section class="featured-section">
        <header class="featured-section-header">
          <h2 class="featured-section-title">Featured Project</h2>
          <p class="featured-section-subtitle">A closer look at one of our flagship engagements</p>
        </header>
        <article class="featured">
        <div class="featured-content">
          <div class="featured-badge">
            <ClientOnly>
              <Icon icon="mdi:star" />
              <template #fallback><span>★</span></template>
            </ClientOnly>
            Featured Project
          </div>
          <h2 class="featured-title">HIPAA Education Platform</h2>
          <p class="featured-tagline">Compliance education for mental health professionals</p>
          <p class="featured-description">
            Full-stack platform transformation: site architecture, security hardening, 
            custom dashboard tools, and ongoing hosting with 99.9% uptime since 2022.
          </p>
          <ul class="featured-features">
            <li>
              <ClientOnly>
                <Icon icon="mdi:check-circle" />
                <template #fallback><span class="check">✓</span></template>
              </ClientOnly>
              WordPress modernization & legacy plugin rehab
            </li>
            <li>
              <ClientOnly>
                <Icon icon="mdi:check-circle" />
                <template #fallback><span class="check">✓</span></template>
              </ClientOnly>
              DevOps, CI/CD, and performance optimization
            </li>
            <li>
              <ClientOnly>
                <Icon icon="mdi:check-circle" />
                <template #fallback><span class="check">✓</span></template>
              </ClientOnly>
              24/7 monitoring and managed hosting
            </li>
            <li>
              <ClientOnly>
                <Icon icon="mdi:check-circle" />
                <template #fallback><span class="check">✓</span></template>
              </ClientOnly>
              API development & third-party integrations
            </li>
            <li>
              <ClientOnly>
                <Icon icon="mdi:check-circle" />
                <template #fallback><span class="check">✓</span></template>
              </ClientOnly>
              Secure email and newsletter infrastructure
            </li>
            <li>
              <ClientOnly>
                <Icon icon="mdi:check-circle" />
                <template #fallback><span class="check">✓</span></template>
              </ClientOnly>
              UI/UX and accessibility improvements
            </li>
          </ul>
          <NuxtLink to="/services" class="featured-cta">
            Start Your Project
            <ClientOnly>
              <Icon icon="mdi:arrow-right" />
              <template #fallback><span>→</span></template>
            </ClientOnly>
          </NuxtLink>
        </div>
        <div class="featured-visual">
          <div class="featured-icon-wrap">
            <ClientOnly>
              <Icon icon="mdi:shield-lock-outline" class="featured-icon" />
              <template #fallback><div class="icon-placeholder">🛡️</div></template>
            </ClientOnly>
          </div>
          <div class="featured-stats">
            <div class="stat">
              <span class="stat-value">99.9%</span>
              <span class="stat-label">Uptime since 2022</span>
            </div>
          </div>
        </div>
      </article>
      </section>

      <!-- Book Covers Gallery -->
      <section class="book-covers-section" aria-label="Book cover design work">
        <header class="book-covers-header">
          <h2 class="book-covers-title">Book Covers</h2>
          <p class="book-covers-subtitle">Custom cover design for print and digital—KDP and Amazon optimized</p>
        </header>
        <BookCoverGallery :items="bookCovers" />
      </section>

      <!-- CTA Section -->
      <section class="cta-section">
        <div class="cta-content">
          <h2 class="cta-title">Ready to elevate your digital presence?</h2>
          <p class="cta-subtitle">Let's discuss how we can help your business grow.</p>
          <NuxtLink to="/services" class="cta-button">
            View Our Services
            <ClientOnly>
              <Icon icon="mdi:arrow-right" />
              <template #fallback><span>→</span></template>
            </ClientOnly>
          </NuxtLink>
        </div>
      </section>
    </div>
  </section>
</template>

<script setup lang="ts">
interface Client {
  id: string
  title: string
  type: string
  description: string
  url: string
  logo: string
  logoAbove?: string
  darkTheme?: boolean
}

const bookCovers = [
  {
    src: '/images/media/ScentOfLiesAmazonCover.png',
    alt: 'Scent of Lies — book cover, Amazon/KDP',
    title: 'Scent of Lies'
  }
  // Add more covers: { src: '/images/media/YourCover.png', alt: '...', title: 'Book Title' }
]

const clients: Client[] = [
  {
    id: 'kavoossi',
    title: 'Kavoossi',
    type: 'Indie Rock · Annapolis, MD, USA',
    description: 'Website design, development, and hosting for the Annapolis-based indie-rock band.',
    url: 'https://kavoossi.com',
    logoAbove: '/images/primary/BLUE GUY transparent.png',
    logo: '/images/primary/kavoossi logo.avif',
    darkTheme: true
  },
  {
    id: 'cascabel-event-company',
    title: 'Cascabel Event Company',
    type: 'Events & Hospitality · Annapolis, MD, USA',
    description: 'Brand identity, custom website build, and reliable hosting.',
    url: 'https://cascabeleventcompany.com',
    logo: '/images/primary/cascabellogo.png',
    darkTheme: false
  },
  {
    id: 'vivarium-salon',
    title: 'Vivarium Salon',
    type: 'Beauty & Wellness · Annapolis, MD, USA',
    description: 'Headless WordPress on Nuxt — lightning-fast, modern web presence.',
    url: 'https://vivariumsalon.com',
    logo: '/images/primary/vivariumlogo.png',
    darkTheme: true
  }
]

useHead({
  title: 'Our Work | StellarPossible',
  meta: [
    {
      name: 'description',
      content: 'See our portfolio of successful web projects including HIPAA compliance platforms, business websites, and custom digital solutions.'
    }
  ]
})
</script>

<style scoped lang="scss">
.products-page {
  min-height: 100vh;
  padding: 5rem 1.5rem 4rem;
  color: #fff;
}

.products-inner {
  max-width: 1100px;
  margin: 0 auto;
}

// Hero Section
.hero {
  text-align: center;
  margin-bottom: 4rem;
  padding: 2.5rem 1.5rem;
  padding-top: 3rem;
  background: rgba(0, 0, 0, 0.4);
  border-radius: 24px;
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.06);
  overflow: visible;
}

.hero-badge {
  display: inline-block;
  padding: 0.4rem 1rem;
  font-size: 0.75rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: rgba(255, 255, 255, 0.95);
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 100px;
  margin-bottom: 1.25rem;
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
}

.hero-title {
  font-size: clamp(2.5rem, 6vw, 3.5rem);
  font-weight: 700;
  letter-spacing: -0.03em;
  line-height: 1.35;
  margin: 0 0 1rem;
  padding-top: 0.15em;
  background: linear-gradient(135deg, #fff 0%, rgba(255,255,255,0.9) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  filter: drop-shadow(0 2px 8px rgba(0, 0, 0, 0.7)) drop-shadow(0 4px 16px rgba(0, 0, 0, 0.4));
}

.hero-subtitle {
  font-size: 1.125rem;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.9);
  max-width: 540px;
  margin: 0 auto;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.8), 0 1px 3px rgba(0, 0, 0, 0.6);
}

// Featured Project Section
.featured-section {
  margin-bottom: 5rem;
}

.featured-section-header {
  text-align: center;
  margin-bottom: 2rem;
}

.featured-section-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #fff;
  margin: 0 0 0.5rem;
  letter-spacing: -0.02em;
}

.featured-section-subtitle {
  font-size: 1rem;
  color: rgba(255, 255, 255, 0.65);
  margin: 0;
}

.book-covers-section {
  margin-bottom: 5rem;
}

.book-covers-header {
  text-align: center;
  margin-bottom: 2rem;
}

.book-covers-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #fff;
  margin: 0 0 0.5rem;
  letter-spacing: -0.02em;
}

.book-covers-subtitle {
  font-size: 1rem;
  color: rgba(255, 255, 255, 0.65);
  margin: 0;
}

.featured {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  align-items: center;
  padding: 3rem;
  background: #fff;
  border-radius: 24px;
  border: 1px solid rgba(0, 0, 0, 0.06);
  box-shadow: 
    0 1px 3px rgba(0, 0, 0, 0.04),
    0 6px 16px rgba(0, 0, 0, 0.06),
    0 12px 32px rgba(0, 0, 0, 0.04),
    0 24px 64px rgba(0, 0, 0, 0.06);
  transition: box-shadow 0.3s ease, transform 0.3s ease;

  &:hover {
    box-shadow: 
      0 2px 6px rgba(0, 0, 0, 0.04),
      0 12px 24px rgba(0, 0, 0, 0.08),
      0 24px 48px rgba(0, 0, 0, 0.06),
      0 32px 80px rgba(0, 0, 0, 0.08);
  }
}

.featured-content {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  min-width: 0;
}

.featured-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.4rem 1rem;
  font-size: 0.7rem;
  font-weight: 600;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: #b8860b;
  background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%);
  border: 1px solid rgba(212, 165, 116, 0.35);
  border-radius: 100px;
  margin-bottom: 1.25rem;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
}

.featured-title {
  font-size: 2rem;
  font-weight: 700;
  letter-spacing: -0.03em;
  line-height: 1.2;
  color: #0f172a;
  margin: 0 0 0.5rem;
}

.featured-tagline {
  font-size: 1rem;
  color: #64748b;
  margin: 0 0 1.25rem;
}

.featured-description {
  font-size: 1rem;
  line-height: 1.7;
  color: #475569;
  margin: 0 0 1.5rem;
}

.featured-features {
  list-style: none;
  padding: 0;
  margin: 0 0 2rem;
  display: grid;
  gap: 0.6rem;

  li {
    display: flex;
    align-items: flex-start;
    gap: 0.6rem;
    font-size: 0.9375rem;
    color: #334155;
    line-height: 1.5;

    svg, .check {
      flex-shrink: 0;
      color: #10b981;
      font-size: 1.1rem;
      margin-top: 0.1rem;
    }
  }
}

.featured-cta {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.875rem 1.75rem;
  font-size: 1rem;
  font-weight: 600;
  color: #fff;
  background: linear-gradient(135deg, #6366f1 0%, #7c3aed 50%, #6d28d9 100%);
  border-radius: 12px;
  text-decoration: none;
  transition: all 0.25s ease;
  box-sizing: border-box;
  max-width: 100%;
  box-shadow: 
    0 1px 2px rgba(0, 0, 0, 0.05),
    0 4px 12px rgba(99, 102, 241, 0.35),
    inset 0 1px 0 rgba(255, 255, 255, 0.15);

  &:hover {
    transform: translateY(-2px);
    box-shadow: 
      0 2px 4px rgba(0, 0, 0, 0.06),
      0 8px 24px rgba(99, 102, 241, 0.45),
      inset 0 1px 0 rgba(255, 255, 255, 0.2);
  }

  &:active {
    transform: translateY(0);
  }

  svg {
    font-size: 1.1rem;
    transition: transform 0.2s ease;
  }

  &:hover svg {
    transform: translateX(3px);
  }
}

.featured-visual {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2rem;
}

.featured-icon-wrap {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 140px;
  height: 140px;
  background: linear-gradient(145deg, #f0f9ff 0%, #e0f2fe 50%, #bae6fd 100%);
  border-radius: 28px;
  border: 1px solid rgba(59, 130, 246, 0.2);
  box-shadow: 
    0 2px 8px rgba(59, 130, 246, 0.12),
    inset 0 1px 0 rgba(255, 255, 255, 0.8);

  .featured-icon {
    font-size: 4rem;
    color: #2563eb;
  }

  .icon-placeholder {
    font-size: 3.5rem;
  }
}

.featured-stats {
  display: flex;
  gap: 3rem;
}

.stat {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.stat-value {
  font-size: 2rem;
  font-weight: 700;
  color: #1a1a2e;
  letter-spacing: -0.02em;
}

.stat-label {
  font-size: 0.8125rem;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

// Portfolio Section
.portfolio {
  margin-bottom: 5rem;
}

.portfolio-header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.portfolio-title {
  font-size: 1.75rem;
  font-weight: 700;
  color: #fff;
  margin: 0 0 0.5rem;
}

.portfolio-subtitle {
  font-size: 1rem;
  color: rgba(255, 255, 255, 0.65);
  margin: 0;
}

.portfolio-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
}

.client-card {
  display: flex;
  flex-direction: column;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(8px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 20px;
  text-decoration: none;
  transition: all 0.3s ease;
  box-shadow: 
    0 2px 4px rgba(0, 0, 0, 0.04),
    0 8px 16px rgba(0, 0, 0, 0.06);

  &:hover {
    transform: translateY(-4px);
    background: rgba(255, 255, 255, 0.92);
    box-shadow: 
      0 4px 8px rgba(0, 0, 0, 0.06),
      0 16px 32px rgba(0, 0, 0, 0.1);

    .client-cta {
      color: #667eea;

      svg {
        transform: translate(2px, -2px);
      }
    }
  }

  &.client-card-dark {
    background: linear-gradient(
      165deg,
      rgba(18, 49, 70, 0.85) 0%,
      rgba(18, 49, 70, 0.7) 100%
    );
    border: 1px solid rgba(84, 117, 128, 0.3);
    box-shadow: 
      0 4px 8px rgba(0, 0, 0, 0.15),
      inset 0 1px 0 rgba(255, 255, 255, 0.05);

    .client-logo-wrap {
      background: transparent;
    }

    .client-name {
      color: #fff;
    }

    .client-type {
      color: #84a5af;
    }

    .client-description {
      color: rgba(255, 255, 255, 0.75);
    }

    .client-cta {
      color: rgba(255, 255, 255, 0.6);
    }

    &:hover {
      border-color: rgba(84, 117, 128, 0.45);
      box-shadow: 
        0 8px 16px rgba(0, 0, 0, 0.2),
        0 0 0 1px rgba(84, 117, 128, 0.15),
        inset 0 1px 0 rgba(255, 255, 255, 0.06);

      .client-cta {
        color: #84a5af;
      }
    }
  }
}

.client-logo-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  flex: 1;
  min-height: 180px;
  background: transparent;
  border-radius: 12px;
}

.client-logo-above {
  width: auto;
  object-fit: contain;
  width: 8rem;
}

.client-logo {
  max-width: 90%;
  width: auto;
  object-fit: contain;
}

.client-info {
  text-align: center;
}

.client-name {
  font-size: 1.125rem;
  font-weight: 700;
  color: #1a1a2e;
  margin: 0 0 0.2rem;
}

.client-type {
  font-size: 0.7rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: #667eea;
  margin: 0 0 0.5rem;
}

.client-description {
  font-size: 0.875rem;
  line-height: 1.5;
  color: #64748b;
  margin: 0;
}

.client-cta {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.35rem;
  margin-top: 1rem;
  font-size: 0.8125rem;
  font-weight: 600;
  color: #94a3b8;
  transition: color 0.2s ease;

  svg {
    font-size: 0.85rem;
    transition: transform 0.2s ease;
  }
}

// CTA Section
.cta-section {
  text-align: center;
  padding: 3.5rem 2rem;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 24px;
  backdrop-filter: blur(8px);
  overflow: hidden;
}

.cta-content {
  width: 100%;
  max-width: 100%;
  box-sizing: border-box;
}

.cta-title {
  font-size: 1.75rem;
  font-weight: 700;
  color: #fff;
  margin: 0 0 0.75rem;
}

.cta-subtitle {
  font-size: 1.0625rem;
  color: rgba(255, 255, 255, 0.7);
  margin: 0 0 2rem;
}

.cta-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 1rem 2rem;
  font-size: 1rem;
  font-weight: 600;
  color: #1a1a2e;
  background: #fff;
  border-radius: 12px;
  text-decoration: none;
  transition: all 0.25s ease;
  box-sizing: border-box;
  max-width: 100%;
  box-shadow: 0 4px 14px rgba(0, 0, 0, 0.1);

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
  }

  svg {
    font-size: 1.1rem;
    transition: transform 0.2s ease;
  }

  &:hover svg {
    transform: translateX(3px);
  }
}

// Responsive
@media (max-width: 900px) {
  .featured {
    grid-template-columns: 1fr;
    gap: 2rem;
    padding: 2rem;
  }

  .featured-visual {
    order: -1;
  }

  .featured-icon-wrap {
    width: 100px;
    height: 100px;

    .featured-icon {
      font-size: 2.5rem;
    }
  }

  .featured-stats {
    gap: 2rem;
  }

  .stat-value {
    font-size: 1.5rem;
  }

  .portfolio-grid {
    grid-template-columns: 1fr;
    gap: 1.25rem;
  }

  .client-card {
    flex-direction: row;
    align-items: center;
    gap: 1.25rem;
  }

  .client-logo-wrap {
    width: 120px;
    min-height: 100px;
    flex: 0 0 auto;
    margin-bottom: 0;
  }

  .client-info {
    text-align: left;
    flex: 1;
  }

  .client-cta {
    margin-top: 0;
    margin-left: auto;
    white-space: nowrap;
  }
}

@media (max-width: 600px) {
  .products-page {
    padding: 4rem 1rem 3rem;
  }

  .hero {
    margin-bottom: 3rem;
  }

  .featured {
    padding: 1.5rem;
    margin-bottom: 3.5rem;
  }

  .featured-title {
    font-size: 1.5rem;
  }

  .featured-cta {
    width: 100%;
    justify-content: center;
  }

  .client-card {
    flex-direction: column;
    text-align: center;
  }

  .client-logo-wrap {
    width: 100%;
    min-height: 140px;
  }

  .client-info {
    text-align: center;
  }

  .client-cta {
    margin-left: 0;
    margin-top: 0.75rem;
  }

  .cta-section {
    padding: 2.5rem 1.5rem;
  }

  .cta-title {
    font-size: 1.5rem;
  }

  .cta-button {
    width: 100%;
    justify-content: center;
  }
}
</style>
