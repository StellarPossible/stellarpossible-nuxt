<template>
  <div class="dashboard-content-page">
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
  middleware: 'auth'
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
.dashboard-content-page {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.page-hero {
  margin-bottom: 1.5rem;
  color: white;

  h1 {
    font-size: clamp(1.5rem, 2.5vw, 1.9rem);
    font-family: 'Evermore', 'Inter', sans-serif;
    margin: 0 0 0.35rem;
    font-weight: 400;
  }

  p {
    font-size: 0.95rem;
    opacity: 0.9;
    margin: 0;
  }
}

.content-card {
  max-width: 480px;
  padding: 2rem;
}

.card-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin: 0 0 0.75rem;
  font-size: 1rem;
  font-weight: 600;
  color: #1a1a2e;
}

.card-icon {
  width: 20px;
  height: 20px;
  color: #4c5fd5;
}

.content-desc {
  margin: 0 0 1.25rem;
  font-size: 0.95rem;
  color: #495057;
  line-height: 1.5;
}

.content-cta {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.65rem 1.1rem;
  font-size: 0.95rem;
  font-weight: 600;
  color: #fff;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 8px;
  text-decoration: none;
  transition: opacity 0.2s, transform 0.15s;

  &:hover {
    opacity: 0.95;
    transform: translateY(-1px);
  }

  :deep(svg) {
    width: 18px;
    height: 18px;
  }
}
</style>
