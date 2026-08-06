<template>
  <form class="author-form" @submit.prevent="submit">
    <div class="author-fields">
      <FormField
        id="newsletter-name"
        v-model="form.name"
        placeholder="Name"
        autocomplete="name"
        required
      />
      <FormField
        id="newsletter-email"
        v-model="form.email"
        type="email"
        placeholder="Email"
        autocomplete="email"
        required
      />
    </div>
    <AppButton type="submit" variant="primary" block :disabled="loading">
      {{ loading ? '…' : 'Join the mailing list' }}
    </AppButton>
    <p v-if="error" class="author-msg author-msg--error">{{ error }}</p>
    <p v-else-if="success" class="author-msg author-msg--success">You're subscribed. Check {{ successEmail }}.</p>
  </form>
</template>

<script setup lang="ts">
const form = reactive({
  name: '',
  email: ''
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
    await $fetch('/api/newsletter-signup', {
      method: 'POST',
      body: {
        name: form.name,
        email: form.email
      }
    })
    successEmail.value = form.email
    success.value = true
    form.name = ''
    form.email = ''
  } catch (e: any) {
    error.value = e?.data?.statusMessage || e?.message || 'Something went wrong. Try again.'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped lang="scss">
.author-form {
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
  width: 100%;
}

.author-fields {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-3);

  :deep(.form-field) {
    margin-bottom: 0;
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
