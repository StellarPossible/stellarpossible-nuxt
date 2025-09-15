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
      failOnError: false
    },
    compatibilityDate: '2025-05-20',
  },
  
  runtimeConfig: {
    // Private keys (only available on server-side)
    wpAppPassword: process.env.WP_APP_PASSWORD,
    jwtSecret: process.env.JWT_SECRET,
    
    // Public keys (exposed to client-side)
    public: {
      wpUser: process.env.WP_USER,
      wpGraphqlEndpoint: process.env.WP_GRAPHQL_ENDPOINT,
      wpRestEndpoint: process.env.WP_REST_ENDPOINT,
      useJWT: process.env.USE_JWT || 'false'
    },
  },
})