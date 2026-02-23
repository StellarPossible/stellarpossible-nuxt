<template>
  <footer ref="footerEl" class="site-footer" :class="{ 'theme-light': theme === 'light', 'scrolled': scrolled }">
    <nav v-if="isAuthPage" class="auth-cross-nav" aria-label="Site navigation">
      <NuxtLink to="/services" class="auth-cross-link">Services</NuxtLink>
      <span class="auth-cross-sep" aria-hidden="true">·</span>
      <NuxtLink to="/products" class="auth-cross-link">Our Work</NuxtLink>
      <span class="auth-cross-sep" aria-hidden="true">·</span>
      <button type="button" class="auth-cross-link auth-cross-contact" @click="openContact">Contact</button>
    </nav>
    <div class="footer-content">
      <a
        href="https://instagram.com/stellarpossible"
        target="_blank"
        rel="noopener noreferrer"
        class="footer-ig"
        aria-label="Instagram (opens in new tab)"
      >
        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" aria-hidden="true">
          <path class="ig-body" d="M7 2h10a5 5 0 0 1 5 5v10a5 5 0 0 1-5 5H7a5 5 0 0 1-5-5V7a5 5 0 0 1 5-5z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          <circle class="ig-lens" cx="12" cy="12" r="4" stroke-width="2"/>
          <circle class="ig-dot" cx="16.5" cy="7.5" r="1.25" fill="currentColor"/>
        </svg>
      </a>
      <span class="copyright">&copy; {{ year }} StellarPossible, LLC</span>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'

defineProps<{ scrolled?: boolean }>()

const route = useRoute()
const footerEl = ref<HTMLElement | null>(null)
const year = new Date().getFullYear()
const { theme } = useTheme()
const { open: openContact } = useContactModal()

const isAuthPage = computed(() => {
  const p = route.path
  return p === '/login' || p === '/register'
})

function syncFooterHeight() {
  if (import.meta.client && footerEl.value) {
    const h = footerEl.value.offsetHeight
    document.documentElement.style.setProperty('--site-footer-height', `${h}px`)
  }
}

let resizeObserver: ResizeObserver | null = null
onMounted(() => {
  if (import.meta.client) {
    syncFooterHeight()
    resizeObserver = new ResizeObserver(syncFooterHeight)
    if (footerEl.value) resizeObserver.observe(footerEl.value)
  }
})
onBeforeUnmount(() => {
  if (import.meta.client && resizeObserver && footerEl.value) {
    resizeObserver.unobserve(footerEl.value)
  }
})
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.site-footer {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100%;
  padding: 0.35rem 0.5rem;
  background: $primary;
  color: $white;
  font-family: 'Montserrat', sans-serif;
  text-align: center;
  font-size: 1.5rem;
  z-index: 3000;
  overflow: hidden;
  transition: background 0.3s ease, color 0.3s ease;

  &::before {
    content: '';
    position: absolute;
    inset: 0;
    background: rgba(0, 0, 0, 0.6);
    background-size: cover;
    background-attachment: fixed;
    filter: blur(3px);
    z-index: -1;
    transition: opacity 0.3s ease;
  }

  &.scrolled::before {
    opacity: 0.25;
  }

  &.theme-light {
    /* Soft blue-grey to complement light galaxy background */
    background: rgba(226, 232, 240, 0.92);
    color: #1a1a2e;
    &::before {
      background: rgba(226, 232, 240, 0.92);
      filter: none;
    }
    &.scrolled::before {
      opacity: 0.25;
    }
  }

  .auth-cross-nav {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    align-items: center;
    gap: 0.5rem;
    padding: 0.6rem 0.5rem 0.5rem;
    margin: 0 0 0.25rem 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
    position: relative;
    z-index: 1;
  }

  &.theme-light .auth-cross-nav {
    border-bottom-color: rgba(0, 0, 0, 0.12);
  }

  .auth-cross-link {
    font-size: 0.9375rem;
    font-weight: 500;
    color: rgba(255, 255, 255, 0.85);
    text-decoration: none;
    background: none;
    border: none;
    cursor: pointer;
    padding: 0;
    transition: color 0.2s ease;
  }

  .auth-cross-link:hover {
    color: #fff;
  }

  &.theme-light .auth-cross-link {
    color: rgba(26, 26, 46, 0.85);
    &:hover {
      color: #1a1a2e;
    }
  }

  .auth-cross-sep {
    color: rgba(255, 255, 255, 0.4);
    font-size: 0.875rem;
    user-select: none;
  }

  &.theme-light .auth-cross-sep {
    color: rgba(26, 26, 46, 0.4);
  }

  .footer-content {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: center;
    align-items: center;
    gap: 0.5rem;
    position: relative;
    z-index: 1;
  }

  .footer-ig {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    color: $white;
    padding: 0.2rem;
    transition: color 0.2s ease, transform 0.15s ease;

    .ig-body, .ig-lens {
      stroke: currentColor;
      fill: none;
    }
    .ig-dot {
      fill: currentColor;
      opacity: 0.9;
    }
    &:hover {
      color: #e1306c;
      transform: scale(1.08);
      .ig-body, .ig-lens { stroke: #e1306c; }
      .ig-dot { fill: #e1306c; }
    }
    &:focus-visible {
      outline: 2px solid $white;
      outline-offset: 2px;
    }
  }

  &.theme-light .footer-ig {
    color: #1a1a2e;
    .ig-body, .ig-lens { stroke: #1a1a2e; }
    .ig-dot { fill: #1a1a2e; }
    &:hover {
      color: #e1306c;
      .ig-body, .ig-lens { stroke: #e1306c; }
      .ig-dot { fill: #e1306c; }
    }
  }

  .copyright {
    font-size: 0.9rem;
    letter-spacing: 0.02em;
    color: $white;
    opacity: 0.9;
  }

  &.theme-light .copyright {
    color: #1a1a2e;
    opacity: 0.85;
  }

  @media (max-width: 768px) {
    padding: 0.3rem 0.4rem;
    .copyright {
      font-size: 0.7rem;
    }
  }
}
</style>