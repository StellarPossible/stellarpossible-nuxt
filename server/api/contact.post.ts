export default defineEventHandler(async (event) => {
  const body = await readBody<{ name?: string; email?: string; subject?: string; message?: string }>(event)

  const name = (body.name || '').trim()
  const email = (body.email || '').trim()
  const subject = (body.subject || '').trim()
  const message = (body.message || '').trim()

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!name || !emailRegex.test(email) || !message) {
    throw createError({ statusCode: 400, statusMessage: 'Invalid form data' })
  }

  // TODO: Integrate with email or ticketing. For now, log to server.
  console.info('[Contact] New message received:', { name, email, subject, message: message.slice(0, 200) })

  // Simulate processing delay (optional)
  await new Promise((r) => setTimeout(r, 250))

  return { success: true }
})
