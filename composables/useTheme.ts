import { computed, onMounted } from 'vue'

export type ThemeMode = 'dark' | 'light'

const STORAGE_KEY = 'stellarpossible-theme'

export function useTheme() {
  const theme = useState<ThemeMode>('app.theme', () => 'dark')

  function initFromStorage() {
    if (import.meta.client && typeof localStorage !== 'undefined') {
      try {
        const stored = localStorage.getItem(STORAGE_KEY) as ThemeMode | null
        if (stored === 'dark' || stored === 'light') {
          theme.value = stored
        }
      } catch {
        // ignore
      }
    }
  }

  function setTheme(value: ThemeMode) {
    theme.value = value
    if (import.meta.client && typeof localStorage !== 'undefined') {
      try {
        localStorage.setItem(STORAGE_KEY, value)
      } catch {
        // ignore
      }
    }
  }

  function toggleTheme() {
    setTheme(theme.value === 'dark' ? 'light' : 'dark')
  }

  onMounted(initFromStorage)

  return { theme, setTheme, toggleTheme, isDark: computed(() => theme.value === 'dark'), isLight: computed(() => theme.value === 'light') }
}
