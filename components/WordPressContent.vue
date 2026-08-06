<template>
  <article class="wordpress-content">
    <header v-if="title || featuredImage" class="wordpress-content__header">
      <div v-if="featuredImage" class="wordpress-content__image-wrap">
        <NuxtImg
          :src="featuredImage"
          :alt="title || 'Featured image'"
          class="wordpress-content__image"
        />
      </div>
      <div class="wordpress-content__meta">
        <time v-if="date" class="wordpress-content__date" :datetime="date">{{ date }}</time>
        <h1 v-if="title" class="wordpress-content__title">{{ title }}</h1>
      </div>
    </header>

    <div
      class="wordpress-content__body wp-content"
      v-html="sanitizedContent"
    />
  </article>
</template>

<script setup lang="ts">
const props = defineProps<{
  content: string
  title?: string
  featuredImage?: string
  date?: string
}>()

const sanitizedContent = computed(() => props.content || '')
</script>

<style scoped lang="scss">
.wordpress-content {
  width: 100%;
}

.wordpress-content__header {
  border-bottom: 1px solid var(--color-border);
}

.wordpress-content__image-wrap {
  width: 100%;
  max-height: 22rem;
  overflow: hidden;
}

.wordpress-content__image {
  width: 100%;
  height: 100%;
  max-height: 22rem;
  object-fit: cover;
  display: block;
}

.wordpress-content__meta {
  padding: var(--space-6) var(--space-8);
}

.wordpress-content__date {
  display: block;
  font-size: var(--fs-200);
  color: var(--color-text-subtle);
  margin-bottom: var(--space-2);
}

.wordpress-content__title {
  font-family: var(--font-display);
  font-size: var(--fs-600);
  font-weight: 500;
  line-height: 1.15;
  margin: 0;
  color: var(--color-text);
}

.wordpress-content__body {
  padding: var(--space-6) var(--space-8) var(--space-8);
}

@media (max-width: 768px) {
  .wordpress-content__meta,
  .wordpress-content__body {
    padding-inline: var(--space-5);
  }

  .wordpress-content__title {
    font-size: var(--fs-500);
  }
}

@media (max-width: 480px) {
  .wordpress-content__meta,
  .wordpress-content__body {
    padding-inline: var(--space-4);
  }

  .wordpress-content__image-wrap {
    max-height: 14rem;
  }
}
</style>
