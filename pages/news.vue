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
      <p v-if="pending" class="news-status">Loading posts…</p>
      <p v-else-if="error" class="news-status news-error">
        Unable to load posts. Please try again later.
      </p>
      <template v-else-if="posts.length">
        <div class="posts-grid">
          <BlogCard
            v-for="post in posts"
            :key="post.id"
            :title="post.title"
            :slug="post.slug"
            :excerpt="post.excerpt ?? ''"
            :image="post.image"
          />
        </div>
      </template>
      <p v-else class="news-status">No posts yet. Check back soon.</p>
    </div>

    <div class="news-cross-nav-wrap">
      <CrossNav variant="inline" />
    </div>
  </section>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: 'auth'
})

interface WpPost {
  id: string
  title: string
  slug: string
  excerpt: string
  featuredImage?: { node?: { sourceUrl: string; altText?: string } }
}

const { data, pending, error } = await useFetch<{ posts: WpPost[] }>('/api/posts', {
  query: { perPage: 24 },
  default: () => ({ posts: [] })
})

const posts = computed(() => {
  const nodes = data.value?.posts ?? []
  return nodes.map((p) => ({
    id: p.id,
    title: p.title,
    slug: p.slug,
    excerpt: p.excerpt ?? '',
    image: p.featuredImage?.node?.sourceUrl
  }))
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
  min-height: 12rem;
}

.news-status {
  color: rgba(255, 255, 255, 0.8);
  text-align: center;
  font-size: 1rem;
}

.news-status.news-error {
  color: rgba(255, 200, 150, 0.95);
}

.posts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
}

.news-cross-nav-wrap {
  margin-top: 2.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid rgba(255, 255, 255, 0.12);
}
</style>
