<template>
  <PageShell narrow class="status-page">
    <Reveal>
      <GlassCard class="status-page__card" :hover="false">
        <div class="status-page__icon" :class="`status-page__icon--${variant}`" aria-hidden="true">
          <Icon :icon="iconName" />
        </div>
        <h1 class="status-page__title">{{ title }}</h1>
        <p class="status-page__message">{{ message }}</p>
        <div v-if="$slots.default" class="status-page__actions">
          <slot />
        </div>
      </GlassCard>
    </Reveal>
  </PageShell>
</template>

<script setup lang="ts">
const props = withDefaults(
  defineProps<{
    title: string
    message: string
    variant?: 'success' | 'cancel' | 'error' | 'info'
  }>(),
  { variant: 'info' }
)

const iconName = computed(() => {
  switch (props.variant) {
    case 'success':
      return 'mdi:check-circle'
    case 'cancel':
      return 'mdi:close-circle-outline'
    case 'error':
      return 'mdi:alert-circle'
    default:
      return 'mdi:information'
  }
})
</script>

<style scoped lang="scss">
.status-page {
  display: flex;
  align-items: center;
  min-height: calc(100vh - var(--site-header-height, 5rem) - var(--site-footer-height, 3rem));
  padding-bottom: var(--space-16);
}

.status-page__card {
  text-align: center;
  max-width: 36rem;
  margin-inline: auto;
  padding: clamp(var(--space-8), 5vw, var(--space-12)) !important;
}

.status-page__icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 4rem;
  height: 4rem;
  border-radius: 50%;
  margin-bottom: var(--space-5);
  font-size: 2rem;

  &--success {
    background: var(--color-success-soft);
    color: var(--color-success);
  }

  &--cancel {
    background: var(--color-warning-soft);
    color: var(--color-warning);
  }

  &--error {
    background: var(--color-error-soft);
    color: var(--color-error);
  }

  &--info {
    background: var(--color-accent-soft);
    color: var(--color-accent);
  }
}

.status-page__title {
  font-family: var(--font-display);
  font-size: var(--fs-600);
  font-weight: 500;
  margin: 0 0 var(--space-4);
  line-height: 1.15;
}

.status-page__message {
  font-size: var(--fs-300);
  color: var(--color-text-muted);
  line-height: 1.6;
  margin: 0;
  max-width: 32rem;
  margin-inline: auto;
}

.status-page__actions {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: var(--space-3);
  margin-top: var(--space-8);
}

@media (max-width: 480px) {
  .status-page__actions {
    flex-direction: column;
    align-items: stretch;
  }

  .status-page__actions :deep(.app-btn) {
    width: 100%;
  }
}
</style>
