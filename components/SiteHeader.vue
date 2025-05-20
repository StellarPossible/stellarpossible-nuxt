<template>
    <header class="site-header">
      <div class="container">
        <NuxtLink to="/" class="logo">Stellar Possible</NuxtLink>
  
        <nav class="nav">
          <NuxtLink to="/" exact-active-class="active">Home</NuxtLink>
          <NuxtLink to="/about" active-class="active">About</NuxtLink>
          <NuxtLink to="/blog" active-class="active">Blog</NuxtLink>
          <NuxtLink to="/contact" active-class="active">Contact</NuxtLink>
        </nav>
      </div>
    </header>
  </template>
  
  <script setup lang="ts"></script>
  
  <style scoped lang="scss">
  .site-header {
    position: fixed;
    top: 0;
    width: 100%;
    background: #fff;
    border-bottom: 1px solid #eee;
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
      font-weight: bold;
      font-size: 1.25rem;
      color: #333;
      text-decoration: none;
    }
  
    .nav a {
      margin-left: 1.5rem;
      text-decoration: none;
      color: #555;
      font-weight: 500;
      transition: color 0.2s;
  
      &:hover,
      &.active {
        color: var(--primary, #007bff);
      }
    }
  }
  </style>
  