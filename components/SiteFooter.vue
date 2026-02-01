<template>
  <footer class="site-footer" :class="{ 'theme-light': theme === 'light', 'scrolled': scrolled }">
    <div class="footer-content">
  <button type="button" class="contact-btn" aria-label="Contact StellarPossible" @click="open()">Contact</button>
      <span class="copyright">&copy; {{ year }} StellarPossible, LLC</span>
      <a
        href="https://instagram.com/stellarpossible"
        target="_blank"
        rel="noopener"
        aria-label="Instagram"
        class="social-icon"
      >
        <svg viewBox="0 0 32 32" width="32" height="32" fill="none">
          <circle class="ig-bg" cx="16" cy="16" r="14" />
          <rect x="9" y="9" width="14" height="14" rx="7" class="ig-square"/>
          <circle cx="16" cy="16" r="4" class="ig-circle"/>
          <circle cx="21" cy="11" r="1.5" class="ig-dot"/>
        </svg>
      </a>
    </div>
  </footer>
</template>

<script setup lang="ts">
defineProps<{ scrolled?: boolean }>()

const year = new Date().getFullYear()
const { open } = useContactModal()
const { theme } = useTheme()
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
    justify-content: center;
    align-items: center;
    gap: 1.25rem;
    position: relative;
    z-index: 1;
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
    display: inline-block;
    transition: transform 0.3s;
    svg {
      vertical-align: middle;
    }
    &:hover {
      transform: scale(1.2) rotate(-10deg);
      .ig-bg {
        stroke: #e1306c;
        stroke-width: 2;
        animation: igPulse 0.7s;
      }
      .ig-square {
        fill: #e1306c;
      }
      .ig-circle {
        fill: #fff;
      }
      .ig-dot {
        fill: #e1306c;
      }
    }
  }

  .ig-bg {
    stroke: #fff;
    stroke-width: 1;
    fill: none;
    transition: stroke 0.3s;
  }
  &.theme-light .ig-bg {
    stroke: #1a1a2e;
  }
  .ig-square {
    fill: #fff;
    transition: fill 0.3s;
  }
  &.theme-light .ig-square {
    fill: #1a1a2e;
  }
  .ig-circle {
    fill: #e1306c;
    transition: fill 0.3s;
  }
  .ig-dot {
    fill: #fff;
    transition: fill 0.3s;
  }

  @keyframes igPulse {
    0% { stroke-width: 2; }
    50% { stroke-width: 6; }
    100% { stroke-width: 2; }
  }
}
</style>