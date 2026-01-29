export default defineNuxtConfig({
  modules: [
    '@nuxt/image',
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

  // Full SSR for headless frontend
  ssr: true,

  // Route rules
  routeRules: {
    '/': { prerender: true },
    '/services': { prerender: true },
    '/services/success': { prerender: true },
    '/services/cancel': { prerender: true },
    '/login': { ssr: false },
    
    // API routes (server-side only)
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
    preset: 'node-server',
    
    prerender: {
      crawlLinks: true,
      routes: ['/sitemap.xml'],
      failOnError: false,
      ignore: ['/api/**']
    },
    compatibilityDate: '2025-01-15'
  },

  runtimeConfig: {
    // Private keys (server-side only)
    wpAppPassword: process.env.WP_APP_PASSWORD || '',
    jwtSecret: process.env.JWT_SECRET || '',
    
    // Public keys (client-side accessible)
    public: {
      siteUrl: process.env.NUXT_PUBLIC_SITE_URL || 'http://localhost:3001',
      wpUser: process.env.WP_USER || '',
      // Updated for headless CMS subdirectory
      wpGraphqlEndpoint: process.env.WP_GRAPHQL_ENDPOINT || 'https://stellarpossible.com/cms/graphql',
      wpRestEndpoint: process.env.WP_REST_ENDPOINT || 'https://stellarpossible.com/cms/wp-json',
      useJWT: process.env.USE_JWT || 'true',
      // WooCommerce store (CMS) – used for subscription/checkout links
      wooStoreUrl: process.env.WOO_STORE_URL || 'https://stellarpossible.com/cms',
      // Optional: product/variation IDs for add-to-cart links (set after creating products in WooCommerce)
      wooProductHostingId: process.env.WOO_PRODUCT_HOSTING_ID || '',
      wooVariationMonthlyId: process.env.WOO_VARIATION_MONTHLY_ID || '',
      wooVariationAnnualId: process.env.WOO_VARIATION_ANNUAL_ID || '',
      wooVariation3YearId: process.env.WOO_VARIATION_3YEAR_ID || ''
    },

    // Stripe (server-only) – for custom subscription checkout
    stripeSecretKey: process.env.STRIPE_SECRET_KEY || '',
    stripePriceMonthly: process.env.STRIPE_PRICE_MONTHLY || '',
    stripePriceAnnual: process.env.STRIPE_PRICE_ANNUAL || '',
    stripePrice3Year: process.env.STRIPE_PRICE_3YEAR || '',

    // Email/private server-side config
    emailFrom: process.env.EMAIL_FROM || '',
    emailTo: process.env.EMAIL_TO || '',
    resendApiKey: process.env.RESEND_API_KEY || ''
  },

  experimental: {
    payloadExtraction: false,
    renderJsonPayloads: true
  },

  compatibilityDate: '2025-01-15'
})