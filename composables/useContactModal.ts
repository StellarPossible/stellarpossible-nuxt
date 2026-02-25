export const useContactModal = () => {
  const isOpen = useState<boolean>('contact.modal.open', () => false)
  const initialSubject = useState<string | null>('contact.modal.initialSubject', () => null)
  const open = (subject?: string) => {
    initialSubject.value = subject ?? null
    isOpen.value = true
  }
  const close = () => {
    isOpen.value = false
    initialSubject.value = null
  }
  const toggle = () => (isOpen.value = !isOpen.value)
  return { isOpen, open, close, toggle, initialSubject }
}
