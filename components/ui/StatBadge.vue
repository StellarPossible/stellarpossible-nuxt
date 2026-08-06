<template>
  <span class="stat-badge">
    <span v-if="value" class="stat-badge__value">{{ value }}</span>
    <span class="stat-badge__label">{{ label }}</span>
  </span>
</template>

<script setup lang="ts">
defineProps<{
  value?: string
  label: string
}>()
</script>

<style scoped lang="scss">
.stat-badge {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--space-1);
  padding: var(--space-4) var(--space-6);
  background: var(--color-glass-solid);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  backdrop-filter: blur(12px);
  min-width: 7rem;
}

.stat-badge__value {
  font-family: var(--font-display);
  font-size: var(--fs-500);
  font-weight: 600;
  color: var(--color-accent);
  line-height: 1;
}

.stat-badge__label {
  font-family: var(--font-ui);
  font-size: var(--fs-100);
  color: var(--color-text-muted);
  text-align: center;
  line-height: 1.3;
}

@media (max-width: 480px) {
  .stat-badge {
    min-width: 0;
    width: 100%;
    padding: var(--space-3) var(--space-4);
  }

  .stat-badge__value {
    font-size: var(--fs-400);
  }
}
</style>
