<template>
  <AuthShell
    :tabs="authTabs"
    :active-tab="isRegistering ? 'register' : 'login'"
    @update:active-tab="onTabChange"
  >
    <!-- Login Form -->
    <form
      v-if="!isRegistering"
      id="login-form"
      class="auth-form"
      autocomplete="off"
      @submit.prevent="login"
      @reset.prevent
    >
      <h1 class="auth-form__title">Welcome Back</h1>

      <div style="display:none">
        <input type="text" name="prevent-autofill-username" />
        <input type="password" name="prevent-autofill-password" />
      </div>

      <FormField
        v-model="loginForm.username"
        placeholder="Username (6+ characters) or Email"
        name="login-username"
        autocomplete="new-password"
        required
        :minlength="6"
        @blur="checkAutofill('login')"
      />
      <FormField
        v-model="loginForm.password"
        placeholder="Password"
        :type="showLoginPassword ? 'text' : 'password'"
        name="login-current-password"
        autocomplete="new-password"
        required
        @blur="checkAutofill('login')"
      >
        <template #suffix>
          <button
            type="button"
            class="password-toggle"
            :aria-label="showLoginPassword ? 'Hide password' : 'Show password'"
            @click="showLoginPassword = !showLoginPassword"
          >
            <Icon :icon="showLoginPassword ? 'mdi:eye-off' : 'mdi:eye'" />
          </button>
        </template>
      </FormField>
      <label class="remember-me">
        <input
          v-model="rememberMe"
          type="checkbox"
          name="remember-me"
          aria-label="Remember me on this device"
        />
        <span>Remember me</span>
      </label>
      <AppButton type="submit" variant="primary" block :disabled="isLoading">
        {{ isLoading ? 'Signing in...' : 'Sign In' }}
      </AppButton>
      <p v-if="error" class="form-feedback form-feedback--error">{{ error }}</p>
    </form>

    <!-- Register Form -->
    <form
      v-else
      id="register-form"
      class="auth-form"
      autocomplete="off"
      @submit.prevent="register"
    >
      <h1 class="auth-form__title">Create Account</h1>

      <div style="display:none">
        <input type="text" name="prevent-autofill-username-reg" />
        <input type="email" name="prevent-autofill-email-reg" />
        <input type="password" name="prevent-autofill-password-reg" />
      </div>

      <FormField
        v-model="registerForm.username"
        placeholder="Username (6+ characters)"
        name="register-new-username"
        autocomplete="new-password"
        required
        :minlength="6"
        @blur="checkAutofill('register')"
      />
      <FormField
        v-model="registerForm.email"
        placeholder="Email Address"
        type="email"
        name="register-new-email"
        autocomplete="new-password"
        required
        @blur="checkAutofill('register')"
      />
      <FormField
        v-model="registerForm.password"
        placeholder="Password (8+ characters)"
        :type="showRegisterPassword ? 'text' : 'password'"
        name="register-new-password"
        autocomplete="new-password"
        required
        :minlength="8"
        @blur="checkAutofill('register')"
      >
        <template #suffix>
          <button
            type="button"
            class="password-toggle"
            :aria-label="showRegisterPassword ? 'Hide password' : 'Show password'"
            @click="showRegisterPassword = !showRegisterPassword"
          >
            <Icon :icon="showRegisterPassword ? 'mdi:eye-off' : 'mdi:eye'" />
          </button>
        </template>
      </FormField>
      <AppButton type="submit" variant="primary" block :disabled="isLoading">
        {{ isLoading ? 'Creating Account...' : 'Create Account' }}
      </AppButton>
      <p v-if="error" class="form-feedback form-feedback--error">{{ error }}</p>
      <p v-if="success" class="form-feedback form-feedback--success">{{ success }}</p>
    </form>

    <div v-if="showDebug" class="debug-info">
      <button type="button" class="debug-btn" @click="loadDebugInfo">Load Debug Info</button>
      <pre v-if="debugInfo">{{ JSON.stringify(debugInfo, null, 2) }}</pre>
      <WordPressTest />
    </div>
  </AuthShell>
</template>

<script setup lang="ts">
const route = useRoute()
const isRegistering = ref(false)
const isLoading = ref(false)

const authTabs = [
  { id: 'login', label: 'Login' },
  { id: 'register', label: 'Create Account' }
]

onMounted(() => {
  if (route.query.tab === 'register') {
    isRegistering.value = true
  }
})

const error = ref('')
const success = ref('')
const debugInfo = ref<any>(null)
const showDebug = process.dev
const showLoginPassword = ref(false)
const showRegisterPassword = ref(false)
const rememberMe = ref(true)

const loginForm = ref({
  username: '',
  password: ''
})

const registerForm = ref({
  username: '',
  email: '',
  password: ''
})

function onTabChange(tabId: string) {
  if (tabId === 'register') switchToRegister()
  else switchToLogin()
}

function switchToLogin() {
  if (isRegistering.value) {
    error.value = ''
    success.value = ''
    showLoginPassword.value = false
    showRegisterPassword.value = false
    registerForm.value = { username: '', email: '', password: '' }
    autofillHandled.value = false
    isRegistering.value = false
    setTimeout(() => {
      loginForm.value = { username: '', password: '' }
    }, 10)
  }
}

function switchToRegister() {
  if (!isRegistering.value) {
    error.value = ''
    success.value = ''
    showLoginPassword.value = false
    showRegisterPassword.value = false
    loginForm.value = { username: '', password: '' }
    autofillHandled.value = false
    isRegistering.value = true
    setTimeout(() => {
      registerForm.value = { username: '', email: '', password: '' }
    }, 10)
  }
}

function resetAllFormFields() {
  loginForm.value = { username: '', password: '' }
  registerForm.value = { username: '', email: '', password: '' }
  showLoginPassword.value = false
  showRegisterPassword.value = false
}

const autofillHandled = ref(false)

function checkAutofill(formType: 'login' | 'register') {
  if (autofillHandled.value) return

  setTimeout(() => {
    if (
      formType === 'login' &&
      loginForm.value.username.includes('@') &&
      loginForm.value.username !== '' &&
      loginForm.value.password !== ''
    ) {
      loginForm.value = { username: '', password: '' }
      autofillHandled.value = true
    }

    if (
      formType === 'register' &&
      registerForm.value.username === registerForm.value.email &&
      registerForm.value.username !== ''
    ) {
      registerForm.value = { username: '', email: '', password: '' }
      autofillHandled.value = true
    }
  }, 50)
}

async function login() {
  isLoading.value = true
  error.value = ''

  const isEmail = loginForm.value.username.includes('@') && loginForm.value.username.includes('.')
  if (!isEmail && loginForm.value.username.length < 6) {
    error.value = 'Username must be at least 6 characters'
    isLoading.value = false
    return
  }

  try {
    const response = await $fetch('/api/auth/login', {
      method: 'POST',
      body: {
        username: loginForm.value.username,
        password: loginForm.value.password,
        rememberMe: rememberMe.value
      }
    })

    if (response.success) {
      const user = useState('auth.user')
      if ('user' in response) {
        user.value = response.user
      }
      await navigateTo('/')
    } else {
      error.value = 'message' in response ? response.message : 'Login failed'
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

  if (registerForm.value.username.length < 6) {
    error.value = 'Username must be at least 6 characters'
    isLoading.value = false
    return
  }

  try {
    const response = await $fetch('/api/auth/register', {
      method: 'POST',
      body: {
        username: registerForm.value.username,
        email: registerForm.value.email,
        password: registerForm.value.password
      }
    })

    if (response.success) {
      success.value = response.message || 'Registration successful!'
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
    debugInfo.value = await $fetch<any>('/api/auth/debug')
  } catch (err) {
    console.error('Debug info failed:', err)
  }
}

const user = useState('auth.user')
if (user.value) {
  await navigateTo('/')
}

useSeo({
  title: 'Login | StellarPossible',
  description: 'Sign in or create your StellarPossible account.',
  path: '/login'
})

onMounted(() => {
  resetAllFormFields()
  setTimeout(() => {
    resetAllFormFields()
    if (!isRegistering.value) {
      ;(document.querySelector('#login-form input[name="login-username"]') as HTMLInputElement)?.focus()
    }
  }, 100)
})
</script>

<style scoped lang="scss">
.auth-form__title {
  font-family: var(--font-display);
  font-size: var(--fs-500);
  font-weight: 500;
  text-align: center;
  margin: 0 0 var(--space-6);
  color: var(--color-text);
}

.auth-form :deep(.form-field__control) {
  position: relative;
}

.password-toggle {
  position: absolute;
  right: var(--space-3);
  top: 50%;
  transform: translateY(-50%);
  background: transparent;
  border: none;
  color: var(--color-text-muted);
  cursor: pointer;
  padding: var(--space-1);
  display: inline-flex;
  align-items: center;
  justify-content: center;

  &:hover {
    color: var(--color-accent);
  }

  &:focus-visible {
    outline: 2px solid var(--color-accent);
    outline-offset: 2px;
    border-radius: var(--radius-sm);
  }
}

.remember-me {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  margin-bottom: var(--space-5);
  cursor: pointer;
  font-size: var(--fs-200);
  color: var(--color-text-muted);
  user-select: none;

  input {
    width: 1rem;
    height: 1rem;
    accent-color: var(--color-accent);
  }
}

.form-feedback {
  text-align: center;
  margin: var(--space-4) 0 0;
  font-size: var(--fs-200);
}

.form-feedback--error {
  color: var(--color-error);
}

.form-feedback--success {
  color: var(--color-success);
}

.debug-info {
  margin-top: var(--space-6);
  padding: var(--space-4);
  background: rgba(0, 0, 0, 0.2);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  max-height: 400px;
  overflow-y: auto;
  color: var(--color-text-muted);
}

.debug-btn {
  background: var(--color-glass-solid);
  color: var(--color-text);
  border: 1px solid var(--color-border);
  padding: var(--space-2) var(--space-4);
  border-radius: var(--radius-sm);
  cursor: pointer;
  margin-bottom: var(--space-3);
  font: inherit;
}

.debug-info pre {
  background: rgba(0, 0, 0, 0.25);
  padding: var(--space-3);
  border-radius: var(--radius-sm);
  font-size: var(--fs-100);
  overflow-x: auto;
  white-space: pre-wrap;
  word-break: break-word;
  border: 1px solid var(--color-border);
}
</style>
