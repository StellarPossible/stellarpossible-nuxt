<template>
  <label class="form-field" :class="{ 'form-field--error': !!error }">
    <span v-if="label" class="form-field__label">{{ label }}</span>
    <div class="form-field__control" :class="{ 'form-field__control--suffix': !!$slots.suffix }">
      <component
        :is="multiline ? 'textarea' : 'input'"
        :id="inputId"
        :value="modelValue"
        :type="multiline ? undefined : type"
        :placeholder="placeholder"
        :required="required"
        :disabled="disabled"
        :autocomplete="autocomplete"
        :name="name"
        :minlength="minlength"
        :rows="multiline ? rows : undefined"
        class="form-field__input"
        @input="onInput"
        @blur="$emit('blur')"
        @focus="$emit('focus')"
      />
      <slot name="suffix" />
    </div>
    <p v-if="error" class="form-field__error" role="alert">{{ error }}</p>
    <p v-else-if="hint" class="form-field__hint">{{ hint }}</p>
  </label>
</template>

<script setup lang="ts">
const props = withDefaults(
  defineProps<{
    modelValue?: string
    label?: string
    placeholder?: string
    type?: string
    name?: string
    autocomplete?: string
    required?: boolean
    disabled?: boolean
    error?: string
    hint?: string
    minlength?: number
    multiline?: boolean
    rows?: number
    id?: string
  }>(),
  {
    type: 'text',
    required: false,
    disabled: false,
    multiline: false,
    rows: 5
  }
)

const emit = defineEmits<{
  'update:modelValue': [string]
  blur: []
  focus: []
}>()

const inputId = computed(() => props.id || props.name || `field-${Math.random().toString(36).slice(2, 9)}`)

function onInput(e: Event) {
  const target = e.target as HTMLInputElement | HTMLTextAreaElement
  emit('update:modelValue', target.value)
}
</script>

<style scoped lang="scss">
.form-field {
  display: grid;
  gap: var(--space-2);
  margin-bottom: var(--space-4);
}

.form-field__label {
  font-family: var(--font-ui);
  font-size: var(--fs-100);
  font-weight: 600;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--color-text-muted);
}

.form-field__control {
  position: relative;
  display: flex;
  align-items: stretch;
}

.form-field__control--suffix .form-field__input {
  padding-right: 2.75rem;
}

.form-field__input {
  width: 100%;
  padding: var(--space-3) var(--space-4);
  font-family: var(--font-body);
  font-size: var(--fs-200);
  color: var(--color-text);
  background: rgba(255, 255, 255, 0.06);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  transition:
    border-color var(--dur-med) var(--ease-out),
    box-shadow var(--dur-med) var(--ease-out);

  &::placeholder {
    color: var(--color-text-subtle);
  }

  &:focus {
    outline: none;
    border-color: var(--color-border-strong);
    box-shadow: 0 0 0 3px var(--color-accent-soft);
  }

  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }
}

textarea.form-field__input {
  min-height: 7rem;
  resize: vertical;
}

.form-field--error .form-field__input {
  border-color: rgba(255, 107, 107, 0.6);
}

.form-field__error {
  margin: 0;
  font-size: var(--fs-100);
  color: #ff8a8a;
}

.form-field__hint {
  margin: 0;
  font-size: var(--fs-100);
  color: var(--color-text-subtle);
}

@media (max-width: 480px) {
  .form-field__input {
    font-size: 16px;
  }
}
</style>
