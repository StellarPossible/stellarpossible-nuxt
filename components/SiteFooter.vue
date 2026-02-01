<template>
  <footer class="site-footer" :class="{ 'theme-light': theme === 'light', 'scrolled': scrolled }">
    <div class="footer-content">
      <button type="button" class="contact-btn" aria-label="Contact StellarPossible" @click="open()">Contact</button>
      <nav v-if="showCrossNav" class="footer-cross-nav" aria-label="Site navigation">
        <NuxtLink to="/services" class="footer-cross-link">Services</NuxtLink>
        <span class="footer-cross-sep" aria-hidden="true">·</span>
        <NuxtLink to="/products" class="footer-cross-link">Our Work</NuxtLink>
      </nav>
      <span class="copyright">&copy; {{ year }} StellarPossible, LLC</span>
      <a
        href="https://instagram.com/stellarpossible"
        target="_blank"
        rel="noopener"
        aria-label="Instagram"
        class="social-icon social-icon-ig"
      >
        <svg viewBox="0 0 24 24" width="28" height="28" fill="none" aria-hidden="true">
          <!-- Classic Instagram camera: rounded square + lens + viewfinder dot -->
          <path class="ig-body" d="M7 2h10a5 5 0 0 1 5 5v10a5 5 0 0 1-5 5H7a5 5 0 0 1-5-5V7a5 5 0 0 1 5-5z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          <circle class="ig-lens" cx="12" cy="12" r="4" stroke-width="2"/>
          <circle class="ig-dot" cx="16.5" cy="7.5" r="1.25" fill="currentColor"/>
        </svg>
      </a>
    </div>
  </footer>
</template>

<script setup lang="ts">
defineProps<{ scrolled?: boolean }>()

const route = useRoute()
const year = new Date().getFullYear()
const { open } = useContactModal()
const { theme } = useTheme()

const showCrossNav = computed(() => {
  const path = route.path
  return path !== '/' && !path.startsWith('/dashboard')
})
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.site-footer {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100%;
  padding: 0.5rem;
  background: $primary;
  color: $white;
  font-family: 'Montserrat', sans-serif;
  text-align: center;
  font-size: 1.5rem;
  z-index: 3000;
  overflow: hidden;
  transition: background 0.3s ease, color 0.3s ease;

  &::before {
    content: '';
    position: absolute;
    inset: 0;
    background: rgba(0, 0, 0, 0.6);
    background-size: cover;
    background-attachment: fixed;
    filter: blur(3px);
    z-index: -1;
    transition: opacity 0.3s ease;
  }

  &.scrolled::before {
    opacity: 0.25;
  }

  &.theme-light {
    /* Soft blue-grey to complement light galaxy background */
    background: rgba(226, 232, 240, 0.92);
    color: #1a1a2e;
    &::before {
      background: rgba(226, 232, 240, 0.92);
      filter: none;
    }
    &.scrolled::before {
      opacity: 0.25;
    }
  }

  .footer-content {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    align-items: center;
    gap: 0.75rem 1.25rem;
    position: relative;
    z-index: 1;
  }

  .footer-cross-nav {
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .footer-cross-link {
    font-size: 0.9375rem;
    font-weight: 500;
    color: rgba(255, 255, 255, 0.9);
    text-decoration: none;
    transition: color 0.2s ease;
    white-space: nowrap;
  }

  .footer-cross-link:hover {
    color: #fff;
  }

  .footer-cross-sep {
    color: rgba(255, 255, 255, 0.4);
    font-size: 0.875rem;
    user-select: none;
  }

  &.theme-light .footer-cross-link {
    color: rgba(26, 26, 46, 0.9);
  }

  &.theme-light .footer-cross-link:hover {
    color: #1a1a2e;
  }

  &.theme-light .footer-cross-sep {
    color: rgba(26, 26, 46, 0.4);
  }

  .contact-btn {
    background: rgba(255, 255, 255, 0.08);
    color: $white;
    border: 1px solid rgba(255, 255, 255, 0.24);
    padding: 0.3rem 0.65rem;
    border-radius: 10px;
    text-decoration: none;
    font-weight: 600;
    font-size: 0.95rem;
    letter-spacing: 0.01em;
    transition: background 0.2s ease, border-color 0.2s ease;

    &:hover {
      background: rgba(255, 255, 255, 0.16);
      border-color: rgba(255, 255, 255, 0.3);
    }
  }

  &.theme-light .contact-btn {
    background: rgba(0, 0, 0, 0.06);
    color: #1a1a2e;
    border-color: rgba(0, 0, 0, 0.15);
    &:hover {
      background: rgba(0, 0, 0, 0.1);
      border-color: rgba(0, 0, 0, 0.25);
    }
  }

  .copyright {
    font-size: 1rem;
    letter-spacing: 0.02em;
    color: $white;
    opacity: 0.9;
  }

  &.theme-light .copyright {
    color: #1a1a2e;
    opacity: 0.85;
  }

@media (max-width: 768px) {
  .copyright {
    font-size: .5rem;
  }
  .footer-content { gap: 0.75rem; }
  .contact-btn { padding: 0.28rem 0.55rem; font-size: .9rem; }
  }

  .social-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    color: inherit;
    transition: transform 0.25s ease, color 0.25s ease;
    svg {
      vertical-align: middle;
    }
    &:hover {
      transform: scale(1.15);
    }
  }

  /* Instagram icon: theme-matched by default, recognizable camera shape */
  .social-icon-ig {
    .ig-body {
      stroke: currentColor;
      fill: none;
      transition: stroke 0.25s ease;
    }
    .ig-lens {
      stroke: currentColor;
      fill: none;
      transition: stroke 0.25s ease;
    }
    .ig-dot {
      fill: currentColor;
      transition: fill 0.25s ease;
    }
    /* Subtle Instagram accent on the viewfinder dot so it reads as IG */
    .ig-dot {
      opacity: 0.9;
    }
    &:hover {
      color: #e1306c; /* Instagram coral-pink */
      .ig-body,
      .ig-lens {
        stroke: #e1306c;
      }
      .ig-dot {
        fill: #e1306c;
      }
    }
  }

  &.theme-light .social-icon-ig {
    color: #1a1a2e;
    .ig-body,
    .ig-lens {
      stroke: #1a1a2e;
    }
    .ig-dot {
      fill: #1a1a2e;
    }
    &:hover {
      color: #e1306c;
      .ig-body,
      .ig-lens {
        stroke: #e1306c;
      }
      .ig-dot {
        fill: #e1306c;
      }
    }
  }
}
</style>