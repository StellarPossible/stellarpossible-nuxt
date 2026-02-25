<template>
  <div class="dashboard-settings-page">
    <header class="page-hero">
      <h1>Settings</h1>
      <p>Configure your preferences</p>
    </header>

    <section class="dashboard-card settings-card">
      <h2 class="settings-section-title">
        <Icon icon="mdi:palette-outline" class="section-icon" />
        Appearance
      </h2>
      <div class="settings-row">
        <label class="settings-label">Theme</label>
        <div class="theme-toggle-group">
          <button
            type="button"
            class="theme-btn"
            :class="{ active: theme === 'dark' }"
            @click="setTheme('dark')"
          >
            <Icon icon="mdi:weather-night" />
            Dark
          </button>
          <button
            type="button"
            class="theme-btn"
            :class="{ active: theme === 'light' }"
            @click="setTheme('light')"
          >
            <Icon icon="mdi:weather-sunny" />
            Light
          </button>
        </div>
      </div>

      <h2 class="settings-section-title">
        <Icon icon="mdi:bell-outline" class="section-icon" />
        Notifications
      </h2>
      <div class="settings-row">
        <label class="settings-label">Email updates</label>
        <div class="toggle-wrapper">
          <button
            type="button"
            class="toggle-btn"
            :class="{ on: emailUpdates }"
            role="switch"
            :aria-checked="emailUpdates"
            @click="emailUpdates = !emailUpdates"
          >
            <span class="toggle-thumb" />
          </button>
          <span class="toggle-label">{{ emailUpdates ? 'On' : 'Off' }}</span>
        </div>
      </div>
      <p class="settings-hint">Receive email when we post updates or have news. (Preference saved locally.)</p>
    </section>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: 'auth'
})

const { theme, setTheme } = useTheme()

const NOTIFY_KEY = 'stellarpossible-email-updates'
const emailUpdates = ref(false)

onMounted(() => {
  if (import.meta.client) {
    try {
      const stored = localStorage.getItem(NOTIFY_KEY)
      emailUpdates.value = stored === 'true'
    } catch {}
  }
})

watch(emailUpdates, (v) => {
  if (import.meta.client) {
    try {
      localStorage.setItem(NOTIFY_KEY, String(v))
    } catch {}
  }
})

useHead({
  title: 'Settings | Dashboard | StellarPossible',
  meta: [{ name: 'description', content: 'Manage your account settings.' }]
})
</script>

<style scoped lang="scss">
.dashboard-settings-page {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.page-hero {
  margin-bottom: 1.5rem;
  color: white;

  h1 {
    font-size: clamp(1.5rem, 2.5vw, 1.9rem);
    font-family: 'Evermore', 'Inter', sans-serif;
    margin: 0 0 0.35rem;
    font-weight: 400;
  }

  p {
    font-size: 0.95rem;
    opacity: 0.9;
    margin: 0;
  }
}

.settings-card {
  max-width: 480px;
  padding: 2rem;
}

.settings-section-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin: 0 0 1rem;
  font-size: 1rem;
  font-weight: 600;
  color: #1a1a2e;

  &:not(:first-child) {
    margin-top: 1.5rem;
    padding-top: 1.5rem;
    border-top: 1px solid rgba(0, 0, 0, 0.06);
  }
}

.section-icon {
  width: 20px;
  height: 20px;
  color: #4c5fd5;
}

.settings-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  margin-bottom: 0.5rem;
}

.settings-label {
  font-size: 0.95rem;
  color: #495057;
}

.theme-toggle-group {
  display: flex;
  gap: 0.5rem;
}

.theme-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.5rem 0.9rem;
  font-size: 0.875rem;
  color: #6c757d;
  background: #f1f3f5;
  border: 1px solid #e9ecef;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;

  &:hover {
    background: #e9ecef;
    color: #495057;
  }

  &.active {
    background: rgba(102, 126, 234, 0.15);
    border-color: rgba(102, 126, 234, 0.3);
    color: #4c5fd5;
  }

  :deep(svg) {
    width: 18px;
    height: 18px;
  }
}

.toggle-wrapper {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.toggle-btn {
  width: 44px;
  height: 24px;
  padding: 2px;
  background: #e9ecef;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.2s;

  &.on {
    background: #4c5fd5;
  }
}

.toggle-thumb {
  display: block;
  width: 20px;
  height: 20px;
  background: #fff;
  border-radius: 50%;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
  transition: transform 0.2s;
}

.toggle-btn.on .toggle-thumb {
  transform: translateX(20px);
}

.toggle-label {
  font-size: 0.875rem;
  color: #6c757d;
}

.settings-hint {
  margin: 0.5rem 0 0;
  font-size: 0.8rem;
  color: #868e96;
}
</style>
