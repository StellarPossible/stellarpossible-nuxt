<template>
  <header :class="['site-header', { scrolled, 'menu-on-left': menuSide === 'left' }]">
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
        <div
          class="drawer-backdrop site-header-backdrop"
          :class="{ open: isMenuOpen }"
          aria-hidden="true"
          @click="closeMenu"
        />
        <nav
          class="nav-drawer site-header-drawer"
          :class="{ open: isMenuOpen, 'drawer-left': menuSide === 'left', 'drawer-right': menuSide === 'right' }"
          aria-label="Main navigation"
          :aria-hidden="!isMenuOpen"
        >
          <NuxtLink to="/products" active-class="active" @click="closeMenu">products</NuxtLink>
          <NuxtLink to="/services" active-class="active" @click="closeMenu">services</NuxtLink>
          <template v-if="user">
            <NuxtLink to="/dashboard" active-class="active" @click="closeMenu" class="drawer-link-with-icon">
              <Icon icon="mdi:view-dashboard" />
              <span>dashboard</span>
            </NuxtLink>
            <button type="button" class="logout-btn" @click="logout">logout</button>
          </template>
          <NuxtLink v-else to="/login" active-class="active" @click="closeMenu">login</NuxtLink>

          <div class="drawer-accessibility" role="group" aria-label="Menu position">
            <span class="drawer-accessibility-label">Menu side:</span>
            <div class="drawer-accessibility-buttons">
              <button
                type="button"
                :class="{ active: menuSide === 'left' }"
                :aria-pressed="menuSide === 'left'"
                aria-label="Menu opens from left (left-handed)"
                @click="setMenuSide('left')"
              >
                Left
              </button>
              <button
                type="button"
                :class="{ active: menuSide === 'right' }"
                :aria-pressed="menuSide === 'right'"
                aria-label="Menu opens from right (right-handed)"
                @click="setMenuSide('right')"
              >
                Right
              </button>
            </div>
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

defineProps<{ scrolled: boolean }>()

const { menuSide, setMenuSide } = useMenuSide()
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
    transition: background 0.3s ease, backdrop-filter 0.3s ease;
  }

  &.scrolled::before {
    background: rgba(0, 0, 0, 0.25);
    backdrop-filter: blur(6px);
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

  /* Backdrop and drawer are teleported to body; see unscoped .site-header-backdrop / .site-header-drawer below */

  @media (max-width: 480px) {
    .logo > img {
      width: 5rem;
    }
  }
}

/* Teleported backdrop and drawer (render under body, high z-index so never clipped) */
.site-header-backdrop {
  position: fixed !important;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 10000;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s ease;
}
.site-header-backdrop.open {
  opacity: 1;
  pointer-events: auto;
}

.site-header-drawer {
  display: flex;
  position: fixed !important;
  top: 0;
  bottom: 0;
  width: 100%;
  max-width: 320px;
  min-width: 280px;
  padding: 6rem 2rem 2rem;
  background: $primary;
  flex-direction: column;
  justify-content: flex-start;
  gap: 0.5rem;
  font-family: 'Chocolates', serif;
  overflow-y: auto;
  visibility: hidden;
  transition: transform 0.3s ease;
  z-index: 10001;
}
.site-header-drawer.drawer-right {
  right: 0;
  left: auto;
  align-items: flex-end;
  box-shadow: -4px 0 24px rgba(0, 0, 0, 0.3);
  transform: translateX(100%);
}
.site-header-drawer.drawer-right.open {
  transform: translateX(0);
  visibility: visible;
}
.site-header-drawer.drawer-left {
  left: 0;
  right: auto;
  align-items: flex-start;
  box-shadow: 4px 0 24px rgba(0, 0, 0, 0.3);
  transform: translateX(-100%);
}
.site-header-drawer.drawer-left.open {
  transform: translateX(0);
  visibility: visible;
}

.site-header-drawer a {
  display: block;
  padding: 0.75rem 0;
  font-size: 1.25rem;
  text-decoration: none;
  color: white;
  font-weight: 600;
  transition: color 0.2s;
}
.site-header-drawer a.active {
  color: $primary-light;
}
.site-header-drawer a:hover {
  color: $primary-light;
}
.site-header-drawer .drawer-link-with-icon {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
}
.site-header-drawer .drawer-link-with-icon svg {
  font-size: 1.25rem;
}

.site-header-drawer .logout-btn {
  margin-top: 0.5rem;
  padding: 0.75rem 0;
  background: transparent;
  color: white;
  border: none;
  font-size: 1.25rem;
  font-weight: 600;
  font-family: 'Chocolates', serif;
  cursor: pointer;
  transition: color 0.2s;
  text-align: left;
  width: 100%;
  display: block;
}
.site-header-drawer.drawer-right .logout-btn {
  text-align: right;
}
.site-header-drawer .logout-btn:hover {
  color: $primary-light;
}

/* Accessibility: menu side (left/right handed) */
.drawer-accessibility {
  margin-top: auto;
  padding-top: 1.5rem;
  border-top: 1px solid rgba(255, 255, 255, 0.2);
}
.drawer-accessibility-label {
  display: block;
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 0.5rem;
}
.drawer-accessibility-buttons {
  display: flex;
  gap: 0.5rem;
}
.drawer-accessibility-buttons button {
  padding: 0.5rem 0.75rem;
  font-size: 0.875rem;
  font-family: 'Chocolates', serif;
  background: rgba(255, 255, 255, 0.15);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 0.25rem;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
}
.drawer-accessibility-buttons button:hover {
  background: rgba(255, 255, 255, 0.25);
}
.drawer-accessibility-buttons button.active {
  background: rgba(255, 255, 255, 0.3);
  border-color: rgba(255, 255, 255, 0.5);
}
.drawer-accessibility-buttons button:focus-visible {
  outline: 2px solid white;
  outline-offset: 2px;
}

@media (max-width: 480px) {
  .site-header-drawer {
    max-width: 100%;
    min-width: 100%;
    padding: 6rem 1.5rem 2rem;
  }
}
</style>