<template>
  <section class="write-index">
    <div class="hero fade-up">
      <h1>Write</h1>
      <p class="subtitle">Select a section below to get started.</p>

      <nav class="write-links" aria-label="Write sections">
        <NuxtLink to="/write/self-publish" class="card">Self-Publish</NuxtLink>
        <NuxtLink to="/write/mstompsword" class="card">M Stompsword</NuxtLink>
        <NuxtLink to="/write/make-me" class="card">Make Me</NuxtLink>
      </nav>
    </div>

    <section class="explore fade-up">
      <h2>Explore</h2>
      <p>Discover related reading and tutorials.</p>
      <ul class="explore-list">
        <li><NuxtLink to="/blog">Blog</NuxtLink></li>
        <li><NuxtLink to="/write/make-me">Make Me (recipes & DIY)</NuxtLink></li>
        <li><NuxtLink to="/posts/how-to-format-ebook">How to Format an eBook</NuxtLink></li>
        <li><NuxtLink to="/posts/book-marketing-basics">Book Marketing Basics</NuxtLink></li>
      </ul>
    </section>
  </section>
</template><script setup lang="ts">
import { onMounted } from 'vue'

// Set page title
useHead({ title: 'Write | StellarPossible' })

onMounted(() => {
  // Reuse fade-up animation peripheral
  document.body.classList.add('js-animation-enabled')
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => entry.isIntersecting && entry.target.classList.add('visible'))
  }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' })
  setTimeout(() => document.querySelectorAll('.fade-up').forEach((el) => observer.observe(el)), 100)
})
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.write-index {
  padding: 3rem 1.5rem;
  color: $white;
  text-align: center;
  display: flex;
  flex-direction: column;
  gap: 2rem;
  align-items: center;
}

.hero {
  max-width: 880px;

  h1 { font-size: 2.75rem; font-weight: 800; margin-bottom: 0.5rem; }
  .subtitle { color: #e7f7ff; margin-bottom: 1rem; }

  .write-links { display: flex; gap: 1rem; justify-content: center; margin-top: 1rem; flex-wrap: wrap; }

  .card {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 1rem 1.25rem;
    border-radius: 10px;
    background: rgba(255,255,255,0.04);
    color: $white;
    text-decoration: none;
    font-weight: 700;
    min-width: 160px;
    transition: transform 0.18s, background 0.18s;

    &:hover { transform: translateY(-4px); background: $primary-light; color: #111; }
  }
}

.explore { max-width: 900px; text-align: left; width: 100%; }
.explore-list { list-style: none; padding: 0; margin: 0; display: grid; grid-template-columns: repeat(auto-fit,minmax(220px,1fr)); gap: 0.75rem; }
.explore-list a { display: block; padding: 0.75rem 1rem; background: rgba(255,255,255,0.03); color: $white; border-radius: 8px; text-decoration: none; }

@media (max-width: 767px) { .hero .write-links { flex-direction: column; } }
</style>