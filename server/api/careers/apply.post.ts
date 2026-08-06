import { readMultipartFormData } from 'h3'
import { sendInquiryEmailWithAttachment } from '~/server/utils/email'

const MAX_BYTES = 5 * 1024 * 1024
const ALLOWED_EXT = ['.pdf', '.doc', '.docx']
const ALLOWED_MIME = new Set([
  'application/pdf',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
])

export default defineEventHandler(async (event) => {
  const form = await readMultipartFormData(event)
  if (!form?.length) {
    throw createError({ statusCode: 400, statusMessage: 'Invalid form data' })
  }

  const name = getField(form, 'name')
  const email = getField(form, 'email')
  const message = getField(form, 'message')
  const resume = form.find((f) => f.name === 'resume' && f.data)

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!name || !emailRegex.test(email) || !message) {
    throw createError({ statusCode: 400, statusMessage: 'Please provide a valid name, email, and message.' })
  }

  if (!resume?.data?.length) {
    throw createError({ statusCode: 400, statusMessage: 'Please attach a resume.' })
  }

  const filename = resume.filename || 'resume.pdf'
  const ext = filename.toLowerCase().slice(filename.lastIndexOf('.'))
  if (!ALLOWED_EXT.includes(ext)) {
    throw createError({ statusCode: 400, statusMessage: 'Resume must be a PDF, DOC, or DOCX file.' })
  }

  if (resume.type && !ALLOWED_MIME.has(resume.type)) {
    throw createError({ statusCode: 400, statusMessage: 'Resume file type is not allowed.' })
  }

  if (resume.data.length > MAX_BYTES) {
    throw createError({ statusCode: 400, statusMessage: 'Resume must be 5 MB or smaller.' })
  }

  await sendInquiryEmailWithAttachment({
    name,
    email,
    subject: `StellarPossible — Team application from ${name}`,
    message,
    attachment: {
      filename,
      content: resume.data,
      contentType: resume.type
    }
  })

  return { success: true }
})

function getField(form: NonNullable<Awaited<ReturnType<typeof readMultipartFormData>>>, key: string): string {
  const field = form.find((f) => f.name === key && f.data)
  if (!field?.data) return ''
  return field.data.toString('utf8').trim()
}
