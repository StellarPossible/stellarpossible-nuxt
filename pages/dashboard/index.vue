<template>
  <div class="dashboard-overview">
    <header class="dashboard-hero">
      <h1>Welcome back, {{ displayName }}</h1>
      <p>Here’s an overview of your account</p>
    </header>

    <div class="dashboard-grid">
      <DashboardStats />
      <DashboardQuickActions />
      <DashboardRecentActivity />
    </div>
  </div>
</template>

<script setup lang="ts">
import type { User } from '~/types/auth'

definePageMeta({
  middleware: 'auth'
})

const user = useState<User | null>('auth.user')
const displayName = computed(() => user.value?.name || user.value?.username || user.value?.email?.split('@')[0] || 'User')
</script>

<style scoped lang="scss">
.dashboard-overview {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.dashboard-hero {
  margin-bottom: 2rem;
  color: white;

  h1 {
    font-size: clamp(1.75rem, 3vw, 2.25rem);
    font-family: 'Evermore', 'Inter', sans-serif;
    margin: 0 0 0.35rem;
    font-weight: 400;
  }

  p {
    font-size: 1rem;
    opacity: 0.9;
    margin: 0;
  }
}
</style>
