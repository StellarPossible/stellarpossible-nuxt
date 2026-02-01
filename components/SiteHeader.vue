<template>
  <header ref="headerEl" :class="['site-header', { scrolled, 'menu-on-left': menuSide === 'left', 'theme-light': theme === 'light', 'menu-open': isMenuOpen }]">
    <div class="container" :class="{ 'home-layout': isHomePage }">
      <div class="header-left">
        <button
          v-if="menuSide === 'right'"
          class="menu-toggle"
          :class="{ open: isMenuOpen }"
          :aria-expanded="isMenuOpen"
          aria-label="Toggle navigation menu"
          @click="isMenuOpen = !isMenuOpen"
        >
          <span></span>
          <span></span>
          <span></span>
        </button>
        <template v-else>
          <!-- Spacer when menu is on right side -->
        </template>
      </div>

      <NuxtLink
        to="/"
        class="logo"
        :class="{ 'logo-hidden': isHomePage }"
        @click="closeMenu"
      >
        <div v-if="isHomePage" class="logo-backdrop"></div>
        <img
          src="~/public/images/primary/spicon.png"
          alt="Stellar Possible logo"
        />
      </NuxtLink>

      <div class="header-right" aria-hidden="true">
        <button
          v-if="menuSide === 'left'"
          class="menu-toggle"
          :class="{ open: isMenuOpen }"
          :aria-expanded="isMenuOpen"
          aria-label="Toggle navigation menu"
          @click="isMenuOpen = !isMenuOpen"
        >
          <span></span>
          <span></span>
          <span></span>
        </button>
      </div>
    </div>

    <!-- Backdrop and drawer teleported to body so they are never clipped -->
    <ClientOnly>
      <Teleport to="body">
        <!-- No blocking backdrop: strip stays open so users can browse; close via X -->
        <div
          class="drawer-backdrop site-header-backdrop"
          :class="{ open: isMenuOpen }"
          aria-hidden="true"
          @click="closeMenu"
        />
        <nav
          class="nav-drawer site-header-drawer"
          :class="{ open: isMenuOpen, 'drawer-left': menuSide === 'left', 'drawer-right': menuSide === 'right', 'drawer-theme-light': theme === 'light' }"
          aria-label="Main navigation"
          :aria-hidden="!isMenuOpen"
        >
          <header class="drawer-header">
            <button
              type="button"
              class="drawer-toggle"
              :class="{ open: isMenuOpen }"
              aria-label="Close menu"
              @click="closeMenu"
            >
              <span></span>
              <span></span>
              <span></span>
            </button>
            <div class="drawer-side-pills" role="group" aria-label="Menu side">
              <button
                type="button"
                :class="{ active: menuSide === 'left' }"
                :aria-pressed="menuSide === 'left'"
                aria-label="Menu from left"
                @click="setMenuSide('left')"
              >L</button>
              <button
                type="button"
                :class="{ active: menuSide === 'right' }"
                :aria-pressed="menuSide === 'right'"
                aria-label="Menu from right"
                @click="setMenuSide('right')"
              >R</button>
            </div>
          </header>
          <div class="drawer-nav-links">
            <NuxtLink to="/products" active-class="active" class="drawer-link" @click="closeMenu">
              <Icon icon="mdi:package-variant" aria-hidden />
              <span>products</span>
            </NuxtLink>
            <NuxtLink to="/services" active-class="active" class="drawer-link" @click="closeMenu">
              <Icon icon="mdi:hand-heart" aria-hidden />
              <span>services</span>
            </NuxtLink>
            <template v-if="user">
              <NuxtLink to="/dashboard" active-class="active" class="drawer-link" @click="closeMenu">
                <Icon icon="mdi:view-dashboard" aria-hidden />
                <span>dashboard</span>
              </NuxtLink>
              <button type="button" class="drawer-link drawer-btn" @click="logout">
                <Icon icon="mdi:logout" aria-hidden />
                <span>logout</span>
              </button>
            </template>
            <NuxtLink v-else to="/login" active-class="active" class="drawer-link" @click="closeMenu">
              <Icon icon="mdi:login" aria-hidden />
              <span>login</span>
            </NuxtLink>
          </div>

          <div class="drawer-footer" role="group" aria-label="Options">
            <button
              type="button"
              class="drawer-footer-btn"
              :aria-label="theme === 'dark' ? 'Light mode' : 'Dark mode'"
              @click="toggleTheme"
            >
              <Icon v-if="theme === 'dark'" icon="mdi:weather-sunny" />
              <Icon v-else icon="mdi:weather-night" />
            </button>
          </div>
        </nav>
      </Teleport>
    </ClientOnly>
  </header>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onBeforeUnmount } from 'vue'
import type { User } from '~/types/auth'
import { useMenuSide } from '~/composables/useMenuSide'
import { useTheme } from '~/composables/useTheme'

defineProps<{ scrolled: boolean }>()

const { menuSide, setMenuSide } = useMenuSide()
const { theme, toggleTheme } = useTheme()
const headerEl = ref<HTMLElement | null>(null)
let resizeObserver: ResizeObserver | null = null
const isMenuOpen = ref(false)
const route = useRoute()
const user = useState<User | null>('auth.user', () => null)

function syncHeaderHeight() {
  if (import.meta.client && headerEl.value) {
    const h = headerEl.value.offsetHeight
    document.documentElement.style.setProperty('--site-header-height', `${h}px`)
  }
}

const isHomePage = computed(() => route.path === '/')

function handleEscape(e: KeyboardEvent) {
  if (e.key === 'Escape') closeMenu()
}

onMounted(() => {
  if (process.client) {
    syncHeaderHeight()
    resizeObserver = new ResizeObserver(syncHeaderHeight)
    if (headerEl.value) resizeObserver.observe(headerEl.value)
    watch(isMenuOpen, (open) => {
      document.body.classList.toggle('menu-open', open)
      if (open) {
        syncHeaderHeight()
        window.addEventListener('keydown', handleEscape)
      } else {
        window.removeEventListener('keydown', handleEscape)
      }
    }, { immediate: true })
  }
})

onBeforeUnmount(() => {
  if (process.client) {
    window.removeEventListener('keydown', handleEscape)
    if (resizeObserver && headerEl.value) resizeObserver.unobserve(headerEl.value)
  }
})

function closeMenu() {
  isMenuOpen.value = false
}

async function logout() {
  try {
    await $fetch('/api/auth/logout', { method: 'POST' })
    user.value = null
    await navigateTo('/services')
  } catch (error) {
    console.error('Logout failed:', error)
  }
  closeMenu()
}
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.site-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  width: 100%;
  z-index: 2000;
  overflow: visible;
  transition: background-color 0.3s ease, backdrop-filter 0.3s ease;

  &::before {
    content: '';
    position: absolute;
    inset: 0;
    background: rgba(0, 0, 0, 0.05);
    backdrop-filter: blur(2px);
    z-index: -1;
    transition: background 0.3s ease, backdrop-filter 0.3s ease, opacity 0.3s ease;
  }

  &.scrolled::before {
    background: rgba(0, 0, 0, 0.25);
    backdrop-filter: blur(6px);
    opacity: 0.25;
  }

  .container {
    position: relative;
    z-index: 2100;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 2rem;
    margin: auto;
    padding: 0.5rem 1.5rem;
    width: 100%;
    max-width: 100%;
    box-sizing: border-box;
  }

  .header-left {
    display: flex;
    align-items: center;
    min-width: 0;
    flex: 1;
    justify-content: flex-start;
  }

  .header-right {
    flex: 1;
    min-width: 0;
    display: flex;
    align-items: center;
    justify-content: flex-end;
  }

  .logo {
    display: flex;
    align-items: center;
    flex-shrink: 0;
    transition: opacity 0.3s ease;
    position: relative;

    img {
      display: block;
      width: 7rem;
    }
  }

  .menu-toggle {
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 2.5rem;
    height: 2.5rem;
    background: none;
    border: none;
    cursor: pointer;
    z-index: 1100;
    margin: 0;
    transition: opacity 0.2s ease, transform 0.2s ease;

    span {
      position: absolute;
      left: 0;
      width: 2.5rem;
      height: 0.25rem;
      background: $white;
      border-radius: 2px;
      transition: transform 0.3s ease, opacity 0.3s ease;
    }

    span:nth-child(1) { top: 0.5rem; }
    span:nth-child(2) { top: 1.125rem; }
    span:nth-child(3) { top: 1.75rem; }

    &.open span:nth-child(1) {
      transform: translateY(0.625rem) rotate(45deg);
    }
    &.open span:nth-child(2) {
      opacity: 0;
    }
    &.open span:nth-child(3) {
      transform: translateY(-0.625rem) rotate(-45deg);
    }
  }

  /* When menu is open, ham fades out so X in drawer reads as the same control */
  &.menu-open .menu-toggle {
    opacity: 0;
    pointer-events: none;
  }

  &.theme-light {
    &::before {
      /* Soft blue-grey to complement light galaxy background */
      background: rgba(226, 232, 240, 0.92);
      backdrop-filter: blur(8px);
      transition: opacity 0.3s ease, background 0.3s ease;
    }
    &.scrolled::before {
      background: rgba(226, 232, 240, 0.92);
      opacity: 0.25;
    }
    .menu-toggle span {
      background: #1a1a2e;
    }
  }

  /* Backdrop and drawer are teleported to body; see unscoped .site-header-backdrop / .site-header-drawer below */

  @media (max-width: 480px) {
    .logo > img {
      width: 5rem;
    }
  }
}

/* Backdrop: non-blocking so users can browse with menu open; close via X */
.site-header-backdrop {
  position: fixed !important;
  inset: 0;
  background: transparent;
  z-index: 10000;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s ease;
}
.site-header-backdrop.open {
  opacity: 0;
  pointer-events: none;
}

/* Dropdown: semi-transparent glass panel, pro-level */
.site-header-drawer {
  --header-height: var(--site-header-height, 4rem);
  --ease-out: cubic-bezier(0.25, 0.46, 0.45, 0.94);
  --ease-out-snappy: cubic-bezier(0.32, 0.72, 0, 1);
  position: fixed !important;
  top: var(--header-height);
  left: 50%;
  width: min(100%, 85vw);
  min-width: 280px;
  max-width: 85vw;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  flex-wrap: nowrap;
  height: fit-content;
  max-height: calc(100vh - var(--header-height));
  padding: 0 1.125rem 0.875rem;
  padding-top: 0.5rem;
  background: rgba(18, 49, 70, 0.78);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  font-family: 'Chocolates', serif;
  overflow-y: auto;
  visibility: hidden;
  transition:
    transform 0.32s var(--ease-out-snappy),
    visibility 0s linear 0.32s;
  z-index: 10001;
  box-shadow:
    0 24px 48px rgba(0, 0, 0, 0.2),
    0 12px 24px rgba(0, 0, 0, 0.12),
    inset 0 1px 0 rgba(255, 255, 255, 0.06);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 0 0 16px 16px;
  transform: translate(-50%, 0) scaleY(0);
  transform-origin: top center;
  opacity: 1;
  pointer-events: none;
  overflow: hidden;
}
.site-header-drawer.open {
  visibility: visible;
  transition:
    transform 0.32s var(--ease-out-snappy),
    visibility 0s,
    opacity 0.24s var(--ease-out);
  transform: translate(-50%, 0) scaleY(1);
  opacity: 1;
  pointer-events: auto;
  overflow-y: auto;
}
/* Staggered content fade-in when opening */
.site-header-drawer .drawer-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 0.5rem;
  width: 100%;
  flex-shrink: 0;
  padding: 0.5rem 0;
  margin-bottom: 0.375rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  opacity: 0;
  transform: translateY(-6px);
  transition: opacity 0.22s var(--ease-out), transform 0.22s var(--ease-out);
  transition-delay: 0s;
}
.site-header-drawer.open .drawer-header {
  opacity: 1;
  transform: translateY(0);
  transition-delay: 0.06s;
}
.site-header-drawer .drawer-nav-links {
  opacity: 0;
  transform: translateY(-4px);
  transition: opacity 0.22s var(--ease-out), transform 0.22s var(--ease-out);
  transition-delay: 0s;
}
.site-header-drawer.open .drawer-nav-links {
  opacity: 1;
  transform: translateY(0);
  transition-delay: 0.1s;
}
.site-header-drawer .drawer-footer {
  opacity: 0;
  transform: translateY(-4px);
  transition: opacity 0.22s var(--ease-out), transform 0.22s var(--ease-out);
  transition-delay: 0s;
}
.site-header-drawer.open .drawer-footer {
  opacity: 1;
  transform: translateY(0);
  transition-delay: 0.14s;
}
/* R mode: X left, L R right */
.site-header-drawer.drawer-right .drawer-header {
  flex-direction: row;
  justify-content: space-between;
}
.site-header-drawer.drawer-right .drawer-toggle {
  order: 0;
  margin-right: auto;
}
.site-header-drawer.drawer-right .drawer-side-pills {
  order: 0;
  margin-left: 0;
}
/* L mode: L R left, hamburger/X right */
.site-header-drawer.drawer-left .drawer-header {
  flex-direction: row;
  justify-content: space-between;
}
.site-header-drawer.drawer-left .drawer-toggle {
  order: 1;
  margin-left: auto;
}
.site-header-drawer.drawer-left .drawer-side-pills {
  order: 0;
  margin-right: 0;
}
.site-header-drawer.drawer-theme-light .drawer-header {
  border-bottom-color: rgba(0, 0, 0, 0.08);
}
.site-header-drawer.drawer-theme-light {
  background: rgba(255, 255, 255, 0.72);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  box-shadow:
    0 24px 48px rgba(0, 0, 0, 0.1),
    0 12px 24px rgba(0, 0, 0, 0.06),
    inset 0 1px 0 rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.5);
}
.site-header-drawer.drawer-theme-light .drawer-link,
.site-header-drawer.drawer-theme-light .drawer-btn {
  color: #1a1a2e;
}
.site-header-drawer.drawer-theme-light .drawer-link.active {
  color: $primary;
  background: rgba(18, 49, 70, 0.08);
  border-color: rgba(18, 49, 70, 0.1);
}
.site-header-drawer.drawer-theme-light .drawer-link:hover,
.site-header-drawer.drawer-theme-light .drawer-btn:hover {
  color: $primary;
  background: rgba(18, 49, 70, 0.06);
  border-color: rgba(18, 49, 70, 0.08);
}
.site-header-drawer.drawer-theme-light .drawer-link.active:hover {
  background: rgba(18, 49, 70, 0.12);
  border-color: rgba(18, 49, 70, 0.14);
}
/* Drawer header toggle: hamburger → X, glass-style */
.site-header-drawer .drawer-toggle {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  position: relative;
  width: 2.5rem;
  height: 2.5rem;
  min-width: 2.5rem;
  min-height: 2.5rem;
  padding: 0;
  background: rgba(255, 255, 255, 0.06);
  border: 1px solid rgba(255, 255, 255, 0.06);
  border-radius: 8px;
  cursor: pointer;
  flex-shrink: 0;
  transition: background 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
}
.site-header-drawer .drawer-toggle span {
  position: absolute;
  left: 50%;
  margin-left: -1.25rem;
  width: 2.5rem;
  height: 0.25rem;
  background: rgba(255, 255, 255, 0.92);
  border-radius: 2px;
  transition: transform 0.3s ease, opacity 0.3s ease;
}
.site-header-drawer .drawer-toggle span:nth-child(1) { top: 0.5rem; }
.site-header-drawer .drawer-toggle span:nth-child(2) { top: 1.125rem; }
.site-header-drawer .drawer-toggle span:nth-child(3) { top: 1.75rem; }
.site-header-drawer .drawer-toggle.open span:nth-child(1) {
  top: 1.125rem;
  transform: rotate(45deg);
}
.site-header-drawer .drawer-toggle.open span:nth-child(2) {
  opacity: 0;
}
.site-header-drawer .drawer-toggle.open span:nth-child(3) {
  top: 1.125rem;
  transform: rotate(-45deg);
}
.site-header-drawer .drawer-toggle:hover {
  background: rgba(255, 255, 255, 0.12);
  border-color: rgba(255, 255, 255, 0.1);
}
.site-header-drawer .drawer-toggle:focus-visible {
  outline: 2px solid rgba(255, 255, 255, 0.6);
  outline-offset: 2px;
}
.site-header-drawer.drawer-theme-light .drawer-toggle {
  background: rgba(0, 0, 0, 0.05);
  border-color: rgba(0, 0, 0, 0.06);
}
.site-header-drawer.drawer-theme-light .drawer-toggle span {
  background: #1a1a2e;
}
.site-header-drawer.drawer-theme-light .drawer-toggle:hover {
  background: rgba(0, 0, 0, 0.1);
  border-color: rgba(0, 0, 0, 0.1);
}
.site-header-drawer.drawer-theme-light .drawer-toggle:focus-visible {
  outline-color: #1a1a2e;
}
.site-header-drawer .drawer-nav-links {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.25rem 0.75rem;
  padding: 0.375rem 0;
  flex-shrink: 0;
}
.site-header-drawer.drawer-right .drawer-nav-links {
  justify-content: flex-end;
}
.site-header-drawer.drawer-left .drawer-nav-links {
  justify-content: flex-start;
}

.site-header-drawer .drawer-link,
.site-header-drawer .drawer-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.4375rem;
  padding: 0.5625rem 0.75rem;
  min-height: 2.5rem;
  font-size: 0.9375rem;
  font-weight: 500;
  font-family: 'Chocolates', serif;
  letter-spacing: 0.01em;
  color: rgba(255, 255, 255, 0.94);
  text-decoration: none;
  background: transparent;
  border: 1px solid transparent;
  border-radius: 10px;
  cursor: pointer;
  box-sizing: border-box;
  transition: color 0.2s ease, background 0.2s ease, border-color 0.2s ease;
}
.site-header-drawer .drawer-link:hover,
.site-header-drawer .drawer-btn:hover {
  background: rgba(255, 255, 255, 0.08);
  border-color: rgba(255, 255, 255, 0.06);
  color: #fff;
}
.site-header-drawer .drawer-link svg,
.site-header-drawer .drawer-btn svg {
  font-size: 1.0625rem;
  flex-shrink: 0;
  opacity: 0.92;
}
.site-header-drawer .drawer-link.active {
  color: $primary-light;
  font-weight: 600;
  background: rgba(255, 255, 255, 0.06);
  border-color: rgba(255, 255, 255, 0.04);
}
.site-header-drawer .drawer-link.active:hover,
.site-header-drawer .drawer-btn:hover {
  color: $primary-light;
  background: rgba(255, 255, 255, 0.1);
}
.site-header-drawer.drawer-right .drawer-btn {
  margin-left: auto;
}
.site-header-drawer.drawer-left .drawer-btn {
  margin-right: auto;
}

/* Footer: theme + hint, glass-style */
.drawer-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.5rem;
  padding-top: 0.5rem;
  margin-top: 0.375rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  flex-shrink: 0;
}
.site-header-drawer.drawer-right .drawer-footer {
  flex-direction: row;
}
.site-header-drawer.drawer-left .drawer-footer {
  flex-direction: row-reverse;
}
.site-header-drawer.drawer-theme-light .drawer-footer {
  border-top-color: rgba(0, 0, 0, 0.08);
}
.drawer-footer-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 2rem;
  height: 2rem;
  min-width: 2rem;
  min-height: 2rem;
  padding: 0;
  background: rgba(255, 255, 255, 0.06);
  color: rgba(255, 255, 255, 0.88);
  border: 1px solid rgba(255, 255, 255, 0.04);
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s ease, border-color 0.2s ease, color 0.2s ease;
}
.drawer-footer-btn svg {
  font-size: 1rem;
}
.drawer-footer-btn:hover {
  background: rgba(255, 255, 255, 0.12);
  border-color: rgba(255, 255, 255, 0.08);
}
.drawer-footer-btn:focus-visible {
  outline: 2px solid rgba(255, 255, 255, 0.5);
  outline-offset: 2px;
}
.site-header-drawer.drawer-theme-light .drawer-footer-btn {
  background: rgba(0, 0, 0, 0.05);
  color: #1a1a2e;
  border-color: rgba(0, 0, 0, 0.06);
}
.site-header-drawer.drawer-theme-light .drawer-footer-btn:hover {
  background: rgba(0, 0, 0, 0.1);
  border-color: rgba(0, 0, 0, 0.08);
}
.site-header-drawer.drawer-theme-light .drawer-footer-btn:focus-visible {
  outline-color: #1a1a2e;
}
.drawer-side-pills {
  display: flex;
  flex-direction: row;
  gap: 0.25rem;
  justify-content: center;
}
.drawer-side-pills button {
  width: 1.75rem;
  height: 1.75rem;
  min-width: 1.75rem;
  min-height: 1.75rem;
  padding: 0;
  font-size: 0.625rem;
  font-weight: 600;
  font-family: 'Chocolates', serif;
  letter-spacing: 0.02em;
  background: rgba(255, 255, 255, 0.06);
  color: rgba(255, 255, 255, 0.82);
  border: 1px solid rgba(255, 255, 255, 0.04);
  border-radius: 6px;
  cursor: pointer;
  transition: background 0.2s ease, border-color 0.2s ease, color 0.2s ease;
}
.drawer-side-pills button:hover {
  background: rgba(255, 255, 255, 0.12);
  border-color: rgba(255, 255, 255, 0.06);
  color: #fff;
}
.drawer-side-pills button.active {
  background: rgba(255, 255, 255, 0.14);
  border-color: rgba(255, 255, 255, 0.08);
  color: #fff;
}
.drawer-side-pills button:focus-visible {
  outline: 2px solid rgba(255, 255, 255, 0.5);
  outline-offset: 2px;
}
.site-header-drawer.drawer-theme-light .drawer-side-pills button {
  background: rgba(0, 0, 0, 0.05);
  color: rgba(0, 0, 0, 0.72);
  border-color: rgba(0, 0, 0, 0.06);
}
.site-header-drawer.drawer-theme-light .drawer-side-pills button:hover {
  background: rgba(0, 0, 0, 0.1);
  border-color: rgba(0, 0, 0, 0.08);
}
.site-header-drawer.drawer-theme-light .drawer-side-pills button.active {
  background: rgba(0, 0, 0, 0.14);
  border-color: rgba(0, 0, 0, 0.1);
  color: #1a1a2e;
}
.site-header-drawer.drawer-theme-light .drawer-side-pills button:focus-visible {
  outline-color: #1a1a2e;
}

@media (max-width: 640px) {
  .site-header-drawer {
    width: min(100%, 95vw);
    max-width: 95vw;
  }
  .site-header-drawer .drawer-nav-links {
    flex-direction: column;
    align-items: stretch;
  }
  .site-header-drawer.drawer-right .drawer-nav-links,
  .site-header-drawer.drawer-left .drawer-nav-links {
    justify-content: flex-start;
  }
  .site-header-drawer .drawer-link,
  .site-header-drawer .drawer-btn {
    width: 100%;
  }
  .site-header-drawer.drawer-right .drawer-btn,
  .site-header-drawer.drawer-left .drawer-btn {
    margin-left: 0;
    margin-right: 0;
  }
}
</style>