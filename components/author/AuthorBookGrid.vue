<template>
  <div class="book-grid">
    <a
      v-for="book in books"
      :key="book.id"
      :href="book.amazonUrl"
      target="_blank"
      rel="noopener noreferrer"
      class="book-card"
    >
      <div class="book-cover-wrap">
        <img
          v-if="book.coverSrc"
          :src="book.coverSrc"
          :alt="book.coverAlt || `${book.title} by Marine Stompsword`"
          class="book-cover"
          width="140"
          height="210"
          loading="lazy"
        />
        <div v-else class="book-cover-placeholder" aria-hidden="true">
          <span class="book-placeholder-title">{{ book.title }}</span>
        </div>
      </div>
      <div class="book-info">
        <span class="book-title">{{ book.title }}</span>
        <span v-if="formatSeriesLabel(book)" class="book-series">{{ formatSeriesLabel(book) }}</span>
        <span v-if="book.releaseDate && book.status === 'preorder'" class="book-date">{{ book.releaseDate }}</span>
        <span class="book-cta">{{ getAmazonCtaLabel(book.status) }}</span>
      </div>
    </a>
  </div>
</template>

<script setup lang="ts">
import {
  formatSeriesLabel,
  getAmazonCtaLabel,
  type AuthorBookDisplay
} from '~/data/author-books'

defineProps<{
  books: AuthorBookDisplay[]
}>()
</script>

<style scoped lang="scss">
.book-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(10.5rem, 1fr));
  gap: 1rem;
  width: 100%;
}

.book-card {
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
  padding: var(--space-4);
  border-radius: var(--radius-lg);
  border: 1px solid var(--color-border);
  background: var(--color-glass-solid);
  backdrop-filter: blur(12px);
  text-decoration: none;
  color: inherit;
  box-shadow: var(--shadow-sm);
  transition:
    border-color var(--dur-med) var(--ease-out),
    box-shadow var(--dur-med) var(--ease-out),
    transform var(--dur-med) var(--ease-out);
}

.book-card:hover {
  border-color: var(--color-border-strong);
  box-shadow: var(--shadow-glow);
  transform: translateY(-2px);
}

.book-card:focus-visible {
  outline: 2px solid var(--color-accent);
  outline-offset: 2px;
}

.book-cover-wrap {
  display: flex;
  justify-content: center;
  min-height: 8.5rem;
}

.book-cover {
  display: block;
  width: 100%;
  max-width: 7rem;
  height: auto;
  border-radius: 6px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.book-cover-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  max-width: 7rem;
  min-height: 10.5rem;
  padding: 0.75rem;
  border-radius: 6px;
  background: rgba(255, 255, 255, 0.08);
  border: 1px dashed rgba(255, 255, 255, 0.2);
  text-align: center;
}

.book-placeholder-title {
  font-size: 0.8125rem;
  font-weight: 600;
  line-height: 1.35;
  color: rgba(255, 255, 255, 0.85);
}

.book-info {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
  min-width: 0;
}

.book-title {
  font-size: 0.9375rem;
  font-weight: 700;
  color: #fff;
  line-height: 1.25;
}

.book-series {
  font-size: 0.6875rem;
  color: rgba(255, 255, 255, 0.7);
}

.book-date {
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.85);
}

.book-cta {
  font-size: 0.75rem;
  font-weight: 600;
  color: #fff;
  margin-top: 0.25rem;
  text-decoration: underline;
  text-underline-offset: 2px;
}

@media (max-width: 480px) {
  .book-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: var(--space-3);
  }

  .book-cover-wrap {
    min-height: 7rem;
  }

  .book-cover-placeholder {
    min-height: 8rem;
  }
}
</style>
