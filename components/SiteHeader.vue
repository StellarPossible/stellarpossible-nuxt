<template>
    <header class="site-header">
      <div class="container">
        <NuxtLink 
          to="/" 
          class="logo"
          :class="{ 'logo-hidden': isHomePage }"
        >
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
    width: 100%;
    background: transparent;
    z-index: 1000;
    padding: 1rem 0;
  
    .container {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin: auto;
      max-width: 1200px;
      padding: 0 2rem;
    }
  
    .logo {
      display: flex;
      align-items: center;
      transition: opacity 0.3s ease;

      &.logo-hidden {
        opacity: 0;
        pointer-events: none;
      }
  
      img {
        display: block;
        max-width: 10rem;
      }
    }
  
    .menu-toggle {
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
        margin: 0;
        position: fixed;
        top: 0;
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
