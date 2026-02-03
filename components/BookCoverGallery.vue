<template>
  <section
    class="book-cover-gallery"
    role="region"
    aria-label="Book cover gallery"
  >
    <div class="gallery-stage">
      <div class="stage-inner" :style="stageStyle">
        <div
          v-for="(item, i) in items"
          :key="item.src"
          class="slide"
          :class="{ active: i === currentIndex }"
          :aria-hidden="i !== currentIndex"
        >
          <NuxtImg
            :src="item.src"
            :alt="item.alt ?? item.title ?? 'Book cover'"
            class="slide-img"
            loading="lazy"
            format="webp"
            sizes="(max-width: 640px) 100vw, (max-width: 1024px) 80vw, 560px"
          />
          <p v-if="item.title" class="slide-caption">{{ item.title }}</p>
        </div>
      </div>
      <div
        v-if="items.length > 1"
        class="stage-nav"
        aria-label="Previous and next cover"
      >
        <button
          type="button"
          class="nav-btn nav-prev"
          aria-label="Previous cover"
          :disabled="currentIndex === 0"
          @click="prev"
        >
          <ClientOnly>
            <Icon icon="mdi:chevron-left" aria-hidden />
            <template #fallback><span aria-hidden>‹</span></template>
          </ClientOnly>
        </button>
        <button
          type="button"
          class="nav-btn nav-next"
          aria-label="Next cover"
          :disabled="currentIndex === items.length - 1"
          @click="next"
        >
          <ClientOnly>
            <Icon icon="mdi:chevron-right" aria-hidden />
            <template #fallback><span aria-hidden>›</span></template>
          </ClientOnly>
        </button>
      </div>
    </div>

    <div v-if="items.length > 1" class="gallery-thumbs">
      <button
        v-for="(item, i) in items"
        :key="`thumb-${item.src}`"
        type="button"
        class="thumb"
        :class="{ active: i === currentIndex }"
        :aria-label="`View cover ${i + 1} of ${items.length}`"
        :aria-current="i === currentIndex ? 'true' : undefined"
        @click="currentIndex = i"
      >
        <NuxtImg
          :src="item.src"
          :alt="''"
          class="thumb-img"
          loading="lazy"
          format="webp"
          width="80"
          height="120"
        />
      </button>
    </div>

    <p v-if="items.length > 1" class="gallery-counter" aria-live="polite">
      {{ currentIndex + 1 }} / {{ items.length }}
    </p>
  </section>
</template>

<script setup lang="ts">
export interface BookCoverItem {
  src: string
  alt?: string
  title?: string
}

const props = withDefaults(
  defineProps<{ items: BookCoverItem[] }>(),
  { items: () => [] }
)

const currentIndex = ref(0)
const total = computed(() => props.items.length)

const stageStyle = computed(() => ({
  '--total': total.value,
  '--current': currentIndex.value
}))

function prev() {
  if (currentIndex.value > 0) currentIndex.value--
}

function next() {
  if (currentIndex.value < total.value - 1) currentIndex.value++
}

function onKeydown(e: KeyboardEvent) {
  const target = e.target as HTMLElement
  if (target?.closest?.('input, textarea, [contenteditable="true"]')) return
  if (e.key === 'ArrowLeft') prev()
  else if (e.key === 'ArrowRight') next()
}

onMounted(() => {
  window.addEventListener('keydown', onKeydown)
})
onUnmounted(() => {
  window.removeEventListener('keydown', onKeydown)
})
</script>

<style scoped lang="scss">
.book-cover-gallery {
  width: 100%;
  max-width: 42rem;
  margin: 0 auto;
}

.gallery-stage {
  position: relative;
  aspect-ratio: 2 / 3;
  max-height: 72vh;
  border-radius: 12px;
  overflow: hidden;
  background: rgba(18, 49, 70, 0.4);
  border: 1px solid rgba(84, 117, 128, 0.25);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.25);
}

.stage-inner {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1.25rem;
  box-sizing: border-box;
}

.slide {
  position: absolute;
  inset: 1.25rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transform: translateX(8%);
  pointer-events: none;
  transition: opacity 0.35s ease, transform 0.35s ease;

  &.active {
    opacity: 1;
    transform: translateX(0);
    pointer-events: auto;
  }
}

.slide-img {
  width: auto;
  height: 100%;
  max-height: 100%;
  object-fit: contain;
  object-position: center;
  border-radius: 6px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.35);
}

.slide-caption {
  margin: 0.75rem 0 0;
  font-size: 0.875rem;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.9);
  text-align: center;
}

.stage-nav {
  position: absolute;
  inset: 0;
  pointer-events: none;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 0.5rem;
}

.nav-btn {
  pointer-events: auto;
  width: 2.5rem;
  height: 2.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.12);
  color: #fff;
  cursor: pointer;
  transition: background 0.2s ease, transform 0.2s ease, opacity 0.2s ease;

  &:hover:not(:disabled) {
    background: rgba(255, 255, 255, 0.22);
    transform: scale(1.08);
  }

  &:disabled {
    opacity: 0.35;
    cursor: not-allowed;
  }

  &:focus-visible {
    outline: 2px solid rgba(255, 255, 255, 0.7);
    outline-offset: 2px;
  }

  svg {
    font-size: 1.5rem;
  }
}

.gallery-thumbs {
  display: flex;
  gap: 0.5rem;
  justify-content: center;
  flex-wrap: wrap;
  margin-top: 1rem;
  padding: 0 0.25rem;
  min-height: 0;
  overflow-x: auto;
  overflow-y: hidden;
  scrollbar-width: thin;
  -webkit-overflow-scrolling: touch;

  &::-webkit-scrollbar {
    height: 6px;
  }
  &::-webkit-scrollbar-track {
    background: rgba(255, 255, 255, 0.06);
    border-radius: 3px;
  }
  &::-webkit-scrollbar-thumb {
    background: rgba(255, 255, 255, 0.2);
    border-radius: 3px;
  }
}

.thumb {
  flex-shrink: 0;
  width: 3rem;
  height: 4.5rem;
  padding: 0;
  border: 2px solid transparent;
  border-radius: 6px;
  background: rgba(18, 49, 70, 0.5);
  cursor: pointer;
  overflow: hidden;
  transition: border-color 0.2s ease, box-shadow 0.2s ease, transform 0.15s ease;

  &:hover {
    border-color: rgba(255, 255, 255, 0.25);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    transform: scale(1.03);
  }

  &.active {
    border-color: rgba(255, 255, 255, 0.6);
    box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.15);
  }

  &:focus-visible {
    outline: 2px solid rgba(255, 255, 255, 0.6);
    outline-offset: 2px;
  }
}

.thumb-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.gallery-counter {
  margin: 0.5rem 0 0;
  font-size: 0.8125rem;
  color: rgba(255, 255, 255, 0.6);
  text-align: center;
}

@media (max-width: 640px) {
  .gallery-stage {
    aspect-ratio: 2 / 3;
    max-height: 65vh;
  }

  .stage-inner,
  .slide {
    inset: 0.75rem;
  }

  .nav-btn {
    width: 2.25rem;
    height: 2.25rem;

    svg {
      font-size: 1.25rem;
    }
  }
}
</style>
