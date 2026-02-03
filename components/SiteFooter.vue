<template>
  <footer ref="footerEl" class="site-footer" :class="{ 'theme-light': theme === 'light', 'scrolled': scrolled }">
    <div class="footer-content">
      <span class="copyright">&copy; {{ year }} StellarPossible, LLC</span>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'

defineProps<{ scrolled?: boolean }>()

const footerEl = ref<HTMLElement | null>(null)
const year = new Date().getFullYear()
const { theme } = useTheme()

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
  padding: 0.5rem;
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

  .footer-content {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    align-items: center;
    gap: 0.75rem 1.25rem;
    position: relative;
    z-index: 1;
  }

  .copyright {
    font-size: 1rem;
    letter-spacing: 0.02em;
    color: $white;
    opacity: 0.9;
  }

  &.theme-light .copyright {
    color: #1a1a2e;
    opacity: 0.85;
  }

  @media (max-width: 768px) {
    .copyright {
      font-size: .5rem;
    }
    .footer-content { gap: 0.75rem; }
  }
}
</style>