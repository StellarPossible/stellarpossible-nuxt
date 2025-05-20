<template>
    <section class="products-page">
      <div class="container">
        <h1>Our Products</h1>
        <p class="intro">
          We build solutions that solve real-world problems — from custom internal tools to full-scale SaaS platforms.
        </p>
  
        <ClientHighlight />
  
        <div class="products-section">
          <h2>🟢 Current Products</h2>
          <ul class="item-grid">
            <li v-for="item in currentProducts" :key="item.name">
              <NuxtImg :src="item.logo" :alt="item.name" width="100" height="100" />
              <div>
                <h3>{{ item.name }}</h3>
                <p>{{ item.description }}</p>
              </div>
            </li>
          </ul>
        </div>
  
        <div class="products-section">
          <h2>🕰 Past Projects</h2>
          <ul class="item-grid">
            <li v-for="item in pastProjects" :key="item.name">
              <NuxtImg :src="item.logo" :alt="item.name" width="100" height="100" />
              <div>
                <h3>{{ item.name }}</h3>
                <p>{{ item.description }}</p>
              </div>
            </li>
          </ul>
        </div>
  
        <div class="products-section">
          <h2>🚀 Coming Soon</h2>
          <ul class="item-grid">
            <li v-for="item in upcomingProducts" :key="item.name">
              <NuxtImg :src="item.logo" :alt="item.name" width="100" height="100" />
              <div>
                <h3>{{ item.name }}</h3>
                <p>{{ item.description }}</p>
              </div>
            </li>
          </ul>
        </div>
  
        <div class="clients-section">
          <h2>🤝 Trusted by Clients</h2>
          <ul class="logo-grid">
            <li v-for="client in clients" :key="client.name">
              <NuxtImg :src="client.logo" :alt="client.name" width="120" height="60" />
            </li>
          </ul>
        </div>
      </div>
    </section>
  </template>
  
  <script setup lang="ts">
  import ClientHighlight from '@/components/ClientHighlight.vue'
  
  const currentProducts = [
    {
      name: 'SlateBuilder',
      logo: '/images/products/slatebuilder.png',
      description: 'Drag-and-drop WooCommerce bundle builder used by hundreds of stores.',
    },
    {
      name: 'TherapySync',
      logo: '/images/products/therapysync.png',
      description: 'HIPAA-compliant mental health dashboard with scheduling and file sharing.',
    },
  ]
  
  const pastProjects = [
    {
      name: 'EventPulse',
      logo: '/images/products/eventpulse.png',
      description: 'Live event analytics platform retired in 2023 after acquisition.',
    },
  ]
  
  const upcomingProducts = [
    {
      name: 'GreenStack',
      logo: '/images/products/greenstack.png',
      description: 'Sustainability metrics and carbon reporting toolkit launching Q3 2025.',
    },
  ]
  
  const clients = [
    { name: 'Acme Corp', logo: '/images/clients/acme.png' },
    { name: 'SoundWave', logo: '/images/clients/soundwave.png' },
    { name: 'HealthBridge', logo: '/images/clients/healthbridge.png' },
  ]
  </script>
  
  <style scoped lang="scss">
  $primary: #2b6777;
  $secondary: #52ab98;
  $bg-light: #f2f2f2;
  $text: #333;
  
  .products-page {
  
    .container {
      max-width: 1000px;
      margin: auto;
    }
  
    h1 {
      font-size: 2.25rem;
      margin-bottom: 1rem;
      color: $primary;
    }
  
    .intro {
      font-size: 1.125rem;
      margin-bottom: 2.5rem;
      color: $text;
    }
  
    .products-section {
      margin-top: 3rem;
  
      h2 {
        font-size: 1.5rem;
        margin-bottom: 1.5rem;
        color: $primary;
      }
    }
  
    .clients-section {
      margin-top: 4rem;
  
      h2 {
        font-size: 1.5rem;
        margin-bottom: 1.5rem;
        text-align: center;
        color: $primary;
      }
    }
  
    .item-grid {
      display: grid;
      grid-template-columns: 1fr;
      gap: 2rem;
  
      @media (min-width: 640px) {
        grid-template-columns: 1fr 1fr;
      }
  
      li {
        display: flex;
        align-items: center;
        gap: 1rem;
        padding: 1rem;
        background: $bg-light;
        border-radius: 8px;
  
        img {
          flex-shrink: 0;
          object-fit: contain;
        }
  
        h3 {
          margin: 0 0 0.25rem;
          font-size: 1.125rem;
          color: $primary;
        }
  
        p {
          margin: 0;
          color: $text;
        }
      }
    }
  
    .logo-grid {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 2rem;
  
      li {
        background: white;
        padding: 1rem;
        border-radius: 8px;
        box-shadow: 0 0 0.5rem rgba(0, 0, 0, 0.05);
      }
    }
  }
  </style>
  