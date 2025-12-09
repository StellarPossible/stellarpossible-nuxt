<template>
  <section class="web-page">
    <div class="hero">
      <h1>Web Experiences Built for Momentum</h1>
      <p>
        We design composable web architectures that are fast, accessible, and easy to keep fresh, whether
        you are shipping campaigns weekly or rolling out new revenue streams.
      </p>
      <NuxtLink class="cta-button" to="/contact">Plan a Web Sprint</NuxtLink>
    </div>

    <div class="pillars">
      <article
        v-for="pillar in webPillars"
        :key="pillar.title"
        class="pillar-card"
      >
        <div class="pillar-icon">
          <Icon :icon="pillar.icon" />
        </div>
        <h2>{{ pillar.title }}</h2>
        <p>{{ pillar.description }}</p>
        <ul>
          <li v-for="detail in pillar.details" :key="detail">{{ detail }}</li>
        </ul>
      </article>
    </div>

    <section class="process">
      <h2>How We Land Launches</h2>
      <div class="process-steps">
        <div v-for="step in process" :key="step.title" class="process-card">
          <span class="step-number">{{ step.order }}</span>
          <h3>{{ step.title }}</h3>
          <p>{{ step.summary }}</p>
        </div>
      </div>
    </section>

    <section class="faq">
      <h2>Web Experience FAQ</h2>
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

    <div class="final-cta">
      <h2>Ready to Refresh Your Web Stack?</h2>
      <p>
        Whether you need a headless CMS, a marketing site with Gravity, or a hybrid Nuxt + WordPress
        deployment, we'll help you ship with confidence.
      </p>
      <NuxtLink class="cta-button" to="/contact">Talk With Our Team</NuxtLink>
    </div>
  </section>
</template>

<script setup lang="ts">
const webPillars = [
  {
    title: 'Composable Frontends',
    icon: 'mdi:view-dashboard-variant-outline',
    description:
      'Nuxt, Vue, and modern CSS systems give marketing and product teams a toolkit that is quick to iterate and simple to extend.',
    details: [
      'Component libraries aligned with your brand',
      'Animation systems powered by GSAP and Lottie',
      'Accessibility checks embedded into the build pipeline'
    ]
  },
  {
    title: 'Headless Content Ops',
    icon: 'mdi:server-network-outline',
    description:
      'Connect the CMS your team knows with the performance and guardrails your engineers expect.',
    details: [
      'WordPress, Sanity, and Strapi headless builds',
      'Content modeling and editorial workflows',
      'Static generation plus on-demand revalidation'
    ]
  },
  {
    title: 'Search & Performance',
    icon: 'mdi:rocket-launch-outline',
    description:
      'We tune for sub-second loads, lighthouse 90+, and organic search that sees the content you invest in.',
    details: [
      'Edge caching strategies and image optimization',
      'Schema and structured data implementation',
      'Core Web Vitals monitoring with automated QA'
    ]
  }
]

const process = [
  {
    order: '01',
    title: 'Discovery & Architecture',
    summary:
      'We facilitate stakeholder workshops, audit the current stack, and outline a roadmap that balances quick wins with sustainable growth.'
  },
  {
    order: '02',
    title: 'Design & Build',
    summary:
      'Rapid prototypes validate direction while we stand up scalable components, integrate APIs, and keep SEO intact.'
  },
  {
    order: '03',
    title: 'Launch & Iterate',
    summary:
      'We manage the release, train your team, and stay engaged for continued optimization, testing, and new feature rollouts.'
  }
]

const webFaq = [
  {
    question: 'How do you keep marketing sites fast when content teams publish every day?',
    answer:
      'We pair headless CMS workflows with Nuxt static generation and on-demand ISR so the site revalidates only the pages that changed. Editors get instant previews, and end users keep sub-second page loads.'
  },
  {
    question: 'Can new landing pages still be accessible and SEO-ready without developer involvement?',
    answer:
      'Yes. We design component libraries with baked-in aria patterns, schema markup, and analytics instrumentation. Marketers drag-and-drop sections, and the compiled output still passes lighthouse and WCAG checks.'
  },
  {
    question: 'What happens if we already have WordPress running on shared hosting?',
    answer:
      'We decouple the CMS into a managed headless instance, sync media to object storage, and layer API caching in front. Your editorial team keeps the familiar dashboard while the frontend moves to a modern edge-hosted architecture.'
  }
]
</script>

<style scoped lang="scss">
.web-page {
  padding: 4rem 1.5rem 5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  background: rgba(0, 0, 0, 0.35);
  backdrop-filter: blur(4px);
  color: #fff;
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
    margin-bottom: 2rem;
    color: #e7f7ff;
  }

  .cta-button {
    padding: 0.75rem 2.25rem;
    background: #ffb347;
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

.pillars {
  display: grid;
  gap: 2rem;
  max-width: 1100px;
  width: 100%;
  margin-bottom: 4rem;

  @media (min-width: 768px) {
    grid-template-columns: repeat(3, 1fr);
  }

  .pillar-card {
    background: rgba(255, 255, 255, 0.08);
    border-radius: 14px;
    padding: 2rem 1.5rem;
    text-align: left;
    color: #031524;
    box-shadow: 0 0 25px rgba(0, 0, 0, 0.18);
    display: flex;
    flex-direction: column;
    gap: 0.75rem;

    h2 {
      font-size: 1.55rem;
      font-weight: 700;
      color: #fff;
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
          color: #ffb347;
          font-size: 1.4rem;
          line-height: 1;
        }
      }
    }

    .pillar-icon {
      font-size: 2.25rem;
      color: #ffb347;
      margin-bottom: 0.25rem;
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
      color: #ffb347;
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
    background: #ffb347;
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

  .pillars,
  .process-steps {
    grid-template-columns: 1fr;
  }
}
</style>
