<template>
  <section class="dashboard-card activity-card">
    <h2 class="card-title">
      <Icon icon="mdi:clock-outline" class="card-icon" />
      Recent Activity
    </h2>
    <div v-if="items.length" class="activity-list">
      <div
        v-for="(item, i) in items"
        :key="i"
        class="activity-item"
      >
        <span class="activity-icon" :class="item.type">
          <Icon :icon="item.icon" />
        </span>
        <div class="activity-content">
          <p class="activity-text">{{ item.text }}</p>
          <span class="activity-time">{{ item.time }}</span>
        </div>
      </div>
    </div>
    <div v-else class="activity-empty">
      <NuxtLink to="/dashboard/services" class="activity-item activity-item-cta">
        <span class="activity-icon success">
          <Icon icon="mdi:rocket-launch" />
        </span>
        <div class="activity-content">
          <p class="activity-text">Get started — Subscribe to hosting</p>
          <span class="activity-time">Managed hosting for your site</span>
        </div>
        <Icon icon="mdi:chevron-right" class="activity-arrow" />
      </NuxtLink>
      <p class="empty-hint">Subscription events and updates will appear here.</p>
    </div>
  </section>
</template>

<script setup lang="ts">
type Stats = { totalPosts: number; totalComments: number; lastLogin?: string | null }
const { data: stats } = useLazyFetch<Stats>('/api/dashboard/stats')

const items = computed(() => {
  const out: { icon: string; text: string; time: string; type: string }[] = []
  const lastLogin = stats.value?.lastLogin
  if (lastLogin) {
    try {
      const d = new Date(lastLogin)
      const now = new Date()
      const diffDays = Math.floor((now.getTime() - d.getTime()) / 86400000)
      let time = 'Recently'
      if (diffDays === 0) time = 'Today'
      else if (diffDays === 1) time = 'Yesterday'
      else if (diffDays < 7) time = `${diffDays} days ago`
      else time = d.toLocaleDateString()
      out.push({
        icon: 'mdi:login',
        text: 'Signed in',
        time,
        type: 'info'
      })
    } catch {}
  }
  return out
})
</script>

<style scoped lang="scss">
.dashboard-card {
  background: rgba(255, 255, 255, 0.98);
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08), 0 0 0 1px rgba(255, 255, 255, 0.5);
  transition: transform 0.2s ease, box-shadow 0.2s ease;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12), 0 0 0 1px rgba(255, 255, 255, 0.5);
  }
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

.activity-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.activity-item {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  padding: 0.6rem;
  border-radius: 10px;
  transition: background 0.2s;

  &:hover {
    background: #f8f9fa;
  }
}

.activity-item-cta {
  text-decoration: none;
  color: inherit;
  margin-bottom: 0.5rem;

  &:hover {
    background: rgba(102, 126, 234, 0.08);
  }
}

.activity-item-cta .activity-text {
  color: #1a1a2e;
  font-weight: 500;
}

.activity-arrow {
  width: 20px;
  height: 20px;
  color: #adb5bd;
  flex-shrink: 0;
  margin-left: auto;
}

.activity-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 8px;
  flex-shrink: 0;

  :deep(svg) {
    width: 18px;
    height: 18px;
  }

  &.success {
    background: rgba(34, 197, 94, 0.12);
    color: #16a34a;
  }

  &.info {
    background: rgba(102, 126, 234, 0.12);
    color: #4c5fd5;
  }

  &.neutral {
    background: #f1f3f5;
    color: #6c757d;
  }
}

.activity-content {
  min-width: 0;
}

.activity-text {
  margin: 0;
  font-size: 0.9rem;
  color: #212529;
}

.activity-time {
  font-size: 0.75rem;
  color: #868e96;
  margin-top: 0.15rem;
  display: block;
}

.activity-empty {
  padding: 0.5rem 0;
}

.empty-hint {
  display: block;
  font-size: 0.8rem;
  color: #adb5bd;
  margin-top: 0.5rem;
  text-align: center;
}
</style>
