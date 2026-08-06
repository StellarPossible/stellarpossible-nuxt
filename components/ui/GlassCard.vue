<template>
  <component
    :is="tag"
    :to="to"
    :href="href"
    :target="external ? '_blank' : undefined"
    :rel="external ? 'noopener noreferrer' : undefined"
    class="glass-card"
    :class="{ 'glass-card--hover': hover, 'glass-card--pad': pad }"
  >
    <slot />
  </component>
</template>

<script setup lang="ts">
const props = withDefaults(
  defineProps<{
    to?: string
    href?: string
    external?: boolean
    hover?: boolean
    pad?: boolean
  }>(),
  { hover: true, pad: true, external: false }
)

const tag = computed(() => {
  if (props.to) return resolveComponent('NuxtLink')
  if (props.href) return 'a'
  return 'div'
})
</script>

<style scoped lang="scss">
.glass-card {
  display: block;
  background: var(--color-glass);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  box-shadow: var(--shadow-md);
  text-decoration: none;
  color: inherit;
  transition:
    transform var(--dur-med) var(--ease-out),
    box-shadow var(--dur-med) var(--ease-out),
    border-color var(--dur-med) var(--ease-out);
}

.glass-card--pad {
  padding: var(--space-6);
}

.glass-card--hover:hover {
  transform: translateY(-3px);
  border-color: var(--color-border-strong);
  box-shadow: var(--shadow-lg), var(--shadow-glow);
}

.glass-card:focus-visible {
  outline: 2px solid var(--color-accent);
  outline-offset: 2px;
}

@media (prefers-reduced-motion: reduce) {
  .glass-card,
  .glass-card--hover:hover {
    transform: none;
    transition: none;
  }
}
</style>
