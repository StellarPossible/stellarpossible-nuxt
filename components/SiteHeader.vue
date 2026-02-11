<template>
  <header ref="headerEl" :class="['site-header', { scrolled, compact: compact, 'menu-on-left': menuSide === 'left', 'theme-light': theme === 'light', 'menu-open': isMenuOpen }]">
    <div class="container" :class="{ 'home-layout': isHomePage }">
      <div class="header-top">
        <div class="header-left">
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
        </div>
        <div class="header-center" :class="{ 'header-center-hero': !!(heroToShow && !isHomePage) }">
          <template v-if="heroToShow && !isHomePage">
            <div class="header-hero header-hero-inline">
              <span v-if="heroToShow.badge" class="header-hero-badge">{{ heroToShow.badge }}</span>
              <h1 class="header-hero-title">{{ heroToShow.title }}</h1>
              <p v-if="heroToShow.subtitle" class="header-hero-subtitle" v-html="heroSubtitleHtml" />
            </div>
          </template>
          <CrossNav v-else-if="showCrossNav" variant="header" class="header-cross-nav inline" :show-contact="false" />
        </div>
        <div class="header-right">
          <nav v-if="showCrossNav" class="header-nav-column" aria-label="Main links">
            <CrossNav variant="header" class="header-cross-nav column" :show-contact="false" />
          </nav>
          <button
            class="menu-toggle menu-toggle-mobile"
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

withDefaults(
  defineProps<{ scrolled: boolean; compact?: boolean }>(),
  { compact: false }
)

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
const { hero: pageHero, servicesHeaderHeroKey } = usePageHero()
const servicesHeaderHero = useState<{ badge?: string; title: string; subtitle?: string } | null>(servicesHeaderHeroKey, () => null)

const heroToShow = computed(() => {
  if (route.path === '/services' && servicesHeaderHero.value) return servicesHeaderHero.value
  return pageHero.value
})

const heroSubtitleHtml = computed(() => {
  const s = heroToShow.value?.subtitle
  if (!s) return ''
  return s
    .replace(/\bperformant\b/gi, '<strong>performant</strong>')
    .replace(/\bsecure\b/gi, '<strong>secure</strong>')
})

const showCrossNav = computed(() => {
  const path = route.path
  return path !== '/' && !path.startsWith('/dashboard')
})

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

  /* Stellar glass: deep cosmic tint + blur */
  &::before {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(
      180deg,
      rgba(12, 20, 38, 0.72) 0%,
      rgba(18, 28, 52, 0.55) 40%,
      rgba(24, 36, 62, 0.35) 100%
    );
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    z-index: -1;
    transition: background 0.35s ease, backdrop-filter 0.35s ease, opacity 0.35s ease;
  }

  &.scrolled::before {
    background: linear-gradient(
      180deg,
      rgba(10, 18, 34, 0.88) 0%,
      rgba(14, 24, 44, 0.82) 100%
    );
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    opacity: 0.98;
  }

  /* Subtle bottom edge: cosmic separation from content */
  &::after {
    content: '';
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    height: 1px;
    background: linear-gradient(
      90deg,
      transparent 0%,
      rgba(120, 160, 220, 0.2) 20%,
      rgba(160, 120, 220, 0.25) 50%,
      rgba(120, 160, 220, 0.2) 80%,
      transparent 100%
    );
    z-index: 2099;
    pointer-events: none;
  }

  &.scrolled::after {
    opacity: 0.6;
  }

  .container {
    position: relative;
    z-index: 2100;
    display: flex;
    flex-direction: column;
    align-items: stretch;
    margin: auto;
    padding: 0.45rem 1.25rem 0.35rem;
    width: 100%;
    max-width: 100%;
    box-sizing: border-box;
    transition: padding 0.28s ease;
  }

  &.compact .container {
    padding: 0.28rem 1rem 0.25rem;
  }

  .header-top {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    gap: 1rem;
    width: 100%;
    flex-shrink: 0;
  }

  .header-left {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    min-width: 0;
    flex-shrink: 0;
  }

  .header-center {
    display: flex;
    flex: 1;
    min-width: 0;
    justify-content: center;
    align-items: center;
  }

  .header-nav-column {
    display: none;
  }

  .header-cross-nav-row {
    display: none;
  }

  .header-cross-nav {
    width: 100%;
    justify-content: center;
  }

  .header-cross-nav.inline {
    width: auto;
  }

  .header-right {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 0.75rem;
    min-width: 0;
    flex-shrink: 0;
  }

  /* Hero on same line as logo and nav: column layout (badge, title, subtitle stacked) */
  .header-hero.header-hero-inline {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 0.2rem 0;
    width: 100%;
    min-width: 0;
    padding: 0.35rem 0.5rem;
    text-align: center;
    box-sizing: border-box;
  }

  .header-hero-inline .header-hero-badge {
    display: inline-block;
    font-size: 0.625rem;
    font-weight: 700;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    color: rgba(200, 220, 255, 0.92);
    margin: 0;
    padding: 0.2rem 0.5rem;
    border: 1px solid rgba(160, 190, 255, 0.25);
    border-radius: 100px;
    background: rgba(255, 255, 255, 0.04);
    box-shadow: 0 0 16px rgba(120, 160, 255, 0.06);
    flex-shrink: 0;
  }

  .header-hero-inline .header-hero-title {
    font-family: 'OldStyle', 'Georgia', serif;
    font-size: clamp(1rem, 2.2vw, 1.35rem);
    font-weight: 400;
    color: $white;
    margin: 0;
    line-height: 1.2;
    letter-spacing: 0.02em;
    text-shadow: 0 0 20px rgba(255, 255, 255, 0.12), 0 1px 4px rgba(0, 0, 0, 0.35);
    flex-shrink: 0;
  }

  .header-hero-inline .header-hero-subtitle {
    font-size: clamp(0.75rem, 1.6vw, 0.875rem);
    line-height: 1.15;
    font-style: italic;
    color: rgba(220, 230, 255, 0.88);
    margin: 0;
    max-width: 20rem;
    text-align: center;
    font-weight: 500;
    letter-spacing: 0.01em;

    strong {
      font-weight: 700;
      font-style: italic;
    }
  }

  @media (min-width: 769px) {
    .header-center {
      display: none;
    }
    .header-center.header-center-hero {
      display: flex;
    }
    .header-nav-column {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      gap: 0.35rem;
    }
    .header-cross-nav.column {
      flex-direction: column;
      align-items: stretch;
      width: auto;
      gap: 0.25rem;
    }
    .header-cross-nav.column :deep(.cross-nav-sep) {
      display: none;
    }
  }

  .logo {
    display: flex;
    align-items: center;
    flex-shrink: 0;
    transition: opacity 0.3s ease, transform 0.25s ease;
    position: relative;
    border-radius: 4px;

    img {
      display: block;
      width: 7rem;
      transition: width 0.25s ease, filter 0.3s ease;
    }

    &:hover img {
      filter: drop-shadow(0 0 12px rgba(160, 190, 255, 0.35));
    }

    &:focus-visible {
      outline: 2px solid rgba(160, 190, 255, 0.5);
      outline-offset: 4px;
    }
  }

  &.compact .logo img {
    width: 5rem;
  }

  &.theme-light .logo:hover img {
    filter: drop-shadow(0 0 10px rgba(30, 58, 100, 0.2));
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

  /* Hamburger only on mobile; hidden on desktop/tablet (769px+) */
  @media (min-width: 769px) {
    .menu-toggle.menu-toggle-mobile {
      display: none;
    }
  }

  /* When menu is open, ham fades out so X in drawer reads as the same control */
  &.menu-open .menu-toggle {
    opacity: 0;
    pointer-events: none;
  }

  &.theme-light {
    &::before {
      background: linear-gradient(
        180deg,
        rgba(248, 250, 252, 0.94) 0%,
        rgba(241, 245, 249, 0.88) 100%
      );
      backdrop-filter: blur(12px);
      -webkit-backdrop-filter: blur(12px);
    }
    &::after {
      background: linear-gradient(
        90deg,
        transparent 0%,
        rgba(30, 58, 100, 0.12) 50%,
        transparent 100%
      );
    }
    &.scrolled::before {
      background: rgba(248, 250, 252, 0.96);
      opacity: 0.98;
    }
    .menu-toggle span {
      background: #1a1a2e;
    }
    .header-hero-inline .header-hero-badge {
      color: rgba(26, 46, 80, 0.9);
      border-color: rgba(30, 58, 100, 0.2);
      background: rgba(255, 255, 255, 0.7);
      box-shadow: 0 0 16px rgba(30, 58, 100, 0.06);
    }
    .header-hero-inline .header-hero-title {
      color: #1a1a2e;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.06);
    }
    .header-hero-inline .header-hero-subtitle {
      color: rgba(26, 46, 80, 0.88);
    }
  }

  /* Backdrop and drawer are teleported to body; see unscoped .site-header-backdrop / .site-header-drawer below */

  @media (max-width: 768px) {
    .header-hero-inline {
      gap: 0.15rem 0;
      padding: 0.25rem 0.35rem;
    }
    .header-hero-inline .header-hero-badge {
      font-size: 0.5rem;
      letter-spacing: 0.12em;
      padding: 0.15rem 0.35rem;
    }
    .header-hero-inline .header-hero-title {
      font-size: 0.9rem;
      line-height: 1.2;
    }
    .header-hero-inline .header-hero-subtitle {
      font-size: 0.6875rem;
      line-height: 1.1;
      max-width: 14rem;
    }
  }

  @media (max-width: 480px) {
    .logo > img {
      width: 5rem;
    }
    .header-hero-inline {
      gap: 0.1rem 0;
      padding: 0.2rem 0.25rem;
    }
    .header-hero-inline .header-hero-badge {
      font-size: 0.4375rem;
      letter-spacing: 0.1em;
      padding: 0.12rem 0.3rem;
    }
    .header-hero-inline .header-hero-title {
      font-size: 0.8rem;
    }
    .header-hero-inline .header-hero-subtitle {
      font-size: 0.625rem;
      line-height: 1.1;
      max-width: 11rem;
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