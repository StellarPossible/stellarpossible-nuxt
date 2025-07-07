<template>
    <section class="hero-section">
      <svg class="galactic-network" viewBox="0 0 1600 900" preserveAspectRatio="xMidYMid slice">
        <!-- Lines -->
        <line
          v-for="(line, index) in connectionLines"
          :key="index"
          :x1="line.x1"
          :y1="line.y1"
          :x2="line.x2"
          :y2="line.y2"
          class="connection-line"
        />
  
        <!-- Planets -->
        <g v-for="planet in planets" :key="planet.id">
          <a :href="planet.link">
            <circle
              class="planet"
              :cx="planet.x"
              :cy="planet.y"
              r="28"
              @mouseover="hovered = planet.id"
              @mouseleave="hovered = null"
              :class="{ active: hovered === planet.id }"
            />
            <text
              :x="planet.x"
              :y="planet.y + 45"
              text-anchor="middle"
              class="planet-label"
            >
              {{ planet.name }}
            </text>
          </a>
        </g>
      </svg>
    </section>
  </template>
  
  <script setup lang="ts">
  import { ref, computed } from 'vue'
  
  interface Planet {
    id: number
    name: string
    link: string
    x: number
    y: number
  }
  
  const hovered = ref<number | null>(null)
  
  // Positions are mapped to elements in the image
  const planets: Planet[] = [
    { id: 1, name: 'Home', link: '/', x: 800, y: 450 },       // center of galaxy
    { id: 2, name: 'About', link: '/about', x: 1120, y: 270 }, // upper right moon
    { id: 3, name: 'Products', link: '/products', x: 600, y: 650 }, // lower left nebula
    { id: 4, name: 'Education', link: '/education', x: 1280, y: 650 }, // bottom right planet
    { id: 5, name: 'Contact', link: '/contact', x: 280, y: 270 }, // upper left
    { id: 6, name: 'Login', link: '/login', x: 900, y: 180 }     // top middle orb
  ]
  
  const connectionLines = computed(() =>
    planets.flatMap((p1, i) =>
      planets.slice(i + 1).map((p2) => ({
        x1: p1.x,
        y1: p1.y,
        x2: p2.x,
        y2: p2.y
      }))
    )
  )
  </script>
  
  <style scoped lang="scss">
  header {
  height: var(--header-height, 100px); // fallback
}
  .hero-section {
    height: calc(100vh - var(--header-height, 100px));
    position: relative;
    width: 100vw;
    background-image: url('/images/primary/galaxyBackground.webp');
    background-size: cover;               // fills full width, crops vertically if needed
    background-position: center center;   // centers the galaxy horizontally AND vertically
    background-repeat: no-repeat;
    background-color: black;              // fallback
    overflow: hidden;
}

  
  .galactic-network {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }
  
  .connection-line {
    stroke: rgba(73, 161, 209, 0.2);
    stroke-width: 1;
  }
  
  .planet {
    fill: #49a1d1;
    stroke: white;
    stroke-width: 2;
    cursor: pointer;
    transition: all 0.3s ease;
    filter: drop-shadow(0 0 5px #49a1d1aa);
  }
  
  .planet.active {
    transform: scale(1.2);
    filter: drop-shadow(0 0 15px #49a1d1);
  }
  
  .planet-label {
    fill: white;
    font-size: 16px;
    font-family: 'Montserrat', sans-serif;
    pointer-events: none;
  }
  </style>
  