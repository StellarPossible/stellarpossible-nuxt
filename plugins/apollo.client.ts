import { ApolloClient, InMemoryCache, HttpLink } from '@apollo/client/core'
import { DefaultApolloClient } from '@vue/apollo-composable'

export default defineNuxtPlugin((nuxtApp) => {
  const config = useRuntimeConfig()

  const username = config.public.wpUser
  const password = config.wpAppPassword
  const authToken = btoa(`${username}:${password}`)

  const httpLink = new HttpLink({
    uri: 'https://stellarpossible.com/graphql',
    headers: {
      Authorization: `Basic ${authToken}`, // 🔐 WP Basic Auth
      'Content-Type': 'application/json',
    },
    fetchOptions: {
      method: 'POST',
    },
  })

  const cache = new InMemoryCache()

  const apolloClient = new ApolloClient({
    link: httpLink,
    cache,
  })

  nuxtApp.vueApp.provide(DefaultApolloClient, apolloClient)
})
