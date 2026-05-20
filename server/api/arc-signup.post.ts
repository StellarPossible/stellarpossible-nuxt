import { sendContactEmail } from '~/server/utils/email'

export default defineEventHandler(async (event) => {
  const body = await readBody<{ name?: string; email?: string; agreedToReview?: boolean; signupForUpdates?: boolean }>(event)

  const name = (body.name || '').trim()
  const email = (body.email || '').trim()
  const agreedToReview = body.agreedToReview === true
  const signupForUpdates = body.signupForUpdates === true

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!name || !emailRegex.test(email)) {
    throw createError({ statusCode: 400, statusMessage: 'Please provide a valid name and email.' })
  }

  if (!agreedToReview) {
    throw createError({
      statusCode: 400,
      statusMessage: 'You must agree to leave an honest review on Amazon to receive the pre-release.'
    })
  }

  const message = [
    `ARC Reader Signup (mstompsword) — What the Cold Keeps (Aurora Peak Mysteries, Book 1)`,
    ``,
    `Name: ${name}`,
    `Email: ${email}`,
    `Agreed to receive the free eBook pre-release of What the Cold Keeps in exchange for an honest review on Amazon.`,
    `Sign up for latest from Marine Stompsword + more free ARC opportunities: ${signupForUpdates ? 'Yes' : 'No'}`
  ].join('\n')

  await sendContactEmail({
    name,
    email,
    subject: 'ARC Reader Signup — What the Cold Keeps (mstompsword)',
    message
  })

  return { success: true }
})
