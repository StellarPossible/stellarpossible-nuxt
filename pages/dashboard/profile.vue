<template>
  <div class="dashboard-profile-page">
    <header class="page-hero">
      <h1>Profile</h1>
      <p>Your account details</p>
    </header>

    <section class="dashboard-card profile-card">
      <div class="profile-avatar-wrap">
        <img :src="avatarSrc" :alt="user?.name || user?.username || 'Avatar'" class="profile-avatar-img" />
        <label class="profile-avatar-upload" :class="{ disabled: uploading }">
          <input
            ref="fileInput"
            type="file"
            accept="image/png,image/jpeg,image/jpg"
            :disabled="uploading"
            @change="onFileChange"
          />
          <Icon icon="mdi:camera" />
          <span>{{ uploading ? 'Uploading…' : 'Upload' }}</span>
        </label>
        <p v-if="avatarError" class="avatar-error">{{ avatarError }}</p>
        <p v-if="avatarSuccess" class="avatar-success">{{ avatarSuccess }}</p>
      </div>
      <div class="profile-details">
        <div class="profile-field">
          <label>Display name</label>
          <p class="profile-value">{{ user?.name || user?.username || '—' }}</p>
        </div>
        <div class="profile-field">
          <label>Email</label>
          <p class="profile-value">{{ user?.email || '—' }}</p>
        </div>
        <div class="profile-field">
          <label>Username</label>
          <p class="profile-value">{{ user?.username || '—' }}</p>
        </div>
      </div>
      <div class="profile-actions">
        <button type="button" class="profile-btn" @click="openUpdateRequest">
          <Icon icon="mdi:message-text" />
          Request profile update
        </button>
        <p class="profile-hint">Need to change your name or email? We’ll help you update your account.</p>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import type { User } from '~/types/auth'

definePageMeta({
  middleware: 'auth'
})

const user = useState<User | null>('auth.user')
const { open: openContact } = useContactModal()
const fileInput = ref<HTMLInputElement | null>(null)
const avatarError = ref('')
const avatarSuccess = ref('')
const uploading = ref(false)

const avatarSrc = computed(() => user.value?.avatar || '/default-avatar.svg')

async function onFileChange(e: Event) {
  const target = e.target as HTMLInputElement
  const file = target.files?.[0]
  if (!file) return

  avatarError.value = ''
  avatarSuccess.value = ''

  if (file.size > 1024 * 1024) {
    avatarError.value = 'File must be under 1MB'
    target.value = ''
    return
  }
  const type = file.type.toLowerCase()
  if (type !== 'image/png' && type !== 'image/jpeg' && type !== 'image/jpg') {
    avatarError.value = 'Only PNG or JPG images are allowed'
    target.value = ''
    return
  }

  uploading.value = true
  try {
    const formData = new FormData()
    formData.append('avatar', file)

    const { avatarUrl } = await $fetch<{ avatarUrl: string }>('/api/avatars/upload', {
      method: 'POST',
      body: formData
    })

    if (user.value) {
      user.value = { ...user.value, avatar: avatarUrl }
    }
    avatarSuccess.value = 'Avatar updated!'
    setTimeout(() => { avatarSuccess.value = '' }, 3000)
  } catch (e: unknown) {
    const err = e as { data?: { statusMessage?: string }; message?: string }
    avatarError.value = err?.data?.statusMessage || err?.message || 'Upload failed'
  } finally {
    uploading.value = false
    target.value = ''
  }
}

function openUpdateRequest() {
  openContact('Profile update request')
}

useHead({
  title: 'Profile | Dashboard | StellarPossible',
  meta: [{ name: 'description', content: 'Manage your profile.' }]
})
</script>

<style scoped lang="scss">
.dashboard-profile-page {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.page-hero {
  margin-bottom: 1.5rem;
  color: white;

  h1 {
    font-size: clamp(1.5rem, 2.5vw, 1.9rem);
    font-family: 'Evermore', 'Inter', sans-serif;
    margin: 0 0 0.35rem;
    font-weight: 400;
  }

  p {
    font-size: 0.95rem;
    opacity: 0.9;
    margin: 0;
  }
}

.profile-card {
  max-width: 480px;
  padding: 2rem;
}

.profile-avatar-wrap {
  position: relative;
  margin-bottom: 1.5rem;
}

.profile-avatar-img {
  width: 96px;
  height: 96px;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid rgba(102, 126, 234, 0.2);
  display: block;
}

.profile-avatar-upload {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  margin-top: 0.75rem;
  padding: 0.4rem 0.75rem;
  font-size: 0.85rem;
  font-weight: 600;
  color: #4c5fd5;
  background: rgba(102, 126, 234, 0.1);
  border: 1px solid rgba(102, 126, 234, 0.25);
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s, border-color 0.2s;

  &:hover {
    background: rgba(102, 126, 234, 0.15);
    border-color: rgba(102, 126, 234, 0.35);
  }

  input {
    position: absolute;
    width: 0;
    height: 0;
    opacity: 0;
  }

  &.disabled {
    opacity: 0.7;
    pointer-events: none;
  }

  :deep(svg) {
    width: 18px;
    height: 18px;
  }
}

.avatar-error {
  margin: 0.5rem 0 0;
  font-size: 0.85rem;
  color: #dc2626;
}

.avatar-success {
  margin: 0.5rem 0 0;
  font-size: 0.85rem;
  color: #16a34a;
}

.profile-details {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.profile-field {
  label {
    display: block;
    font-size: 0.75rem;
    font-weight: 600;
    color: #868e96;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    margin-bottom: 0.25rem;
  }
}

.profile-value {
  margin: 0;
  font-size: 1rem;
  color: #1a1a2e;
}

.profile-actions {
  padding-top: 1.5rem;
  border-top: 1px solid rgba(0, 0, 0, 0.06);
}

.profile-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.6rem 1rem;
  font-size: 0.9rem;
  font-weight: 600;
  color: #4c5fd5;
  background: rgba(102, 126, 234, 0.1);
  border: 1px solid rgba(102, 126, 234, 0.25);
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s, border-color 0.2s;

  &:hover {
    background: rgba(102, 126, 234, 0.15);
    border-color: rgba(102, 126, 234, 0.35);
  }

  :deep(svg) {
    width: 18px;
    height: 18px;
  }
}

.profile-hint {
  margin: 0.5rem 0 0;
  font-size: 0.8rem;
  color: #6c757d;
}
</style>
