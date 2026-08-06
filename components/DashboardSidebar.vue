<template>
  <aside class="dashboard-sidebar">
    <div class="user-profile">
      <img :src="avatarSrc" :alt="user?.name || user?.username || 'User'" />
      <h3>{{ user?.name || user?.username }}</h3>
      <p>{{ user?.email }}</p>
    </div>
    
    <nav class="dashboard-nav">
      <NuxtLink to="/dashboard" class="nav-item" exact-active-class="active">
        <Icon icon="mdi:view-dashboard" />
        <span>Overview</span>
      </NuxtLink>
      <NuxtLink to="/dashboard/profile" class="nav-item" active-class="active">
        <Icon icon="mdi:account" />
        <span>Profile</span>
      </NuxtLink>
      <NuxtLink to="/dashboard/settings" class="nav-item" active-class="active">
        <Icon icon="mdi:cog" />
        <span>Settings</span>
      </NuxtLink>
      <NuxtLink to="/dashboard/services" class="nav-item" active-class="active">
        <Icon icon="mdi:server" />
        <span>Hosting</span>
      </NuxtLink>
      <div v-if="isAdmin" class="admin-section">
        <h4>Admin</h4>
        <NuxtLink to="/dashboard/content" class="nav-item" active-class="active">
          <Icon icon="mdi:file-document" />
          <span>Content</span>
        </NuxtLink>
      </div>
    </nav>
  </aside>
</template>

<script setup lang="ts">
import type { User } from '~/types/auth'
const user = useState<User | null>('auth.user')
const isAdmin = computed(() => user.value?.roles?.includes('administrator'))
const avatarSrc = computed(() => user.value?.avatar || '/default-avatar.svg')
</script>

<style scoped lang="scss">
.dashboard-sidebar {
  background: rgba(255, 255, 255, 0.97);
  backdrop-filter: blur(12px);
  border-right: 1px solid rgba(255, 255, 255, 0.2);
  padding: 1.5rem 1rem 2rem;
  display: flex;
  flex-direction: column;
}

.user-profile {
  display: grid;
  gap: 0.5rem;
  text-align: center;
  margin-bottom: 1.5rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);

  img {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    object-fit: cover;
    margin: 0 auto 0.5rem;
    border: 2px solid rgba(0, 0, 0, 0.06);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  }

  h3 {
    margin: 0;
    font-size: 0.95rem;
    font-weight: 600;
    color: #1a1a2e;
  }

  p {
    margin: 0;
    color: #6c757d;
    font-size: 0.8rem;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

.dashboard-nav {
  display: grid;
  gap: 0.2rem;

  .nav-item {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    padding: 0.6rem 0.85rem;
    border-radius: 10px;
    color: #495057;
    text-decoration: none;
    font-size: 0.9rem;
    font-weight: 500;
    transition: background 0.2s, color 0.2s;

    &:hover {
      background: rgba(102, 126, 234, 0.1);
      color: #4c5fd5;
    }

    &.active {
      background: linear-gradient(135deg, rgba(76, 95, 213, 0.2) 0%, rgba(118, 75, 162, 0.15) 100%);
      color: var(--dash-primary);
      box-shadow: inset 3px 0 0 var(--dash-primary);
    }

    &:focus-visible {
      outline: 2px solid var(--dash-primary);
      outline-offset: 2px;
    }

    :deep(svg) {
      width: 20px;
      height: 20px;
      opacity: 0.9;
    }
  }

  .admin-section {
    margin-top: 1rem;
    padding-top: 1rem;
    border-top: 1px solid rgba(0, 0, 0, 0.06);

    h4 {
      margin: 0 0 0.5rem 0.85rem;
      font-size: 0.7rem;
      color: #868e96;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      font-weight: 600;
    }
  }
}
</style>
