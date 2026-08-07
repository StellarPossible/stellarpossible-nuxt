<template>
  <section class="home-hero">
    <Reveal>
      <GlassCard class="home-hero__card" :hover="false">
        <h1 class="home-hero__title">
          Your Ideas. Our Tech.<br />Infinite Possibility.
        </h1>
        <p class="home-hero__lead">
          Human-focused solutions for creatives, educators, and visionaries.
        </p>
        <div class="home-hero__actions">
          <AppButton v-if="user" :to="'/news'" variant="secondary" block class="home-hero__btn">Latest news</AppButton>
          <AppButton :to="primaryCtaPath" variant="primary" size="lg" block class="home-hero__btn">{{ primaryCtaLabel }}</AppButton>
          <AppButton to="/services" variant="ghost" size="lg" block class="home-hero__btn home-hero__btn--secondary">Services</AppButton>
          <AppButton v-if="!user" to="/login?tab=register" variant="ghost" size="sm" block class="home-hero__btn home-hero__btn--secondary">Login</AppButton>
        </div>
      </GlassCard>
    </Reveal>
  </section>
</template>

<script setup lang="ts">
import type { User } from '~/types/auth'

const user = useState<User | null>('auth.user', () => null)
const { path: primaryCtaPath, label: primaryCtaLabel } = usePrimaryCta()
</script>

<style scoped lang="scss">
.home-hero {
  min-height: min(90vh, 900px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: var(--space-16) var(--space-6) var(--space-12);
  box-sizing: border-box;
}

.home-hero__card {
  text-align: center;
  max-width: 52rem;
  width: 100%;
  padding: clamp(var(--space-8), 6vw, var(--space-12)) !important;
  animation: hero-enter var(--dur-slow) var(--ease-out) both;
}

@keyframes hero-enter {
  from {
    opacity: 0;
    transform: translateY(20px) scale(0.98);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

@media (prefers-reduced-motion: reduce) {
  .home-hero__card {
    animation: none;
  }
}

.home-hero__title {
  font-family: var(--font-display);
  font-size: var(--fs-800);
  font-weight: 500;
  line-height: 1.1;
  margin: 0 0 var(--space-5);
  letter-spacing: -0.02em;
  color: var(--color-text);
}

.home-hero__lead {
  font-size: var(--fs-400);
  color: var(--color-text-muted);
  margin: 0 0 var(--space-8);
  line-height: 1.55;
  max-width: 32rem;
  margin-inline: auto;
}

.home-hero__actions {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: var(--space-3);
}

@media (max-width: 768px) {
  .home-hero {
    min-height: min(80vh, 720px);
    padding: var(--space-10) var(--space-4) var(--space-8);
  }

  .home-hero__card {
    padding: var(--space-6) !important;
  }

  .home-hero__actions {
    flex-direction: column;
    align-items: stretch;
    gap: var(--space-2);
  }
}

@media (max-width: 480px) {
  .home-hero__btn--secondary {
    display: none;
  }
}
</style>
