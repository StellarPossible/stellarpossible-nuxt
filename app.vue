<template>
  <div class="layout-wrapper" :class="{ 'show-logo': isHomePage }">
    <SiteHeader />
    <main class="main-content">
      <div class="page-content">
        <NuxtPage />
      </div>
    </main>
    
  </div>
  <SiteFooter />
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
  background: var(--primary-color, #0e0f1a) url('/images/primary/galaxyBackground.png') no-repeat;
  background-position: calc(50% + 5px) center;
  background-size: cover;
  background-attachment: fixed;

  // Add this pseudo-element for the gradient fade
  &::after {
    content: '';
    position: absolute;
    inset: 0;
    pointer-events: none;
    z-index: 2;
    // Radial gradient: transparent in center, black at edges
    background: radial-gradient(
      ellipse at center,
      rgba(0,0,0,0) 60%,
      rgba(0,0,0,0.7) 100%
    );
    // Optional: smooth the fade by adjusting the percentages and opacity
  }
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  background: transparent; // Make sure main content doesn't block the background
}

.page-content {
  justify-content: center;
  flex: 1;
  display: flex;
  flex-direction: column;
  background-color: $primary;

  // Make background transparent on homepage
  .show-logo & {
    background-color: transparent;
  }
}

@media (max-width: 768px) {
  .main-content {
    border-radius: 0;
  }
}
</style>
