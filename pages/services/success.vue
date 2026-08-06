<template>
  <StatusPage
    variant="success"
    title="Thank you"
    message="Your subscription is active. You'll receive a confirmation email from Stripe with billing details and how to manage your subscription."
  >
    <AppButton to="/services" variant="primary">Back to Services</AppButton>
    <AppButton to="/dashboard/services" variant="secondary">Manage subscription</AppButton>
  </StatusPage>
</template>

<script setup lang="ts">
useSeo({
  title: 'Subscription successful | StellarPossible',
  description: 'Your subscription is active.',
  path: '/services/success'
})
</script>
