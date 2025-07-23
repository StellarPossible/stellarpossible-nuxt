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
    bottom: 0;
    left: 0;
    right: 0;
    width: 100%;
    background: transparent;
    backdrop-filter: blur(2px);
    z-index: 1000;
  
    .container {
      display: flex;
      justify-content: space-around;
      align-items: center;
      margin: auto;

      &.home-layout {
        justify-content: center;
        padding: 1rem;
        
        .logo {
          display: none;
        }
      }
    }
  
    .logo {
      display: flex;
      align-items: center;
      transition: opacity 0.3s ease;
      width: 0;
      height: 6rem;
      position: relative;

      &.logo-hidden {
        opacity: 0;
        pointer-events: none;
      }

      .logo-backdrop {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 12rem;
        height: 12rem;
        background: radial-gradient(
          circle,
          rgba(255, 255, 255, 0.1) 0%,
          rgba(255, 255, 255, 0.05) 30%,
          transparent 70%
        );
        backdrop-filter: blur(10px);
        border-radius: 50%;
        z-index: -1;
      }
  
      img {
        display: block;
        max-width: 7rem;
      }
    }
  
    .menu-toggle {
      margin-left: 0rem;
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
        display: block;
        width: 2.5rem;
        height: 0.25rem;
        margin: 0.25rem 0;
        background: $white;
        border-radius: 2px;
        transition: 0.3s;
      }
  
      // Hamburger to X animation
      & span.open:nth-child(1) {
        transform: translateY(0.5rem) rotate(45deg);
      }
      & span.open:nth-child(2) {
        opacity: 0;
      }
      & span.open:nth-child(3) {
        transform: translateY(-0.5rem) rotate(-45deg);
      }
    }
  
    .nav {
      display: flex;
      align-items: center;
      opacity: .8;
      padding: 1rem;
      font-size: 1.5rem;
      margin-left: -3rem;
  
      a {
        margin-left: 1.5rem;
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
  
    @media (max-width: 700px) {
      
        .menu-toggle {
          display: flex;
      }
      .nav {
        padding: 0;
        margin: 0;
        margin-top: 4rem;
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
        width: 100vh;
        padding-top: 2rem;
  
        a {
          margin: 1rem 0;
          font-size: 1.2rem;
          width: 100%;
        }
  
        &.open {
          transform: translateX(0);
        }
      }
    }
  }
  </style>
