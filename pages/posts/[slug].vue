<script setup lang="ts">
import { useRoute } from 'vue-router'
import gql from 'graphql-tag'
import { useAsyncQuery } from '@vue/apollo-composable'

const route = useRoute()
const slug = route.params.slug

const { result, loading, error } = useAsyncQuery(gql`
  query ($slug: ID!) {
    post(id: $slug, idType: SLUG) {
      title
      content
      featuredImage {
        node {
          sourceUrl
        }
      }
    }
  }
`, { slug })
</script>

<template>
  <article class="post">
    <div v-if="loading">Loading post...</div>
    <div v-if="error">Error loading post.</div>

    <template v-if="result?.post">
      <h1>{{ result.post.title }}</h1>
      <NuxtImg
        v-if="result.post.featuredImage"
        :src="result.post.featuredImage.node.sourceUrl"
        width="800"
        height="400"
        alt=""
      />
      <div v-html="result.post.content" class="post-content" />
    </template>
  </article>
</template>

<style scoped lang="scss">
.post {
  padding: 2rem;

  h1 {
    font-size: 2rem;
    margin-bottom: 1rem;
  }

  .post-content {
    line-height: 1.7;
    font-size: 1rem;

    img {
      max-width: 100%;
    }
  }
}
</style>
