<template>
  <div class="dashboard-overview dashboard-page">
    <header class="page-hero dashboard-hero">
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
.dashboard-hero {
  margin-bottom: 2rem;
}
</style>
