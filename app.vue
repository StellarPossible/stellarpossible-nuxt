<template>
  <div class="layout-wrapper" :class="{ 'show-logo': isHomePage, 'theme-dark': theme === 'dark', 'theme-light': theme === 'light' }">
    <!-- Homepage background overlay fade -->
    <div v-if="isHomePage" class="homepage-overlay"></div>

    <!-- Header with scroll prop -->
    <SiteHeader :scrolled="!scrolledPastThreshold" :compact="headerCompact" />

    <main class="main-content">
      <div class="page-content">
        <!-- Render hero content only on home -->
        <HeroContent v-if="isHomePage" />
        <!-- Render all routed pages except home -->
        <NuxtPage v-else />
      </div>
    </main>
  </div>

  <!-- Floating help button -->
  <FloatingHelp />

  <!-- Contact modal -->
  <ContactModal />

  <SiteFooter :scrolled="scrolledPastThreshold" />
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import { useRoute } from 'vue-router'
import HeroContent from '@/components/HeroContent.vue'
import SiteHeader from '@/components/SiteHeader.vue'
import ContactModal from '@/components/ContactModal.vue'
import FloatingHelp from '@/components/FloatingHelp.vue'

const route = useRoute()
const { theme } = useTheme()
const isHomePage = computed(() => route.path === '/')
const isServicesPage = computed(() => route.path === '/services')

const scrolledPastThreshold = ref(false)
const headerCompact = ref(false)
let lastScrollY = 0

function handleScroll() {
  const y = window.scrollY
  scrolledPastThreshold.value = y > 50
  // Recede to toolbar when scrolling down; expand when scrolling up or near top
  if (y <= 50) {
    headerCompact.value = false
  } else if (y > lastScrollY) {
    headerCompact.value = true
  } else {
    headerCompact.value = false
  }
  lastScrollY = y
}

function setupScrollListener() {
  const needsListener = !isHomePage.value && !isServicesPage.value
  if (needsListener) {
    lastScrollY = window.scrollY
    handleScroll()
    window.addEventListener('scroll', handleScroll)
  } else {
    window.removeEventListener('scroll', handleScroll)
  }
}

onMounted(() => {
  // Disable scroll on homepage and services page (no-scroll design)
  const lockScroll = isHomePage.value || isServicesPage.value
  document.body.style.overflow = lockScroll ? 'hidden' : 'auto'
  setupScrollListener()
})

onBeforeUnmount(() => {
  document.body.style.overflow = 'auto'
  window.removeEventListener('scroll', handleScroll)
})

watch([isHomePage, isServicesPage], ([isHome, isServices]) => {
  document.body.style.overflow = isHome || isServices ? 'hidden' : 'auto'
  setupScrollListener()
})
</script>

<style lang="scss">
@use '@/assets/scss/variables.scss' as *;

.layout-wrapper {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  font-family: 'Inter', sans-serif;
  color: $white;
  position: relative;
  background-size: cover;
  background-attachment: fixed;
  background-repeat: no-repeat;
  background-position: center center;
  /* overflow: visible so fixed nav-drawer (hamburger slide-out) is not clipped on home/dashboard */
  overflow: visible;

  &.theme-dark {
    background-color: var(--primary-color, #0e0f1a);
    background-image: url('/images/primary/galaxyBackgroundV2.png');
  }

  &.theme-light {
    background-color: #f0f4f8;
    background-image: url('/images/primary/galaxyBackgroundLIGHT.png');
    color: #1a1a2e;
  }
  /* Ensure main content text is readable in light mode */
  &.theme-light .main-content,
  &.theme-light .page-content {
    color: #1a1a2e;
  }

  &.show-logo::after {
    content: '';
    position: absolute;
    inset: 0;
    pointer-events: none;
    z-index: 1;
    background: linear-gradient(
      to bottom,
      rgba(0, 0, 0, 0) 60%,
      rgba(0, 0, 0, 0.95) 100%
    );
  }

  &.theme-light.show-logo::after {
    background: linear-gradient(
      to bottom,
      rgba(255, 255, 255, 0) 50%,
      rgba(240, 244, 248, 0.9) 100%
    );
  }
}

.homepage-overlay {
  display: none; // Not needed now, fade handled via ::after
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
  justify-content: center;
  position: relative;
  z-index: 2;
  margin-bottom: 3rem;
  margin-top: 6.5rem;

  .show-logo & {
    max-height: 100vh;
    overflow: hidden;
  }
}

/* WordPress content global styles */
.wp-content {
  color: #333;
  
  p {
    display: block;
    margin-bottom: 1rem;
    line-height: 1.6;
  }
  
  h1, h2, h3, h4, h5, h6 {
    display: block;
    margin-top: 1.5rem;
    margin-bottom: 1rem;
    font-weight: 600;
    color: #222;
  }
  
  ul, ol {
    display: block;
    margin-left: 1.5rem;
    margin-bottom: 1rem;
    
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
  }
  
  a {
    color: #0066cc;
    text-decoration: underline;
    
    &:hover {
      color: #004499;
    }
  }
}
</style>
