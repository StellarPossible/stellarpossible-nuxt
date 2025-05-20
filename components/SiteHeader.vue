<template>
    <header class="site-header">
      <div class="container">
        <NuxtLink to="/" class="logo">
          <img
            src="https://stellarpossible.com/wp-content/uploads/2024/07/stellar-1.png"
            alt="Stellar Possible logo"
            width="160"
            height="auto"
          />
        </NuxtLink>
  
        <nav class="nav">
          <NuxtLink to="/" exact-active-class="active">Home</NuxtLink>
          <NuxtLink to="/about" active-class="active">About</NuxtLink>
          <NuxtLink to="/products" active-class="active">Products</NuxtLink>
          <NuxtLink to="/blog" active-class="active">Education</NuxtLink>
          <NuxtLink to="/contact" active-class="active">Contact</NuxtLink>
          <NuxtLink to="/register" active-class="active">Login</NuxtLink>
        </nav>
      </div>
    </header>
  </template>
  
  <script setup lang="ts"></script>
  
  <style scoped lang="scss">
  @use '@/assets/scss/variables.scss' as *;
  
  .site-header {
    position: fixed;
    top: 0;
    width: 100%;
    background: $primary;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    z-index: 1000;
  
    .container {
      display: flex;
      justify-content: space-between;
      align-items: center;
      max-width: 1200px;
      margin: auto;
      padding: 1rem 2rem;
    }
  
    .logo {
      display: flex;
      align-items: center;
  
      img {
        display: block;
        max-height: 40px;
      }
    }
  
    .nav a {
      margin-left: 1.5rem;
      text-decoration: none;
      color: $white;
      font-weight: 500;
      transition: color 0.2s;
  
      &:hover,
      &.active {
        color: $secondary;
      }
    }
  }
  </style>
  