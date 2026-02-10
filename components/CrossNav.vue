<template>
  <nav
    class="cross-nav"
    :class="[variant, { 'theme-light': theme === 'light' }]"
    aria-label="Site navigation"
  >
    <NuxtLink to="/services" class="cross-nav-link">Services</NuxtLink>
    <span class="cross-nav-sep" aria-hidden="true">·</span>
    <NuxtLink to="/products" class="cross-nav-link">Our Work</NuxtLink>
    <template v-if="showContact">
      <span class="cross-nav-sep" aria-hidden="true">·</span>
      <button type="button" class="cross-nav-link cross-nav-contact" @click="openContact">
        Contact
      </button>
    </template>
  </nav>
</template>

<script setup lang="ts">
withDefaults(
  defineProps<{ variant?: 'header' | 'float' | 'inline'; showContact?: boolean }>(),
  { variant: 'inline', showContact: true }
)

const { theme } = useTheme()
const { open: openContact } = useContactModal()
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.cross-nav {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  align-items: center;
  gap: 0.375rem 0.625rem;
}

/* Match former footer contact button: pill style */
.cross-nav-link {
  font-size: 0.9375rem;
  font-weight: 600;
  letter-spacing: 0.01em;
  color: $white;
  text-decoration: none;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.24);
  cursor: pointer;
  padding: 0.3rem 0.65rem;
  border-radius: 10px;
  transition: background 0.2s ease, border-color 0.2s ease, color 0.2s ease;

  &:hover {
    background: rgba(255, 255, 255, 0.16);
    border-color: rgba(255, 255, 255, 0.3);
    color: #fff;
  }

  &:focus-visible {
    outline: 2px solid rgba(255, 255, 255, 0.5);
    outline-offset: 2px;
  }
}

.cross-nav-sep {
  color: rgba(255, 255, 255, 0.35);
  font-size: 0.75rem;
  font-weight: 600;
  user-select: none;
  line-height: 1;
}

/* Header variant: compact, under logo; no Contact button */
.cross-nav.header {
  padding: 0.35rem 0 0.5rem;
  gap: 0.25rem 0.5rem;

  .cross-nav-link {
    font-size: 0.875rem;
    padding: 0.28rem 0.5rem;
  }

  .cross-nav-sep {
    font-size: 0.6875rem;
  }
}

/* Floating bar above footer: very thin, full viewport width */
.cross-nav.float {
  width: 100%;
  min-height: 0;
  padding: 0.25rem 0.5rem;
  background: rgba(18, 49, 70, 0.9);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  border-top: 1px solid rgba(255, 255, 255, 0.06);
  box-shadow: 0 -2px 12px rgba(0, 0, 0, 0.12);

  .cross-nav-link {
    font-size: 0.8125rem;
    padding: 0.25rem 0.5rem;
  }

  .cross-nav-sep {
    font-size: 0.625rem;
  }
}

/* Inline (e.g. news page) */
.cross-nav.inline {
  padding: 0.5rem 0;
}

/* Light theme */
.cross-nav.theme-light .cross-nav-link {
  color: #1a1a2e;
  background: rgba(0, 0, 0, 0.06);
  border-color: rgba(0, 0, 0, 0.15);

  &:hover {
    color: #1a1a2e;
    background: rgba(0, 0, 0, 0.1);
    border-color: rgba(0, 0, 0, 0.25);
  }

  &:focus-visible {
    outline-color: rgba(26, 26, 46, 0.5);
  }
}

.cross-nav.theme-light .cross-nav-sep {
  color: rgba(26, 26, 46, 0.35);
}

.cross-nav.theme-light.float {
  background: rgba(255, 255, 255, 0.88);
  border-top-color: rgba(0, 0, 0, 0.06);
  box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.08);
}
</style>
