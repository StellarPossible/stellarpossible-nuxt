export default defineNuxtConfig({
  modules: [
    '@nuxt/image-edge',
  ],

  css: ['@/assets/scss/main.scss'],

  vite: {
    css: {
      preprocessorOptions: {
        scss: {
          additionalData: `@use "@/assets/scss/variables.scss" as *;`,
        },
      },
    },
  },

  devServer: {
    port: 3001,
    host: '0.0.0.0',
  },

  nitro: {
    prerender: {
      crawlLinks: true,
      routes: ['/sitemap.xml'],
      failOnError: false // This will ignore prerender errors
    },
    compatibility: {
      date: '2025-05-20',
    },
  },
  
  runtimeConfig: {
    wpAppPassword: process.env.WP_APP_PASSWORD,
    public: {
      wpUser: process.env.WP_USER,
      wpGraphqlEndpoint: process.env.WP_GRAPHQL_ENDPOINT,
    },
  },
})
