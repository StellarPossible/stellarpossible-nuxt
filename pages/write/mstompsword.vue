<template>
  <section class="write-subpage author-page">
    <div class="hero fade-up">
      <h1>M Stompsword</h1>
      <p class="subtitle">Writer, creator, and occasional chaos agent. Find works, news, and contact info here.</p>
      <div class="hero-actions">
        <NuxtLink to="/write" class="cta-button secondary">Back to Write</NuxtLink>
        <NuxtLink to="/contact" class="cta-button primary">Contact</NuxtLink>
      </div>
    </div>

    <div class="content fade-up">
      <h2>Bio</h2>
      <p>M Stompsword is a (fictional) author specializing in strange and helpful guides. Bio text goes here.</p>

      <h2>Selected Works</h2>
      <ul class="works">
        <li><NuxtLink to="/posts/the-odd-guide">The Odd Guide</NuxtLink></li>
        <li><NuxtLink to="/posts/strange-recipes">Strange Recipes</NuxtLink></li>
        <li><NuxtLink to="/posts/minor-epic-tales">Minor Epic Tales</NuxtLink></li>
      </ul>

      <h2>Updates</h2>
      <p>Sign up or follow for updates and new releases.</p>
    </div>
  </section>
</template>

<script setup lang="ts">
useHead({ title: 'M Stompsword | Write — StellarPossible', meta: [{ name: 'description', content: 'M Stompsword — author page with bio, works, and updates.' }] })
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.author-page { padding: 3rem 1.5rem; color: $white; }
.hero { margin-bottom: 1.5rem; text-align: center; }
.subtitle { color: #e7f7ff; }
.hero-actions { display:flex; gap:0.75rem; justify-content:center; }
.cta-button { padding: 0.6rem 1rem; border-radius: 8px; text-decoration: none; font-weight: 700; }
.cta-button.primary { background: $primary-light; color: #111; }
.cta-button.secondary { background: transparent; border: 2px solid rgba(255,255,255,0.06); color: $white; }

.works { list-style: none; padding: 0; display: grid; gap: 0.5rem; }
</style>