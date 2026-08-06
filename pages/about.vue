<template>
  <PageShell class="about-landing">
    <header class="about-hero">
      <h1 class="about-hero__title">About Us</h1>
      <p class="about-hero__lead">A small team building thoughtful digital products — with clarity, craft, and care.</p>
    </header>

    <SectionShell>
      <Reveal>
        <div class="about-grid">
          <AboutTeamMemberCard
            name="Marine Valentonis"
            role="Founder & Lead Developer"
            photo="/images/team/marine.png"
            :bio="marineBio"
          />
          <AboutJoinTeamForm />
        </div>
      </Reveal>
    </SectionShell>
  </PageShell>
</template>

<script setup lang="ts">
const marineBio = [
  'Marine is the founder and technical force behind StellarPossible, where strategy, design, and engineering come together to create thoughtful digital solutions. A full-stack developer with deep experience in WordPress, WooCommerce, Vue, Nuxt, APIs, databases, and server infrastructure, she specializes in turning complex systems into streamlined, reliable experiences that are easier to use, manage, and grow.',
  'Equal parts problem-solver and creative builder, Marine approaches every project with curiosity, precision, and a strong understanding of the people behind the technology. Whether she is modernizing a legacy platform, developing custom software, or shaping a new product from the ground up, her goal is the same: build something purposeful, sustainable, and genuinely useful.'
]

const config = useRuntimeConfig()
const siteUrl = ((config.public.siteUrl as string) || 'https://stellarpossible.com').replace(/\/$/, '')

useSeo({
  title: 'About Us | StellarPossible',
  description: 'Meet the StellarPossible team and learn how to join us — custom software, Nuxt platforms, and managed hosting.',
  path: '/about',
  jsonLd: [organizationJsonLd(siteUrl)]
})
</script>

<style scoped lang="scss">
.about-landing {
  padding-bottom: var(--space-12);
}

.about-hero {
  text-align: center;
  max-width: 40rem;
  margin: 0 auto var(--space-10);
  padding-inline: var(--space-4);
}

.about-hero__title {
  font-family: var(--font-display);
  font-size: var(--fs-700);
  font-weight: 500;
  letter-spacing: -0.02em;
  margin: 0 0 var(--space-4);
  line-height: 1.1;
}

.about-hero__lead {
  font-size: var(--fs-300);
  color: var(--color-text-muted);
  margin: 0;
  line-height: 1.55;
}

.about-grid {
  display: grid;
  grid-template-columns: 1.2fr 0.8fr;
  gap: var(--space-8);
  align-items: start;
}

@media (max-width: 960px) {
  .about-grid {
    grid-template-columns: 1fr;
    gap: var(--space-6);
  }

  .about-hero {
    margin-bottom: var(--space-8);
  }
}

@media (max-width: 480px) {
  .about-hero__title {
    font-size: var(--fs-600);
  }
}
</style>
