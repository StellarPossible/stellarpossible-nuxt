<template>
  <div class="page-shell" :class="{ 'page-shell--narrow': narrow, 'page-shell--flush-top': flushTop }">
    <slot />
  </div>
</template>

<script setup lang="ts">
withDefaults(
  defineProps<{
    narrow?: boolean
    flushTop?: boolean
  }>(),
  {
    narrow: false,
    flushTop: false
  }
)
</script>

<style scoped lang="scss">
.page-shell {
  flex: 1;
  width: 100%;
  max-width: var(--content-max);
  margin-inline: auto;
  padding-top: var(--space-2);
  padding-bottom: var(--space-12);
  padding-inline: max(var(--space-4), env(safe-area-inset-left, 0px)) max(var(--space-4), env(safe-area-inset-right, 0px));
  box-sizing: border-box;
}

@media (min-width: 769px) {
  .page-shell {
    padding-top: var(--space-3);
  }
}

@media (max-width: 768px) {
  .page-shell {
    padding-top: var(--space-2);
    padding-bottom: var(--space-8);
  }
}

.page-shell--narrow {
  max-width: var(--content-narrow);
}

.page-shell--flush-top {
  padding-top: 0;
}
</style>
