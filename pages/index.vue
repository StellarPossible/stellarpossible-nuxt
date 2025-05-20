<template>
  <section class="hero">
    <div class="content">
      <h1>Tech Solutions for a Connected Future</h1>
      <p>
        We build scalable, secure, API-driven platforms using modern frameworks like Nuxt, WordPress, and GraphQL.
      </p>
      <NuxtLink to="/contact" class="cta">Get in Touch</NuxtLink>
    </div>
  </section>
</template>

<style scoped lang="scss">
.hero {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 85vh;
  text-align: center;
  background: linear-gradient(to right, #f5f8ff, #ecf3ff);

  .content {
    max-width: 700px;
    padding: 2rem;

    h1 {
      font-size: 2.5rem;
      margin-bottom: 1rem;
    }

    p {
      font-size: 1.125rem;
      margin-bottom: 2rem;
      color: #555;
    }

    .cta {
      background: var(--primary, #007bff);
      color: #fff;
      padding: 0.75rem 1.5rem;
      border-radius: 6px;
      text-decoration: none;
      font-weight: bold;
      transition: background 0.3s;

      &:hover {
        background: darken(#007bff, 10%);
      }
    }
  }
}
</style>
