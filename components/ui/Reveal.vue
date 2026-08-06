<template>
  <div
    ref="el"
    class="reveal"
    :class="{ 'reveal--visible': visible }"
    :style="delayStyle"
  >
    <slot />
  </div>
</template>

<script setup lang="ts">
const props = withDefaults(
  defineProps<{
    delay?: number
  }>(),
  { delay: 0 }
)

const el = ref<HTMLElement | null>(null)
const delayStyle = computed(() =>
  props.delay > 0 ? { transitionDelay: `${props.delay}ms` } : undefined
)
const visible = ref(false)

onMounted(() => {
  if (typeof window === 'undefined') {
    visible.value = true
    return
  }

  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    visible.value = true
    return
  }

  const observer = new IntersectionObserver(
    ([entry]) => {
      if (entry?.isIntersecting) {
        visible.value = true
        observer.disconnect()
      }
    },
    { threshold: 0.12, rootMargin: '0px 0px -40px 0px' }
  )

  if (el.value) observer.observe(el.value)
})
</script>

<style scoped lang="scss">
.reveal {
  opacity: 0;
  transform: translateY(24px);
  transition:
    opacity var(--dur-slow) var(--ease-out),
    transform var(--dur-slow) var(--ease-out);
}

.reveal--visible {
  opacity: 1;
  transform: translateY(0);
}

@media (prefers-reduced-motion: reduce) {
  .reveal {
    opacity: 1;
    transform: none;
    transition: none;
  }
}
</style>
