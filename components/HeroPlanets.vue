<template>
    <section class="hero" @mousemove="handleMouseMove">
      <svg class="galactic-network" viewBox="0 0 1600 900" preserveAspectRatio="xMidYMid slice">
        <!-- Orbit ring -->
        <circle cx="800" cy="450" r="120" stroke="rgba(255,255,255,0.1)" stroke-width="1" fill="none" />
  
        <!-- Central Home Planet -->
        <a :href="planets[0].link">
          <image
            :href="planets[0].icon"
            x="744"
            y="394"
            width="112"
            height="112"
            class="planet-icon"
          />
          <text x="800" y="480" text-anchor="middle" class="planet-label">
            {{ planets[0].name }}
          </text>
        </a>
  
        <!-- Orbiting Planets -->
        <line
          v-for="(line, index) in connectionLines"
          :key="index"
          :x1="line.x1"
          :y1="line.y1"
          :x2="line.x2"
          :y2="line.y2"
          class="connection-line"
        />
  
        <g
          v-for="planet in planets.slice(1)"
          :key="planet.id"
          class="orbit-group"
          :style="getOrbitStyle(planet)"
        >
          <g
            class="planet-group"
            :transform="`rotate(${-getAngle(planet)}deg)`"
          >
            <a :href="planet.link">
              <image
                v-if="planet.icon"
                :href="planet.icon"
                :x="800 + planet.x - 56"
                :y="450 + planet.y - 56"
                width="112"
                height="112"
                class="planet-icon"
                :class="{ 'planet-active': hovered === planet.id }"
                @mouseover="hovered = planet.id"
                @mouseleave="hovered = null"
              />
              <text
                :x="800 + planet.x"
                :y="450 + planet.y + 70"
                text-anchor="middle"
                class="planet-label"
              >
                {{ planet.name }}
              </text>
            </a>
          </g>
        </g>
      </svg>
    </section>
  </template>
  
  <script setup>
  import { ref } from 'vue'
  
  const hovered = ref(null)
  const cursor = ref({ x: 800, y: 450 })
  
  function handleMouseMove(e) {
    const bounds = e.currentTarget.getBoundingClientRect()
    cursor.value = {
      x: e.clientX - bounds.left,
      y: e.clientY - bounds.top
    }
  }
  
  const baseRadius = 120
  const planets = [
    { id: 'home', name: 'Home', link: '/', angle: 0, radius: 0, icon: '/images/planets/education.png' },
    { id: 'about', name: 'About', link: '/about', angle: 0, radius: baseRadius, icon: '/images/planets/education.png' },
    { id: 'products', name: 'Products', link: '/products', angle: 60, radius: baseRadius, icon: '/images/planets/education.png' },
    { id: 'education', name: 'Education', link: '/blog', angle: 120, radius: baseRadius, icon: '/images/planets/education.png' },
    { id: 'contact', name: 'Contact', link: '/contact', angle: 180, radius: baseRadius, icon: '/images/planets/education.png' },
    { id: 'login', name: 'Login', link: '/login', angle: 240, radius: baseRadius, icon: '/images/planets/education.png' }
  ]
  
  planets.forEach(p => {
    if (p.radius === 0) {
      p.x = 0
      p.y = 0
    } else {
      const rad = (p.angle * Math.PI) / 180
      p.x = Math.cos(rad) * p.radius
      p.y = Math.sin(rad) * p.radius
    }
  })
  
  const connectionLines = planets.slice(1).map(p => ({
    x1: 800,
    y1: 450,
    x2: 800 + p.x,
    y2: 450 + p.y
  }))
  
  function getAngle(planet) {
    return Math.atan2(planet.y, planet.x) * (180 / Math.PI)
  }
  
  function getOrbitStyle(planet) {
    const dx = planet.x
    const dy = planet.y
    const dist = Math.sqrt(dx * dx + dy * dy)
    const dirX = (cursor.value.x - (800 + dx)) * 0.005
    const dirY = (cursor.value.y - (450 + dy)) * 0.005
  
    return {
      transformOrigin: '800px 450px',
      animation: `orbit-${planet.id} 60s linear infinite`,
      transform: `rotate(0deg) translate(${dist + dirX}px, ${dirY}px)`
    }
  }
  </script>
  
  <style scoped lang="scss">
  
  .hero {
  position: relative;
  height: 100vh;
  overflow: hidden;

  // Apply radial fade-out mask
  mask-image: radial-gradient(
    ellipse at center,
    rgba(0, 0, 0, 1) 45%,
    rgba(0, 0, 0, 0.6) 70%,
    rgba(0, 0, 0, 0) 100%
  );
  -webkit-mask-image: radial-gradient(
    ellipse at center,
    rgba(0, 0, 0, 1) 45%,
    rgba(0, 0, 0, 0.6) 70%,
    rgba(0, 0, 0, 0) 100%
  );

  // Remove composite lines (unnecessary for your use case)
  mask-composite: exclude;
  -webkit-mask-composite: destination-in;

  &::before {
    content: '';
    position: absolute;
    inset: 0;
    z-index: -1;

    background: var(--primary-color, #0e0f1a) url('/images/primary/galaxyBackground.webp') no-repeat center center;
    background-size: cover;
  }
}

  .galactic-network {
    width: 100%;
    height: 100%;
  }
  
  .planet-icon {
    transition: transform 0.3s ease, filter 0.3s ease;
  }
  
  .planet-active {
    transform: scale(1.3);
    filter: drop-shadow(0 0 20px #4da6ff);
  }
  
  .planet-label {
    fill: white;
    font-size: 16px;
    font-family: 'Montserrat', sans-serif;
    pointer-events: none;
  }
  
  .connection-line {
    stroke: rgba(255, 255, 255, 0.1);
    stroke-width: 1;
  }
  
  @keyframes orbit-about {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }
  @keyframes orbit-products {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }
  @keyframes orbit-education {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }
  @keyframes orbit-contact {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }
  @keyframes orbit-login {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }
  </style>
  