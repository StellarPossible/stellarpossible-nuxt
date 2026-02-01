<template>
  <section class="news-page">
    <div class="hero">
      <h1 class="news-hero-title">
        Latest from <img src="/images/primary/spicon.png" alt="Stellar Possible" class="news-hero-icon" />
      </h1>
      <p class="hero-subtitle">
        News, updates, and highlights from StellarPossible.
      </p>
    </div>
    <div class="news-content">
      <p class="placeholder">
        Latest updates and news will appear here.
      </p>
    </div>
  </section>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: 'auth'
})
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.news-page {
  padding: 2rem 1.5rem 4rem;
  max-width: 900px;
  margin: 0 auto;
}

.hero {
  text-align: center;
  margin-bottom: 2rem;

  h1.news-hero-title {
    font-family: 'Evermore', 'Inter', sans-serif;
    font-size: 2.5rem;
    color: $white;
    margin-bottom: 0.5rem;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    flex-wrap: wrap;
    justify-content: center;
  }

  .news-hero-icon {
    display: inline-block;
    width: 2.5rem;
    height: 2.5rem;
    object-fit: contain;
    vertical-align: middle;
  }

  .hero-subtitle {
    font-size: 1.125rem;
    color: rgba(255, 255, 255, 0.9);
  }
}

.news-content {
  .placeholder {
    color: rgba(255, 255, 255, 0.8);
    text-align: center;
    font-size: 1rem;
  }
}
</style>
