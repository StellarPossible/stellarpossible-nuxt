import { Resend } from 'resend'

export type ContactEmail = {
  name: string
  email: string
  subject?: string
  message: string
}

export async function sendContactEmail(payload: ContactEmail) {
  const config = useRuntimeConfig()
  const from = formatFrom(config.emailFrom)
  const to = buildRecipientList(config.emailTo)
  const apiKey = config.resendApiKey

  if (!from || to.length === 0) {
    console.warn('[email] EMAIL_FROM or recipient list not configured; printing message to console instead.')
    console.info('[email] Contact message:', payload)
    return { simulated: true }
  }

  if (!apiKey) {
    console.warn('[email] RESEND_API_KEY not set; printing message to console instead.')
    console.info('[email] Contact message:', payload)
    return { simulated: true }
  }

  const resend = new Resend(apiKey)
  const subject = payload.subject?.trim() || `New contact from ${payload.name}`

  const html = `
    <div style="font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, sans-serif; line-height: 1.6;">
      <h2 style="margin: 0 0 12px;">New Contact Submission</h2>
      <p style="margin: 0 0 8px;"><strong>Name:</strong> ${escapeHtml(payload.name)}</p>
      <p style="margin: 0 0 8px;"><strong>Email:</strong> ${escapeHtml(payload.email)}</p>
      ${payload.subject ? `<p style=\"margin: 0 0 8px;\"><strong>Subject:</strong> ${escapeHtml(payload.subject)}</p>` : ''}
      <p style="margin: 12px 0 4px;"><strong>Message:</strong></p>
      <pre style="white-space: pre-wrap; margin: 0;">${escapeHtml(payload.message)}</pre>
    </div>
  `

  await resend.emails.send({
    from,
    to,
    subject,
    html
  })

  return { success: true }
}

function escapeHtml(str: string) {
  return str
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;')
}

// Ensure the From header is in an acceptable format for providers like Resend
function formatFrom(input: string): string {
  const raw = (input || '').trim()
  if (!raw) return ''
  // already formatted with angle brackets
  if (raw.includes('<') && raw.includes('>')) return raw
  // If it looks like "Name email@domain", convert to "Name <email@domain>"
  const match = raw.match(/^(.*)\s+([\w.+-]+@[\w.-]+\.[A-Za-z]{2,})$/)
  if (match) {
    const name = match[1].trim()
    const email = match[2].trim()
    if (name && email) return `${name} <${email}>`
  }
  // Otherwise return as-is (e.g., plain email address)
  return raw
}

/** All contact / ARC inquiry emails are delivered here. `EMAIL_TO` may add extra recipients. */
const INQUIRY_INBOX = 'mlvalentonis@protonmail.com'

function buildRecipientList(value: unknown): string[] {
  const configured = normalizeRecipients(value)
  const combined = [...configured]
  const lowerPrimary = INQUIRY_INBOX.toLowerCase()
  if (!combined.some((a) => a.toLowerCase() === lowerPrimary)) {
    combined.push(INQUIRY_INBOX)
  }
  const unique = new Set<string>()
  for (const address of combined) {
    const normalized = address.trim()
    if (normalized) unique.add(normalized)
  }
  return Array.from(unique)
}

function normalizeRecipients(value: unknown): string[] {
  if (!value) return []
  if (Array.isArray(value)) {
    return value
      .map((item) => (typeof item === 'string' ? item.trim() : ''))
      .filter(Boolean)
  }
  if (typeof value === 'string') {
    return value
      .split(/[;,]/)
      .map((item) => item.trim())
      .filter(Boolean)
  }
  return []
}
