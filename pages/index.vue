<script setup lang="ts">
import { useQuery } from '@vue/apollo-composable'
import gql from 'graphql-tag'

const query = gql`
  query {
    posts {
      nodes {
        title
      }
    }
  }
`

const { result, loading, error } = useQuery(query)

watchEffect(() => {
  if (result.value) console.log('✅ result:', result.value)
  if (error.value) console.error('❌ error:', error.value)
})
</script>

<template>
  <div>
    <h1>Posts</h1>
    <div v-if="loading">Loading...</div>
    <ul v-else>
      <li v-for="post in result?.posts?.nodes" :key="post.title">
        {{ post.title }}
      </li>
    </ul>
  </div>
</template>
