<template>
  <section class="hero-content">
    <div class="hero-backdrop">
      <h1>Your Ideas. Our Tech. <br />Infinite Possibility.</h1>
      <p>
        Crafting solutions for creatives, educators, and visionaries ready to
        make an impact.
      </p>
      <div class="hero-buttons">
        <button class="primary">Launch Your Project</button>
        <button class="secondary">Get a Quote</button>
      </div>
    </div>
  </section>
</template>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.hero-content {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 6rem 2rem;
  min-height: 100vh;
  position: relative;
  z-index: 2;

  .hero-backdrop {
    text-align: center;
    padding: 1rem;
    backdrop-filter: blur(8px);
    background-color: rgba(0, 0, 0, 0.45);
    border-radius: 1rem;
    box-shadow: 0 0 40px rgba(0, 0, 0, 0.5);
    max-width: 900px;
    margin-top: -8rem;
    color: #fff;
  }

  h1 {
    font-family: 'Montserrat', sans-serif;
    font-size: 3.5rem;
    font-weight: 600;
    line-height: 4rem;
    margin: 0;
  }

  p {
    font-size: 1.25rem;
    margin-bottom: 2rem;
    opacity: 0.9;
  }

  .hero-buttons {
    display: flex;
    justify-content: center;
    gap: 1.5rem;

    button {
      padding: 1rem 2rem;
      font-size: 1rem;
      font-weight: 600;
      border: none;
      border-radius: 0.5rem;
      cursor: pointer;
      transition: background-color 0.2s ease;

      &.primary {
        background-color: $primary;
        color: white;
      }

      &.secondary {
        background-color: white;
        color: $primary;
      }

      &:hover {
        opacity: 0.9;
      }
    }
  }
}

@media screen and (max-width: 1024px) {
  .hero-content h1 {
    font-size: 2.5rem;
    line-height: 2.75rem;
  }

  .hero-buttons {
    flex-direction: column;
    gap: 1rem;
  }
}

@media screen and (max-width: 425px) {
  .hero-content h1 {
    font-size: 1.75rem;
    line-height: 2rem;
  }
}
</style>
