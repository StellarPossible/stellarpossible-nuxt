<template>
  <div class="dashboard-page">
    <div class="dashboard-container">
      <header class="dashboard-hero">
        <h1>Dashboard</h1>
        <p>Welcome back, {{ user?.email || 'User' }}</p>
      </header>

      <div class="dashboard-grid">
        <DashboardStats />
        <DashboardQuickActions />
        <DashboardRecentActivity />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { User } from '~/types/auth'

definePageMeta({
  middleware: 'auth'
})

const user = useState<User | null>('auth.user')
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.dashboard-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 6rem 1rem 2rem;
}

.dashboard-container {
  max-width: 1200px;
  margin: 0 auto;
}

.dashboard-hero {
  text-align: center;
  margin-bottom: 3rem;
  color: white;

  h1 {
    font-size: 3rem;
    font-family: 'Evermore', 'Inter', sans-serif;
    margin-bottom: 0.5rem;
  }

  p {
    font-size: 1.2rem;
    opacity: 0.9;
  }
}

.dashboard-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

@media (max-width: 768px) {
  .dashboard-hero h1 {
    font-size: 2rem;
  }

  .dashboard-grid {
    grid-template-columns: 1fr;
  }
}
</style>
