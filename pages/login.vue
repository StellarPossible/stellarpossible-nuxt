<template>
  <div class="auth-container">
    <div class="auth-card">
      <div class="auth-tabs">
        <button 
          :class="{ active: !isRegistering }" 
          @click="isRegistering = false"
        >
          Login
        </button>
        <button 
          :class="{ active: isRegistering }" 
          @click="isRegistering = true"
        >
          Register
        </button>
      </div>

      <!-- Login Form -->
      <form v-if="!isRegistering" @submit.prevent="login" class="auth-form">
        <h1>Welcome Back</h1>
        <div class="form-group">
          <input 
            v-model="loginForm.username" 
            placeholder="Username or Email" 
            required 
            autocomplete="username"
          />
        </div>
        <div class="form-group">
          <input 
            v-model="loginForm.password" 
            placeholder="Password" 
            type="password" 
            required 
            autocomplete="current-password"
          />
        </div>
        <button type="submit" :disabled="isLoading" class="submit-btn">
          {{ isLoading ? 'Signing in...' : 'Sign In' }}
        </button>
        <p v-if="error" class="error">{{ error }}</p>
      </form>

      <!-- Register Form -->
      <form v-else @submit.prevent="register" class="auth-form">
        <h1>Create Account</h1>
        <div class="form-group">
          <input 
            v-model="registerForm.username" 
            placeholder="Username" 
            required 
            autocomplete="username"
          />
        </div>
        <div class="form-group">
          <input 
            v-model="registerForm.email" 
            placeholder="Email" 
            type="email" 
            required 
            autocomplete="email"
          />
        </div>
        <div class="form-group">
          <input 
            v-model="registerForm.password" 
            placeholder="Password" 
            type="password" 
            required 
            autocomplete="new-password"
          />
        </div>
        <button type="submit" :disabled="isLoading" class="submit-btn">
          {{ isLoading ? 'Creating Account...' : 'Create Account' }}
        </button>
        <p v-if="error" class="error">{{ error }}</p>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
const isRegistering = ref(false)
const isLoading = ref(false)
const error = ref('')

const loginForm = ref({
  username: '',
  password: ''
})

const registerForm = ref({
  username: '',
  email: '',
  password: ''
})

// Clear error when switching forms
watch(isRegistering, () => {
  error.value = ''
})

async function login() {
  isLoading.value = true
  error.value = ''
  
  try {
    const response = await $fetch('/api/auth/login', {
      method: 'POST',
      body: {
        username: loginForm.value.username,
        password: loginForm.value.password,
      },
    })

    if (response.success) {
      // Store user data in session
      const user = useState('auth.user')
      user.value = response.user
      
      // Redirect to dashboard or home
      await navigateTo('/')
    } else {
      error.value = response.message || 'Login failed'
    }
  } catch (err: any) {
    error.value = err?.data?.message || 'Login failed. Please try again.'
  } finally {
    isLoading.value = false
  }
}

async function register() {
  isLoading.value = true
  error.value = ''
  
  try {
    const response = await $fetch('/api/auth/register', {
      method: 'POST',
      body: {
        username: registerForm.value.username,
        email: registerForm.value.email,
        password: registerForm.value.password,
      },
    })

    if (response.success) {
      // Auto-login after successful registration
      loginForm.value.username = registerForm.value.username
      loginForm.value.password = registerForm.value.password
      isRegistering.value = false
      await login()
    } else {
      error.value = response.message || 'Registration failed'
    }
  } catch (err: any) {
    error.value = err?.data?.message || 'Registration failed. Please try again.'
  } finally {
    isLoading.value = false
  }
}

// Redirect if already logged in
const user = useState('auth.user')
if (user.value) {
  await navigateTo('/')
}
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.auth-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  background: linear-gradient(135deg, $primary 0%, darken($primary, 10%) 100%);
}

.auth-card {
  background: white;
  border-radius: 12px;
  padding: 0;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
  overflow: hidden;
}

.auth-tabs {
  display: flex;
  background: #f8f9fa;
  
  button {
    flex: 1;
    padding: 1rem;
    border: none;
    background: transparent;
    font-weight: 600;
    color: #6c757d;
    cursor: pointer;
    transition: all 0.3s ease;
    
    &.active {
      background: white;
      color: $primary;
      border-bottom: 2px solid $primary;
    }
    
    &:hover:not(.active) {
      background: #e9ecef;
    }
  }
}

.auth-form {
  padding: 2rem;
  
  h1 {
    text-align: center;
    margin-bottom: 2rem;
    color: $primary;
    font-size: 1.8rem;
  }
}

.form-group {
  margin-bottom: 1.5rem;
  
  input {
    width: 100%;
    padding: 0.75rem;
    border: 2px solid #e9ecef;
    border-radius: 8px;
    font-size: 1rem;
    transition: border-color 0.3s ease;
    
    &:focus {
      outline: none;
      border-color: $primary;
    }
    
    &::placeholder {
      color: #6c757d;
    }
  }
}

.submit-btn {
  width: 100%;
  padding: 0.75rem;
  background: $primary;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.3s ease;
  
  &:hover:not(:disabled) {
    background: darken($primary, 10%);
  }
  
  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }
}

.error {
  color: #dc3545;
  text-align: center;
  margin-top: 1rem;
  font-size: 0.9rem;
}

@media (max-width: 480px) {
  .auth-container {
    padding: 1rem;
  }
  
  .auth-form {
    padding: 1.5rem;
  }
}
</style>