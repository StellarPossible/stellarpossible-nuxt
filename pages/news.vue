<template>
  <PageShell>
    <SectionShell>
      <Reveal>
        <p v-if="pending" class="news-status">Loading posts…</p>
        <p v-else-if="error" class="news-status news-status--error">
          Unable to load posts. Please try again later.
        </p>
        <div v-else-if="posts.length" class="posts-grid">
          <BlogCard
            v-for="post in posts"
            :key="post.id"
            :title="post.title"
            :slug="post.slug"
            :excerpt="post.excerpt ?? ''"
            :image="post.image"
          />
        </div>
        <GlassCard v-else :hover="false" class="news-empty">
          <p class="news-status">No posts yet. Check back soon.</p>
        </GlassCard>
      </Reveal>
    </SectionShell>

    <nav class="news-cross-nav" aria-label="Site navigation">
      <CrossNav variant="inline" />
    </nav>
  </PageShell>
</template>

<script setup lang="ts">
import type { WordPressPostListItem, WordPressPostsResponse } from '~/types/wordpress'

definePageMeta({
  middleware: 'auth'
})

const { data, pending, error } = await useFetch<WordPressPostsResponse>('/api/posts', {
  query: { perPage: 24 },
  default: () => ({ posts: [] })
})

const posts = computed(() => {
  const nodes: WordPressPostListItem[] = data.value?.posts ?? []
  return nodes.map((p) => ({
    id: p.id,
    title: p.title,
    slug: p.slug,
    excerpt: p.excerpt ?? '',
    image: p.featuredImage?.node?.sourceUrl
  }))
})

useSeo({
  title: 'Latest News | StellarPossible',
  description: 'News, updates, and highlights from StellarPossible.',
  path: '/news'
})
</script>

<style scoped lang="scss">
.posts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(16rem, 1fr));
  gap: var(--space-6);
}

.news-status {
  text-align: center;
  font-size: var(--fs-300);
  color: var(--color-text-muted);
  margin: 0;
}

.news-status--error {
  color: var(--color-warning);
}

.news-empty {
  text-align: center;
  max-width: 28rem;
  margin-inline: auto;
}

.news-cross-nav {
  padding: var(--space-8) var(--space-6) var(--space-4);
  display: flex;
  justify-content: center;
}

@media (max-width: 480px) {
  .posts-grid {
    grid-template-columns: 1fr;
    gap: var(--space-4);
  }

  .news-cross-nav {
    padding-inline: var(--space-4);
  }
}
</style>
