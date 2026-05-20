<template>
  <section class="products-page">
    <!-- Tabs: zero scroll, one panel at a time -->
    <div
      class="products-tabs"
      role="tablist"
      aria-label="Content categories"
      @keydown.left.prevent="navigateTab(-1)"
      @keydown.right.prevent="navigateTab(1)"
    >
      <button
        type="button"
        role="tab"
        :aria-selected="activeTab === 'portfolio'"
        :class="['tab-trigger', { active: activeTab === 'portfolio' }]"
        @click="activeTab = 'portfolio'"
      >
        <ClientOnly>
          <Icon icon="mdi:view-grid-outline" aria-hidden />
          <template #fallback><span aria-hidden>◆</span></template>
        </ClientOnly>
        <span>Our Work</span>
      </button>
      <button
        type="button"
        role="tab"
        :aria-selected="activeTab === 'featured'"
        :class="['tab-trigger', { active: activeTab === 'featured' }]"
        @click="activeTab = 'featured'"
      >
        <ClientOnly>
          <Icon icon="mdi:star" aria-hidden />
          <template #fallback><span aria-hidden>★</span></template>
        </ClientOnly>
        <span>Featured</span>
      </button>
      <button
        type="button"
        role="tab"
        :aria-selected="activeTab === 'stack'"
        :class="['tab-trigger', { active: activeTab === 'stack' }]"
        @click="activeTab = 'stack'"
      >
        <ClientOnly>
          <Icon icon="mdi:code-tags" aria-hidden />
          <template #fallback><span aria-hidden>◆</span></template>
        </ClientOnly>
        <span>Stack</span>
      </button>
    </div>

    <div class="tab-panels">
      <Transition name="tab-fade" mode="out-in">
        <div :key="activeTab" role="tabpanel" class="tab-panel">
          <!-- Portfolio panel -->
          <div v-if="activeTab === 'portfolio'" class="products-inner portfolio-panel">
            <div class="portfolio-grid" role="list">
          <template v-for="client in clients" :key="client.id">
            <!-- Video card: hover or tap to play; leave or tap again to stop -->
            <article
              v-if="client.highlightVideo"
              class="client-card client-card-dark client-card-video"
              role="listitem"
              :aria-labelledby="`client-name-${client.id}`"
              @mouseenter="setVideoCardHovered(client.id, true)"
              @mouseleave="setVideoCardHovered(client.id, false)"
              @click="toggleVideoPinned(client.id)"
            >
              <div class="client-video-frame">
                <!-- Poster: default state -->
                <div
                  class="client-video-poster"
                  :class="{ 'client-video-poster-hidden': isVideoActive(client.id) }"
                  :style="{ backgroundImage: `url(${client.logo})` }"
                >
                  <span class="client-video-hint">Tap or hover to preview</span>
                </div>
                <!-- Video: loads and plays on hover or tap -->
                <ClientOnly>
                  <video
                    v-if="isVideoActive(client.id)"
                    :ref="(el) => setVideoRef(client.id, el)"
                    class="client-highlight-video"
                    :src="getVideoSrc(client.highlightVideo)"
                    preload="auto"
                    muted
                    loop
                    playsinline
                    aria-hidden="true"
                    @loadeddata="onVideoLoadedData(client.id)"
                  />
                  <template #fallback>
                    <div class="client-video-fallback" :style="{ backgroundImage: `url(${client.logo})` }" />
                  </template>
                </ClientOnly>
              </div>
              <div class="client-card-footer">
                <h3 :id="`client-name-${client.id}`" class="client-name">{{ client.title }}</h3>
                <p class="client-type">{{ client.type }}</p>
                <p class="client-description">{{ client.description }}</p>
                <a
                  :href="client.url"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="client-cta-primary"
                  :aria-label="`Visit ${client.title} website`"
                  @click.stop
                >
                  {{ client.ctaLabel || 'Visit site' }}
                  <ClientOnly>
                    <Icon icon="mdi:open-in-new" aria-hidden />
                    <template #fallback><span>↗</span></template>
                  </ClientOnly>
                </a>
              </div>
            </article>
            <!-- Non-video card -->
            <a
              v-else
              :href="client.url"
              target="_blank"
              rel="noopener noreferrer"
              class="client-card"
              :class="{ 'client-card-dark': client.darkTheme }"
              role="listitem"
              :aria-label="`${client.title} — ${client.description}. Visit site.`"
            >
              <div class="client-logo-wrap">
                <img
                  v-if="client.logoAbove"
                  :src="client.logoAbove"
                  :alt="''"
                  class="client-logo-above"
                  aria-hidden="true"
                />
                <img :src="client.logo" :alt="`${client.title} logo`" class="client-logo" />
              </div>
              <div class="client-info">
                <h3 class="client-name">{{ client.title }}</h3>
                <p class="client-type">{{ client.type }}</p>
                <p class="client-description">{{ client.description }}</p>
              </div>
              <span class="client-cta client-cta-primary-inline">
                {{ client.ctaLabel || 'Visit site' }}
                <ClientOnly>
                  <Icon icon="mdi:open-in-new" />
                  <template #fallback><span>↗</span></template>
                </ClientOnly>
              </span>
            </a>
          </template>
            </div>
          </div>
          <!-- Featured panel -->
          <div v-else-if="activeTab === 'featured'" class="products-inner featured-panel">
            <article class="featured featured-compact">
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
          <ul class="featured-features featured-features-compact">
            <li>WordPress modernization & DevOps</li>
            <li>CI/CD, monitoring, managed hosting</li>
            <li>API development & integrations</li>
          </ul>
          <NuxtLink :to="primaryCtaPath" class="featured-cta">
            {{ primaryCtaLabel }}
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
          </div>
          <!-- Stack panel -->
          <div v-else-if="activeTab === 'stack'" class="products-inner stack-panel">
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
          </div>
        </div>
      </Transition>
    </div>

    <!-- Slim strip -->
    <div class="products-strip" role="complementary" aria-label="Quick links">
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
      <NuxtLink to="/services" class="strip-link">
        Services
        <ClientOnly>
          <Icon icon="mdi:arrow-right" aria-hidden />
          <template #fallback><span aria-hidden>→</span></template>
        </ClientOnly>
      </NuxtLink>
    </div>
  </section>
</template>

<script setup lang="ts">
import { productsHeaderHeroKey } from '~/composables/usePageHero'

const { path: primaryCtaPath, label: primaryCtaLabel } = usePrimaryCta()
const { open: openContact } = useContactModal()

type TabId = 'portfolio' | 'featured' | 'stack'
const activeTab = ref<TabId>('portfolio')
const productsHeaderHero = useState<{ badge?: string; title: string; subtitle?: string } | null>(productsHeaderHeroKey, () => null)

const tabHeroContent: Record<TabId, { badge?: string; title: string; subtitle: string }> = {
  portfolio: {
    badge: 'Our Work',
    title: 'Crafted with Purpose',
    subtitle: 'We build performant, secure, and beautifully designed digital experiences that drive results.'
  },
  featured: {
    title: 'Featured Project',
    subtitle: 'A closer look at one of our flagship engagements.'
  },
  stack: {
    title: 'Tools we use',
    subtitle: 'Modern, reliable stack for design, development, and hosting.'
  }
}

const tabOrder: TabId[] = ['portfolio', 'featured', 'stack']
function navigateTab(delta: number) {
  const i = tabOrder.indexOf(activeTab.value)
  const next = (i + delta + tabOrder.length) % tabOrder.length
  activeTab.value = tabOrder[next]
}

watch(activeTab, (tab) => {
  productsHeaderHero.value = tabHeroContent[tab] ?? null
}, { immediate: true })

onBeforeUnmount(() => {
  productsHeaderHero.value = null
})

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
  /** Optional: primary CTA label for conversion (e.g. "Visit site") */
  ctaLabel?: string
}

// Video card: hover or tap to play; leave or tap again to stop
const hoveredVideoId = ref<string | null>(null)
const pinnedVideoId = ref<string | null>(null)
const videoRefs: Record<string, HTMLVideoElement | null> = {}

function isVideoActive(id: string) {
  return hoveredVideoId.value === id || pinnedVideoId.value === id
}

function getVideoSrc(path: string | undefined): string {
  if (!path) return ''
  if (typeof window !== 'undefined') {
    return new URL(path, window.location.origin).href
  }
  return path
}

function setVideoRef(id: string, el: unknown) {
  videoRefs[id] = el && el instanceof HTMLVideoElement ? el : null
}

function onVideoLoadedData(id: string) {
  const video = videoRefs[id]
  if (video && isVideoActive(id)) {
    video.currentTime = 0
    video.muted = false
    video.play().catch(() => {})
  }
}

function setVideoCardHovered(id: string, hovered: boolean) {
  if (!hovered && pinnedVideoId.value !== id) {
    const video = videoRefs[id]
    if (video) {
      video.pause()
      video.currentTime = 0
    }
  }
  hoveredVideoId.value = hovered ? id : null
}

function toggleVideoPinned(id: string) {
  if (pinnedVideoId.value === id) {
    const video = videoRefs[id]
    if (video) {
      video.pause()
      video.currentTime = 0
    }
    pinnedVideoId.value = null
  } else {
    pinnedVideoId.value = id
  }
}

function handleClickOutsideVideo(event: MouseEvent) {
  const target = event.target as Node
  if (target && !(target as Element).closest?.('.client-card-video')) {
    const id = pinnedVideoId.value
    if (id) {
      const video = videoRefs[id]
      if (video) {
        video.pause()
        video.currentTime = 0
      }
      pinnedVideoId.value = null
    }
  }
}

onMounted(() => {
  if (typeof document !== 'undefined') {
    document.addEventListener('click', handleClickOutsideVideo)
  }
})

onBeforeUnmount(() => {
  if (typeof document !== 'undefined') {
    document.removeEventListener('click', handleClickOutsideVideo)
  }
})

const toolsWeUse = [
  { name: 'Nuxt.js', description: 'Vue-based framework for fast, modern web apps.', icon: 'simple-icons:nuxtdotjs', url: 'https://nuxt.com' },
  { name: 'Visual Studio Code', description: 'Code editor we use for development.', icon: 'simple-icons:visualstudiocode', url: 'https://code.visualstudio.com' },
  { name: 'GitHub', description: 'Version control and collaboration.', icon: 'simple-icons:github', url: 'https://github.com' },
  { name: 'Slack', description: 'Client communication and file sharing.', icon: 'simple-icons:slack', url: 'https://slack.com' },
  { name: 'WordPress', description: 'Content management and headless CMS.', icon: 'simple-icons:wordpress', url: 'https://wordpress.org' },
  { name: 'Hostinger', description: 'Reliable hosting for client sites.', icon: 'simple-icons:hostinger', url: 'https://www.hostinger.com' },
  { name: 'Unsplash', description: 'High-quality stock imagery.', icon: 'simple-icons:unsplash', url: 'https://unsplash.com' },
  { name: 'Adobe Photoshop', description: 'Logo and visual design work.', icon: 'simple-icons:adobephotoshop', url: 'https://www.adobe.com/products/photoshop.html' },
  { name: 'Procreate', description: 'Digital illustration and design on iPad.', icon: 'simple-icons:procreate', url: 'https://procreate.art' },
]

const clients: Client[] = [
  {
    id: 'kavoossi',
    title: 'Kavoossi',
    type: 'Indie Rock · Annapolis, MD, USA',
    description: 'Website design, development, and hosting for the Annapolis-based indie-rock band.',
    url: 'https://kavoossi.com',
    highlightVideo: '/videos/kavoossiPreview.mp4',
    logoAbove: '/images/primary/BLUE GUY transparent.png',
    logo: '/images/primary/kavoossi.png',
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
.visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

/* No-scroll: constrain to viewport (desktop) */
.products-page {
  --products-height: calc(100dvh - var(--site-header-height, 5rem) - var(--site-footer-height, 3rem));
  padding: 0.75rem 1.25rem 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #fff;
  width: 100%;
  max-width: 100%;
  min-width: 0;
  overflow-x: hidden;
  box-sizing: border-box;
  height: var(--products-height);
  max-height: var(--products-height);
  overflow-y: hidden;
}

/* Tab triggers */
.products-tabs {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 0.375rem;
  margin-bottom: 0.75rem;
  padding: 0.35rem;
  background: linear-gradient(145deg, rgba(18, 49, 70, 0.5) 0%, rgba(24, 58, 82, 0.35) 100%);
  border: 1px solid rgba(120, 180, 220, 0.2);
  border-radius: 14px;
  width: 100%;
  max-width: 36rem;
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
  transition: background 0.25s ease, color 0.25s ease;
  white-space: nowrap;
  flex: 1 1 auto;
  min-width: min(7.5rem, 100%);
}

.tab-trigger:hover {
  background: rgba(255, 255, 255, 0.08);
  color: #fff;
}

.tab-trigger.active {
  background: rgba(255, 255, 255, 0.12);
  color: #fff;
  box-shadow: 0 0 20px rgba(120, 180, 255, 0.12);
  border: 1px solid rgba(160, 200, 255, 0.2);
}

.tab-trigger:focus-visible {
  outline: 2px solid rgba(255, 255, 255, 0.6);
  outline-offset: 2px;
}

.tab-trigger svg {
  font-size: 1.125rem;
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

.tab-panels {
  width: 100%;
  max-width: 1100px;
  flex: 1;
  min-height: 0;
  overflow-y: auto;
  overflow-x: hidden;
}

.tab-panel {
  margin-bottom: 0;
  height: 100%;
}

/* Slim strip */
.products-strip {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem 0.75rem;
  padding: 0.5rem 1rem;
  flex-shrink: 0;
  min-height: 2.5rem;
}

.products-strip .strip-sep {
  opacity: 0.4;
  font-size: 0.75rem;
}

.products-strip .strip-link {
  display: inline-flex;
  align-items: center;
  gap: 0.3rem;
  font-size: 0.875rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.9);
  text-decoration: none;
  transition: color 0.2s ease;
}

.products-strip .strip-link:hover {
  color: #fff;
}

.products-strip .strip-link-button {
  background: transparent;
  border: none;
  cursor: pointer;
  font-family: inherit;
}

.products-strip .strip-link:focus-visible {
  outline: 2px solid rgba(255, 255, 255, 0.45);
  outline-offset: 2px;
}

.products-inner {
  max-width: 1100px;
  margin: 0 auto;
  width: 100%;
}

/* Compact featured for no-scroll */
.featured-panel .featured-compact {
  padding: 1.25rem;
  gap: 1.25rem;
}

.featured-compact .featured-badge {
  margin-bottom: 0.75rem;
}

.featured-compact .featured-title {
  font-size: 1.5rem;
}

.featured-compact .featured-tagline {
  margin-bottom: 0.75rem;
}

.featured-compact .featured-description {
  font-size: 0.9375rem;
  margin-bottom: 1rem;
}

.featured-features-compact {
  gap: 0.4rem !important;
  margin-bottom: 1rem !important;
  list-style: none;
}

.featured-features-compact li {
  font-size: 0.875rem !important;
  display: flex;
  align-items: center;
  gap: 0.4rem;
}

.featured-features-compact li::before {
  content: '✓';
  color: #10b981;
  font-weight: 600;
  flex-shrink: 0;
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

/* Stack panel */
.stack-panel {
  padding-top: 0;
}

.tools-card-section {
  margin-bottom: 0;
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
  gap: 2rem;
  align-items: center;
  padding: 2rem;
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
  width: 100px;
  height: 100px;
  background: linear-gradient(145deg, #f0f9ff 0%, #e0f2fe 50%, #bae6fd 100%);
  border-radius: 28px;
  border: 1px solid rgba(59, 130, 246, 0.2);
  box-shadow: 
    0 2px 8px rgba(59, 130, 246, 0.12),
    inset 0 1px 0 rgba(255, 255, 255, 0.8);

  .featured-icon {
    font-size: 2.5rem;
    color: #2563eb;
  }

  .icon-placeholder {
    font-size: 2.5rem;
  }
}

.featured-compact .featured-icon-wrap {
  width: 80px;
  height: 80px;

  .featured-icon {
    font-size: 2rem;
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

/* Portfolio panel */
.portfolio-panel {
  padding-top: 0;
}

.portfolio-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.25rem;
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

    .client-cta,
    .client-cta-primary-inline {
      color: rgba(226, 232, 240, 0.95);
      background: rgba(255, 255, 255, 0.08);
      border: 1px solid rgba(255, 255, 255, 0.15);
    }

    .client-cta-primary-inline {
      color: #0f172a;
      background: #fff;
      border: none;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
    }

    &:hover {
      border-color: rgba(84, 117, 128, 0.5);
      box-shadow:
        0 12px 32px rgba(0, 0, 0, 0.22),
        0 0 0 1px rgba(84, 117, 128, 0.2),
        inset 0 1px 0 rgba(255, 255, 255, 0.08);
      .client-cta:not(.client-cta-primary-inline) {
        color: #e2e8f0;
        background: rgba(255, 255, 255, 0.12);
        border-color: rgba(255, 255, 255, 0.2);
      }
      .client-cta-primary-inline {
        background: #f1f5f9;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
        transform: translateY(-1px);
      }
    }
  }
}

// Video card: clean hover-to-play; no scale, no pin
.client-card-video {
  position: relative;
  overflow: hidden;
  width: 100%;
  display: flex;
  flex-direction: column;
  border-radius: 24px;

  .client-video-frame {
    position: relative;
    aspect-ratio: 16 / 9;
    background: #000;
    overflow: hidden;
  }

  .client-video-poster {
    position: absolute;
    inset: 0;
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
    transition: opacity 0.25s ease;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .client-video-poster-hidden {
    opacity: 0;
    pointer-events: none;
  }

  .client-video-hint {
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    color: rgba(255, 255, 255, 0.5);
    margin-top: 40%;
  }

  .client-video-fallback {
    position: absolute;
    inset: 0;
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
  }

  .client-highlight-video {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    object-fit: contain;
    display: block;
  }

  .client-card-footer {
    padding: 1.25rem 1.25rem 1rem;
    background: linear-gradient(
      to bottom,
      rgba(18, 49, 70, 0.95) 0%,
      rgba(18, 49, 70, 0.98) 100%
    );
    flex: 1;
    display: flex;
    flex-direction: column;
    min-height: 0;
  }

  .client-name {
    font-size: 1.2rem;
    font-weight: 700;
    color: #fff;
    margin: 0 0 0.25rem;
    line-height: 1.25;
  }

  .client-type {
    font-size: 0.7rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    color: rgba(255, 255, 255, 0.7);
    margin: 0 0 0.4rem;
  }

  .client-description {
    font-size: 0.875rem;
    line-height: 1.45;
    color: rgba(255, 255, 255, 0.9);
    margin: 0 0 1rem;
    flex: 1;
  }

  .client-cta-primary {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.45rem;
    padding: 0.6rem 1.1rem;
    font-size: 0.9375rem;
    font-weight: 700;
    color: #0f172a;
    background: #fff;
    border: none;
    border-radius: 10px;
    text-decoration: none;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.25);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    margin-top: auto;
  }

  .client-cta-primary:hover {
    background: #f1f5f9;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
    transform: translateY(-1px);
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

// Primary CTA on non-video cards (conversion-focused)
.client-cta-primary-inline {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.4rem;
  margin-top: 1rem;
  padding: 0.6rem 1.15rem;
  font-size: 0.9375rem;
  font-weight: 700;
  color: #fff;
  background: #4f46e5;
  border: none;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(79, 70, 229, 0.35);
  transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
}

.client-card:hover .client-cta-primary-inline {
  background: #4338ca;
  box-shadow: 0 4px 12px rgba(79, 70, 229, 0.4);
  transform: translateY(-1px);
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

/* Mobile: allow scroll, stack tabs */
@media (max-width: 768px) {
  .products-page {
    height: auto;
    min-height: var(--products-height);
    max-height: none;
    overflow-y: auto;
  }

  .products-strip {
    flex-wrap: wrap;
    justify-content: center;
    row-gap: 0.35rem;
    column-gap: 0.5rem;
    padding-left: max(0.5rem, env(safe-area-inset-left));
    padding-right: max(0.5rem, env(safe-area-inset-right));
    padding-bottom: max(0.35rem, env(safe-area-inset-bottom));
  }

  .products-strip .strip-link {
    font-size: clamp(0.75rem, 3.4vw, 0.8125rem);
  }

  .products-tabs {
    flex-direction: column;
    max-width: 100%;
  }

  .tab-trigger {
    width: 100%;
    min-width: 0;
    justify-content: center;
  }
}

@media (max-width: 880px) {
  .products-tabs {
    flex-direction: column;
  }
}

@media (max-height: 600px) {
  .products-page {
    overflow-y: auto;
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

  .client-card-video .client-cta-primary {
    width: 100%;
    justify-content: center;
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

  .client-cta,
  .client-cta-primary-inline {
    margin-top: 0;
    margin-left: auto;
    white-space: nowrap;
  }
}

@media (max-width: 600px) {
  .products-page {
    padding: 4rem 1rem 3rem;
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
