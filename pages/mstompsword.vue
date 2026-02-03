<template>
  <section class="arc-page">
    <div class="arc-inner">
      <div class="arc-main">
        <div class="arc-brand">
          <h1 class="arc-title">ARC Readers</h1>
          <p class="arc-tagline">Free eBook pre-release in exchange for an honest Amazon review.</p>
        </div>
        <div class="arc-feature">
          <span class="arc-feature-book">The Scent of Lies</span>
          <span class="arc-feature-date">Feb 28</span>
          <a
            :href="amazonBookUrl"
            target="_blank"
            rel="noopener noreferrer"
            class="arc-cta-preorder"
          >
            Pre-order
            <ClientOnly>
              <Icon icon="mdi:open-in-new" aria-hidden />
              <template #fallback><span aria-hidden>↗</span></template>
            </ClientOnly>
          </a>
        </div>
      </div>

      <a
        :href="amazonBookUrl"
        target="_blank"
        rel="noopener noreferrer"
        class="arc-preview"
      >
        <img
          src="/images/media/ScentOfLiesAmazonCover.png"
          alt="The Scent of Lies — Aurora Peak Mystery Book 1"
          class="arc-preview-cover"
          width="140"
          height="210"
        />
        <div class="arc-preview-info">
          <span class="arc-preview-title">The Scent of Lies</span>
          <span class="arc-preview-subtitle">Aurora Peak Mystery Book 1</span>
          <span class="arc-preview-date">Feb 28</span>
          <span class="arc-preview-cta">Pre-order on Amazon</span>
        </div>
      </a>

      <div class="arc-form-wrap">
        <form class="arc-form" @submit.prevent="submit">
          <div class="arc-fields">
            <input
              id="arc-name"
              v-model="form.name"
              type="text"
              required
              placeholder="Name"
              autocomplete="name"
            />
            <input
              id="arc-email"
              v-model="form.email"
              type="email"
              required
              placeholder="Email"
              autocomplete="email"
            />
          </div>
          <div class="arc-checkboxes">
            <label class="arc-cb">
              <input v-model="form.agreedToReview" type="checkbox" required name="agreedToReview" />
              <span>I’ll leave an honest review on Amazon.</span>
            </label>
            <label class="arc-cb">
              <input v-model="form.signupForUpdates" type="checkbox" name="signupForUpdates" />
              <span>Latest from M Stompsword + more free ARCs.</span>
            </label>
          </div>
          <button type="submit" class="arc-submit" :disabled="loading">
            {{ loading ? '…' : 'Get free pre-release' }}
          </button>
          <p v-if="error" class="arc-msg arc-error">{{ error }}</p>
          <p v-else-if="success" class="arc-msg arc-success">You’re on the list. Check {{ successEmail }}.</p>
        </form>
      </div>
    </div>

    <nav class="arc-footer">
      <CrossNav variant="inline" />
    </nav>
  </section>
</template>

<script setup lang="ts">
const amazonBookUrl = 'https://a.co/d/0eZgZ2OC'

const form = reactive({
  name: '',
  email: '',
  agreedToReview: false,
  signupForUpdates: true
})

const loading = ref(false)
const error = ref('')
const success = ref(false)
const successEmail = ref('')

async function submit() {
  error.value = ''
  success.value = false
  loading.value = true
  try {
    await $fetch('/api/arc-signup', {
      method: 'POST',
      body: {
        name: form.name,
        email: form.email,
        agreedToReview: form.agreedToReview,
        signupForUpdates: form.signupForUpdates
      }
    })
    successEmail.value = form.email
    success.value = true
    form.name = ''
    form.email = ''
    form.agreedToReview = false
    form.signupForUpdates = true
  } catch (e: any) {
    error.value = e?.data?.statusMessage || e?.message || 'Something went wrong. Try again.'
  } finally {
    loading.value = false
  }
}

useHead({
  title: 'ARC Readers | The Scent of Lies | mstompsword | StellarPossible',
  meta: [
    {
      name: 'description',
      content: 'The Scent of Lies releases February 28th. Sign up as an ARC reader to receive the eBook pre-release for free in exchange for an honest Amazon review.'
    }
  ]
})
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.arc-page {
  --arc-available: calc(100vh - var(--site-header-height, 5rem));
  min-height: var(--arc-available);
  height: var(--arc-available);
  max-height: var(--arc-available);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  padding: 0 1rem;
  padding-top: max(0.5rem, env(safe-area-inset-top));
  padding-bottom: max(0.5rem, env(safe-area-inset-bottom));
  color: #fff;
  box-sizing: border-box;
}

.arc-inner {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  justify-content: center;
  align-items: center;
  max-width: 42rem;
  margin: 0 auto;
  width: 100%;
}

@media (min-width: 640px) {
  .arc-inner {
    flex-direction: row;
    flex-wrap: wrap;
    align-items: center;
    gap: 1rem 1.5rem;
    justify-content: center;
  }
}

.arc-main {
  flex-shrink: 0;
  min-width: 0;
  text-align: center;
}

@media (min-width: 640px) {
  .arc-main {
    text-align: left;
  }
}

.arc-title {
  font-size: clamp(1.5rem, 3.5vw, 1.75rem);
  font-weight: 700;
  color: #fff;
  margin: 0 0 0.25rem;
  letter-spacing: -0.02em;
}

.arc-tagline {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.88);
  margin: 0 0 0.75rem;
  line-height: 1.35;
}

.arc-feature {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.5rem 0.75rem;
  justify-content: center;
}

@media (min-width: 640px) {
  .arc-feature {
    justify-content: flex-start;
  }
}

.arc-feature-book {
  font-size: 0.9375rem;
  font-weight: 600;
  color: #fff;
}

.arc-feature-date {
  font-size: 0.8125rem;
  color: rgba(255, 255, 255, 0.7);
}

.arc-cta-preorder {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.35rem 0.65rem;
  font-size: 0.8125rem;
  font-weight: 600;
  color: #123146;
  background: #fff;
  border-radius: 8px;
  text-decoration: none;
  transition: background 0.2s, transform 0.1s;
}

.arc-cta-preorder:hover {
  background: #f0f4f8;
  transform: translateY(-1px);
}

.arc-cta-preorder svg {
  font-size: 0.875rem;
}

.arc-preview {
  flex: 0 0 auto;
  min-width: 0;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.5rem 0.75rem;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.15);
  background: rgba(18, 49, 70, 0.5);
  text-decoration: none;
  color: inherit;
  transition: border-color 0.2s, background 0.2s, transform 0.15s;
}

.arc-preview:hover {
  border-color: rgba(255, 255, 255, 0.3);
  background: rgba(18, 49, 70, 0.65);
  transform: translateY(-2px);
}

.arc-preview-cover {
  display: block;
  width: 100%;
  height: auto;
  max-width: 100px;
  border-radius: 6px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.arc-preview-info {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
  min-width: 0;
}

.arc-preview-title {
  font-size: 0.9375rem;
  font-weight: 700;
  color: #fff;
}

.arc-preview-subtitle {
  font-size: 0.6875rem;
  color: rgba(255, 255, 255, 0.7);
}

.arc-preview-date {
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.85);
}

.arc-preview-cta {
  font-size: 0.75rem;
  font-weight: 600;
  color: #fff;
  margin-top: 0.25rem;
  text-decoration: underline;
  text-underline-offset: 2px;
}

.arc-form-wrap {
  flex: 0 0 auto;
  width: 100%;
  max-width: 20rem;
}

.arc-form {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.arc-fields {
  display: flex;
  gap: 0.5rem;
}

.arc-fields input {
  flex: 1;
  min-width: 0;
  padding: 0.45rem 0.6rem;
  font-size: 0.875rem;
  border: 1px solid rgba(255, 255, 255, 0.25);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.08);
  color: #fff;
  transition: border-color 0.2s, background 0.2s;
}

.arc-fields input::placeholder {
  color: rgba(255, 255, 255, 0.45);
}

.arc-fields input:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.5);
  background: rgba(255, 255, 255, 0.12);
}

.arc-checkboxes {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.arc-cb {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  cursor: pointer;
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.88);
  line-height: 1.3;
}

.arc-cb input {
  flex-shrink: 0;
  width: 0.9375rem;
  height: 0.9375rem;
  margin: 0;
  accent-color: $primary-light;
}

.arc-submit {
  padding: 0.6rem 1rem;
  font-size: 0.9375rem;
  font-weight: 600;
  color: #123146;
  background: #fff;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s, transform 0.1s;
  margin-top: 0.25rem;
}

.arc-submit:hover:not(:disabled) {
  background: #f0f4f8;
  transform: translateY(-1px);
}

.arc-submit:disabled {
  opacity: 0.8;
  cursor: not-allowed;
}

.arc-msg {
  font-size: 0.75rem;
  margin: 0;
}

.arc-error {
  color: #faa;
}

.arc-success {
  color: #afa;
}

.arc-footer {
  flex-shrink: 0;
  padding: 0.5rem 0 0;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}
</style>
