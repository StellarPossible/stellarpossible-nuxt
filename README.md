# Stellar Possible — Headless Nuxt 3 + TypeScript Frontend

This project is a fully headless, API-driven frontend for a **tech solutions website**, built using **Nuxt 3 with TypeScript**. It connects to a secure **WordPress + WPGraphQL** backend and renders content using authenticated GraphQL requests.

- ⚙️ Powered by [Nuxt 3](https://nuxt.com/) + [TypeScript](https://www.typescriptlang.org/)
- 🔐 Authenticated GraphQL via [Apollo Client](https://www.apollographql.com/docs/react/)
- 📸 Optimized image delivery with `@nuxt/image-edge`
- 🎨 SCSS theming with modular variables and global styles
- 🧠 Dynamic content routing via WordPress slugs

---

## 🧱 Tech Stack

| Tech                | Role                                 |
|---------------------|--------------------------------------|
| Nuxt 3              | Application framework (SSR/SSG)      |
| TypeScript          | Type-safe development                |
| WordPress + WPGraphQL| CMS and content API                 |
| Apollo Client       | Secure GraphQL data fetching         |
| SCSS                | Custom styles and theming            |
| @nuxt/image-edge    | Optimized, responsive images         |

---

## 🔐 Authentication

This frontend uses **Basic Auth via WP Application Passwords** to securely query the WordPress GraphQL API.

Create a `.env` file in the project root:

```env
WP_USER=your_wp_username
WP_APP_PASSWORD=your_app_password
