<template>
  <PageShell narrow class="post-page">
    <Reveal>
      <div class="post-page__nav">
        <AppButton to="/news" variant="ghost" size="sm">
          <Icon icon="mdi:arrow-left" aria-hidden="true" />
          Back to news
        </AppButton>
      </div>

      <p v-if="pending" class="post-page__status">Loading post…</p>
      <GlassCard v-else-if="fetchError" :hover="false" class="post-page__error">
        <p class="post-page__status post-page__status--error">
          {{ errorMessage }}
        </p>
        <AppButton to="/news" variant="secondary">Return to news</AppButton>
      </GlassCard>

      <GlassCard v-else-if="post" :hover="false" class="post-page__card">
        <WordPressContent
          :title="post.title"
          :content="post.content"
          :featured-image="post.featuredImage?.node?.sourceUrl"
          :date="post.date"
        />
      </GlassCard>
    </Reveal>
  </PageShell>
</template>

<script setup lang="ts">
import type { WordPressPost } from '~/types/wordpress'

definePageMeta({
  middleware: 'auth'
})

const route = useRoute()
const config = useRuntimeConfig()
const siteUrl = ((config.public.siteUrl as string) || 'https://stellarpossible.com').replace(/\/$/, '')

const slug = computed(() => route.params.slug as string)

const { data: post, pending, error: fetchError } = await useFetch<WordPressPost>(
  () => `/api/posts/${slug.value}`,
  { watch: [slug] }
)

const errorMessage = computed(() => {
  const status = (fetchError.value as { statusCode?: number })?.statusCode
  if (status === 404) {
    return 'This post could not be found.'
  }
  return 'Unable to load this post. Please try again later.'
})

function stripHtml(html: string): string {
  return html.replace(/<[^>]*>/g, ' ').replace(/\s+/g, ' ').trim()
}

watch(
  post,
  (value) => {
    if (!value) return

    const description = stripHtml(value.excerpt || value.content).slice(0, 160)
    const image = value.featuredImage?.node?.sourceUrl

    useSeo({
      title: `${value.title} | StellarPossible`,
      description,
      path: `/posts/${value.slug}`,
      image,
      jsonLd: {
        '@context': 'https://schema.org',
        '@type': 'BlogPosting',
        headline: value.title,
        description,
        datePublished: value.date,
        url: `${siteUrl}/posts/${value.slug}`,
        image: image ? [image] : undefined,
        publisher: {
          '@type': 'Organization',
          name: 'StellarPossible',
          url: siteUrl
        }
      }
    })
  },
  { immediate: true }
)
</script>

<style scoped lang="scss">
.post-page {
  padding-bottom: var(--space-16);
}

.post-page__nav {
  margin-bottom: var(--space-6);
}

.post-page__card {
  padding: 0 !important;
  overflow: hidden;
}

.post-page__error {
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--space-4);
}

.post-page__status {
  text-align: center;
  font-size: var(--fs-300);
  color: var(--color-text-muted);
  margin: var(--space-8) 0;
}

.post-page__status--error {
  color: var(--color-warning);
  margin: 0;
}
</style>
