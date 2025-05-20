<template>
    <section class="about-page">
      <div class="container">
        <h1>About Us</h1>
        <p class="intro">
          Stellar Possible is a tech solutions company focused on building scalable, secure, and human-centered digital platforms.
        </p>
  
        <div class="content">
          <h2>What We Do</h2>
          <p>
            We specialize in API-driven web architecture, modern frontend frameworks, and WordPress backend integrations. From headless CMS implementations to custom platform development, we turn complex needs into elegant solutions.
          </p>
  
          <h2>Our Philosophy</h2>
          <p>
            We believe that technology should empower — not overwhelm. That’s why we build tools that are as intuitive as they are powerful, tailored to your team's workflow and your users' experience.
          </p>
  
          <h2>Meet the Team</h2>
          <p>
            We’re a small, passionate team of engineers, designers, and problem solvers committed to delivering thoughtful and impactful digital experiences.
          </p>
        </div>
      </div>
    </section>
  </template>
  
  <script setup lang="ts">
  // Static about page — no logic required
  </script>
  
  <style scoped lang="scss">
  .about-page {
    padding: 3rem 1.5rem;
  
    .container {
      max-width: 800px;
      margin: auto;
    }
  
    h1 {
      font-size: 2.25rem;
      margin-bottom: 1rem;
    }
  
    .intro {
      font-size: 1.125rem;
      color: #444;
      margin-bottom: 2rem;
    }
  
    .content h2 {
      margin-top: 2rem;
      font-size: 1.5rem;
      color: #222;
    }
  
    .content p {
      margin-top: 0.5rem;
      line-height: 1.7;
      color: #555;
    }
  }
  </style>
  