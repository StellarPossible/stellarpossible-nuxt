<template>
  <Teleport to="body">
    <div
      v-if="isOpen"
      class="modal-overlay"
      :class="{ 'theme-light': theme === 'light', 'theme-dark': theme === 'dark' }"
      @click.self="onClose"
      role="dialog"
      aria-modal="true"
      aria-labelledby="contact-title"
    >
      <GlassCard class="modal" :hover="false" :pad="false">
        <header class="modal-header">
          <h2 id="contact-title" class="modal-title">Contact Us</h2>
          <button type="button" class="icon-btn" aria-label="Close" @click="onClose">
            <Icon icon="mdi:close" aria-hidden="true" />
          </button>
        </header>

        <form class="modal-body" @submit.prevent="onSubmit" novalidate>
          <FormField
            v-model="form.name"
            label="Name"
            type="text"
            required
            :disabled="submitting"
          />
          <FormField
            v-model="form.email"
            label="Email"
            type="email"
            required
            :disabled="submitting"
          />
          <FormField
            v-model="form.subject"
            label="Subject"
            type="text"
            :disabled="submitting"
          />
          <FormField
            v-model="form.message"
            label="Message"
            multiline
            :rows="5"
            required
            :disabled="submitting"
          />

          <p v-if="error" class="form-message form-message--error" role="alert">{{ error }}</p>

          <footer class="modal-footer">
            <AppButton type="button" variant="ghost" :disabled="submitting" @click="onClose">
              Cancel
            </AppButton>
            <AppButton type="submit" variant="primary" :disabled="submitting || !isValid">
              {{ submitting ? 'Sending…' : 'Send' }}
            </AppButton>
          </footer>
        </form>
      </GlassCard>
    </div>
  </Teleport>
</template>

<script setup lang="ts">
import { onMounted, onBeforeUnmount } from 'vue'
import type { User } from '~/types/auth'

const { isOpen, close, initialSubject, initialMessage } = useContactModal()
const { theme } = useTheme()
const user = useState<User | null>('auth.user')

const form = reactive({
  name: '',
  email: '',
  subject: '',
  message: ''
})

const submitting = ref(false)
const error = ref('')

watch(isOpen, (open) => {
  if (!open) return
  if (user.value && !form.name && !form.email) {
    form.name = user.value.name || user.value.username
    form.email = user.value.email
  }
  form.subject = initialSubject.value ?? ''
  form.message = initialMessage.value ?? ''
})

const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
const isValid = computed(() => !!form.name && emailRegex.test(form.email) && !!form.message)

function resetForm() {
  form.name = ''
  form.email = ''
  form.subject = ''
  form.message = ''
}

function onClose() {
  close()
  setTimeout(() => {
    error.value = ''
    submitting.value = false
    resetForm()
  }, 150)
}

async function onSubmit() {
  error.value = ''
  if (!isValid.value) {
    error.value = 'Please fill all required fields with a valid email.'
    return
  }
  submitting.value = true
  try {
    await $fetch('/api/contact', {
      method: 'POST',
      body: { ...form }
    })
    onClose()
  } catch (e: any) {
    error.value = e?.data?.message || 'Failed to send message. Please try again.'
  } finally {
    submitting.value = false
  }
}

function onKeydown(e: KeyboardEvent) {
  if (e.key === 'Escape' && isOpen.value) onClose()
}
onMounted(() => window.addEventListener('keydown', onKeydown))
onBeforeUnmount(() => window.removeEventListener('keydown', onKeydown))
</script>

<style scoped lang="scss">
.modal-overlay {
  position: fixed;
  inset: 0;
  padding: max(0.75rem, env(safe-area-inset-top))
    max(0.75rem, env(safe-area-inset-right))
    max(0.75rem, env(safe-area-inset-bottom))
    max(0.75rem, env(safe-area-inset-left));
  background: var(--color-overlay);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow-y: auto;
  z-index: 4000;
}

.modal {
  width: min(680px, 100%);
  max-width: 100%;
  max-height: min(90dvh, calc(100vh - env(safe-area-inset-top) - env(safe-area-inset-bottom) - 1.5rem));
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--space-5) var(--space-6);
  border-bottom: 1px solid var(--color-border);
}

.modal-title {
  font-family: var(--font-display);
  font-size: var(--fs-500);
  font-weight: 500;
  margin: 0;
}

.icon-btn {
  background: transparent;
  border: 1px solid var(--color-border);
  color: var(--color-text);
  width: 2.75rem;
  height: 2.75rem;
  min-width: 44px;
  min-height: 44px;
  border-radius: 50%;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  transition:
    background var(--dur-med) var(--ease-out),
    border-color var(--dur-med) var(--ease-out);

  &:hover {
    background: var(--color-accent-soft);
    border-color: var(--color-border-strong);
  }

  &:focus-visible {
    outline: 2px solid var(--color-accent);
    outline-offset: 2px;
  }
}

.modal-body {
  display: grid;
  gap: var(--space-1);
  padding: var(--space-5) var(--space-6) var(--space-6);
  overflow-y: auto;
  flex: 1;
  min-height: 0;

  :deep(.form-field) {
    margin-bottom: var(--space-3);
  }
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  flex-wrap: wrap;
  gap: var(--space-3);
  margin-top: var(--space-4);
}

.form-message {
  margin: 0;
  font-size: var(--fs-200);
  text-align: center;
}

.form-message--error {
  color: var(--color-error);
}

@media (max-width: 520px) {
  .modal-header,
  .modal-body {
    padding-inline: var(--space-4);
  }
}
</style>
