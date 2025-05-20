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
    compatibility: {
      date: '2025-05-20',
    },
  },
  runtimeConfig: {
    wpAppPassword: process.env.WP_APP_PASSWORD, // 👈 server-only
    public: {
      wpUser: process.env.WP_USER,              // 👈 exposed to client
    },
  },
})
