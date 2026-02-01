import { onMounted } from 'vue'

export type MenuSide = 'left' | 'right'

const STORAGE_KEY = 'stellarpossible-menu-side'

export function useMenuSide() {
  const side = useState<MenuSide>('menu.side', () => 'right')

  function initFromStorage() {
    if (import.meta.client && typeof localStorage !== 'undefined') {
      try {
        const stored = localStorage.getItem(STORAGE_KEY) as MenuSide | null
        if (stored === 'left' || stored === 'right') {
          side.value = stored
        }
      } catch {
        // ignore
      }
    }
  }

  function setSide(value: MenuSide) {
    side.value = value
    if (import.meta.client && typeof localStorage !== 'undefined') {
      try {
        localStorage.setItem(STORAGE_KEY, value)
      } catch {
        // ignore
      }
    }
  }

  // Hydrate from localStorage after mount to avoid SSR/client mismatch
  onMounted(initFromStorage)

  return { menuSide: side, setMenuSide: setSide }
}
