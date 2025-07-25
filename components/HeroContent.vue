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
    font-family: 'Montserrat', sans-serif;
    font-size: 3.5rem;
    font-weight: 500;
    line-height: 4rem;
  }
  p {
    font-size: 1.25rem;
    opacity: 0.85;
  }
}



@media screen and (max-width: 1024px) {
  .hero-content h1 {
    font-size: 2.5rem;
        line-height: 2.75rem;

  }
  @media screen and (max-width: 425px) {
  .hero-content h1 {
      font-size: 1.75rem;
      line-height: 2rem;    }
}
}
</style>