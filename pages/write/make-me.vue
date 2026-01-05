<template>
  <section class="make-me-page">
    <div class="hero fade-up">
      <h1>Make Me</h1>
      <p class="subtitle">Recipes, DIY tutorials, and useful how-tos to inspire your next project.</p>
      <div class="hero-actions">
        <NuxtLink to="/write" class="cta-button secondary">Back to Write</NuxtLink>
      </div>
    </div>

    <div class="content fade-up">
      <h2>Categories</h2>
      <div class="categories">
        <NuxtLink to="/posts/tag/recipes" class="cat">Recipes</NuxtLink>
        <NuxtLink to="/posts/tag/diy" class="cat">DIY Tutorials</NuxtLink>
        <NuxtLink to="/posts/tag/how-to" class="cat">How-To Guides</NuxtLink>
      </div>

      <h2 class="mt-2">Featured Guides</h2>
      <ul class="guides">
        <li><NuxtLink to="/posts/recipe-easy-pancakes">Easy Pancakes Recipe</NuxtLink></li>
        <li><NuxtLink to="/posts/diy-bookshelf">DIY Bookshelf Tutorial</NuxtLink></li>
        <li><NuxtLink to="/posts/home-office-setup">Home Office Setup Guide</NuxtLink></li>
      </ul>
    </div>
  </section>
</template>

<script setup lang="ts">
useHead({ title: 'Make Me | Write — StellarPossible', meta: [{ name: 'description', content: 'Recipes, tutorials and how-to guides curated for creators.' }] })
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.make-me-page { padding: 3rem 1.5rem; color: $white; }
.hero { margin-bottom: 1.5rem; }
.subtitle { color: #e7f7ff; }
.hero-actions { margin-top: 0.75rem; }

.categories { display:flex; gap:0.5rem; flex-wrap:wrap; margin:0.75rem 0; }
.cat { padding:0.5rem 0.75rem; background: rgba(255,255,255,0.04); border-radius:8px; text-decoration:none; color:$white; font-weight:700; }

.guides { list-style:none; padding:0; display:grid; gap:0.5rem; }
.guides a { display:block; padding:0.75rem 1rem; background: rgba(255,255,255,0.03); color: $white; border-radius: 8px; text-decoration:none; }

.mt-2 { margin-top: 1.25rem; }
</style>