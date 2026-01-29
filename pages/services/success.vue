<template>
  <section class="services-page success-page">
    <div class="hero">
      <h1>Thank you</h1>
      <p>Your subscription is active. You’ll receive a confirmation email from Stripe with billing details and how to manage your subscription.</p>
      <NuxtLink to="/services" class="cta-button">Back to Services</NuxtLink>
    </div>
  </section>
</template>

<script setup lang="ts">
useHead({
  title: 'Subscription successful | StellarPossible',
  meta: [{ name: 'description', content: 'Your subscription is active.' }]
})
</script>

<style scoped lang="scss">
.success-page {
  padding: 4rem 1.5rem 5rem;
  min-height: 50vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #fff;
  background: rgba(0, 0, 0, 0.32);
  backdrop-filter: blur(3px);
  text-align: center;

  .hero h1 {
    font-size: clamp(2rem, 4vw, 2.75rem);
    margin-bottom: 0.75rem;
  }

  .hero p {
    font-size: 1.1rem;
    line-height: 1.6;
    color: rgba(255, 255, 255, 0.88);
    max-width: 36rem;
    margin-bottom: 0;
  }

  .cta-button {
    display: inline-block;
    margin-top: 1rem;
    padding: 0.75rem 1.5rem;
    background: var(--primary-medium, #2d4558);
    color: #fff;
    font-weight: 600;
    text-decoration: none;
    border-radius: 8px;
    transition: background 0.2s;

    &:hover {
      background: var(--primary-light, #547580);
    }
  }
}
</style>
