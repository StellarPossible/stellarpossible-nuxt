<template>
  <div class="arc-signup">
    <div v-if="book" class="arc-featured">
      <a
        :href="book.amazonUrl"
        target="_blank"
        rel="noopener noreferrer"
        class="arc-preview"
      >
        <img
          v-if="book.coverSrc"
          :src="book.coverSrc"
          :alt="book.coverAlt || `${book.title} by Marine Stompsword`"
          class="arc-preview-cover"
          width="140"
          height="210"
        />
        <div v-else class="arc-preview-placeholder" aria-hidden="true">{{ book.title }}</div>
        <div class="arc-preview-info">
          <span class="arc-preview-title">{{ book.title }}</span>
          <span v-if="formatSeriesLabel(book)" class="arc-preview-subtitle">{{ formatSeriesLabel(book) }}</span>
          <span v-if="book.releaseDate" class="arc-preview-date">{{ book.releaseDate }}</span>
          <span class="arc-preview-cta">{{ getAmazonCtaLabel(book.status) }}</span>
        </div>
      </a>
    </div>

    <form class="author-form" @submit.prevent="submit">
      <div class="author-fields">
        <FormField
          id="arc-name"
          v-model="form.name"
          placeholder="Name"
          autocomplete="name"
          required
        />
        <FormField
          id="arc-email"
          v-model="form.email"
          type="email"
          placeholder="Email"
          autocomplete="email"
          required
        />
      </div>
      <div class="arc-checkboxes">
        <label class="arc-cb">
          <input v-model="form.agreedToReview" type="checkbox" required name="agreedToReview" />
          <span>I'll leave an honest review on Amazon.</span>
        </label>
        <label class="arc-cb">
          <input v-model="form.signupForUpdates" type="checkbox" name="signupForUpdates" />
          <span>Latest from Marine Stompsword + more free ARCs.</span>
        </label>
      </div>
      <AppButton type="submit" variant="primary" block :disabled="loading">
        {{ loading ? '…' : 'Get free pre-release' }}
      </AppButton>
      <p v-if="error" class="author-msg author-msg--error">{{ error }}</p>
      <p v-else-if="success" class="author-msg author-msg--success">You're on the list. Check {{ successEmail }}.</p>
    </form>
  </div>
</template>

<script setup lang="ts">
import {
  formatSeriesLabel,
  getAmazonCtaLabel,
  type AuthorBookDisplay
} from '~/data/author-books'

const props = defineProps<{
  book: AuthorBookDisplay
}>()

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
        signupForUpdates: form.signupForUpdates,
        bookId: props.book.id
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
</script>

<style scoped lang="scss">
.arc-signup {
  display: flex;
  flex-direction: column;
  gap: var(--space-5);
  width: 100%;
}

@media (min-width: 640px) {
  .arc-signup {
    flex-direction: row;
    flex-wrap: wrap;
    align-items: flex-start;
    gap: var(--space-6);
  }
}

.arc-featured {
  flex: 0 0 auto;
}

.arc-preview {
  display: flex;
  align-items: center;
  gap: var(--space-4);
  padding: var(--space-3) var(--space-4);
  border-radius: var(--radius-md);
  border: 1px solid var(--color-border);
  background: var(--color-glass-solid);
  text-decoration: none;
  color: inherit;
  transition:
    border-color var(--dur-med) var(--ease-out),
    box-shadow var(--dur-med) var(--ease-out),
    transform var(--dur-med) var(--ease-out);

  &:hover {
    border-color: var(--color-border-strong);
    box-shadow: var(--shadow-glow);
    transform: translateY(-2px);
  }

  &:focus-visible {
    outline: 2px solid var(--color-accent);
    outline-offset: 2px;
  }
}

.arc-preview-cover {
  display: block;
  width: 100%;
  height: auto;
  max-width: 100px;
  border-radius: var(--radius-sm);
  box-shadow: var(--shadow-sm);
}

.arc-preview-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 5rem;
  min-height: 7.5rem;
  padding: var(--space-2);
  border-radius: var(--radius-sm);
  background: var(--color-accent-soft);
  font-size: var(--fs-100);
  font-weight: 600;
  text-align: center;
  line-height: 1.3;
}

.arc-preview-info {
  display: flex;
  flex-direction: column;
  gap: var(--space-1);
  min-width: 0;
}

.arc-preview-title {
  font-size: var(--fs-200);
  font-weight: 700;
  color: var(--color-text);
}

.arc-preview-subtitle {
  font-size: var(--fs-100);
  color: var(--color-text-muted);
}

.arc-preview-date {
  font-size: var(--fs-100);
  color: var(--color-text-muted);
}

.arc-preview-cta {
  font-size: var(--fs-100);
  font-weight: 600;
  color: var(--color-accent);
  margin-top: var(--space-1);
  text-decoration: underline;
  text-underline-offset: 2px;
}

.author-form {
  flex: 1;
  min-width: 0;
  max-width: 22rem;
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
}

.author-fields {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-3);

  :deep(.form-field) {
    margin-bottom: 0;
  }
}

.arc-checkboxes {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
}

.arc-cb {
  display: flex;
  align-items: flex-start;
  gap: var(--space-2);
  cursor: pointer;
  font-size: var(--fs-100);
  color: var(--color-text-muted);
  line-height: 1.4;

  input {
    flex-shrink: 0;
    width: 1rem;
    height: 1rem;
    margin-top: 0.1rem;
    accent-color: var(--color-accent);
  }
}

.author-msg {
  font-size: var(--fs-100);
  margin: 0;
  text-align: center;
}

.author-msg--error {
  color: #ff8a8a;
}

.author-msg--success {
  color: #6ee7a0;
}

@media (max-width: 480px) {
  .author-fields {
    grid-template-columns: 1fr;
  }
}
</style>
