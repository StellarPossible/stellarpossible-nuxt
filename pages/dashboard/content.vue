<template>
  <div class="dashboard-content-page dashboard-page">
    <header class="page-hero">
      <h1>Content</h1>
      <p>Manage your site content</p>
    </header>

    <section class="dashboard-card content-card">
      <h2 class="card-title">
        <Icon icon="mdi:file-document" class="card-icon" />
        Content manager
      </h2>
      <p class="content-desc">Edit pages, posts, and media in the CMS.</p>
      <a
        :href="cmsAdminUrl"
        target="_blank"
        rel="noopener noreferrer"
        class="content-cta"
      >
        <Icon icon="mdi:open-in-new" />
        Open content manager
      </a>
    </section>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: ['auth', 'admin']
})

const config = useRuntimeConfig()
const wpRest = (config.public.wpRestEndpoint as string) || ''
const cmsAdminUrl = computed(() => {
  if (!wpRest) return 'https://stellarpossible.com/cms/wp-admin'
  try {
    const url = new URL(wpRest)
    return `${url.origin}/wp-admin`
  } catch {
    return 'https://stellarpossible.com/cms/wp-admin'
  }
})

useHead({
  title: 'Content | Dashboard | StellarPossible',
  meta: [{ name: 'description', content: 'Manage site content.' }]
})
</script>

<style scoped lang="scss">
.content-card {
  max-width: 480px;
  padding: 2rem;
}

.content-desc {
  margin: 0 0 1.25rem;
  font-size: 0.95rem;
  color: #495057;
  line-height: 1.5;
}
</style>
