<template>
  <section
    :id="id"
    class="section-shell"
    :class="{ 'section-shell--narrow': narrow }"
  >
    <slot />
  </section>
</template>

<script setup lang="ts">
defineProps<{
  id?: string
  narrow?: boolean
}>()
</script>

<style scoped lang="scss">
.section-shell {
  width: 100%;
  max-width: var(--content-max);
  margin-inline: auto;
  padding-top: var(--section-py);
  padding-bottom: var(--section-py);
  padding-left: max(var(--space-6), env(safe-area-inset-left, 0px));
  padding-right: max(var(--space-6), env(safe-area-inset-right, 0px));
  box-sizing: border-box;
  min-width: 0;
}

.section-shell--narrow {
  max-width: var(--content-narrow);
}

@media (max-width: 768px) {
  .section-shell {
    padding-inline: max(var(--space-4), env(safe-area-inset-left, 0px)) max(var(--space-4), env(safe-area-inset-right, 0px));
  }
}
</style>
