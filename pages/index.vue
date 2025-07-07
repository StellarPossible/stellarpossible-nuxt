<template>
  <div>
    <header v-if="data?.generalSettings">
      <h1>{{ data.generalSettings.title }}</h1>
      <p v-if="data.generalSettings.description">{{ data.generalSettings.description }}</p>
    </header>
    
    <div v-if="pending">
      Loading...
    </div>
    
    <div v-if="error" class="error">
      Error: {{ error.message }}
    </div>
    
    <main>
      <GalacticNetwork />
    </main>
  </div>
</template>

<script setup>
import { useQuery } from '@vue/apollo-composable'
import { gql } from '@apollo/client/core'

// Simple query to get WordPress site title
const GET_SITE_INFO = gql`
  query GetSiteInfo {
    generalSettings {
      title
      description
    }
  }
`

const { result: data, loading: pending, error } = useQuery(GET_SITE_INFO)
</script>
