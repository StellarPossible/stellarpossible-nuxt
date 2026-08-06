<template>
  <footer ref="footerEl" class="site-footer" :class="{ 'theme-light': theme === 'light' }">
    <div class="footer-inner">
      <div class="footer-brand">
        <p class="footer-tagline">Your ideas. Our tech. Infinite possibility.</p>
      </div>

      <div class="footer-nav">
        <nav class="footer-group" aria-label="Explore">
          <NuxtLink to="/services">Services</NuxtLink>
          <NuxtLink to="/products">Products</NuxtLink>
          <NuxtLink to="/about">About Us</NuxtLink>
        </nav>

        <span class="footer-sep" aria-hidden="true" />

        <nav class="footer-group" aria-label="Connect">
          <button type="button" class="footer-link-btn" @click="openContact">Contact</button>
        </nav>

        <span class="footer-sep" aria-hidden="true" />

        <nav class="footer-group" aria-label="Account">
          <NuxtLink v-if="user" to="/dashboard">Dashboard</NuxtLink>
          <NuxtLink v-else to="/login?tab=register">Create Account</NuxtLink>
          <button v-if="user" type="button" class="footer-link-btn" @click="logout">Logout</button>
        </nav>
      </div>

      <p class="footer-copy">&copy; {{ year }} StellarPossible, LLC</p>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'
import type { User } from '~/types/auth'

const footerEl = ref<HTMLElement | null>(null)
const year = new Date().getFullYear()
const { theme } = useTheme()
const { open: openContact } = useContactModal()
const user = useState<User | null>('auth.user', () => null)

async function logout() {
  try {
    await $fetch('/api/auth/logout', { method: 'POST' })
    user.value = null
    await navigateTo('/')
  } catch (error) {
    console.error('Logout failed:', error)
  }
}

function syncFooterHeight() {
  if (import.meta.client && footerEl.value) {
    document.documentElement.style.setProperty('--site-footer-height', `${footerEl.value.offsetHeight}px`)
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
.site-footer {
  position: relative;
  width: 100%;
  margin-top: auto;
  padding: var(--space-4) max(var(--space-4), env(safe-area-inset-right, 0px))
    calc(var(--space-4) + env(safe-area-inset-bottom, 0px))
    max(var(--space-4), env(safe-area-inset-left, 0px));
  background: var(--color-glass-solid);
  border-top: 1px solid var(--color-border);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  color: var(--color-text);
  font-family: var(--font-ui);
  z-index: 3;
}

.footer-inner {
  max-width: var(--content-max);
  margin-inline: auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--space-3);
  text-align: center;
}

.footer-brand {
  min-width: 0;
}

.footer-tagline {
  font-family: var(--font-display);
  font-size: var(--fs-200);
  font-weight: 500;
  margin: 0;
  line-height: 1.3;
  color: var(--color-text-muted);
}

.footer-nav {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: center;
  gap: var(--space-2) var(--space-3);
}

.footer-group {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: center;
  gap: var(--space-1) var(--space-3);
}

.footer-sep {
  width: 1px;
  height: 1rem;
  background: var(--color-border-strong);
  flex-shrink: 0;
}

.footer-group a,
.footer-link-btn {
  font-family: var(--font-ui);
  font-size: var(--fs-100);
  font-weight: 500;
  letter-spacing: 0.02em;
  color: var(--color-text-muted);
  text-decoration: none;
  background: none;
  border: none;
  padding: var(--space-1) var(--space-2);
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: color var(--dur-fast) var(--ease-out), background var(--dur-fast) var(--ease-out);

  &:hover {
    color: var(--color-text);
    background: var(--color-accent-soft);
  }

  &:focus-visible {
    outline: 2px solid var(--color-accent);
    outline-offset: 2px;
  }
}

.footer-copy {
  margin: 0;
  font-size: var(--fs-100);
  color: var(--color-text-subtle);
  letter-spacing: 0.02em;
}

@media (min-width: 768px) {
  .footer-inner {
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: center;
    text-align: left;
    gap: var(--space-3) var(--space-6);
  }

  .footer-brand {
    flex: 1 1 12rem;
  }

  .footer-nav {
    flex: 2 1 auto;
    justify-content: flex-end;
  }

  .footer-copy {
    flex: 0 0 100%;
    text-align: center;
    padding-top: var(--space-1);
    border-top: 1px solid var(--color-border);
  }
}

@media (max-width: 767px) {
  .footer-sep {
    display: none;
  }

  .footer-group a,
  .footer-link-btn {
    min-height: 44px;
    display: inline-flex;
    align-items: center;
  }

  .footer-nav {
    gap: var(--space-3);
  }
}
</style>
