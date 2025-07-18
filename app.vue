<template>
    <div class="layout-wrapper" :class="{ 'show-logo': isHomePage }">
      <SiteHeader />
      <main class="main-content">
        <NuxtPage />
      </main>
    </div>
  </template>
  
  <script setup lang="ts">
  import { computed } from 'vue'
  
  const route = useRoute()
  const isHomePage = computed(() => route.path === '/')
  </script>
  
  <style lang="scss">
  @use '@/assets/scss/variables.scss' as *;
  
  .site-content {
    background-color: $primary;
  }
  
  .layout-wrapper {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    font-family: 'Inter', sans-serif;
    color: $white;
    position: relative;
    
    // Galaxy background - try different approaches
    background: var(--primary-color, #0e0f1a) url('/images/primary/galaxyBackground.webp') no-repeat center center;
    background-size: cover;
    background-attachment: fixed;

    // Logo overlay - only visible on homepage
    &.show-logo::before {
      content: '';
      position: fixed;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 20rem;
      height: 20rem;
      background: url('~/public/images/primary/spicon.png') no-repeat center center;
      background-size: contain;
      z-index: 1;
      pointer-events: none;
      border-radius: 10rem;
    }
  }
  
  .main-content {
    flex: 1;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
    border-radius: 12px;
    transition: all 0.3s ease;
    background: transparent; // Make sure main content doesn't block the background
  }
  
  @media (max-width: 768px) {
    .main-content {
      border-radius: 0;
    }
  }
  </style>
