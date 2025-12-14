<template>
  <section class="web-page">
    <div class="hero">
      <h1>Simple, Managed Websites That Help You Grow</h1>
      <p class="subhead">Get a fast, secure, and easy-to-manage site—without the headaches. We handle hosting, updates, and the technical work so you can focus on customers and content.</p>

      <ul class="hero-benefits">
        <li>Launch faster: single-page sites in days, multi-page in weeks</li>
        <li>Managed hosting & security so you don't have to worry</li>
        <li>Ongoing updates & a monthly support window that scales with you</li>
      </ul>

      <div class="hero-ctas">
        <NuxtLink class="cta-button primary" to="/contact?source=web&audit=true">Get a Free Site Audit</NuxtLink>
        <NuxtLink class="cta-button ghost" to="#packages">See Packages</NuxtLink>
      </div>
    </div>

    <div class="packages">
      <h2>Our Packages</h2>
      <div id="packages" class="package-grid">
        <article
          v-for="pkg in packages"
          :key="pkg.name"
          class="package-card"
        >
          <div class="card-top">
            <h3>{{ pkg.name }}</h3>
            <span v-if="pkg.popular" class="badge">Most Popular</span>
          </div>
          <div class="price">{{ pkg.price }}</div>
          <p class="pkg-lead">{{ pkg.description }}</p>
          <ul>
            <li v-for="feature in pkg.features" :key="feature">{{ feature }}</li>
          </ul>
          <div class="card-actions">
            <NuxtLink class="cta-button small" :to="`/contact?package=${encodeURIComponent(pkg.name)}`">Choose {{ pkg.name }}</NuxtLink>
            <NuxtLink class="link-secondary" :to="`/contact?package=${encodeURIComponent(pkg.name)}&quote=true`">Request a Quote</NuxtLink>
          </div>
        </article>
      </div>
      <div class="addons">
        <h3>Add-Ons</h3>
        <ul>
          <li>New Domain: $50/year</li>
          <li>Additional web development support: $85/hour</li>
          <li>Custom software development: $115/hour</li>
        </ul>
        <p class="limited-time">* Initial single page site setup is included (for a limited time) in enrollment of one of the monthly packages.</p>
      </div>
      <div class="hourly-overview">
        <h3>Hourly Services</h3>
        <div class="hourly-grid">
          <article class="hourly-card">
            <h4>Web Development — $85/hour</h4>
            <ul>
              <li>Configuring WordPress themes, plugins, and hosting</li>
              <li>Content updates and minor UX adjustments</li>
              <li>Performance tuning or accessibility fixes</li>
            </ul>
          </article>
          <article class="hourly-card">
            <h4>Custom Software — $115/hour</h4>
            <ul>
              <li>New feature development in Nuxt, Vue, or backend services</li>
              <li>API integrations, automations, or data workflows</li>
              <li>Architectural consulting and ongoing product support</li>
            </ul>
          </article>
        </div>
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

    <section class="trust">
      <h2>Trusted by Small Businesses</h2>
      <div class="trust-inner">
        <div class="testimonial">
          <blockquote>“Vivarium Salon's site is fast and easy for our stylists to update. StellarPossible manages everything so our team can focus on bookings.”</blockquote>
          <cite>— Vivarium Salon</cite>
        </div>
        <div class="trust-links">
          <a :href="clientShowcase.url" target="_blank" rel="noopener noreferrer">Visit Vivarium Salon</a>
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

    <div id="contact" class="final-cta">
      <h2>Ready to Build Your Online Presence?</h2>
      <p>
        From a single landing page to a comprehensive multi-page site, we're here to help you succeed online. Let's start a partnership that grows with you.
      </p>
      <NuxtLink class="cta-button primary" to="/contact?source=web">Get Started Today</NuxtLink>
    </div>
  </section>
</template>

<script setup lang="ts">
const packages = [
  {
    name: 'Starter Package',
    price: '$150/month',
    description: 'Managed essentials for a single-page presence and quick updates.',
    features: [
      '1 professionally managed page',
      '1 hour of monthly development support',
      'Basic monthly updates',
      'Managed hosting and updates',
      'Basic SEO optimization',
      'Mobile responsive design'
    ]
  },
  {
    name: 'Growth Package',
    price: '$350/month',
    description: 'Expand your presence with more pages and hands-on updates.',
    features: [
      'Up to 5 managed pages',
      '3 hours of monthly development support',
      'Managed hosting and staging',
      'Advanced SEO and analytics',
      'Priority support'
    ],
    popular: true
  },
  {
    name: 'Enterprise Package',
    price: '$750/month',
    description: 'For growing teams needing broader sites and steady iteration.',
    features: [
      'Up to 15 managed pages',
      '5 hours of monthly development support',
      'Basic monthly updates',
      'Basic monthly updates',
      'Managed hosting with performance tuning',
      'Advanced SEO and analytics',
      'Quarterly roadmap reviews'
    ]
  }
]


const process = [
  {
    order: '01',
    title: 'Discovery & Partnership',
    summary:
      'We learn your goals and priorities, then build a practical roadmap focused on measurable results.'
  },
  {
    order: '02',
    title: 'Design & Development',
    summary:
      'We design and build fast, accessible pages, integrate tools you need, and keep you involved during key decisions.'
  },
  {
    order: '03',
    title: 'Launch & Support',
    summary:
      'We launch, monitor performance, and provide ongoing updates so your site keeps delivering value.'
  }
]

const webFaq = [
  {
    question: 'Do I need technical skills to get started?',
    answer:
      'No technical experience needed — we handle setup, hosting, and maintenance. You provide goals and content; we handle the rest.'
  },
  {
    question: 'Can I keep my existing domain?',
    answer:
      'Yes — we can use your current domain or register and manage a new one for $50/year.'
  },
  {
    question: 'What if I need more content development time?',
    answer:
      'Extra content or copy support is available at $95/hour — from writing to editing and image selection.'
  },
  {
    question: 'How do I get started?',
    answer:
      "Start with a free site audit and brief call — we'll recommend the best package and timeline. Click 'Get a Free Site Audit' above to begin."
  },
  {
    question: 'Is the initial setup really free?',
    answer:
      'For a limited time, yes — an initial single-page setup is included with any monthly package. Ask us about upgrade options.'
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
    margin-bottom: 0.5rem;
  }

  .subhead {
    font-size: 1.15rem;
    margin-bottom: 1rem;
    color: #dff6ff;
    font-weight: 600;
  }

  .hero-benefits {
    list-style: none;
    padding: 0;
    margin: 0 0 1.25rem;
    display: flex;
    gap: 1rem;
    justify-content: center;
    flex-wrap: wrap;

    li {
      background: rgba(255,255,255,0.06);
      padding: 0.5rem 0.9rem;
      border-radius: 999px;
      color: #eaf9ff;
      font-weight: 600;
      font-size: 0.95rem;
    }
  }

  p {
    font-size: 1.05rem;
    margin-bottom: 0.75rem;
    color: #e7f7ff;
  }

  .hero-ctas {
    display: flex;
    gap: 0.75rem;
    justify-content: center;
    margin-top: 0.5rem;
  }

  .cta-button {
    padding: 0.75rem 2.25rem;
    background: $secondary;
    color: white;
    font-weight: 700;
    border-radius: 8px;
    text-decoration: none;
    transition: background 0.3s ease;

    &.primary {
      background: $primary-light;
      color: #08141a;
    }

    &.ghost {
      background: transparent;
      border: 1px solid rgba(255,255,255,0.14);
      color: $white;
    }

    &.small {
      padding: 0.5rem 1rem;
      font-size: 0.95rem;
    }

    &:hover {
      background: #ff9330;
      color: #08141a;
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

    .badge {
      background: $primary-light;
      color: #08141a;
      padding: 0.25rem 0.6rem;
      border-radius: 999px;
      font-weight: 800;
      font-size: 0.85rem;
      margin-left: 0.5rem;
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

    .card-top {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 0.5rem;
    }

    h3 {
      font-size: 1.55rem;
      font-weight: 700;
      color: $white;
      margin: 0;
    }

    .price {
      font-size: 1.5rem;
      font-weight: 800;
      color: $primary-light;
      margin-bottom: 0.5rem;
    }

    .pkg-lead {
      color: #dcecf6;
      line-height: 1.4;
      margin-bottom: 0.5rem;
      font-weight: 600;
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

    .card-actions {
      margin-top: 1rem;
      display: flex;
      gap: 0.75rem;
      align-items: center;
    }

    .link-secondary {
      color: #dbeeff;
      text-decoration: underline;
      font-weight: 600;
      font-size: 0.95rem;
      margin-left: 0.5rem;
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
  .hourly-overview {
    margin-top: 2rem;
    background: rgba(255, 255, 255, 0.08);
    border-radius: 14px;
    padding: 2rem 1.5rem;

    h3 {
      font-size: 1.6rem;
      font-weight: 700;
      margin-bottom: 1.5rem;
      text-align: center;
    }

    .hourly-grid {
      display: grid;
      gap: 1.5rem;

      @media (min-width: 768px) {
        grid-template-columns: repeat(2, 1fr);
      }
    }

    .hourly-card {
      background: rgba(0, 0, 0, 0.45);
      border: 1px solid rgba(255, 179, 71, 0.25);
      border-radius: 12px;
      padding: 1.5rem;
      text-align: left;

      h4 {
        font-size: 1.2rem;
        font-weight: 700;
        color: $white;
        margin-bottom: 0.75rem;
      }

      ul {
        list-style: none;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        gap: 0.5rem;

        li {
          color: #deeff9;
          line-height: 1.5;
          position: relative;
          padding-left: 1.1rem;

          &::before {
            content: '•';
            position: absolute;
            left: 0;
            color: $primary-light;
          }
        }
      }
    }
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


  .trust {
    margin-top: 1.5rem;
    display: flex;
    flex-direction: column;
    gap: 1rem;

    .trust-inner {
      display: flex;
      gap: 1rem;
      align-items: center;
      justify-content: space-between;
      flex-wrap: wrap;
    }

    .testimonial {
      max-width: 700px;
    }

    .testimonial blockquote {
      font-size: 1.05rem;
      color: #e7f7ff;
      margin: 0 0 0.5rem 0;
    }

    .testimonial cite {
      color: #dbeeff;
      font-weight: 700;
    }

    .trust-links a {
      background: rgba(255,255,255,0.08);
      padding: 0.5rem 0.9rem;
      border-radius: 8px;
      color: $white;
      text-decoration: none;
      font-weight: 700;
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
      gap: 1rem;

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
      line-height: 1;
      color: #e7f7ff;
    }
  }
}

@media (max-width: 767px) {
  .hero h1 {
    font-size: 2.25rem;
  }

  .hero-benefits {
    gap: 0.5rem;
  }

  .package-grid,
  .process-steps,
  .client-details {
    grid-template-columns: 1fr;
  }

  .hero-ctas {
    flex-direction: column;
  }
}
</style>
