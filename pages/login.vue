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
        <div class="form-group password-group">
          <input 
            v-model="loginForm.password" 
            placeholder="Password" 
            :type="showLoginPassword ? 'text' : 'password'" 
            required 
            autocomplete="current-password"
          />
          <span class="password-toggle" @click="showLoginPassword = !showLoginPassword">
            <Icon :icon="showLoginPassword ? 'mdi:eye-off' : 'mdi:eye'" />
          </span>
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
            placeholder="Username (3+ characters)" 
            required 
            autocomplete="username"
            minlength="3"
          />
        </div>
        <div class="form-group">
          <input 
            v-model="registerForm.email" 
            placeholder="Email Address" 
            type="email" 
            required 
            autocomplete="email"
          />
        </div>
        <div class="form-group password-group">
          <input 
            v-model="registerForm.password" 
            placeholder="Password (8+ characters)" 
            :type="showRegisterPassword ? 'text' : 'password'" 
            required 
            autocomplete="new-password"
            minlength="8"
          />
          <span class="password-toggle" @click="showRegisterPassword = !showRegisterPassword">
            <Icon :icon="showRegisterPassword ? 'mdi:eye-off' : 'mdi:eye'" />
          </span>
        </div>
        <button type="submit" :disabled="isLoading" class="submit-btn">
          {{ isLoading ? 'Creating Account...' : 'Create Account' }}
        </button>
        <p v-if="error" class="error">{{ error }}</p>
        <p v-if="success" class="success">{{ success }}</p>
      </form>
      
    <!-- Debug Info (Development Only) -->
    <div v-if="showDebug" class="debug-info">
      <button @click="loadDebugInfo" class="debug-btn">Load Debug Info</button>
      <pre v-if="debugInfo">{{ JSON.stringify(debugInfo, null, 2) }}</pre>
      
      <!-- Add WordPress connection test -->
      <WordPressTest />
    </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const isRegistering = ref(false)
const isLoading = ref(false)
const error = ref('')
const success = ref('')
const debugInfo = ref(null)
const showDebug = process.dev // Only show in development
const showLoginPassword = ref(false)
const showRegisterPassword = ref(false)

const loginForm = ref({
  username: '',
  password: ''
})

const registerForm = ref({
  username: '',
  email: '',
  password: ''
})

// Clear messages when switching forms
watch(isRegistering, () => {
  error.value = ''
  success.value = ''
  showLoginPassword.value = false
  showRegisterPassword.value = false
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
      const user = useState('auth.user')
      user.value = response.user
      await navigateTo('/')
    } else {
      error.value = response.message || 'Login failed'
    }
  } catch (err: any) {
    console.error('Login error:', err)
    error.value = err?.data?.message || 'Login failed. Please try again.'
  } finally {
    isLoading.value = false
  }
}

async function register() {
  isLoading.value = true
  error.value = ''
  success.value = ''
  
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
      success.value = response.message || 'Registration successful!'
      // Auto-login after successful registration
      setTimeout(async () => {
        loginForm.value.username = registerForm.value.username
        loginForm.value.password = registerForm.value.password
        isRegistering.value = false
        await login()
      }, 1500)
    } else {
      error.value = response.message || 'Registration failed'
    }
  } catch (err: any) {
    console.error('Registration error:', err)
    error.value = err?.data?.message || 'Registration failed. Please try again.'
  } finally {
    isLoading.value = false
  }
}

async function loadDebugInfo() {
  try {
    debugInfo.value = await $fetch('/api/auth/debug')
  } catch (err) {
    console.error('Debug info failed:', err)
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
  position: relative;
  
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

.password-group {
  position: relative;
  
  .password-toggle {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    cursor: pointer;
    color: #6c757d;
    transition: color 0.3s ease;
    
    &:hover {
      color: $primary;
    }
    
    svg {
      font-size: 1.2rem;
      width: 1.2rem;
      height: 1.2rem;
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

.success {
  color: #28a745;
  text-align: center;
  margin-top: 1rem;
  font-size: 0.9rem;
}

.debug-info {
  margin-top: 2rem;
  padding: 1rem;
  background: #f8f9fa;
  border-radius: 4px;
  max-height: 400px;
  overflow-y: auto;
  color: #495057; // Ensure dark text
}

.debug-section {
  margin-bottom: 1.5rem;
  
  &:last-child {
    margin-bottom: 0;
  }
}

.debug-btn {
  background: #6c757d;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  margin-bottom: 1rem;
  
  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }
}

.wp-test-results {
  h4 {
    color: #343a40; // Dark text for heading
    margin-bottom: 1rem;
  }
  
  p {
    color: #495057; // Dark text for paragraphs
    margin: 0.5rem 0;
  }
}

.test-item {
  margin: 1rem 0;
  padding: 0.75rem;
  border: 1px solid #dee2e6;
  border-radius: 4px;
  background: white;
}

.test-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: bold;
  margin-bottom: 0.5rem;
  
  &.success {
    color: #28a745;
  }
  
  &.failed {
    color: #dc3545;
  }
}

.test-name {
  font-size: 0.9rem;
  color: inherit; // Inherit color from parent
}

.test-data {
  background: #f8f9fa;
  padding: 0.5rem;
  border-radius: 4px;
  margin-top: 0.5rem;
  border: 1px solid #e9ecef;
  
  pre {
    margin: 0;
    font-size: 0.75rem;
    white-space: pre-wrap;
    word-break: break-word;
    color: #495057; // Dark text for code
    font-family: 'Courier New', monospace;
  }
}

.test-error {
  background: #fff5f5;
  padding: 0.5rem;
  border-radius: 4px;
  border-left: 4px solid #dc3545;
  margin-top: 0.5rem;
  
  p {
    margin: 0.25rem 0;
    font-size: 0.85rem;
    color: #721c24; // Dark red text for errors
  }
}

pre {
  background: white;
  padding: 1rem;
  border-radius: 4px;
  font-size: 0.8rem;
  overflow-x: auto;
  white-space: pre-wrap;
  word-break: break-word;
  color: #495057; // Dark text for all pre elements
  border: 1px solid #dee2e6;
  font-family: 'Courier New', monospace;
}

// Override any inherited styles that might be causing white text
.debug-info * {
  color: inherit;
}

.debug-info .test-item * {
  color: #495057;
}

.debug-info .test-header.success * {
  color: #28a745;
}

.debug-info .test-header.failed * {
  color: #dc3545;
}

.debug-info .test-error * {
  color: #721c24;
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