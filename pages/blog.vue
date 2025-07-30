<template>
  <section class="education-page">
    <div class="header fade-up">
      <h1>Education</h1>
      <p class="subtitle">
        Stay up to date with our latest articles, news, and insights
      </p>
      <div class="tags">
        <span class="tag">Tech</span>
        <span class="tag">Indie Publishing</span>
        <span class="tag">Compliance</span>
        <span class="tag">STEM</span>
      </div>
    </div>

    <div class="featured-posts fade-up">
      <div class="post-card" v-for="post in featuredPosts" :key="post.title">
        <NuxtImg :src="post.image" :alt="post.title" class="post-img" />
        <div class="post-content">
          <h3>{{ post.title }}</h3>
          <p class="date">{{ post.date }}</p>
          <p>{{ post.summary }}</p>
        </div>
      </div>
    </div>

    <div class="newsletter fade-up">
      <h2>Never miss an insight</h2>
      <p>Subscribe to our newsletter for updates</p>
      <button class="subscribe-button">Subscribe</button>
    </div>

    <div class="popular-reads fade-up">
      <h2>Popular Reads</h2>
      <div class="post-card" v-for="post in popularReads" :key="post.title">
        <NuxtImg :src="post.image" :alt="post.title" class="post-img" />
        <div class="post-content">
          <h3>{{ post.title }}</h3>
          <p class="date">{{ post.date }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
onMounted(() => {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
        }
      });
    },
    { threshold: 0.1 }
  );

  document.querySelectorAll('.fade-up').forEach((el) => {
    observer.observe(el);
  });
});

const featuredPosts = [
  {
    title: 'Introduction to API-Driven Web Apps',
    date: 'April 12, 2024',
    summary: "A beginner’s guide to building scalable platforms with API-first architecture.",
    image: '/images/blog/api-intro.png'
  },
  {
    title: 'Self-Publishing for Creatives 101',
    date: 'April 6, 2024',
    summary: "Learn how to bring your creative works to life with our step-by-step guide.",
    image: '/images/blog/self-publishing.png'
  },
  {
    title: 'Navigating Data Privacy Laws',
    date: 'April 5, 2024',
    summary: "A comprehensive overview of the latest in data protection regulations.",
    image: '/images/blog/privacy-laws.png'
  }
];

const popularReads = [
  {
    title: 'Browse an API-Driven Web Apps',
    date: 'April 24, 2024',
    image: '/images/blog/popular-api.png'
  },
  {
    title: 'Self-Publishing for Creatives',
    date: 'April 15, 2024',
    image: '/images/blog/popular-publishing.png'
  },
  {
    title: 'Navigating Data Privacy Laws',
    date: 'April 9, 2024',
    image: '/images/blog/popular-privacy.png'
  }
];
</script>

<style scoped lang="scss">
.education-page {
  padding: 4rem 2rem;
  color: #fff;
  background: transparent;

  .fade-up {
    opacity: 0;
    transform: translateY(30px);
    transition: opacity 0.6s ease-out, transform 0.6s ease-out;
  }

  .fade-up.visible {
    opacity: 1;
    transform: translateY(0);
  }

  .header {
    text-align: center;
    margin-bottom: 3rem;

    h1 {
      font-size: 3rem;
      font-weight: 800;
      color: #ffffff;
    }

    .subtitle {
      font-size: 1.2rem;
      color: #ccc;
      margin-top: 0.5rem;
    }

    .tags {
      margin-top: 1rem;
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
      gap: 1rem;

      .tag {
        background: #222;
        color: #fff;
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-weight: 600;
      }
    }
  }

  .featured-posts {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 2rem;
    margin-bottom: 4rem;

    .post-card {
      background: #fff;
      color: #000;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
      transition: transform 0.3s ease;

      &:hover {
        transform: scale(1.02);
      }

      .post-img {
        width: 100%;
        height: 180px;
        object-fit: cover;
      }

      .post-content {
        padding: 1rem;

        h3 {
          font-size: 1.2rem;
          font-weight: 700;
        }

        .date {
          font-size: 0.9rem;
          color: #666;
          margin-top: 0.25rem;
        }

        p {
          font-size: 1rem;
          color: #333;
          margin-top: 0.5rem;
        }
      }
    }
  }

  .newsletter {
    background: linear-gradient(90deg, #002f4b, #005f83);
    padding: 2rem;
    text-align: center;
    border-radius: 12px;
    margin-bottom: 4rem;

    h2 {
      font-size: 1.8rem;
      margin-bottom: 0.5rem;
    }

    p {
      color: #ccc;
      margin-bottom: 1rem;
    }

    .subscribe-button {
      background: #00aaff;
      border: none;
      padding: 0.75rem 2rem;
      font-weight: 700;
      font-size: 1rem;
      border-radius: 8px;
      cursor: pointer;
      color: #fff;
      transition: background 0.3s;
      box-shadow: 0 0 10px #00aaff;

      &:hover {
        background: #008ecc;
      }
    }
  }

  .popular-reads {
    h2 {
      font-size: 1.75rem;
      font-weight: 700;
      margin-bottom: 1.5rem;
    }

    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 2rem;

    .post-card {
      background: #fff;
      color: #000;
      border-radius: 12px;
      overflow: hidden;
      transition: transform 0.3s ease;

      &:hover {
        transform: scale(1.02);
      }

      .post-img {
        width: 100%;
        height: 160px;
        object-fit: cover;
      }

      .post-content {
        padding: 1rem;

        h3 {
          font-size: 1.1rem;
          font-weight: 600;
        }

        .date {
          font-size: 0.85rem;
          color: #555;
          margin-top: 0.25rem;
        }
      }
    }
  }
}
</style>
