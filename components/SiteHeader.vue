<template>
  <header :class="['site-header', { scrolled }]">
    <div class="container" :class="{ 'home-layout': isHomePage }">
      <div class="header-left">
        <button
          class="menu-toggle"
          :class="{ open: isMenuOpen }"
          :aria-expanded="isMenuOpen"
          aria-label="Toggle navigation"
          @click="isMenuOpen = !isMenuOpen"
        >
          <span></span>
          <span></span>
          <span></span>
        </button>
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
        <!-- Spacer for balance; nav is in slide-out -->
      </div>
    </div>

    <!-- Backdrop: close menu when clicking outside -->
    <div
      class="drawer-backdrop"
      :class="{ open: isMenuOpen }"
      aria-hidden="true"
      @click="closeMenu"
    />

    <!-- Slide-out menu: all viewports -->
    <nav
      class="nav-drawer"
      :class="{ open: isMenuOpen }"
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
    </nav>
  </header>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onBeforeUnmount } from 'vue'

defineProps<{ scrolled: boolean }>()

const isMenuOpen = ref(false)
const route = useRoute()
import type { User } from '~/types/auth'
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
    background: rgba(0, 0, 0, 0.45);
    backdrop-filter: blur(6px);
  }

  .container {
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

  /* Backdrop: close menu when clicking outside */
  .drawer-backdrop {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.4);
    z-index: 1040;
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.3s ease;

    &.open {
      opacity: 1;
      pointer-events: auto;
    }
  }

  /* Slide-out menu: all viewports */
  .nav-drawer {
    display: flex;
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    width: 100%;
    max-width: 320px;
    padding: 5rem 2rem 2rem;
    background: $primary;
    flex-direction: column;
    align-items: flex-end;
    justify-content: flex-start;
    gap: 0.25rem;
    box-shadow: -4px 0 24px rgba(0, 0, 0, 0.2);
    transform: translateX(100%);
    transition: transform 0.3s ease;
    z-index: 1050;
    font-family: 'Chocolates', serif;
    overflow-y: auto;

    a {
      display: block;
      padding: 0.75rem 0;
      font-size: 1.25rem;
      text-decoration: none;
      color: white;
      font-weight: 600;
      transition: color 0.2s;

      &.active {
        color: $primary-light;
      }

      &:hover {
        color: $primary-light;
      }

      &.drawer-link-with-icon {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;

        svg {
          font-size: 1.25rem;
        }
      }
    }

    .logout-btn {
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
      text-align: right;
      width: 100%;
      display: block;

      &:hover {
        color: $primary-light;
      }
    }

    &.open {
      transform: translateX(0);
    }
  }

  @media (max-width: 480px) {
    .nav-drawer {
      max-width: 100%;
      padding: 5rem 1.5rem 2rem;
    }

    .logo > img {
      width: 5rem;
    }
  }
}
</style>