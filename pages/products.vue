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
          <template v-for="client in clients" :key="client.id">
            <!-- Video card: overlay by default; hover/click expands, hides overlay, plays video -->
            <div
              v-if="client.highlightVideo"
              class="client-card client-card-dark client-card-video"
              :class="{ 'client-card-video-active': activeVideoId === client.id }"
              @mouseenter="setVideoCardActive(client.id)"
              @mouseleave="setVideoCardInactive(client.id)"
              @click="toggleVideoCardActive(client.id)"
            >
              <div class="client-video-frame" aria-hidden="true">
                <video
                  :ref="(el) => setVideoRef(client.id, el)"
                  class="client-highlight-video"
                  :src="client.highlightVideo"
                  muted
                  loop
                  playsinline
                />
              </div>
              <div
                class="client-card-overlay"
                :class="{ 'client-card-overlay-hidden': activeVideoId === client.id }"
              >
                <div class="client-info">
                  <h3 class="client-name">{{ client.title }}</h3>
                  <p class="client-type">{{ client.type }}</p>
                  <p class="client-description">{{ client.description }}</p>
                </div>
                <a
                  :href="client.url"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="client-cta client-cta-link"
                  @click.stop
                >
                  View Site
                  <ClientOnly>
                    <Icon icon="mdi:open-in-new" />
                    <template #fallback><span>↗</span></template>
                  </ClientOnly>
                </a>
              </div>
            </div>
            <!-- Non-video card: standard link -->
            <a
              v-else
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
          </template>
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

      <!-- Tools we use — premium stellar card -->
      <section class="tools-card-section" aria-label="Tools we use">
        <article class="tools-card tools-card-stellar">
          <div class="tools-card-glow" aria-hidden="true" />
          <header class="tools-card-header">
            <span class="tools-card-label">Stack</span>
            <h2 class="tools-card-title">Tools we use</h2>
            <p class="tools-card-subtitle">Modern, reliable stack for design, development, and hosting</p>
          </header>
          <ul class="tools-list" aria-label="Tools and what we use them for">
            <li v-for="tool in toolsWeUse" :key="tool.name" class="tools-list-item">
              <a
                :href="tool.url"
                target="_blank"
                rel="noopener noreferrer"
                class="tools-list-link"
                :aria-label="`${tool.name} — ${tool.description} (opens in new tab)`"
              >
                <span class="tools-list-icon-wrap" aria-hidden>
                  <span class="tools-list-icon">
                    <svg v-if="tool.name === 'Nuxt.js'" class="nuxt-logo" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
                      <path d="M12.894 17.94L9.26 11.652 6.108 17.94H0l9.26-16 2.634 4.52L21 17.94h-8.106z" fill="currentColor"/>
                    </svg>
                    <Icon v-else :icon="tool.icon" aria-hidden />
                  </span>
                </span>
                <span class="tools-list-text">
                  <strong class="tools-list-name">{{ tool.name }}</strong>
                  <span class="tools-list-desc">{{ tool.description }}</span>
                </span>
              </a>
            </li>
          </ul>
        </article>
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
  highlightVideo?: string
  darkTheme?: boolean
}

// Video card: play only on hover/click; overlay visible by default
const activeVideoId = ref<string | null>(null)
const videoRefs: Record<string, HTMLVideoElement | null> = {}

function setVideoRef(id: string, el: unknown) {
  if (el && el instanceof HTMLVideoElement) {
    videoRefs[id] = el
  }
}

function setVideoCardActive(id: string) {
  activeVideoId.value = id
  const video = videoRefs[id]
  if (video) {
    video.play().catch(() => {})
  }
}

function setVideoCardInactive(id: string) {
  if (activeVideoId.value === id) {
    activeVideoId.value = null
    const video = videoRefs[id]
    if (video) {
      video.pause()
    }
  }
}

function toggleVideoCardActive(id: string) {
  if (activeVideoId.value === id) {
    setVideoCardInactive(id)
  } else {
    setVideoCardActive(id)
  }
}

const toolsWeUse = [
  { name: 'Nuxt.js', description: 'Vue-based framework for fast, modern web apps.', icon: 'simple-icons:nuxtdotjs', url: 'https://nuxt.com' },
  { name: 'Visual Studio Code', description: 'Code editor we use for development.', icon: 'simple-icons:visualstudiocode', url: 'https://code.visualstudio.com' },
  { name: 'GitHub', description: 'Version control and collaboration.', icon: 'simple-icons:github', url: 'https://github.com' },
  { name: 'Slack', description: 'Client communication and file sharing.', icon: 'simple-icons:slack', url: 'https://slack.com' },
  { name: 'WordPress', description: 'Content management and headless CMS.', icon: 'simple-icons:wordpress', url: 'https://wordpress.org' },
  { name: 'Hostinger', description: 'Reliable hosting for client sites.', icon: 'simple-icons:hostinger', url: 'https://www.hostinger.com' },
  { name: 'Unsplash', description: 'High-quality stock imagery.', icon: 'simple-icons:unsplash', url: 'https://unsplash.com' },
  { name: 'Adobe Photoshop', description: 'Logo and visual design work.', icon: 'simple-icons:adobephotoshop', url: 'https://www.adobe.com/products/photoshop.html' },
]

const clients: Client[] = [
  {
    id: 'kavoossi',
    title: 'Kavoossi',
    type: 'Indie Rock · Annapolis, MD, USA',
    description: 'Website design, development, and hosting for the Annapolis-based indie-rock band.',
    url: 'https://kavoossi.com',
    highlightVideo: '/videos/kavoossiPreview.mov',
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

// Tools we use — compact stellar card
.tools-card-section {
  margin-bottom: 3rem;
}

.tools-card-stellar {
  position: relative;
  padding: 0.85rem 1rem;
  background: linear-gradient(
    165deg,
    rgba(18, 49, 70, 0.88) 0%,
    rgba(18, 49, 70, 0.78) 50%,
    rgba(45, 69, 88, 0.75) 100%
  );
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-radius: 16px;
  border: 1px solid rgba(84, 117, 128, 0.35);
  box-shadow:
    0 4px 24px rgba(0, 0, 0, 0.2),
    0 0 0 1px rgba(255, 255, 255, 0.04) inset;
  text-align: left;
  overflow: hidden;
}

.tools-card-glow {
  position: absolute;
  top: -40%;
  right: -20%;
  width: 60%;
  height: 80%;
  background: radial-gradient(
    ellipse at center,
    rgba(84, 117, 128, 0.2) 0%,
    transparent 70%
  );
  pointer-events: none;
}

.tools-card-header {
  position: relative;
  margin-bottom: 0.6rem;
}

.tools-card-label {
  display: inline-block;
  font-size: 0.5625rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 0.1rem;
}

.tools-card-title {
  font-size: 0.9rem;
  font-weight: 700;
  color: #fff;
  margin: 0 0 0.1rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.tools-card-subtitle {
  font-size: 0.7rem;
  color: rgba(255, 255, 255, 0.65);
  margin: 0;
  line-height: 1.3;
}

.tools-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 0.05rem 0.75rem;
}

.tools-list-item {
  border-radius: 8px;
  transition: background 0.2s ease;
}

.tools-list-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.3rem 0.4rem;
  color: rgba(255, 255, 255, 0.92);
  text-decoration: none;
  border-radius: 8px;
  transition: color 0.2s ease, background 0.2s ease;
}

.tools-list-item:hover .tools-list-link {
  background: rgba(255, 255, 255, 0.06);
  color: #fff;
}

.tools-list-link:focus-visible {
  outline: 2px solid rgba(255, 255, 255, 0.5);
  outline-offset: 2px;
}

.tools-list-icon-wrap {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 1.6rem;
  height: 1.6rem;
  flex-shrink: 0;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 6px;
  transition: background 0.2s ease, border-color 0.2s ease;
}

.tools-list-item:hover .tools-list-icon-wrap {
  background: rgba(255, 255, 255, 0.12);
  border-color: rgba(255, 255, 255, 0.12);
}

.tools-list-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 0.95rem;
  height: 0.95rem;
  color: rgba(255, 255, 255, 0.95);
}

.tools-list-icon :deep(svg),
.tools-list-icon .nuxt-logo {
  width: 0.95rem;
  height: 0.95rem;
  flex-shrink: 0;
}

.tools-list-icon .nuxt-logo {
  display: block;
}

.tools-list-text {
  display: flex;
  flex-direction: column;
  gap: 0.05rem;
  min-width: 0;
}

.tools-list-name {
  font-size: 0.8rem;
  font-weight: 600;
  color: inherit;
  line-height: 1.25;
}

.tools-list-desc {
  font-size: 0.6875rem;
  line-height: 1.3;
  color: rgba(255, 255, 255, 0.6);
}

.tools-list-item:hover .tools-list-desc {
  color: rgba(255, 255, 255, 0.75);
}

@media (max-width: 768px) {
  .tools-card-stellar {
    padding: 0.7rem 0.85rem;
  }
  .tools-card-header {
    margin-bottom: 0.5rem;
  }
  .tools-card-title {
    font-size: 0.8rem;
  }
  .tools-card-subtitle {
    font-size: 0.65rem;
  }
  .tools-list {
    grid-template-columns: 1fr;
    gap: 0.05rem;
  }
  .tools-list-link {
    gap: 0.45rem;
    padding: 0.25rem 0.35rem;
  }
  .tools-list-icon-wrap {
    width: 1.45rem;
    height: 1.45rem;
  }
  .tools-list-icon,
  .tools-list-icon :deep(svg),
  .tools-list-icon .nuxt-logo {
    width: 0.85rem;
    height: 0.85rem;
  }
  .tools-list-name {
    font-size: 0.75rem;
  }
  .tools-list-desc {
    font-size: 0.625rem;
  }
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
  gap: 1.75rem;
}

// Premium client cards
.client-card {
  display: flex;
  flex-direction: column;
  background: rgba(255, 255, 255, 0.94);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.4);
  border-radius: 24px;
  text-decoration: none;
  overflow: hidden;
  transition: transform 0.32s cubic-bezier(0.25, 0.46, 0.45, 0.94),
    box-shadow 0.32s ease,
    border-color 0.28s ease;
  box-shadow:
    0 2px 8px rgba(0, 0, 0, 0.04),
    0 12px 32px rgba(0, 0, 0, 0.06),
    inset 0 1px 0 rgba(255, 255, 255, 0.7);

  &:hover {
    transform: translateY(-6px);
    box-shadow:
      0 8px 24px rgba(0, 0, 0, 0.08),
      0 24px 48px rgba(0, 0, 0, 0.08),
      inset 0 1px 0 rgba(255, 255, 255, 0.8);
    border-color: rgba(255, 255, 255, 0.6);

    .client-cta {
      color: #4f46e5;
      background: rgba(79, 70, 229, 0.08);
      border-color: rgba(79, 70, 229, 0.2);
      svg {
        transform: translate(2px, -2px);
      }
    }
  }

  &.client-card-dark {
    background: linear-gradient(
      165deg,
      rgba(18, 49, 70, 0.92) 0%,
      rgba(18, 49, 70, 0.82) 100%
    );
    border: 1px solid rgba(84, 117, 128, 0.35);
    box-shadow:
      0 4px 16px rgba(0, 0, 0, 0.18),
      inset 0 1px 0 rgba(255, 255, 255, 0.06);

    .client-logo-wrap {
      background: transparent;
    }

    .client-name {
      color: #fff;
    }

    .client-type {
      color: rgba(148, 163, 184, 0.95);
    }

    .client-description {
      color: rgba(226, 232, 240, 0.88);
    }

    .client-cta {
      color: rgba(226, 232, 240, 0.9);
      background: rgba(255, 255, 255, 0.06);
      border: 1px solid rgba(255, 255, 255, 0.12);
    }

    &:hover {
      border-color: rgba(84, 117, 128, 0.5);
      box-shadow:
        0 12px 32px rgba(0, 0, 0, 0.22),
        0 0 0 1px rgba(84, 117, 128, 0.2),
        inset 0 1px 0 rgba(255, 255, 255, 0.08);
      .client-cta {
        color: #e2e8f0;
        background: rgba(255, 255, 255, 0.12);
        border-color: rgba(255, 255, 255, 0.2);
      }
    }
  }
}

// Video card: overlay by default; hover/click expands 30%, hides overlay, plays video
.client-card-video {
  position: relative;
  overflow: hidden;
  min-height: 300px;
  cursor: pointer;
  transition: transform 0.35s cubic-bezier(0.25, 0.46, 0.45, 0.94),
    box-shadow 0.35s ease,
    z-index 0s;
  z-index: 0;

  &.client-card-video-active {
    transform: scale(1.3);
    z-index: 10;
    box-shadow:
      0 16px 48px rgba(0, 0, 0, 0.35),
      0 0 0 1px rgba(255, 255, 255, 0.08);
  }

  .client-video-frame {
    position: absolute;
    inset: 0;
  }

  .client-highlight-video {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
  }

  .client-card-overlay {
    position: absolute;
    inset: 0;
    z-index: 1;
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    padding: 1.5rem 1.5rem 1.25rem;
    background: linear-gradient(
      to top,
      rgba(0, 0, 0, 0.92) 0%,
      rgba(0, 0, 0, 0.5) 45%,
      rgba(0, 0, 0, 0.2) 100%
    );
    transition: opacity 0.3s ease, visibility 0.3s ease;
    pointer-events: auto;
  }

  .client-card-overlay-hidden {
    opacity: 0;
    visibility: hidden;
    pointer-events: none;
  }

  .client-info {
    margin-bottom: 0.75rem;
  }

  .client-name,
  .client-type,
  .client-description {
    color: #fff;
    text-shadow: 0 1px 4px rgba(0, 0, 0, 0.5);
  }

  .client-type {
    color: rgba(255, 255, 255, 0.9);
  }

  .client-description {
    color: rgba(255, 255, 255, 0.92);
  }

  .client-cta,
  .client-cta-link {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.4rem;
    padding: 0.5rem 1rem;
    font-size: 0.8125rem;
    font-weight: 600;
    color: rgba(255, 255, 255, 0.98);
    background: rgba(255, 255, 255, 0.12);
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 10px;
    text-decoration: none;
    transition: color 0.2s ease, background 0.2s ease, border-color 0.2s ease;
  }

  .client-cta-link:hover {
    color: #fff;
    background: rgba(255, 255, 255, 0.2);
    border-color: rgba(255, 255, 255, 0.3);
  }
}

.client-logo-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.6rem;
  flex: 1;
  min-height: 200px;
  padding: 1.5rem 1rem;
  background: transparent;
  overflow: hidden;
}

.client-logo-above {
  width: auto;
  object-fit: contain;
  max-width: 8rem;
  height: auto;
}

.client-logo {
  max-width: 85%;
  width: auto;
  object-fit: contain;
  max-height: 4rem;
}

.client-info {
  text-align: center;
  padding: 0 1.25rem;
  flex: 0 0 auto;
}

.client-name {
  font-size: 1.25rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: #0f172a;
  margin: 0 0 0.25rem;
  line-height: 1.3;
}

.client-type {
  font-size: 0.6875rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  color: #64748b;
  margin: 0 0 0.5rem;
}

.client-description {
  font-size: 0.875rem;
  line-height: 1.55;
  color: #475569;
  margin: 0;
}

.client-cta {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.4rem;
  margin-top: 1rem;
  padding: 0.5rem 1rem;
  font-size: 0.8125rem;
  font-weight: 600;
  letter-spacing: 0.02em;
  color: #475569;
  background: transparent;
  border: 1px solid rgba(0, 0, 0, 0.08);
  border-radius: 10px;
  transition: color 0.22s ease, background 0.22s ease, border-color 0.22s ease;

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

  .client-card-video {
    flex-direction: column;
    align-items: stretch;
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
