<template>
  <header :class="['site-header', { scrolled, 'menu-on-left': menuSide === 'left', 'theme-light': theme === 'light', 'menu-open': isMenuOpen }]">
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
              class="drawer-close"
              aria-label="Close menu"
              @click="closeMenu"
            >
              <Icon icon="mdi:close" />
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
            <NuxtLink to="/products" active-class="active" class="drawer-link" title="products" aria-label="products" @click="closeMenu">
              <Icon icon="mdi:package-variant" aria-hidden />
              <span class="drawer-link-text">products</span>
            </NuxtLink>
            <NuxtLink to="/services" active-class="active" class="drawer-link" title="services" aria-label="services" @click="closeMenu">
              <Icon icon="mdi:hand-heart" aria-hidden />
              <span class="drawer-link-text">services</span>
            </NuxtLink>
            <template v-if="user">
              <NuxtLink to="/dashboard" active-class="active" class="drawer-link" title="dashboard" aria-label="dashboard" @click="closeMenu">
                <Icon icon="mdi:view-dashboard" aria-hidden />
                <span class="drawer-link-text">dashboard</span>
              </NuxtLink>
              <button type="button" class="drawer-link drawer-btn" title="logout" aria-label="logout" @click="logout">
                <Icon icon="mdi:logout" aria-hidden />
                <span class="drawer-link-text">logout</span>
              </button>
            </template>
            <NuxtLink v-else to="/login" active-class="active" class="drawer-link" title="login" aria-label="login" @click="closeMenu">
              <Icon icon="mdi:login" aria-hidden />
              <span class="drawer-link-text">login</span>
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
const isMenuOpen = ref(false)
const route = useRoute()
const user = useState<User | null>('auth.user', () => null)

const isHomePage = computed(() => route.path === '/')

function handleEscape(e: KeyboardEvent) {
  if (e.key === 'Escape') closeMenu()
}

onMounted(() => {
  if (process.client) {
    watch(isMenuOpen, (open) => {
      document.body.classList.toggle('menu-open', open)
      if (open) {
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

/* Slim strip attached to viewport edge; minimal width so site stays browsable */
.site-header-drawer {
  display: flex;
  position: fixed !important;
  top: 0;
  bottom: 0;
  width: 72px;
  min-width: 72px;
  max-width: 72px;
  padding: 0 0.5rem 0.5rem;
  padding-top: env(safe-area-inset-top, 0.5rem);
  background: $primary;
  flex-direction: column;
  justify-content: space-between;
  font-family: 'Chocolates', serif;
  overflow-y: auto;
  overflow-x: hidden;
  visibility: hidden;
  transition: transform 0.3s ease, background 0.3s ease;
  z-index: 10001;
  border-left: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow: -4px 0 20px rgba(0, 0, 0, 0.15);
}
.site-header-drawer.drawer-left {
  border-left: none;
  border-right: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow: 4px 0 20px rgba(0, 0, 0, 0.15);
}
.site-header-drawer .drawer-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  width: 100%;
  flex-shrink: 0;
  padding-bottom: 0.5rem;
  margin-bottom: 0.25rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.12);
}
.site-header-drawer.drawer-right .drawer-header {
  flex-direction: column;
}
.site-header-drawer.drawer-left .drawer-header {
  flex-direction: column;
}
.site-header-drawer.drawer-theme-light .drawer-header {
  border-bottom-color: rgba(0, 0, 0, 0.08);
}
/* Header: X and L R stacked in slim strip */
.site-header-drawer.drawer-right .drawer-close {
  order: 0;
}
.site-header-drawer.drawer-right .drawer-side-pills {
  order: 1;
}
.site-header-drawer.drawer-left .drawer-close {
  order: 1;
}
.site-header-drawer.drawer-left .drawer-side-pills {
  order: 0;
}
.site-header-drawer.drawer-theme-light {
  background: rgba(226, 232, 240, 0.98);
  border-left-color: rgba(0, 0, 0, 0.06);
  box-shadow: -4px 0 20px rgba(0, 0, 0, 0.08);
}
.site-header-drawer.drawer-theme-light.drawer-left {
  border-right-color: rgba(0, 0, 0, 0.06);
  box-shadow: 4px 0 20px rgba(0, 0, 0, 0.08);
}
.site-header-drawer.drawer-theme-light .drawer-link,
.site-header-drawer.drawer-theme-light .drawer-btn {
  color: #1a1a2e;
}
.site-header-drawer.drawer-theme-light .drawer-link.active,
.site-header-drawer.drawer-theme-light .drawer-link:hover,
.site-header-drawer.drawer-theme-light .drawer-btn:hover {
  color: $primary;
}
.site-header-drawer .drawer-close {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 2.5rem;
  height: 2.5rem;
  padding: 0;
  background: rgba(255, 255, 255, 0.12);
  color: white;
  border: none;
  border-radius: 0.25rem;
  cursor: pointer;
  transition: background 0.2s, color 0.2s, transform 0.25s ease, opacity 0.25s ease;
  flex-shrink: 0;
}
.site-header-drawer .drawer-close svg {
  font-size: 1.375rem;
}
.site-header-drawer .drawer-close:hover {
  background: rgba(255, 255, 255, 0.22);
}
.site-header-drawer .drawer-close:focus-visible {
  outline: 2px solid white;
  outline-offset: 2px;
}
/* X "lands" when drawer opens (ham animates into this) */
.site-header-drawer:not(.open) .drawer-close {
  opacity: 0;
  transform: scale(0.85);
}
.site-header-drawer.open .drawer-close {
  opacity: 1;
  transform: scale(1);
}
.site-header-drawer.drawer-theme-light .drawer-close {
  background: rgba(0, 0, 0, 0.08);
  color: #1a1a2e;
}
.site-header-drawer.drawer-theme-light .drawer-close:hover {
  background: rgba(0, 0, 0, 0.14);
}
.site-header-drawer.drawer-theme-light .drawer-close:focus-visible {
  outline-color: #1a1a2e;
}
.site-header-drawer .drawer-nav-links {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.25rem;
  flex: 1;
  min-height: 0;
}
.site-header-drawer.drawer-right {
  right: 0;
  left: auto;
  align-items: center;
  transform: translateX(100%);
}
.site-header-drawer.drawer-right.open {
  transform: translateX(0);
  visibility: visible;
}
.site-header-drawer.drawer-left {
  left: 0;
  right: auto;
  align-items: center;
  transform: translateX(-100%);
}
.site-header-drawer.drawer-left.open {
  transform: translateX(0);
  visibility: visible;
}

.site-header-drawer .drawer-link,
.site-header-drawer .drawer-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0;
  padding: 0.5rem;
  font-size: 1rem;
  font-weight: 600;
  font-family: 'Chocolates', serif;
  color: white;
  text-decoration: none;
  background: none;
  border: none;
  cursor: pointer;
  transition: color 0.2s, background 0.2s;
  width: 100%;
  min-width: 2.5rem;
  height: 2.5rem;
  border-radius: 0.25rem;
  box-sizing: border-box;
}
.site-header-drawer .drawer-link:hover,
.site-header-drawer .drawer-btn:hover {
  background: rgba(255, 255, 255, 0.1);
}
.site-header-drawer .drawer-link svg,
.site-header-drawer .drawer-btn svg {
  font-size: 1.375rem;
  flex-shrink: 0;
}
.site-header-drawer .drawer-link-text {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip-path: inset(50%);
  white-space: nowrap;
  border: 0;
}
.site-header-drawer .drawer-link.active,
.site-header-drawer .drawer-link:hover,
.site-header-drawer .drawer-btn:hover {
  color: $primary-light;
}

/* Footer: theme icon only in slim strip */
.drawer-footer {
  display: flex;
  align-items: center;
  justify-content: center;
  padding-top: 0.5rem;
  margin-top: 0.25rem;
  border-top: 1px solid rgba(255, 255, 255, 0.12);
  flex-shrink: 0;
}
.site-header-drawer.drawer-theme-light .drawer-footer {
  border-top-color: rgba(0, 0, 0, 0.08);
}
.drawer-footer-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 2.5rem;
  height: 2.5rem;
  padding: 0;
  background: rgba(255, 255, 255, 0.1);
  color: white;
  border: none;
  border-radius: 0.25rem;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
}
.drawer-footer-btn svg {
  font-size: 1.25rem;
}
.drawer-footer-btn:hover {
  background: rgba(255, 255, 255, 0.2);
}
.drawer-footer-btn:focus-visible {
  outline: 2px solid white;
  outline-offset: 2px;
}
.site-header-drawer.drawer-theme-light .drawer-footer-btn {
  background: rgba(0, 0, 0, 0.06);
  color: #1a1a2e;
}
.site-header-drawer.drawer-theme-light .drawer-footer-btn:hover {
  background: rgba(0, 0, 0, 0.12);
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
  padding: 0;
  font-size: 0.6875rem;
  font-weight: 600;
  font-family: 'Chocolates', serif;
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.9);
  border: none;
  border-radius: 0.25rem;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
}
.drawer-side-pills button:hover {
  background: rgba(255, 255, 255, 0.2);
}
.drawer-side-pills button.active {
  background: rgba(255, 255, 255, 0.25);
  color: white;
}
.drawer-side-pills button:focus-visible {
  outline: 2px solid white;
  outline-offset: 2px;
}
.site-header-drawer.drawer-theme-light .drawer-side-pills button {
  background: rgba(0, 0, 0, 0.06);
  color: rgba(0, 0, 0, 0.7);
}
.site-header-drawer.drawer-theme-light .drawer-side-pills button:hover {
  background: rgba(0, 0, 0, 0.12);
}
.site-header-drawer.drawer-theme-light .drawer-side-pills button.active {
  background: rgba(0, 0, 0, 0.18);
  color: #1a1a2e;
}
.site-header-drawer.drawer-theme-light .drawer-side-pills button:focus-visible {
  outline-color: #1a1a2e;
}

@media (max-width: 480px) {
  .site-header-drawer {
    width: 72px;
    min-width: 72px;
    max-width: 72px;
    padding: 0 0.5rem 0.5rem;
    padding-top: env(safe-area-inset-top, 0.5rem);
  }
}
</style>