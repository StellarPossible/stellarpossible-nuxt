<template>
  <component
    :is="tag"
    :to="to"
    :href="href"
    :type="tag === 'button' ? type : undefined"
    :target="external ? '_blank' : undefined"
    :rel="external ? 'noopener noreferrer' : undefined"
    class="app-btn"
    :class="[`app-btn--${variant}`, `app-btn--${size}`, { 'app-btn--block': block }]"
    :disabled="disabled"
    @click="onClick"
  >
    <slot />
  </component>
</template>

<script setup lang="ts">
const props = withDefaults(
  defineProps<{
    variant?: 'primary' | 'secondary' | 'ghost' | 'accent'
    size?: 'sm' | 'md' | 'lg'
    to?: string
    href?: string
    external?: boolean
    type?: 'button' | 'submit' | 'reset'
    disabled?: boolean
    block?: boolean
  }>(),
  {
    variant: 'primary',
    size: 'md',
    type: 'button',
    disabled: false,
    block: false,
    external: false
  }
)

const emit = defineEmits<{ click: [Event] }>()

const tag = computed(() => {
  if (props.to) return resolveComponent('NuxtLink')
  if (props.href) return 'a'
  return 'button'
})

function onClick(e: Event) {
  if (!props.disabled) emit('click', e)
}
</script>

<style scoped lang="scss">
.app-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--space-2);
  font-family: var(--font-ui);
  font-weight: 600;
  text-decoration: none;
  border: none;
  cursor: pointer;
  border-radius: var(--radius-sm);
  transition:
    transform var(--dur-med) var(--ease-out),
    box-shadow var(--dur-med) var(--ease-out),
    background var(--dur-med) var(--ease-out),
    border-color var(--dur-med) var(--ease-out);
  box-sizing: border-box;
  max-width: 100%;
  white-space: nowrap;

  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }

  &:not(:disabled):hover {
    transform: translateY(-2px);
  }

  &:focus-visible {
    outline: 2px solid var(--color-accent);
    outline-offset: 2px;
  }
}

.app-btn--sm {
  padding: var(--space-2) var(--space-4);
  font-size: var(--fs-100);
}

.app-btn--md {
  padding: var(--space-3) var(--space-6);
  font-size: var(--fs-200);
}

.app-btn--lg {
  padding: var(--space-4) var(--space-8);
  font-size: var(--fs-300);
}

.app-btn--block {
  width: 100%;
}

.app-btn--primary {
  background: #fff;
  color: var(--color-panel);
  box-shadow: var(--shadow-sm);

  &:not(:disabled):hover {
    box-shadow: var(--shadow-glow);
  }
}

.app-btn--secondary {
  background: var(--color-glass-solid);
  color: var(--color-text);
  border: 1px solid var(--color-border);
  backdrop-filter: blur(12px);

  &:not(:disabled):hover {
    border-color: var(--color-border-strong);
    box-shadow: var(--shadow-glow);
  }
}

.app-btn--ghost {
  background: transparent;
  color: var(--color-text);
  border: 1px solid var(--color-border);

  &:not(:disabled):hover {
    background: var(--color-accent-soft);
    border-color: var(--color-border-strong);
  }
}

.app-btn--accent {
  background: linear-gradient(135deg, var(--color-accent) 0%, var(--color-aurora) 100%);
  color: #fff;
  box-shadow: var(--shadow-glow);

  &:not(:disabled):hover {
    box-shadow: var(--shadow-glow-strong);
  }
}

@media (hover: none) and (pointer: coarse) {
  .app-btn {
    min-height: 44px;
  }

  .app-btn--block {
    white-space: normal;
    text-align: center;
  }
}
</style>
