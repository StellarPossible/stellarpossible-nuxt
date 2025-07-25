<template>
  <section class="hero-content">
    <h1>Your Ideas. Our Tech. <br>Infinite Possibility.</h1>
  </section>
</template>

<style scoped lang="scss">
.hero-content {
  text-align: center;
  color: #fff;
  h1 {
    font-family: 'OrionSans', 'Inter', sans-serif;
    font-size: 7rem;
    margin-bottom: 1rem;
  }
  p {
    font-size: 1.25rem;
    opacity: 0.85;
  }
}
@media screen and (max-width: 1024px) {
  .hero-content h1 {
    font-size: 4.5rem;
  }
  @media screen and (max-width: 425px) {
    .hero-content h1 {
      font-size: 2.5rem;
    }
  }
  
}
</style>