<template>
  <section class="dashboard-card coming-soon-card">
    <div class="coming-soon-content">
      <div class="coming-soon-icon">
        <Icon :icon="props.icon" />
      </div>
      <h2>{{ props.title }}</h2>
      <p>{{ props.description }}</p>
      <span class="coming-soon-badge">Coming soon</span>
    </div>
  </section>
</template>

<script setup lang="ts">
const props = withDefaults(
  defineProps<{
    title: string
    description: string
    icon?: string
  }>(),
  { icon: 'mdi:hammer-wrench' }
)
</script>

<style scoped lang="scss">
.coming-soon-card {
  background: rgba(255, 255, 255, 0.98);
  border-radius: 16px;
  padding: 3rem 2rem;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08), 0 0 0 1px rgba(255, 255, 255, 0.5);
  max-width: 480px;
  margin: 0 auto;
}

.coming-soon-content {
  text-align: center;
}

.coming-soon-icon {
  width: 64px;
  height: 64px;
  margin: 0 auto 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(102, 126, 234, 0.1);
  border-radius: 16px;
  color: #4c5fd5;

  :deep(svg) {
    width: 32px;
    height: 32px;
  }
}

.coming-soon-content h2 {
  margin: 0 0 0.5rem;
  font-size: 1.5rem;
  color: #1a1a2e;
}

.coming-soon-content p {
  margin: 0 0 1rem;
  font-size: 0.95rem;
  color: #6c757d;
  line-height: 1.5;
}

.coming-soon-badge {
  display: inline-block;
  font-size: 0.75rem;
  font-weight: 600;
  color: #868e96;
  background: #f1f3f5;
  padding: 0.3rem 0.6rem;
  border-radius: 6px;
}
</style>
