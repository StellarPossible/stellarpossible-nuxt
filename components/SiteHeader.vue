<template>
  <header :class="['site-header', { scrolled }]">
    <div class="container" :class="{ 'home-layout': isHomePage }">
      <div class="header-left">
        <button
          class="menu-toggle"
          @click="isMenuOpen = !isMenuOpen"
          aria-label="Toggle navigation"
        >
          <span :class="{ open: isMenuOpen }"></span>
          <span :class="{ open: isMenuOpen }"></span>
          <span :class="{ open: isMenuOpen }"></span>
        </button>
        <nav class="nav nav-left" :class="{ open: isMenuOpen }">
          <template v-if="user">
            <button type="button" class="logout-btn" @click="logout">logout</button>
          </template>
          <NuxtLink v-else to="/login" active-class="active" @click="closeMenu">login</NuxtLink>
        </nav>
      </div>

      <NuxtLink
        to="/"
        class="logo"
        :class="{ 'logo-hidden': isHomePage }"
      >
        <div v-if="isHomePage" class="logo-backdrop"></div>
        <img
          src="~/public/images/primary/spicon.png"
          alt="Stellar Possible logo"
        />
      </NuxtLink>

      <nav class="nav nav-right" :class="{ open: isMenuOpen }">
        <NuxtLink to="/services" active-class="active" @click="closeMenu">services</NuxtLink>
      </nav>
    </div>

    <!-- Mobile drawer: single panel with both links -->
    <nav class="nav-drawer" :class="{ open: isMenuOpen }" aria-hidden="true">
      <template v-if="user">
        <button type="button" class="logout-btn" @click="logout">logout</button>
      </template>
      <NuxtLink v-else to="/login" active-class="active" @click="closeMenu">login</NuxtLink>
      <NuxtLink to="/services" active-class="active" @click="closeMenu">services</NuxtLink>
    </nav>
  </header>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'

defineProps<{ scrolled: boolean }>()

const isMenuOpen = ref(false)
const route = useRoute()
import type { User } from '~/types/auth'
const user = useState<User | null>('auth.user', () => null)

const isHomePage = computed(() => route.path === '/')

onMounted(() => {
  if (process.client) {
    watch(isMenuOpen, (open) => {
      document.body.classList.toggle('menu-open', open)
    }, { immediate: true })
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
    background: rgba(0, 0, 0, 0.3);
    backdrop-filter: blur(4px);
    z-index: -1;
    transition: background 0.3s ease, backdrop-filter 0.3s ease;
  }

  &.scrolled::before {
    background: rgba(0, 0, 0, 0.85);
    backdrop-filter: blur(8px);
  }

  .container {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 2rem;
    margin: auto;
    padding: 0.5rem;
    width: 100%;
    max-width: 100%;
  }

  .header-left {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    min-width: 0;
  }

  .nav-left,
  .nav-right {
    display: flex;
    align-items: center;
  }

  .logo {
    display: flex;
    align-items: center;
    transition: opacity 0.3s ease;
    position: relative;

    img {
      display: block;
      width: 7rem;
    }
  }

  .menu-toggle {
    position: relative;
    display: none;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 2.5rem;
    height: 2.5rem;
    background: none;
    border: none;
    cursor: pointer;
    z-index: 1100;
    margin: 1rem;

    span {
      position: absolute;
      left: 0;
      width: 2.5rem;
      height: 0.25rem;
      background: $white;
      border-radius: 2px;
      transition: 0.3s;
    }

    span:nth-child(1) { top: 0.5rem; }
    span:nth-child(2) { top: 1.125rem; }
    span:nth-child(3) { top: 1.75rem; }

    & span.open:nth-child(1) {
      transform: translateY(0.625rem) rotate(45deg);
    }
    & span.open:nth-child(2) {
      opacity: 0;
    }
    & span.open:nth-child(3) {
      transform: translateY(-0.625rem) rotate(-45deg);
    }
  }

  .nav {
    display: flex;
    align-items: center;
    gap: 2rem;
    font-size: 2rem;
    min-width: 0;
    font-family: 'OldStyle', 'Inter', sans-serif;

    a {
      text-decoration: none;
      color: white;
      font-weight: 600;
      transition: color 0.2s;

      &:hover,
      &.active {
        color: $primary-light;
      }
    }

    /* Submenu for write */
    .nav-item {
      position: relative;
      display: inline-flex;
      align-items: center;

      .submenu {
        display: none;
        position: absolute;
        top: calc(100% + 0.5rem);
        left: 0;
        background: rgba(0,0,0,0.9);
        border-radius: 8px;
        padding: 0.5rem;
        min-width: 160px;
        flex-direction: column;
        gap: 0.25rem;
        box-shadow: 0 8px 20px rgba(0,0,0,0.25);
        z-index: 3000;
      }

      &:hover .submenu,
      &:focus-within .submenu {
        display: flex;
      }

      .submenu a {
        font-size: 1rem;
        padding: 0.5rem 0.75rem;
        color: white;
        text-decoration: none;
        border-radius: 6px;
      }

      .submenu a:hover {
        background: rgba(255,255,255,0.04);
        color: $primary-light;
      }
    }

    @media (max-width: 768px) {
      .nav-item .submenu {
        position: static;
        display: none;
        padding-left: 1rem;
      }

      .nav.open .nav-item .submenu {
        display: flex;
      }
    }

    .logout-btn {
      background: rgba(255, 255, 255, 0.1);
      color: white;
      border: 1px solid rgba(255, 255, 255, 0.2);
      padding: 0.5rem 1rem;
      border-radius: 4px;
      cursor: pointer;
      font-size: 0.9rem;
      font-weight: 600;
      transition: all 0.2s ease;
      
      &:hover {
        background: rgba(255, 255, 255, 0.2);
        border-color: rgba(255, 255, 255, 0.3);
        transform: translateY(-1px);
      }
      
      &:active {
        transform: translateY(0);
      }
    }
  }

  .nav-drawer {
    display: none;
  }

  @media (max-width: 768px) {
    .logo > img {
      width: 5rem;
    }

    .menu-toggle {
      display: flex;
    }

    .nav-left,
    .nav-right {
      display: none;
    }

    .nav-drawer {
      display: flex;
      padding: 0 1rem;
      margin: 0;
      position: fixed;
      top: 0;
      right: 0;
      bottom: 0;
      height: 100vh;
      background: $primary;
      flex-direction: column;
      align-items: flex-end;
      justify-content: center;
      gap: 1.5rem;
      box-shadow: -2px 0 10px rgba(0, 0, 0, 0.1);
      transform: translateX(100%);
      transition: transform 0.3s;
      z-index: 1050;
      width: 100%;
      font-size: 2rem;
      font-family: 'OldStyle', 'Inter', sans-serif;

      a {
        font-size: 1.2rem;
        text-decoration: none;
        color: white;
        font-weight: 600;

        &.active {
          color: $primary-light;
        }
      }

      .logout-btn {
        background: rgba(255, 255, 255, 0.1);
        color: white;
        border: 1px solid rgba(255, 255, 255, 0.2);
        padding: 0.75rem 1.5rem;
        border-radius: 4px;
        cursor: pointer;
        font-size: 1rem;
        font-weight: 600;
      }

      &.open {
        transform: translateX(0);
      }
    }
  }
}
</style>