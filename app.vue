<template>
  <div class="layout-wrapper" :class="{ 'theme-dark': theme === 'dark', 'theme-light': theme === 'light' }">
    <a href="#main-content" class="skip-link">Skip to main content</a>

    <CosmicBackground v-if="!isDashboard" />

    <SiteHeader
      v-if="!isDashboard"
      :scrolled="scrolledPastThreshold"
      :compact="headerCompact"
      :hide-cta="showStickyCta"
    />

    <main id="main-content" class="main-content" tabindex="-1">
      <template v-if="isDashboard">
        <div class="dashboard-layout">
          <DashboardSidebar />
          <div class="dashboard-main">
            <DashboardTopBar />
            <NuxtPage />
          </div>
        </div>
      </template>
      <div v-else class="page-content" :class="{ 'page-content--sticky-cta': showStickyCta }">
        <NuxtPage />
      </div>
    </main>

    <StickyCtaBar v-if="showStickyCta" />
    <SiteFooter v-if="!isDashboard" />
  </div>

  <ContactModal v-if="!isDashboard" />
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useRoute } from 'vue-router'
import SiteHeader from '@/components/SiteHeader.vue'
import ContactModal from '@/components/ContactModal.vue'
import DashboardSidebar from '@/components/DashboardSidebar.vue'
import DashboardTopBar from '@/components/DashboardTopBar.vue'

const route = useRoute()
const { theme } = useTheme()
const isDashboard = computed(() => route.path.startsWith('/dashboard'))

const longFormRoutes = ['/', '/services', '/products']
const showStickyCta = computed(() => longFormRoutes.includes(route.path))

const scrolledPastThreshold = ref(false)
const headerCompact = ref(false)
let lastScrollY = 0

function handleScroll() {
  const y = window.scrollY
  scrolledPastThreshold.value = y > 50
  if (y <= 50) {
    headerCompact.value = false
  } else if (y > lastScrollY) {
    headerCompact.value = true
  } else {
    headerCompact.value = false
  }
  lastScrollY = y
}

onMounted(() => {
  document.body.style.overflow = 'auto'
  lastScrollY = window.scrollY
  handleScroll()
  window.addEventListener('scroll', handleScroll, { passive: true })
})

onBeforeUnmount(() => {
  document.body.style.overflow = 'auto'
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style lang="scss">
@use '@/assets/scss/variables.scss' as *;

.layout-wrapper {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  font-family: var(--font-ui);
  color: var(--color-text);
  position: relative;
  overflow: visible;
  background: transparent;
}

.skip-link {
  position: absolute;
  top: -100%;
  left: var(--space-4);
  z-index: 10000;
  padding: var(--space-3) var(--space-4);
  background: var(--color-accent);
  color: var(--color-space-deep);
  font-weight: 600;
  text-decoration: none;
  border-radius: var(--radius-sm);
  transition: top var(--dur-fast) var(--ease-out);

  &:focus {
    top: var(--space-4);
    outline: 2px solid var(--color-accent);
    outline-offset: 2px;
  }
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: transparent;
  position: relative;
  z-index: 2;
}

.page-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  background-color: transparent;
  position: relative;
  z-index: 2;
  padding-left: env(safe-area-inset-left, 0px);
  padding-right: env(safe-area-inset-right, 0px);
  padding-bottom: env(safe-area-inset-bottom, 0px);
}

@media (max-width: 768px) {
  .page-content--sticky-cta {
    padding-bottom: calc(var(--site-footer-height, 4rem) + 4.5rem + env(safe-area-inset-bottom, 0px));
  }
}

/* WordPress content — theme-aware */
.wp-content {
  color: var(--color-text);

  p {
    display: block;
    margin-bottom: 1rem;
    line-height: 1.6;
    color: var(--color-text-muted);
  }

  h1, h2, h3, h4, h5, h6 {
    display: block;
    margin-top: 1.5rem;
    margin-bottom: 1rem;
    font-weight: 600;
    color: var(--color-text);
    font-family: var(--font-display);
  }

  ul, ol {
    display: block;
    margin-left: 1.5rem;
    margin-bottom: 1rem;
    color: var(--color-text-muted);

    li {
      display: list-item;
      margin-bottom: 0.5rem;
    }
  }

  img {
    max-width: 100%;
    height: auto;
    display: block;
    margin: 1rem 0;
    border-radius: var(--radius-md);
  }

  a {
    color: var(--color-accent);
    text-decoration: underline;
    text-underline-offset: 2px;

    &:hover {
      color: var(--color-text);
    }

    &:focus-visible {
      outline: 2px solid var(--color-accent);
      outline-offset: 2px;
    }
  }
}
</style>
