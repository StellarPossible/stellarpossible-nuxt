<template>
  <section class="web-page">
    <div class="hero">
      <h1>Web Solutions for Small Businesses & Individuals</h1>
      <p>
        Whether you're looking for a simple landing page and domain setup or a full-scale multi-page site, Stellar Possible is here to walk you through (and do most of the work!) everything.
      </p>
      <p>
        We work with you, where you are at, wherever that is. Let us get to know each other, your goals and vision for the future, and begin a partnership of mutual investment.
      </p>
      <p>
        Because when you succeed, we succeed.
      </p>
      <NuxtLink class="cta-button" to="/contact">Start Your Partnership</NuxtLink>
    </div>

    <div class="packages">
      <h2>Our Packages</h2>
      <div class="package-grid">
        <article
          v-for="pkg in packages"
          :key="pkg.name"
          class="package-card"
        >
          <h3>{{ pkg.name }}</h3>
          <div class="price">{{ pkg.price }}</div>
          <p>{{ pkg.description }}</p>
          <ul>
            <li v-for="feature in pkg.features" :key="feature">{{ feature }}</li>
          </ul>
        </article>
      </div>
      <div class="addons">
        <h3>Add-Ons</h3>
        <ul>
          <li>New Domain: $50/year</li>
          <li>Additional Content Development Hours: $95/hour</li>
        </ul>
        <p class="limited-time">* Initial single page site setup is included (for a limited time) in enrollment of one of the monthly packages.</p>
      </div>
    </div>

    <section class="process">
      <h2>How We Work Together</h2>
      <div class="process-steps">
        <div v-for="step in process" :key="step.title" class="process-card">
          <span class="step-number">{{ step.order }}</span>
          <h3>{{ step.title }}</h3>
          <p>{{ step.summary }}</p>
        </div>
      </div>
    </section>

    <section class="faq">
      <h2>Web Services FAQ</h2>
      <div class="faq-items">
        <details
          v-for="item in webFaq"
          :key="item.question"
          class="faq-item"
        >
          <summary>{{ item.question }}</summary>
          <p>{{ item.answer }}</p>
        </details>
      </div>
    </section>

    <section class="client-showcase">
      <div class="client-card">
        <div class="client-header">
          <h2>Client Highlight</h2>
          <a
            :href="clientShowcase.url"
            target="_blank"
            rel="noopener noreferrer"
            class="client-link"
          >
            Visit Site
          </a>
        </div>
        <h3>{{ clientShowcase.name }}</h3>
        <p class="client-summary">{{ clientShowcase.summary }}</p>
        <div class="client-details">
          <div class="detail-group">
            <h4>What We Delivered</h4>
            <ul>
              <li v-for="item in clientShowcase.deliverables" :key="item">{{ item }}</li>
            </ul>
          </div>
          <div class="detail-group">
            <h4>Platform Highlights</h4>
            <ul>
              <li v-for="item in clientShowcase.highlights" :key="item">{{ item }}</li>
            </ul>
          </div>
        </div>
      </div>
    </section>

    <div class="final-cta">
      <h2>Ready to Build Your Online Presence?</h2>
      <p>
        From a single landing page to a comprehensive multi-page site, we're here to help you succeed online. Let's start a partnership that grows with you.
      </p>
      <NuxtLink class="cta-button" to="/contact">Get Started Today</NuxtLink>
    </div>
  </section>
</template>

<script setup lang="ts">
const packages = [
  {
    name: 'Starter Package',
    price: '$200/month',
    description: 'Perfect for small businesses or individuals starting online.',
    features: [
      '1-page site hosting',
      'Keep your existing domain',
      '2 hours of content development included',
      'Basic SEO optimization',
      'Mobile responsive design',
      'Email support'
    ]
  },
  {
    name: 'Growth Package',
    price: '$400/month',
    description: 'For businesses ready to expand their online presence.',
    features: [
      'Up to 5 pages',
      'Domain hosting included',
      '5 hours of content development',
      'Advanced SEO and analytics',
      'Contact forms and integrations',
      'Priority support'
    ]
  },
  {
    name: 'Enterprise Package',
    price: '$700/month',
    description: 'Full-scale solutions for established businesses.',
    features: [
      'Unlimited pages',
      'Custom domain setup',
      '10 hours of content development',
      'E-commerce integration',
      'Advanced analytics and reporting',
      'Dedicated account manager'
    ]
  }
]

const process = [
  {
    order: '01',
    title: 'Discovery & Partnership',
    summary:
      'We get to know you, your goals, and your vision. Understanding where you are now helps us build a roadmap for your success.'
  },
  {
    order: '02',
    title: 'Design & Development',
    summary:
      'We create and build your site, incorporating your content and ensuring it meets your needs. We handle most of the work so you can focus on your business.'
  },
  {
    order: '03',
    title: 'Launch & Support',
    summary:
      'Your site goes live, and we provide ongoing support. As your business grows, we scale with you, adding features and content as needed.'
  }
]

const webFaq = [
  {
    question: 'Do I need technical skills to get started?',
    answer:
      'Not at all! We handle all the technical aspects. You provide your content and vision, and we take care of building and maintaining your site.'
  },
  {
    question: 'Can I keep my existing domain?',
    answer:
      'Yes, if you already have a domain, we can host your site on it. If you need a new domain, we can help with that for an additional $50/year.'
  },
  {
    question: 'What if I need more content development time?',
    answer:
      'Additional content development hours are available at $95/hour. We can help with writing, editing, or any content needs for your site.'
  },
  {
    question: 'Is the initial setup really free?',
    answer:
      'For a limited time, yes! When you enroll in one of our monthly packages, the initial single-page site setup is included at no extra cost.'
  }
]

const clientShowcase = {
  name: 'Vivarium Salon',
  url: 'https://vivariumsalon.com',
  summary:
    'Vivarium Salon runs on a Nuxt headless WordPress platform hosted on our Hostinger VPS, giving their stylists and marketing crew a fast, fully managed web presence.',
  deliverables: [
    'Customer management workflows tailored for salon bookings',
    'Search-optimized content modeling and deployment pipeline',
    'Shopify storefront integration with Vivarium Salon retail'
  ],
  highlights: [
    'Scalable architecture with reusable Nuxt components',
    'Centralized content and commerce data managed by StellarPossible',
    'Robust monitoring and updates handled by our managed hosting team'
  ]
}
</script>

<style scoped lang="scss">
.web-page {
  padding: 4rem 1.5rem 5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  background: rgba(0, 0, 0, 0.35);
  backdrop-filter: blur(4px);
  color: $white;
  text-align: center;
}

.hero {
  max-width: 880px;
  margin-bottom: 4rem;

  h1 {
    font-size: 2.75rem;
    font-weight: 800;
    margin-bottom: 1rem;
  }

  p {
    font-size: 1.2rem;
    margin-bottom: 1rem;
    color: #e7f7ff;
  }

  p:last-of-type {
    margin-bottom: 2rem;
  }

  .cta-button {
    padding: 0.75rem 2.25rem;
    background: $secondary;
    color: white;
    font-weight: 700;
    border-radius: 8px;
    text-decoration: none;
    transition: background 0.3s ease;

    &:hover {
      background: #ff9330;
    }
  }
}

.packages {
  max-width: 1200px;
  width: 100%;
  margin-bottom: 4rem;

  h2 {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 2rem;
    text-align: center;
  }

  .package-grid {
    display: grid;
    gap: 2rem;
    margin-bottom: 2rem;

    @media (min-width: 768px) {
      grid-template-columns: repeat(3, 1fr);
    }
  }

  .package-card {
    background: rgba(255, 255, 255, 0.08);
    border-radius: 14px;
    padding: 2rem 1.5rem;
    text-align: left;
    color: #031524;
    box-shadow: 0 0 25px rgba(0, 0, 0, 0.18);
    display: flex;
    flex-direction: column;
    gap: 0.75rem;

    h3 {
      font-size: 1.55rem;
      font-weight: 700;
      color: $white;
    }

    .price {
      font-size: 1.5rem;
      font-weight: 800;
      color: $primary-light;
      margin-bottom: 0.5rem;
    }

    p {
      color: #dcecf6;
      line-height: 1.5;
    }

    ul {
      list-style: none;
      padding: 0;
      margin: 0;
      display: flex;
      flex-direction: column;
      gap: 0.5rem;

      li {
        position: relative;
        padding-left: 1.5rem;
        color: #f8fbff;
        line-height: 1.4;

        &::before {
          content: '•';
          position: absolute;
          left: 0;
          color: $primary-light;
          font-size: 1.4rem;
          line-height: 1;
        }
      }
    }
  }

  .addons {
    background: rgba(255, 255, 255, 0.06);
    border-radius: 12px;
    padding: 1.5rem;
    text-align: center;

    h3 {
      font-size: 1.25rem;
      font-weight: 700;
      color: $white;
      margin-bottom: 1rem;
    }

    ul {
      list-style: none;
      padding: 0;
      margin: 0 0 1rem;
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
      text-align: left;
      max-width: 400px;
      margin: 0 auto 1rem;

      li {
        color: #f8fbff;
        line-height: 1.4;
      }
    }

    .limited-time {
      font-size: 0.9rem;
      color: $primary-light;
      font-style: italic;
      margin: 0;
    }
  }
}

.client-showcase {
  max-width: 1000px;
  width: 100%;
  margin: 0 auto 4rem;
  display: flex;
  justify-content: center;

  .client-card {
    width: 100%;
    background: rgba(255, 255, 255, 0.08);
    border: 1px solid rgba(255, 179, 71, 0.25);
    border-radius: 16px;
    padding: 2rem;
    text-align: left;
    color: #06192a;
    box-shadow: 0 0 28px rgba(0, 0, 0, 0.18);
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
  }

  .client-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 1rem;

    h2 {
      font-size: 1.75rem;
      font-weight: 700;
      color: $white;
      margin: 0;
    }
  }

  .client-link {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    padding: 0.55rem 1.1rem;
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.18);
    color: #1a1a1a;
    font-weight: 600;
    text-decoration: none;
    transition: background 0.2s ease;

    &:hover {
      background: rgba(255, 255, 255, 0.3);
    }
  }

  h3 {
    font-size: 1.9rem;
    font-weight: 700;
    color: $white;
    margin: 0;
  }

  .client-summary {
    color: #e7f7ff;
    font-size: 1.1rem;
    line-height: 1.6;
    margin: 0;
  }

  .client-details {
    display: grid;
    gap: 1.5rem;

    @media (min-width: 768px) {
      grid-template-columns: repeat(2, 1fr);
    }
  }

  .detail-group {
    background: rgba(255, 255, 255, 0.06);
    border-radius: 12px;
    padding: 1.25rem;

    h4 {
      font-size: 1.1rem;
      font-weight: 700;
      color: $primary-light;
      margin-bottom: 0.75rem;
    }

    ul {
      list-style: none;
      margin: 0;
      padding: 0;
      display: flex;
      flex-direction: column;
      gap: 0.65rem;

      li {
        position: relative;
        padding-left: 1.25rem;
        color: #f8fbff;
        line-height: 1.5;

        &::before {
          content: '•';
          position: absolute;
          left: 0;
          color: $primary-light;
          font-size: 1.4rem;
          line-height: 1;
        }
      }
    }
  }
}

.process {
  max-width: 960px;
  width: 100%;
  margin-bottom: 4rem;

  h2 {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 2rem;
  }

  .process-steps {
    display: grid;
    gap: 1.5rem;

    @media (min-width: 768px) {
      grid-template-columns: repeat(3, 1fr);
    }
  }

  .process-card {
    background: rgba(255, 255, 255, 0.08);
    border-radius: 12px;
    padding: 1.75rem 1.5rem;
    text-align: left;
    color: #04131f;
    display: flex;
    flex-direction: column;
    gap: 0.75rem;

    .step-number {
      font-size: 1.25rem;
      font-weight: 700;
      color: $primary-light;
    }

    h3 {
      font-size: 1.3rem;
      font-weight: 700;
      color: #fff;
    }

    p {
      color: #dfeef8;
      line-height: 1.6;
    }
  }
}

.final-cta {
  max-width: 720px;

  h2 {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 1rem;
  }

  p {
    font-size: 1.1rem;
    margin-bottom: 2rem;
    color: #e7f7ff;
  }

  .cta-button {
    padding: 0.75rem 2.25rem;
    background: $primary-light;
    color: #1a1a1a;
    font-weight: 700;
    border-radius: 8px;
    text-decoration: none;
    transition: background 0.3s ease;

    &:hover {
      background: #ff9330;
    }
  }
}

.faq {
  max-width: 900px;
  width: 100%;
  margin-bottom: 4rem;
  text-align: left;

  h2 {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 1.5rem;
    text-align: center;
  }

  .faq-items {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  .faq-item {
    background: rgba(255, 255, 255, 0.1);
    border-radius: 12px;
    padding: 1rem 1.25rem;
    color: #f8fbff;
    border: 1px solid rgba(255, 179, 71, 0.25);

    summary {
      font-weight: 700;
      font-size: 1.1rem;
      cursor: pointer;
      list-style: none;
      display: flex;
      justify-content: space-between;
      align-items: center;

      &::marker {
        display: none;
      }

      &::after {
        content: '+';
        font-size: 1.25rem;
        margin-left: 1rem;
        transition: transform 0.2s ease;
      }
    }

    summary::-webkit-details-marker {
      display: none;
    }

    &[open] summary::after {
      content: '-';
    }

    p {
      margin-top: 0.75rem;
      line-height: 1.6;
      color: #e7f7ff;
    }
  }
}

@media (max-width: 767px) {
  .hero h1 {
    font-size: 2.25rem;
  }

  .package-grid,
  .process-steps,
  .client-details {
    grid-template-columns: 1fr;
  }
}
</style>
