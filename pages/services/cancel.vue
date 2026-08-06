<template>
  <StatusPage
    variant="cancel"
    title="Checkout cancelled"
    message="You didn't complete the subscription. No charge was made. You can choose a plan anytime."
  >
    <AppButton to="/services#hosting" variant="primary">View hosting plans</AppButton>
    <AppButton to="/services" variant="ghost">Back to Services</AppButton>
  </StatusPage>
</template>

<script setup lang="ts">
useSeo({
  title: 'Checkout cancelled | StellarPossible',
  description: 'Checkout was cancelled.',
  path: '/services/cancel'
})
</script>
