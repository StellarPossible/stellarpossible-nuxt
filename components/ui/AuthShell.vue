<template>
  <div class="auth-shell">
    <GlassCard class="auth-shell__card" :hover="false" :pad="false">
      <div v-if="tabs?.length" class="auth-shell__tabs" role="tablist">
        <button
          v-for="tab in tabs"
          :key="tab.id"
          type="button"
          role="tab"
          class="auth-shell__tab"
          :class="{ 'auth-shell__tab--active': activeTab === tab.id }"
          :aria-selected="activeTab === tab.id"
          @click="$emit('update:activeTab', tab.id)"
        >
          {{ tab.label }}
        </button>
      </div>
      <div class="auth-shell__body">
        <slot />
      </div>
    </GlassCard>
  </div>
</template>

<script setup lang="ts">
export interface AuthTab {
  id: string
  label: string
}

defineProps<{
  tabs?: AuthTab[]
  activeTab?: string
}>()

defineEmits<{ 'update:activeTab': [string] }>()
</script>

<style scoped lang="scss">
.auth-shell {
  min-height: calc(100vh - var(--site-header-height, 5rem) - var(--site-footer-height, 3rem));
  display: flex;
  align-items: center;
  justify-content: center;
  padding: var(--space-8) var(--space-4);
  box-sizing: border-box;
}

.auth-shell__card {
  width: 100%;
  max-width: 26rem;
  overflow: hidden;
}

.auth-shell__tabs {
  display: flex;
  border-bottom: 1px solid var(--color-border);
  background: rgba(0, 0, 0, 0.12);
}

.auth-shell__tab {
  flex: 1;
  padding: var(--space-4);
  border: none;
  background: transparent;
  font-family: var(--font-ui);
  font-size: var(--fs-200);
  font-weight: 600;
  color: var(--color-text-muted);
  cursor: pointer;
  transition:
    color var(--dur-med) var(--ease-out),
    background var(--dur-med) var(--ease-out),
    border-color var(--dur-med) var(--ease-out);
  border-bottom: 2px solid transparent;

  &:hover:not(.auth-shell__tab--active) {
    color: var(--color-text);
    background: var(--color-accent-soft);
  }

  &:focus-visible {
    outline: 2px solid var(--color-accent);
    outline-offset: -2px;
  }
}

.auth-shell__tab--active {
  color: var(--color-text);
  background: var(--color-accent-soft);
  border-bottom-color: var(--color-accent);
}

.auth-shell__body {
  padding: var(--space-8);
}

@media (max-width: 480px) {
  .auth-shell {
    padding: var(--space-4);
    align-items: flex-start;
    padding-top: calc(var(--site-header-height, 5rem) + var(--space-4));
    min-height: auto;
  }

  .auth-shell__body {
    padding: var(--space-6);
  }

  .auth-shell__tab {
    min-height: 44px;
  }
}
</style>
