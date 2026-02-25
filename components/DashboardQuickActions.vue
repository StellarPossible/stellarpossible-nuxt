<template>
  <section class="dashboard-card actions-card">
    <h2 class="card-title">
      <Icon icon="mdi:lightning-bolt-outline" class="card-icon" />
      Quick Actions
    </h2>
    <div class="actions-grid">
      <NuxtLink to="/dashboard/services" class="action action-primary">
        <span class="action-icon">
          <Icon icon="mdi:server" />
        </span>
        <span class="action-text">Subscribe to Hosting</span>
        <Icon icon="mdi:chevron-right" class="action-arrow" />
      </NuxtLink>
      <NuxtLink to="/write" class="action">
        <span class="action-icon">
          <Icon icon="mdi:book-open-page-variant" />
        </span>
        <span class="action-text">Read Author Updates</span>
        <Icon icon="mdi:chevron-right" class="action-arrow" />
      </NuxtLink>
      <a
        href="https://stellarpossible.slack.com"
        target="_blank"
        rel="noopener noreferrer"
        class="action"
      >
        <span class="action-icon">
          <Icon icon="simple-icons:slack" />
        </span>
        <span class="action-text">Contact Us (Slack)</span>
        <Icon icon="mdi:open-in-new" class="action-arrow" />
      </a>
      <button type="button" class="action" @click="openRequestModal">
        <span class="action-icon">
          <Icon icon="mdi:lightbulb-outline" />
        </span>
        <span class="action-text">Request update or feature</span>
        <Icon icon="mdi:chevron-right" class="action-arrow" />
      </button>
    </div>
  </section>
</template>

<script setup lang="ts">
const { open: openContact } = useContactModal()

function openRequestModal() {
  openContact('Request: Update, feature, or change')
}
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

.actions-grid {
  display: grid;
  gap: 0.5rem;
}

.action {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1rem;
  border-radius: 12px;
  text-decoration: none;
  color: #212529;
  background: #f8f9fa;
  border: 1px solid transparent;
  transition: background 0.2s, border-color 0.2s, transform 0.15s;
  width: 100%;
  text-align: left;
  font: inherit;
  cursor: pointer;

  &:hover {
    background: rgba(102, 126, 234, 0.1);
    border-color: rgba(102, 126, 234, 0.2);
    transform: translateX(4px);
  }
}

.action-primary {
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.15) 0%, rgba(118, 75, 162, 0.1) 100%);
  border-color: rgba(102, 126, 234, 0.25);

  .action-icon {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: #fff;
  }

  &:hover {
    background: linear-gradient(135deg, rgba(102, 126, 234, 0.22) 0%, rgba(118, 75, 162, 0.15) 100%);
    border-color: rgba(102, 126, 234, 0.35);
  }
}

.action-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border-radius: 10px;
  background: rgba(102, 126, 234, 0.12);
  color: #4c5fd5;
  flex-shrink: 0;

  :deep(svg) {
    width: 20px;
    height: 20px;
  }
}

.action-text {
  flex: 1;
  font-size: 0.95rem;
  font-weight: 500;
}

.action-arrow {
  width: 20px;
  height: 20px;
  color: #adb5bd;
  transition: transform 0.2s;

  .action:hover & {
    transform: translateX(2px);
  }
}

.action-badge {
  font-size: 0.7rem;
  font-weight: 600;
  color: #868e96;
  background: #e9ecef;
  padding: 0.2rem 0.5rem;
  border-radius: 6px;
}
</style>
