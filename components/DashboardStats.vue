<template>
  <section class="dashboard-card stats-card">
    <h2 class="card-title">
      <Icon icon="mdi:chart-box-outline" class="card-icon" />
      Overview
    </h2>
    <div v-if="pending" class="stats-loading">
      <div v-for="i in 3" :key="i" class="skeleton skeleton-stat" />
    </div>
    <div v-else class="stats-grid">
      <div class="stat-item">
        <span class="stat-value">{{ data?.totalPosts ?? '—' }}</span>
        <span class="stat-label">Site posts</span>
      </div>
      <div class="stat-item">
        <span class="stat-value">{{ data?.totalComments ?? '—' }}</span>
        <span class="stat-label">Site comments</span>
      </div>
      <div class="stat-item">
        <span class="stat-value stat-value-sm">{{ lastLoginDisplay }}</span>
        <span class="stat-label">Last login</span>
      </div>
    </div>
    <div class="stats-footer">
      <NuxtLink to="/dashboard/services" class="stat-badge stat-badge-link">
        <Icon icon="mdi:server" />
        <span>Hosting — Subscribe or manage</span>
        <Icon icon="mdi:chevron-right" class="stat-badge-arrow" />
      </NuxtLink>
    </div>
  </section>
</template>

<script setup lang="ts">
type Stats = { totalPosts: number; totalComments: number; lastLogin?: string | null }
const { data, pending } = useLazyFetch<Stats>('/api/dashboard/stats')
const lastLoginDisplay = computed(() => {
  if (!data.value?.lastLogin) return '—'
  try {
    const d = new Date(data.value.lastLogin)
    const now = new Date()
    const diffDays = Math.floor((now.getTime() - d.getTime()) / 86400000)
    if (diffDays === 0) return 'Today'
    if (diffDays === 1) return 'Yesterday'
    if (diffDays < 7) return `${diffDays} days ago`
    return d.toLocaleDateString()
  } catch {
    return String(data.value.lastLogin)
  }
})
</script>

<style scoped lang="scss">
.dashboard-card {
  background: rgba(255, 255, 255, 0.98);
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08), 0 0 0 1px rgba(255, 255, 255, 0.5);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.dashboard-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12), 0 0 0 1px rgba(255, 255, 255, 0.5);
}
.card-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin: 0 0 1rem;
  font-size: 1rem;
  font-weight: 600;
  color: #1a1a2e;
}
.card-icon {
  width: 20px;
  height: 20px;
  color: #4c5fd5;
}
.stats-loading {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
}
.skeleton {
  background: linear-gradient(90deg, #e9ecef 25%, #f1f3f5 50%, #e9ecef 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: 8px;
}
.skeleton-stat {
  height: 48px;
}
@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
.stats-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
}
.stat-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}
.stat-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1a1a2e;
}
.stat-value-sm {
  font-size: 0.95rem;
  font-weight: 600;
}
.stat-label {
  font-size: 0.8rem;
  color: #6c757d;
}
.stats-footer {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid rgba(0, 0, 0, 0.06);
}
.stat-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.8rem;
  color: #6c757d;
  padding: 0.35rem 0.6rem;
  background: rgba(102, 126, 234, 0.08);
  border-radius: 8px;
}
.stat-badge :deep(svg) {
  width: 16px;
  height: 16px;
  color: #4c5fd5;
}
.stat-badge-link {
  text-decoration: none;
  color: #4c5fd5;
  font-weight: 500;
  transition: background 0.2s;
}
.stat-badge-link:hover {
  background: rgba(102, 126, 234, 0.14);
  color: #4c5fd5;
}
.stat-badge-arrow {
  width: 14px;
  height: 14px;
  margin-left: 0.2rem;
  opacity: 0.8;
}
@media (max-width: 640px) {
  .stats-grid, .stats-loading {
    grid-template-columns: 1fr;
  }
}
</style>
