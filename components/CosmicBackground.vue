<template>
  <div
    class="cosmic-bg"
    :class="{ 'theme-light': theme === 'light' }"
    aria-hidden="true"
  >
    <div class="cosmic-nebula" />
    <div class="cosmic-bloom cosmic-bloom-1" />
    <div class="cosmic-bloom cosmic-bloom-2" />
    <div class="cosmic-stars cosmic-stars-1" />
    <div class="cosmic-stars cosmic-stars-2" />
    <div class="cosmic-stars cosmic-stars-3" />
  </div>
</template>

<script setup lang="ts">
const { theme } = useTheme()
</script>

<style scoped lang="scss">
.cosmic-bg {
  position: fixed;
  inset: 0;
  z-index: 0;
  pointer-events: none;
  overflow: hidden;
  background: var(--color-space-deep);
}

.cosmic-nebula {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(ellipse 80% 60% at 20% 20%, rgba(35, 60, 100, 0.45) 0%, transparent 55%),
    radial-gradient(ellipse 70% 50% at 80% 70%, rgba(60, 40, 90, 0.35) 0%, transparent 50%),
    radial-gradient(ellipse 100% 80% at 50% 100%, rgba(18, 49, 70, 0.5) 0%, transparent 60%),
    linear-gradient(180deg, var(--color-space-deep) 0%, var(--color-space) 40%, #0e1525 100%);
}

.cosmic-bloom {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.5;
  animation: drift 120s ease-in-out infinite;
}

.cosmic-bloom-1 {
  width: 40vw;
  height: 40vw;
  max-width: 500px;
  max-height: 500px;
  top: -10%;
  right: -5%;
  background: rgba(100, 140, 220, 0.25);
}

.cosmic-bloom-2 {
  width: 35vw;
  height: 35vw;
  max-width: 420px;
  max-height: 420px;
  bottom: 10%;
  left: -8%;
  background: rgba(155, 123, 255, 0.2);
  animation-delay: -60s;
  animation-direction: reverse;
}

.cosmic-stars {
  position: absolute;
  inset: 0;
  background-repeat: repeat;
  opacity: 0.6;
}

.cosmic-stars-1 {
  background-image:
    radial-gradient(1px 1px at 20px 30px, rgba(255, 255, 255, 0.8), transparent),
    radial-gradient(1px 1px at 80px 120px, rgba(255, 255, 255, 0.6), transparent),
    radial-gradient(1px 1px at 160px 60px, rgba(255, 255, 255, 0.7), transparent),
    radial-gradient(1.5px 1.5px at 240px 180px, rgba(200, 220, 255, 0.9), transparent),
    radial-gradient(1px 1px at 320px 40px, rgba(255, 255, 255, 0.5), transparent);
  background-size: 350px 200px;
  animation: twinkle 8s ease-in-out infinite;
}

.cosmic-stars-2 {
  background-image:
    radial-gradient(1px 1px at 50px 90px, rgba(255, 255, 255, 0.5), transparent),
    radial-gradient(1.5px 1.5px at 130px 20px, rgba(180, 200, 255, 0.8), transparent),
    radial-gradient(1px 1px at 210px 150px, rgba(255, 255, 255, 0.6), transparent),
    radial-gradient(1px 1px at 290px 70px, rgba(255, 255, 255, 0.4), transparent);
  background-size: 320px 180px;
  animation: twinkle 12s ease-in-out infinite reverse;
  opacity: 0.4;
}

.cosmic-stars-3 {
  background-image:
    radial-gradient(2px 2px at 100px 100px, rgba(140, 200, 255, 0.3), transparent),
    radial-gradient(1px 1px at 200px 50px, rgba(255, 255, 255, 0.35), transparent);
  background-size: 280px 160px;
  opacity: 0.25;
}

.theme-light {
  .cosmic-nebula {
    background:
      radial-gradient(ellipse 80% 60% at 30% 20%, rgba(180, 200, 230, 0.4) 0%, transparent 55%),
      radial-gradient(ellipse 70% 50% at 70% 80%, rgba(200, 190, 230, 0.25) 0%, transparent 50%),
      linear-gradient(180deg, #e8eef5 0%, var(--color-space) 50%, #dce4ec 100%);
  }

  .cosmic-bloom-1 {
    background: rgba(140, 170, 220, 0.2);
  }

  .cosmic-bloom-2 {
    background: rgba(180, 160, 220, 0.15);
  }

  .cosmic-stars {
    opacity: 0.15;
  }
}

@keyframes drift {
  0%,
  100% {
    transform: translate(0, 0) scale(1);
  }
  33% {
    transform: translate(3%, 2%) scale(1.05);
  }
  66% {
    transform: translate(-2%, 3%) scale(0.98);
  }
}

@keyframes twinkle {
  0%,
  100% {
    opacity: 0.6;
  }
  50% {
    opacity: 0.85;
  }
}

@media (prefers-reduced-motion: reduce) {
  .cosmic-bloom,
  .cosmic-stars-1,
  .cosmic-stars-2 {
    animation: none;
  }
}

@media (max-width: 768px) {
  .cosmic-bloom {
    animation: none;
    opacity: 0.35;
  }

  .cosmic-stars-1,
  .cosmic-stars-2 {
    animation: none;
    opacity: 0.35;
  }

  .cosmic-stars-3 {
    opacity: 0.15;
  }
}
</style>
