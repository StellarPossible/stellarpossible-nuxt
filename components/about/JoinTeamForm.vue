<template>
  <GlassCard :hover="false" :pad="false" class="join-team">
    <div class="join-team__header">
      <span class="join-team__badge">Open role</span>
      <div class="join-team__icon-wrap" aria-hidden="true">
        <Icon icon="mdi:account-plus" class="join-team__icon" />
      </div>
      <h2 class="join-team__title">Join StellarPossible</h2>
      <p class="join-team__lead">Interested in building with us? Share a brief note and your resume — we read every application.</p>
    </div>

    <form class="join-team__form" @submit.prevent="onSubmit" novalidate>
      <FormField
        v-model="form.name"
        label="Name"
        name="name"
        required
        :disabled="submitting"
      />
      <FormField
        v-model="form.email"
        label="Email"
        name="email"
        type="email"
        required
        :disabled="submitting"
      />
      <FormField
        v-model="form.message"
        label="Brief message"
        name="message"
        multiline
        :rows="4"
        required
        :disabled="submitting"
        hint="Tell us about your skills and what you're looking for."
      />

      <div class="file-field">
        <span class="file-field__label">Resume</span>
        <label class="file-field__drop" :class="{ 'file-field__drop--has-file': !!fileName, 'file-field__drop--disabled': submitting }">
          <input
            ref="fileInput"
            type="file"
            name="resume"
            accept=".pdf,.doc,.docx,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            required
            :disabled="submitting"
            class="file-field__input"
            @change="onFileChange"
          />
          <Icon icon="mdi:file-upload-outline" class="file-field__drop-icon" aria-hidden="true" />
          <span v-if="fileName" class="file-field__drop-text">{{ fileName }}</span>
          <span v-else class="file-field__drop-text">Drop your resume or <strong>browse files</strong></span>
          <span class="file-field__hint">PDF, DOC, or DOCX — max 5 MB</span>
        </label>
      </div>

      <p v-if="error" class="form-message form-message--error" role="alert">{{ error }}</p>
      <p v-if="success" class="form-message form-message--success">Thanks — we'll review your application.</p>

      <div class="join-team__actions">
        <AppButton type="submit" variant="primary" size="lg" :disabled="submitting || !isValid" block>
          {{ submitting ? 'Sending…' : 'Submit application' }}
        </AppButton>
      </div>
    </form>
  </GlassCard>
</template>

<script setup lang="ts">
const MAX_BYTES = 5 * 1024 * 1024
const ALLOWED_EXT = ['.pdf', '.doc', '.docx']

const form = reactive({
  name: '',
  email: '',
  message: ''
})

const fileInput = ref<HTMLInputElement | null>(null)
const resumeFile = ref<File | null>(null)
const fileName = ref('')
const submitting = ref(false)
const success = ref(false)
const error = ref('')

const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
const isValid = computed(
  () => !!form.name.trim() && emailRegex.test(form.email.trim()) && !!form.message.trim() && !!resumeFile.value
)

function onFileChange(e: Event) {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0] ?? null
  resumeFile.value = file
  fileName.value = file?.name ?? ''
  error.value = ''
}

function validateFile(file: File): string | null {
  const ext = file.name.toLowerCase().slice(file.name.lastIndexOf('.'))
  if (!ALLOWED_EXT.includes(ext)) {
    return 'Resume must be a PDF, DOC, or DOCX file.'
  }
  if (file.size > MAX_BYTES) {
    return 'Resume must be 5 MB or smaller.'
  }
  return null
}

async function onSubmit() {
  error.value = ''
  success.value = false

  if (!isValid.value || !resumeFile.value) {
    error.value = 'Please fill all fields and attach a resume.'
    return
  }

  const fileError = validateFile(resumeFile.value)
  if (fileError) {
    error.value = fileError
    return
  }

  submitting.value = true
  try {
    const body = new FormData()
    body.append('name', form.name.trim())
    body.append('email', form.email.trim())
    body.append('message', form.message.trim())
    body.append('resume', resumeFile.value)

    await $fetch('/api/careers/apply', { method: 'POST', body })

    success.value = true
    form.name = ''
    form.email = ''
    form.message = ''
    resumeFile.value = null
    fileName.value = ''
    if (fileInput.value) fileInput.value.value = ''
  } catch (e: unknown) {
    const err = e as { data?: { message?: string; statusMessage?: string } }
    error.value = err?.data?.message || err?.data?.statusMessage || 'Failed to send application. Please try again.'
  } finally {
    submitting.value = false
  }
}
</script>

<style scoped lang="scss">
.join-team {
  display: flex;
  flex-direction: column;
  height: 100%;
  padding: var(--space-8);
  border-color: var(--color-border);
}

.join-team__header {
  text-align: center;
  margin-bottom: var(--space-8);
  padding-bottom: var(--space-6);
  border-bottom: 1px solid var(--color-border);
}

.join-team__badge {
  display: inline-block;
  font-family: var(--font-ui);
  font-size: var(--fs-100);
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-gold);
  background: var(--color-gold-soft);
  border: 1px solid var(--color-gold-border);
  border-radius: var(--radius-pill);
  padding: var(--space-1) var(--space-3);
  margin-bottom: var(--space-4);
}

.join-team__icon-wrap {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 3rem;
  height: 3rem;
  margin-bottom: var(--space-4);
  border-radius: 50%;
  background: var(--color-accent-soft);
  border: 1px solid var(--color-border);
  box-shadow: var(--shadow-glow);
}

.join-team__icon {
  font-size: 1.5rem;
  color: var(--color-accent);
}

.join-team__title {
  font-family: var(--font-display);
  font-size: var(--fs-500);
  font-weight: 500;
  margin: 0 0 var(--space-3);
  line-height: 1.2;
  letter-spacing: -0.01em;
}

.join-team__lead {
  font-size: var(--fs-200);
  color: var(--color-text-muted);
  margin: 0;
  line-height: 1.6;
  max-width: 22rem;
  margin-inline: auto;
}

.join-team__form {
  display: grid;
  gap: var(--space-1);

  :deep(.form-field__label) {
    letter-spacing: 0.06em;
    font-size: 0.6875rem;
    color: var(--color-text-subtle);
  }

  :deep(.form-field__input) {
    background: rgba(255, 255, 255, 0.04);
    border-radius: var(--radius-md);
  }
}

.file-field {
  display: grid;
  gap: var(--space-2);
  margin-bottom: var(--space-2);
}

.file-field__label {
  font-family: var(--font-ui);
  font-size: 0.6875rem;
  font-weight: 600;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: var(--color-text-subtle);
}

.file-field__drop {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: var(--space-2);
  padding: var(--space-6) var(--space-4);
  text-align: center;
  border: 1px dashed var(--color-border-strong);
  border-radius: var(--radius-md);
  background: rgba(255, 255, 255, 0.03);
  cursor: pointer;
  transition:
    border-color var(--dur-med) var(--ease-out),
    background var(--dur-med) var(--ease-out),
    box-shadow var(--dur-med) var(--ease-out);

  &:hover:not(.file-field__drop--disabled) {
    border-color: var(--color-accent);
    background: var(--color-accent-soft);
    box-shadow: var(--shadow-glow);
  }

  &--has-file {
    border-style: solid;
    background: rgba(110, 231, 160, 0.06);
    border-color: rgba(110, 231, 160, 0.35);
  }

  &--disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }
}

.file-field__input {
  position: absolute;
  inset: 0;
  opacity: 0;
  cursor: pointer;
  width: 100%;
  height: 100%;

  &:disabled {
    cursor: not-allowed;
  }
}

.file-field__drop-icon {
  font-size: 1.75rem;
  color: var(--color-accent);
}

.file-field__drop-text {
  font-size: var(--fs-200);
  color: var(--color-text-muted);
  line-height: 1.4;

  strong {
    color: var(--color-accent);
    font-weight: 600;
  }
}

.file-field__hint {
  font-size: var(--fs-100);
  color: var(--color-text-subtle);
}

.form-message {
  margin: var(--space-2) 0;
  font-size: var(--fs-200);
  text-align: center;
}

.form-message--error {
  color: var(--color-error);
}

.form-message--success {
  color: var(--color-success);
}

.join-team__actions {
  padding-top: var(--space-4);
  margin-top: var(--space-2);
  border-top: 1px solid var(--color-border);
}

@media (max-width: 480px) {
  .join-team {
    padding: var(--space-6);
  }

  .join-team__header {
    margin-bottom: var(--space-6);
    padding-bottom: var(--space-5);
  }
}
</style>
