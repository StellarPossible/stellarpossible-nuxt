<template>
  <GlassCard :hover="false" :pad="false" class="team-member">
    <div class="team-member__accent" aria-hidden="true" />

    <div class="team-member__header">
      <div class="team-member__photo-wrap">
        <NuxtImg
          v-if="photo"
          :src="photo"
          :alt="`${name} headshot`"
          class="team-member__photo"
          loading="lazy"
        />
        <div v-else class="team-member__photo team-member__photo--placeholder" aria-hidden="true">
          <Icon icon="mdi:account" />
        </div>
      </div>

      <div class="team-member__identity">
        <span class="team-member__label">Team</span>
        <h2 class="team-member__name">{{ name }}</h2>
        <p class="team-member__role">{{ role }}</p>
      </div>
    </div>

    <div v-if="bioParagraphs.length" class="team-member__bio-wrap">
      <p v-for="(paragraph, index) in bioParagraphs" :key="index" class="team-member__bio">{{ paragraph }}</p>
    </div>
  </GlassCard>
</template>

<script setup lang="ts">
const props = defineProps<{
  name: string
  role: string
  bio?: string | string[]
  photo?: string
}>()

const bioParagraphs = computed(() => {
  if (!props.bio) return []
  if (Array.isArray(props.bio)) return props.bio
  return props.bio.split(/\n\n+/).map((p) => p.trim()).filter(Boolean)
})
</script>

<style scoped lang="scss">
.team-member {
  position: relative;
  overflow: hidden;
  padding: var(--space-8);
  border-color: var(--color-border-strong);
  box-shadow: var(--shadow-lg), var(--shadow-glow);
}

.team-member__accent {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(
    90deg,
    transparent 0%,
    var(--color-accent) 20%,
    var(--color-aurora) 50%,
    var(--color-accent) 80%,
    transparent 100%
  );
  opacity: 0.85;
}

.team-member__header {
  display: flex;
  align-items: center;
  gap: var(--space-6);
  margin-bottom: var(--space-8);
}

.team-member__photo-wrap {
  position: relative;
  width: 7.5rem;
  height: 7.5rem;
  flex-shrink: 0;
  border-radius: 50%;
  padding: 3px;
  background: linear-gradient(145deg, var(--color-accent), var(--color-aurora));
  box-shadow: var(--shadow-glow-strong);
}

.team-member__photo {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  border-radius: 50%;
  border: 2px solid rgba(8, 14, 24, 0.9);
}

.team-member__photo--placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-accent-soft);
  color: var(--color-accent);
  font-size: 2.5rem;
}

.team-member__identity {
  min-width: 0;
}

.team-member__label {
  display: inline-block;
  font-family: var(--font-ui);
  font-size: var(--fs-100);
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--color-gold);
  margin-bottom: var(--space-2);
}

.team-member__name {
  font-family: var(--font-display);
  font-size: var(--fs-600);
  font-weight: 500;
  margin: 0 0 var(--space-2);
  line-height: 1.15;
  letter-spacing: -0.02em;
}

.team-member__role {
  display: inline-block;
  font-family: var(--font-ui);
  font-size: var(--fs-200);
  font-weight: 600;
  color: var(--color-accent);
  margin: 0;
  padding: var(--space-1) var(--space-3);
  background: var(--color-accent-soft);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-pill);
}

.team-member__bio-wrap {
  display: grid;
  gap: var(--space-5);
}

.team-member__bio {
  font-size: var(--fs-200);
  color: var(--color-text-muted);
  margin: 0;
  line-height: 1.7;
}

@media (max-width: 560px) {
  .team-member {
    padding: var(--space-6);
  }

  .team-member__header {
    flex-direction: column;
    text-align: center;
    margin-bottom: var(--space-6);
  }

  .team-member__photo-wrap {
    width: 6.5rem;
    height: 6.5rem;
  }

  .team-member__name {
    font-size: var(--fs-500);
  }
}
</style>
