<template>
    <div class="layout-wrapper">
      <SiteHeader />
      <main class="main-content">
        <NuxtPage />
      </main>
    </div>
  </template>
  
  <script setup lang="ts">
  // Global layout
  </script>
  
  <style scoped lang="scss">
  @use '@/assets/scss/variables.scss' as *;
  
  .site-content {
    background-color: $primary;

  }
  .layout-wrapper {
    background-color: $light;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    font-family: 'Inter', sans-serif;
    color: $white;
  }
  
  .main-content {
    flex: 1;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
    border-radius: 12px;
    transition: all 0.3s ease;
  }
  
  @media (max-width: 768px) {
    .main-content {
      padding: 3rem 1rem 1.5rem;
      border-radius: 0;
    }
  }
  </style>
  