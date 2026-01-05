<template>
  <section class="write-subpage">
    <div class="hero fade-up">
      <h1>Self-Publish</h1>
      <p class="subtitle">Everything you need to self-publish your book — formatting, distribution, and launch support.</p>
      <div class="hero-actions">
        <NuxtLink to="/contact" class="cta-button primary">Get a Free Consultation</NuxtLink>
        <NuxtLink to="/write" class="cta-button secondary">Back to Write</NuxtLink>
      </div>
    </div>

    <div class="content fade-up">
      <h2>Our Services</h2>
      <ul class="services-list">
        <li>Cover & interior design (print + ebook)</li>
        <li>Formatting for KDP, Apple Books, and other platforms</li>
        <li>Publication setup and distribution guidance</li>
        <li>Marketing & launch strategy</li>
      </ul>

      <h2>Our Process</h2>
      <ol class="process-list">
        <li>Discovery & goal-setting</li>
        <li>Editing & design</li>
        <li>Formatting & upload</li>
        <li>Launch support & promotion</li>
      </ol>

      <h2>Frequently Asked Questions</h2>
      <details>
        <summary>How long does publishing take?</summary>
        <p>Typical timelines vary by service, but most projects complete within 4–8 weeks depending on the scope.</p>
      </details>

      <NuxtLink to="/contact" class="cta-button primary">Contact Us to Start</NuxtLink>
    </div>
  </section>
</template>

<script setup lang="ts">
useHead({
  title: 'Self-Publish | Write — StellarPossible',
  meta: [{ name: 'description', content: 'Self-publishing support: design, formatting, distribution and launch services for independent authors.' }]
})
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.write-subpage { padding: 3rem 1.5rem; color: $white; }
.hero { margin-bottom: 1.5rem; text-align: center; }
.subtitle { color: #e7f7ff; margin-bottom: 0.75rem; }
.hero-actions { display: flex; gap: 0.75rem; justify-content: center; margin-top: 0.75rem; }
.cta-button { padding: 0.6rem 1rem; border-radius: 8px; font-weight: 700; text-decoration: none; }
.cta-button.primary { background: $primary-light; color: #111; }
.cta-button.secondary { background: transparent; border: 2px solid rgba(255,255,255,0.06); color: $white; }

.content { max-width: 900px; margin: 2rem auto 0; }
.services-list { list-style: none; padding: 0; display: grid; gap: 0.5rem; }
.process-list { padding-left: 1rem; }

details summary { cursor: pointer; font-weight: 700; margin-top: 0.5rem; }
details p { margin: 0.5rem 0 0; }
</style>