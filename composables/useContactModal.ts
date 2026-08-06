export type ContactModalPreset = {
  subject?: string
  message?: string
}

export const useContactModal = () => {
  const isOpen = useState<boolean>('contact.modal.open', () => false)
  const initialSubject = useState<string | null>('contact.modal.initialSubject', () => null)
  const initialMessage = useState<string | null>('contact.modal.initialMessage', () => null)

  const open = (preset?: string | ContactModalPreset) => {
    if (typeof preset === 'string') {
      initialSubject.value = preset
      initialMessage.value = null
    } else if (preset) {
      initialSubject.value = preset.subject ?? null
      initialMessage.value = preset.message ?? null
    } else {
      initialSubject.value = null
      initialMessage.value = null
    }
    isOpen.value = true
  }

  const close = () => {
    isOpen.value = false
    initialSubject.value = null
    initialMessage.value = null
  }

  const toggle = () => (isOpen.value = !isOpen.value)

  return { isOpen, open, close, toggle, initialSubject, initialMessage }
}
