<template>
  <section class="hero-content">
    <div class="hero-backdrop">
      <h1>Your Ideas. Our Tech. <br />Infinite Possibility.</h1>
      <p>
        Human-focused solutions for creatives, educators, and visionaries.
      </p>
      <div class="hero-buttons">
        <NuxtLink v-if="user" to="/news" class="button latest">
          Latest from <img src="/images/primary/spicon.png" alt="Stellar Possible" class="hero-btn-icon" />
        </NuxtLink>
        <NuxtLink v-else to="/services" class="button primary">Services</NuxtLink>
        <NuxtLink v-if="user" to="/dashboard" class="button ghost">Manage Account</NuxtLink>
        <NuxtLink v-else to="/login" class="button ghost">Login</NuxtLink>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import type { User } from '~/types/auth'

const user = useState<User | null>('auth.user', () => null)
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.hero-content {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 6rem 2rem 4rem;
  min-height: 100vh;
  position: relative;
  z-index: 2;
  box-sizing: border-box;

  .hero-backdrop {
    text-align: center;
    padding: 2rem 2.5rem;
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    background-color: rgba(0, 0, 0, 0.5);
    border-radius: 1.25rem;
    box-shadow: 0 8px 48px rgba(0, 0, 0, 0.4), 0 0 0 1px rgba(255, 255, 255, 0.06);
    max-width: 900px;
    width: 100%;
    margin-top: -6rem;
    color: #fff;
    overflow: hidden;
    box-sizing: border-box;
  }

  h1 {
    font-family: 'OldStyle';
    font-size: clamp(1.75rem, 5vw, 3.5rem);
    font-weight: 300;
    line-height: 1.2;
    margin: 0 0 0.75rem;
    letter-spacing: .5px;
  }

  p {
    font-size: clamp(1rem, 2vw, 1.25rem);
    margin: 0 0 2rem;
    opacity: 0.92;
    line-height: 1.5;
  }

  .hero-buttons {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    align-items: center;
    gap: 1rem;
    min-width: 0;
    max-width: 100%;

    .button {
      padding: 0.875rem 1.75rem;
      font-size: 1rem;
      font-weight: 600;
      border: none;
      border-radius: 0.5rem;
      cursor: pointer;
      transition: transform 0.2s ease, box-shadow 0.2s ease, background-color 0.2s ease, border-color 0.2s ease;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      text-align: center;
      box-sizing: border-box;
      max-width: 100%;

      &.primary {
        background-color: white;
        color: $primary;
      }

      &.latest {
        background-color: #1a1a2e !important;
        color: #ffffff !important;
        border: 1px solid rgba(255, 255, 255, 0.25);
      }

      &.latest,
      &.latest:hover,
      &.latest:focus {
        color: #ffffff !important;
      }

      &.latest .hero-btn-icon {
        width: auto;
        max-width: 2.25rem;
        height: 1.125rem;
        margin-left: 0.35rem;
        flex-shrink: 0;
        filter: brightness(1.1);
        object-fit: contain;
        object-position: left center;
      }

      &.ghost {
        background-color: transparent;
        color: white;
        border: 1px solid rgba(255, 255, 255, 0.6);
      }

      &.primary:hover {
        background-color: #f5f5f5;
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
      }

      &.latest:hover {
        background-color: #0e0f1a !important;
        color: #ffffff !important;
        border-color: rgba(255, 255, 255, 0.35);
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
      }

      .hero-btn-icon {
        display: inline-block;
        vertical-align: middle;
        width: auto;
        max-width: 2rem;
        height: 1.25rem;
        margin-left: 0.35rem;
        flex-shrink: 0;
        object-fit: contain;
        object-position: left center;
      }

      &.ghost:hover {
        background-color: rgba(255, 255, 255, 0.12);
        border-color: rgba(255, 255, 255, 0.8);
        transform: translateY(-2px);
      }

      &:focus-visible {
        outline: 2px solid white;
        outline-offset: 3px;
      }
    }
  }
}

@media screen and (max-width: 768px) {
  .hero-content {
    padding: 5rem 1.25rem 3rem;
  }

  .hero-content .hero-backdrop {
    padding: 1.5rem 1.25rem;
    margin-top: -4rem;
  }

  .hero-content .hero-buttons {
    flex-direction: column;
    width: 100%;
    max-width: 280px;
    margin: 0 auto;

    .button {
      width: 100%;
    }
  }
}
</style>
