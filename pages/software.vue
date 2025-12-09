<template>
  <section class="software-page">
    <div class="hero">
      <h1>Software That Scales With You</h1>
      <p>
        From HIPAA-compliant platforms to internal product dashboards, we design and ship
        cloud-native software that can keep pace with the ways you grow.
      </p>
      <NuxtLink class="cta-button" to="/contact">Start a Software Project</NuxtLink>
    </div>

    <div class="solutions-grid">
      <article
        v-for="solution in softwareSolutions"
        :key="solution.title"
        class="solution-card"
      >
        <div class="solution-icon">
          <Icon :icon="solution.icon" />
        </div>
        <h2>{{ solution.title }}</h2>
        <p>{{ solution.description }}</p>
        <ul>
          <li v-for="capability in solution.capabilities" :key="capability">{{ capability }}</li>
        </ul>
      </article>
    </div>

    <section class="faq">
      <h2>Software FAQ</h2>
      <div class="faq-items">
        <details
          v-for="item in softwareFaq"
          :key="item.question"
          class="faq-item"
        >
          <summary>{{ item.question }}</summary>
          <p>{{ item.answer }}</p>
        </details>
      </div>
    </section>

    <div class="final-cta">
      <h2>Let's Build Your Next Release</h2>
      <p>
        We partner long-term to ship roadmaps, reduce technical debt, and keep your software
        handled so you can stay focused on strategy.
      </p>
      <NuxtLink class="cta-button" to="/contact">Book a Discovery Call</NuxtLink>
    </div>
  </section>
</template>

<script setup lang="ts">
const softwareSolutions = [
  {
    title: 'Product Platforms',
    icon: 'mdi:chart-timeline-variant-shimmer',
    description:
      'Architected for scale with role-based access, real-time dashboards, and APIs that map to your core workflows.',
    capabilities: [
      'Custom dashboards with granular permissions',
      'Secure data pipelines across internal services',
      'Analytics layers tuned for decision-making'
    ]
  },
  {
    title: 'Operational Tooling',
    icon: 'mdi:robot-excited',
    description:
      'Automation and integrations that keep ops teams efficient, compliant, and confident when new requirements land.',
    capabilities: [
      'Workflow automations and AI-assisted tooling',
      'Integrations with CRMs, ERPs, and data warehouses',
      'De-risked releases with monitoring and observability'
    ]
  },
  {
    title: 'Compliance-Ready Systems',
    icon: 'mdi:shield-lock-outline',
    description:
      'We design for HIPAA, SOC 2, FERPA, and other compliance landscapes from day one, no retrofitted stress.',
    capabilities: [
      'Encryption and event logging baked into the stack',
      'Role-segregated experiences for every audience',
      'Audit-ready documentation and deployment pipelines'
    ]
  }
]

const softwareFaq = [
  {
    question: 'How do you design custom software that meets compliance requirements like HIPAA or SOC 2?',
    answer:
      'We start by mapping every user flow to the regulatory controls it touches, then codify those rules into infrastructure-as-code, audit logging, and automated testing. That way your compliance posture is enforced by the platform rather than a manual checklist.'
  },
  {
    question: 'Can you integrate with the legacy tools our teams already rely on?',
    answer:
      'Yes. We build integration layers that wrap legacy systems with modern APIs, apply data transforms, and queue updates when upstream services are offline. The result is a cohesive product layer without forcing a risky rip-and-replace project.'
  },
  {
    question: 'What happens after the initial software launch?',
    answer:
      'Every engagement includes error monitoring, performance reviews, and roadmap workshops so we can prioritize optimizations with you. We operate as an embedded product squad, handling maintenance updates while keeping new feature work on schedule.'
  }
]
</script>

<style scoped lang="scss">
.software-page {
  padding: 4rem 1.5rem 5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #fff;
  background: rgba(0, 0, 0, 0.32);
  backdrop-filter: blur(3px);
  text-align: center;
}

.hero {
  max-width: 800px;
  margin-bottom: 4rem;

  h1 {
    font-size: 2.75rem;
    font-weight: 800;
    margin-bottom: 1rem;
  }

  p {
    font-size: 1.2rem;
    margin-bottom: 2rem;
    color: #e6f6ff;
  }

  .cta-button {
    padding: 0.75rem 2.25rem;
    background: $primary-light;
    color: #000;
    font-weight: 700;
    border-radius: 8px;
    text-decoration: none;
    transition: background 0.3s ease;

    &:hover {
      background: #00a3cc;
    }
  }
}

.solutions-grid {
  display: grid;
  gap: 2rem;
  max-width: 1100px;
  width: 100%;
  margin-bottom: 4rem;

  @media (min-width: 768px) {
    grid-template-columns: repeat(3, 1fr);
  }

  .solution-card {
    background: rgba(255, 255, 255, 0.08);
    border-radius: 12px;
    padding: 2rem 1.5rem;
    text-align: left;
    color: #01131f;
    backdrop-filter: blur(2px);
    box-shadow: 0 0 25px rgba(0, 0, 0, 0.18);
    display: flex;
    flex-direction: column;
    gap: 0.75rem;

    h2 {
      font-size: 1.5rem;
      font-weight: 700;
      color: #fff;
    }

    p {
      color: #dbe9f2;
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
        color: #f5fbff;
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

    .solution-icon {
      font-size: 2.25rem;
      color: $primary-light;
      margin-bottom: 0.25rem;
    }
  }
}

.final-cta {
  max-width: 720px;
  text-align: center;

  h2 {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 1rem;
  }

  p {
    font-size: 1.1rem;
    margin-bottom: 2rem;
    color: #deeff9;
  }

  .cta-button {
    padding: 0.75rem 2.25rem;
    background: $primary-light;
    color: #000;
    font-weight: 700;
    border-radius: 8px;
    text-decoration: none;
    transition: background 0.3s ease;

    &:hover {
      background: #00a3cc;
    }
  }
}

.faq {
  max-width: 860px;
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
    background: rgba(255, 255, 255, 0.08);
    border-radius: 10px;
    padding: 1rem 1.25rem;
    color: #f5fbff;
    border: 1px solid rgba(0, 209, 255, 0.15);

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
      line-height: 1.5;
      color: #deeff9;
    }
  }
}

@media (max-width: 767px) {
  .hero h1 {
    font-size: 2.25rem;
  }

  .solutions-grid {
    grid-template-columns: 1fr;
  }
}
</style>
