<template>
  <footer ref="footerEl" class="site-footer" :class="{ 'theme-light': theme === 'light', 'scrolled': scrolled }">
    <div class="footer-content">
      <!-- Tools We Use -->
      <section class="tools-section" aria-label="Tools we use">
        <h3 class="tools-heading">Tools We Use</h3>
        <div class="tools-grid">
          <a
            v-for="tool in tools"
            :key="tool.name"
            :href="tool.url"
            target="_blank"
            rel="noopener noreferrer"
            class="tool-link"
            :aria-label="`${tool.name} (opens in new tab)`"
          >
            <span class="tool-icon-wrap">
              <Icon :icon="tool.icon" aria-hidden />
            </span>
          </a>
        </div>
      </section>
      <div class="footer-divider" aria-hidden />
      <span class="copyright">&copy; {{ year }} StellarPossible, LLC</span>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'

defineProps<{ scrolled?: boolean }>()

const tools = [
  { name: 'Nuxt.js', icon: 'simple-icons:nuxt-dot-js', url: 'https://nuxt.com' },
  { name: 'Visual Studio Code', icon: 'simple-icons:visualstudiocode', url: 'https://code.visualstudio.com' },
  { name: 'GitHub', icon: 'simple-icons:github', url: 'https://github.com' },
  { name: 'Slack', icon: 'simple-icons:slack', url: 'https://slack.com' },
  { name: 'WordPress', icon: 'simple-icons:wordpress', url: 'https://wordpress.org' },
  { name: 'Hostinger', icon: 'simple-icons:hostinger', url: 'https://www.hostinger.com' },
  { name: 'Unsplash', icon: 'simple-icons:unsplash', url: 'https://unsplash.com' },
  { name: 'Adobe Photoshop', icon: 'simple-icons:adobephotoshop', url: 'https://www.adobe.com/products/photoshop.html' },
]

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
    flex-direction: column;
    flex-wrap: wrap;
    justify-content: center;
    align-items: center;
    gap: 0.75rem 1.25rem;
    position: relative;
    z-index: 1;
  }

  .tools-section {
    width: 100%;
    max-width: 42rem;
    margin: 0 auto;
  }

  .tools-heading {
    font-family: 'Montserrat', sans-serif;
    font-size: 0.7rem;
    font-weight: 600;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    color: $text-muted;
    margin: 0 0 0.75rem;
  }

  &.theme-light .tools-heading {
    color: rgba(26, 26, 46, 0.7);
  }

  .tools-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 0.5rem;
    justify-items: center;
  }

  .tool-link {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 2.75rem;
    height: 2.75rem;
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.08);
    color: $white;
    transition: background 0.2s ease, color 0.2s ease, transform 0.15s ease;
  }

  .tool-link:hover {
    background: rgba(255, 255, 255, 0.18);
    transform: scale(1.06);
  }

  .tool-link:focus-visible {
    outline: 2px solid $white;
    outline-offset: 2px;
  }

  &.theme-light .tool-link {
    background: rgba(26, 26, 46, 0.08);
    color: #1a1a2e;
  }

  &.theme-light .tool-link:hover {
    background: rgba(26, 26, 46, 0.15);
  }

  .tool-icon-wrap {
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .tool-icon-wrap :deep(svg) {
    width: 1.35rem;
    height: 1.35rem;
  }

  .footer-divider {
    width: 100%;
    max-width: 24rem;
    height: 1px;
    background: $border;
    flex-shrink: 0;
  }

  &.theme-light .footer-divider {
    background: rgba(26, 26, 46, 0.2);
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
    .tools-heading {
      font-size: 0.6rem;
      letter-spacing: 0.14em;
      margin-bottom: 0.5rem;
    }
    .tools-grid {
      grid-template-columns: repeat(4, 1fr);
      gap: 0.4rem;
    }
    .tool-link {
      width: 2.5rem;
      height: 2.5rem;
      border-radius: 10px;
    }
    .tool-icon-wrap :deep(svg) {
      width: 1.15rem;
      height: 1.15rem;
    }
    .copyright {
      font-size: 0.75rem;
    }
    .footer-content {
      gap: 0.5rem 0.75rem;
    }
  }

  @media (max-width: 380px) {
    .tools-grid {
      grid-template-columns: repeat(4, 1fr);
    }
    .tool-link {
      width: 2.25rem;
      height: 2.25rem;
    }
    .tool-icon-wrap :deep(svg) {
      width: 1rem;
      height: 1rem;
    }
  }
}
</style>