<template>
    <form @submit.prevent="register">
      <h1>Create an Account</h1>
      <input v-model="username" placeholder="Username" required />
      <input v-model="email" placeholder="Email" type="email" required />
      <input v-model="password" placeholder="Password" type="password" required />
      <button type="submit">Register</button>
      <p v-if="error">{{ error }}</p>
    </form>
  </template>
  
  <script setup lang="ts">
  const username = ref('')
  const email = ref('')
  const password = ref('')
  const error = ref('')
  
  async function register() {
    try {
      await $fetch('https://stellarpossible.com/wp-json/wp/v2/users/register', {
        method: 'POST',
        body: {
          username: username.value,
          email: email.value,
          password: password.value,
        },
      })
  
      // Now log the user in immediately
      await navigateTo('/login')
    } catch (err: any) {
      error.value = err?.data?.message || 'Registration failed'
    }
  }
  </script>
  