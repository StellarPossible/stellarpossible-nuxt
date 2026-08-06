import { enrichAuthorBooks } from '~/server/utils/author-books-enrich'

export default defineCachedEventHandler(
  async () => {
    const books = await enrichAuthorBooks()
    return { books }
  },
  {
    maxAge: 60 * 60 * 24,
    name: 'author-books',
    swr: true
  }
)
