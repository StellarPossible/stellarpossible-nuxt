import { ApolloClient, InMemoryCache, HttpLink } from '@apollo/client/core'
import { DefaultApolloClient } from '@vue/apollo-composable'

export default defineNuxtPlugin((nuxtApp) => {
  const httpLink = new HttpLink({
    uri: 'https://stellarpossible.com/graphql',
  })

  const cache = new InMemoryCache()

  const apolloClient = new ApolloClient({
    link: httpLink,
    cache,
  })

  nuxtApp.vueApp.provide(DefaultApolloClient, apolloClient)
})
