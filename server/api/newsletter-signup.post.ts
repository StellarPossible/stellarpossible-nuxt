import { sendContactEmail } from '~/server/utils/email'

export default defineEventHandler(async (event) => {
  const body = await readBody<{ name?: string; email?: string }>(event)

  const name = (body.name || '').trim()
  const email = (body.email || '').trim()

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!name || !emailRegex.test(email)) {
    throw createError({ statusCode: 400, statusMessage: 'Please provide a valid name and email.' })
  }

  const message = [
    'Newsletter Signup (mstompsword) — Marine Stompsword',
    '',
    `Name: ${name}`,
    `Email: ${email}`,
    'Requested author updates and new release announcements.'
  ].join('\n')

  await sendContactEmail({
    name,
    email,
    subject: 'Newsletter Signup — Marine Stompsword (mstompsword)',
    message
  })

  return { success: true }
})
