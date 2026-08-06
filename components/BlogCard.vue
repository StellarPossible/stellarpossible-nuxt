<script setup lang="ts">
defineProps<{
  title: string
  slug: string
  excerpt: string
  image?: string
}>()
</script>

<template>
  <NuxtLink :to="`/posts/${slug}`" class="blog-card">
    <div v-if="image" class="blog-card__media">
      <NuxtImg :src="image" width="400" height="200" :alt="title" class="blog-card__img" />
    </div>
    <div class="blog-card__body">
      <h2 class="blog-card__title">{{ title }}</h2>
      <div v-html="excerpt" class="blog-card__excerpt" />
      <span class="blog-card__cta">
        Read more
        <Icon icon="mdi:arrow-right" aria-hidden="true" />
      </span>
    </div>
  </NuxtLink>
</template>

<style scoped lang="scss">
.blog-card {
  display: flex;
  flex-direction: column;
  height: 100%;
  background: var(--color-glass);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  box-shadow: var(--shadow-md);
  text-decoration: none;
  color: inherit;
  overflow: hidden;
  transition:
    transform var(--dur-med) var(--ease-out),
    box-shadow var(--dur-med) var(--ease-out),
    border-color var(--dur-med) var(--ease-out);

  &:hover {
    transform: translateY(-3px);
    border-color: var(--color-border-strong);
    box-shadow: var(--shadow-lg), var(--shadow-glow);
  }

  &:focus-visible {
    outline: 2px solid var(--color-accent);
    outline-offset: 2px;
  }
}

.blog-card__media {
  aspect-ratio: 16 / 9;
  overflow: hidden;
  background: rgba(0, 0, 0, 0.2);
}

.blog-card__img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.blog-card__body {
  display: flex;
  flex-direction: column;
  flex: 1;
  gap: var(--space-3);
  padding: var(--space-5);
}

.blog-card__title {
  font-family: var(--font-display);
  font-size: var(--fs-400);
  font-weight: 500;
  margin: 0;
  line-height: 1.2;
  color: var(--color-text);
}

.blog-card__excerpt {
  font-size: var(--fs-200);
  color: var(--color-text-muted);
  line-height: 1.55;
  flex: 1;

  :deep(p) {
    margin: 0;
  }
}

.blog-card__cta {
  display: inline-flex;
  align-items: center;
  gap: var(--space-2);
  font-family: var(--font-ui);
  font-size: var(--fs-100);
  font-weight: 600;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--color-accent);
}
</style>
