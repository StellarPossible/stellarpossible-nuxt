<template>
  <header class="dashboard-topbar">
    <nav class="breadcrumb" aria-label="Breadcrumb">
      <NuxtLink to="/dashboard" class="breadcrumb-link">Dashboard</NuxtLink>
      <template v-if="crumbs.length > 0">
        <span class="breadcrumb-sep" aria-hidden>/</span>
        <template v-for="(crumb, i) in crumbs" :key="crumb.path">
          <NuxtLink
            v-if="i < crumbs.length - 1"
            :to="crumb.path"
            class="breadcrumb-link"
          >
            {{ crumb.label }}
          </NuxtLink>
          <span v-else class="breadcrumb-current" aria-current="page">
            {{ crumb.label }}
          </span>
          <span v-if="i < crumbs.length - 1" class="breadcrumb-sep" aria-hidden>/</span>
        </template>
      </template>
    </nav>
    <div class="topbar-actions">
      <span class="user-email">{{ user?.email }}</span>
      <button
        type="button"
        class="logout-btn"
        aria-label="Sign out"
        @click="logout"
      >
        <Icon icon="mdi:logout" />
        <span>Sign out</span>
      </button>
    </div>
  </header>
</template>

<script setup lang="ts">
import type { User } from '~/types/auth'

const route = useRoute()

const LABELS: Record<string, string> = {
  services: 'Hosting',
  profile: 'Profile',
  settings: 'Settings',
  users: 'Users',
  content: 'Content'
}

const crumbs = computed(() => {
  const segments = route.path.replace(/^\/dashboard\/?/, '').split('/').filter(Boolean)
  if (!segments.length) return []
  const result: { label: string; path: string }[] = []
  let path = '/dashboard'
  for (const seg of segments) {
    path += `/${seg}`
    const label = LABELS[seg] || seg.charAt(0).toUpperCase() + seg.slice(1)
    result.push({ label, path })
  }
  return result
})

const user = useState<User | null>('auth.user')

async function logout() {
  try {
    await $fetch('/api/auth/logout', { method: 'POST' })
    user.value = null
    await navigateTo('/login')
  } catch (error) {
    console.error('Logout failed:', error)
  }
}
</script>

<style scoped lang="scss">
.dashboard-topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  margin-bottom: 1.5rem;
  flex-wrap: wrap;
}

.breadcrumb {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 0.25rem;
  font-size: 0.875rem;
  min-width: 0;
  flex: 1;
}

.breadcrumb-current {
  color: #fff;
  font-weight: 500;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 12rem;
}

.breadcrumb-link {
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  transition: color 0.2s;

  &:hover {
    color: #fff;
  }
}

.breadcrumb-sep {
  color: rgba(255, 255, 255, 0.4);
  user-select: none;
}

.topbar-actions {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.user-email {
  font-size: 0.8rem;
  color: rgba(255, 255, 255, 0.7);
  max-width: 180px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.logout-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.4rem 0.75rem;
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.9);
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s, border-color 0.2s;

  &:hover {
    background: rgba(255, 255, 255, 0.18);
    border-color: rgba(255, 255, 255, 0.3);
  }

  &:focus-visible {
    outline: 2px solid rgba(255, 255, 255, 0.8);
    outline-offset: 2px;
  }
}

@media (max-width: 640px) {
  .dashboard-topbar {
    flex-direction: column;
    align-items: stretch;
    gap: 0.75rem;
  }

  .user-email {
    display: none;
  }

  .topbar-actions {
    justify-content: flex-end;
  }

  .logout-btn {
    min-height: 44px;
  }
}
</style>
