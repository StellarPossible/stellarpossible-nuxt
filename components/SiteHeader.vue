<template>
    <header class="site-header">
      <div class="container" :class="{ 'home-layout': isHomePage }">
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

        <button
          class="menu-toggle"
          @click="isMenuOpen = !isMenuOpen"
          aria-label="Toggle navigation"
        >
          <span :class="{ open: isMenuOpen }"></span>
          <span :class="{ open: isMenuOpen }"></span>
          <span :class="{ open: isMenuOpen }"></span>
        </button>

        <nav
          class="nav"
          :class="{ open: isMenuOpen }"
        >
          <NuxtLink to="/" exact-active-class="active" @click="closeMenu">Home</NuxtLink>
          <NuxtLink to="/about" active-class="active" @click="closeMenu">About</NuxtLink>
          <NuxtLink to="/products" active-class="active" @click="closeMenu">Products</NuxtLink>
          <NuxtLink to="/blog" active-class="active" @click="closeMenu">Education</NuxtLink>
          <NuxtLink to="/contact" active-class="active" @click="closeMenu">Contact</NuxtLink>
          <NuxtLink to="/register" active-class="active" @click="closeMenu">Login</NuxtLink>
        </nav>
      </div>
    </header>
  </template>
  
  <script setup lang="ts">
  import { ref, computed } from 'vue'

  const isMenuOpen = ref(false)
  const route = useRoute()

  const isHomePage = computed(() => route.path === '/')

  function closeMenu() {
    isMenuOpen.value = false
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
    overflow: hidden;

    &::before {
      content: '';
      position: absolute;
      inset: 0;
      background: rgba(0, 0, 0, 0.6);
      background-size: cover;
      background-attachment: fixed;
      filter: blur(3px);
      z-index: -1;
    }
  
    .container {
      display: flex;
      justify-content: space-around;
      align-items: center;
      margin: auto;
      padding: 1rem;
    }
  
    .logo {
      display: flex;
      align-items: center;
      transition: opacity 0.3s ease;
      position: relative;
  
      img {
        display: block;
        max-width: 7rem;
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
      span:nth-child(1) {
        top: 0.5rem;
      }
      span:nth-child(2) {
        top: 1.125rem;
      }
      span:nth-child(3) {
        top: 1.75rem;
      }

      // Hamburger to X animation
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
      opacity: .8;
      font-size: 1rem;
      font-family: 'Evermore', 'Inter', sans-serif;
  
      a {
        text-decoration: none;
        color: white;
        font-weight: 600;
        transition: color 0.2s;
  
        &:hover,
        &.active {
          color: $secondary;
        }
      }
    }
  
    @media (max-width: 768px) {
    .menu-toggle {
      display: flex;
    }
    .nav {
      padding: 0 1rem;
      margin: 0;
      position: fixed;
      bottom: 0;
      right: 0;
      height: 100vh;
      background: $primary;
      flex-direction: column;
      align-items: flex-start;
      box-shadow: -2px 0 10px rgba(0,0,0,0.1);
      transform: translateX(100%);
      transition: transform 0.3s;
      z-index: 1050;
      width: 100%;
      justify-content: center;

      a {
        font-size: 1.2rem;
        width: 100%;
        text-align: right;
      }

      &.open {
        transform: translateX(0);
      }
    }
  }
  }
  </style>
