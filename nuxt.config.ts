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

  // Add route rules to fix the JavaScript errors
  routeRules: {
    // Static pages
    '/': { prerender: true },
    '/about': { prerender: true },
    '/contact': { prerender: true },
    '/products': { prerender: true },
    '/blog': { isr: true },
    
    // Authentication pages (SPA mode for dynamic state)
    '/login': { ssr: false },
    '/register': { ssr: false },
    
    // API routes
    '/api/**': { 
      cors: true,
      headers: { 
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization'
      }
    }
  },

  nitro: {
    prerender: {
      crawlLinks: true,
      routes: ['/sitemap.xml'],
      failOnError: false
    },
    compatibilityDate: '2025-01-15',
    
    // Additional nitro route rules for production
    routeRules: {
      '/api/**': { 
        cors: true,
        headers: { 
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization'
        }
      }
    }
  },

  runtimeConfig: {
    // Private keys (only available on server-side)
    wpAppPassword: process.env.WP_APP_PASSWORD || '',
    jwtSecret: process.env.JWT_SECRET || '',
    
    // Public keys (exposed to client-side)
    public: {
      wpUser: process.env.WP_USER || '',
      wpGraphqlEndpoint: process.env.WP_GRAPHQL_ENDPOINT || 'https://stellarpossible.com/graphql',
      wpRestEndpoint: process.env.WP_REST_ENDPOINT || 'https://stellarpossible.com/wp-json',
      useJWT: process.env.USE_JWT || 'false'
    },
  },

  // Add experimental features for better stability
  experimental: {
    payloadExtraction: false,
    renderJsonPayloads: true
  },

  // Ensure compatibility
  compatibilityDate: '2025-01-15'
})