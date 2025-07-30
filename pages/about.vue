<template>
  <section class="about-page">
    <div class="about-panel">
      <h1>About Us</h1>
      <div class="section">
        <h2><span class="icon">🔧</span> What We Do</h2>
        <p>
          We specialize in API-driven web architecture, modern frontend frameworks, and WordPress backend integrations. From headless CMS implementations to custom platform development, we turn complex needs into elegant solutions.
        </p>
      </div>
      <div class="section">
        <h2><span class="icon">💡</span> Our Philosophy</h2>
        <p>
          We believe that technology should empower — not overwhelm. That’s why we build tools that are as intuitive as they are powerful, tailored to your team's workflow and your users' experience.
        </p>
      </div>
      <div class="section">
        <h2><span class="icon">🧑‍🚀</span> Meet the Team</h2>
        <p>
          We’re a small, passionate team of engineers, designers, and problem solvers committed to delivering thoughtful and impactful digital experiences.
        </p>
      </div>
      <div class="cta">
        <h3>Want to Work with Us?</h3>
        <NuxtLink to="/contact" class="cta-button">Let’s Talk</NuxtLink>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
// Static about page — no logic required
</script>

<style scoped lang="scss">
.about-page {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  padding: 4rem 1rem;
  background: rgba(0, 0, 0, 0.4);
  backdrop-filter: blur(4px);
}

.about-panel {
  background: rgba(0, 0, 0, 0.65);
  padding: 3rem;
  border-radius: 1rem;
  max-width: 900px;
  color: #fff;
  width: 100%;
  box-shadow: 0 0 30px rgba(0, 0, 0, 0.4);
}

h1 {
  font-size: 2.5rem;
  font-weight: 800;
  color: #00d1ff;
  margin-bottom: 2rem;
}

.section {
  margin-bottom: 2rem;
}

.section h2 {
  font-size: 1.5rem;
  font-weight: 700;
  color: #ffffff;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
}

.section p {
  font-size: 1.1rem;
  line-height: 1.7;
  color: #e2e2e2;
}

.cta {
  margin-top: 3rem;
  text-align: center;
}

.cta h3 {
  font-size: 1.4rem;
  margin-bottom: 1rem;
}

.cta-button {
  display: inline-block;
  padding: 0.75rem 2rem;
  font-weight: 600;
  font-size: 1rem;
  color: #000;
  background-color: #00d1ff;
  border-radius: 8px;
  text-decoration: none;
  transition: background-color 0.3s;
}

.cta-button:hover {
  background-color: #00a3cc;
}
</style>
