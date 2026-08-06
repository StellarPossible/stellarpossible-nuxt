<template>
  <div
    v-if="show"
    class="sticky-cta"
    role="complementary"
    aria-label="Create Account"
  >
    <AppButton :to="primaryCtaPath" variant="accent" size="md" block>
      {{ primaryCtaLabel }}
    </AppButton>
  </div>
</template>

<script setup lang="ts">
const { path: primaryCtaPath, label: primaryCtaLabel } = usePrimaryCta()
const user = useState<{ id?: string } | null>('auth.user', () => null)

const show = computed(() => !user.value?.id)
</script>

<style scoped lang="scss">
.sticky-cta {
  display: none;
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 1500;
  padding: var(--space-3) var(--space-4);
  padding-bottom: max(var(--space-3), env(safe-area-inset-bottom));
  background: linear-gradient(to top, rgba(11, 13, 23, 0.95) 0%, rgba(11, 13, 23, 0.85) 70%, transparent 100%);
  backdrop-filter: blur(12px);
}

@media (max-width: 768px) {
  .sticky-cta {
    display: block;
  }
}
</style>
