<template>
  <section class="author-services-page">
    <div class="hero fade-up">
      <h1>Self-Publishing Services for Authors</h1>
      <p class="subtitle">
        Empower your story with professional publishing support. From concept to bestseller, we help authors navigate the self-publishing journey with confidence.
      </p>
      <NuxtLink to="/contact" class="cta-button">Get Started Today</NuxtLink>
    </div>

    <div class="services-grid">
      <div class="service-card fade-up">
        <div class="service-icon">
          <span class="icon-book"></span>
        </div>
        <h3>Cover Design</h3>
        <p>
          Professional, eye-catching book covers that capture your story's essence and stand out on virtual shelves. Custom designs for print and digital formats.
        </p>
        <ul>
          <li>Genre-appropriate aesthetics</li>
          <li>Print-ready formatting</li>
          <li>Multiple revision rounds</li>
          <li>Digital optimization</li>
        </ul>
      </div>

      <div class="service-card fade-up">
        <div class="service-icon">
          <span class="icon-publish"></span>
        </div>
        <h3>Self-Publishing Assistance</h3>
        <p>
          Complete walkthrough and troubleshooting for publishing on major platforms. We guide you through every step of the process.
        </p>
        <ul>
          <li>Amazon KDP setup and optimization</li>
          <li>Barnes & Noble Press publishing</li>
          <li>Audible ACX audiobook production</li>
          <li>Platform-specific formatting</li>
        </ul>
      </div>

      <div class="service-card fade-up">
        <div class="service-icon">
          <span class="icon-edit"></span>
        </div>
        <h3>Professional Editing</h3>
        <p>
          Transform your manuscript with expert editing services. From developmental guidance to final polish, we ensure your story shines.
        </p>
        <ul>
          <li>Developmental editing</li>
          <li>Line editing and copyediting</li>
          <li>Proofreading</li>
          <li>Manuscript evaluation</li>
        </ul>
      </div>

      <div class="service-card fade-up">
        <div class="service-icon">
          <span class="icon-tools"></span>
        </div>
        <h3>Free Tools & Education</h3>
        <p>
          Empower yourself with our comprehensive library of free resources, templates, and educational content for independent publishing success.
        </p>
        <ul>
          <li>Publishing checklists and templates</li>
          <li>Platform guides and tutorials</li>
          <li>Marketing strategy resources</li>
          <li>Author community access</li>
        </ul>
      </div>

      <div class="service-card fade-up">
        <div class="service-icon">
          <span class="icon-marketing"></span>
        </div>
        <h3>Marketing & Social Media</h3>
        <p>
          Strategic marketing campaigns and social media management to build your author platform and reach your target readers.
        </p>
        <ul>
          <li>Social media strategy development</li>
          <li>Content creation and scheduling</li>
          <li>Email marketing campaigns</li>
          <li>Book launch planning</li>
        </ul>
      </div>

      <div class="service-card fade-up">
        <div class="service-icon">
          <span class="icon-sales"></span>
        </div>
        <h3>Ethical Sales Strategies</h3>
        <p>
          Sustainable, author-focused sales approaches that prioritize long-term success over quick profits. Build lasting relationships with readers.
        </p>
        <ul>
          <li>Reader engagement tactics</li>
          <li>Promotional pricing strategies</li>
          <li>Cross-promotion opportunities</li>
          <li>Sales tracking and analysis</li>
        </ul>
      </div>
    </div>

    <div class="releases-section fade-up">
      <h2>Checkout Recent Author Releases</h2>
      <div class="book-slideshow">
        <div class="book-container" v-for="book in recentBooks" :key="book.id" @click="selectBook(book)">
          <img :src="book.cover" :alt="book.title" class="book-cover" />
          <div class="book-info">
            <h4>{{ book.title }}</h4>
            <p>by {{ book.author }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Book Overlay -->
    <div v-if="selectedBook" class="book-overlay" @click="closeOverlay">
      <div class="overlay-content" @click.stop>
        <button class="close-btn" @click="closeOverlay">&times;</button>
        <div class="book-details">
          <img :src="selectedBook.cover" :alt="selectedBook.title" class="overlay-cover" />
          <div class="book-meta">
            <h3>{{ selectedBook.title }}</h3>
            <p class="author">by {{ selectedBook.author }}</p>
            <p class="genre">{{ selectedBook.genre }}</p>
            <p class="description">{{ selectedBook.description }}</p>
          </div>
        </div>
        <div class="overlay-actions">
          <a :href="selectedBook.authorLink" target="_blank" class="overlay-btn author-btn">
            <span class="icon">👤</span>
            Author
          </a>
          <a :href="selectedBook.purchaseLink" target="_blank" class="overlay-btn book-btn">
            <span class="icon">📖</span>
            Book
          </a>
        </div>
      </div>
    </div>

    <div class="process-section fade-up">
      <h2>Our Publishing Process</h2>
      <div class="process-steps">
        <div class="step">
          <div class="step-number">01</div>
          <h4>Discovery & Planning</h4>
          <p>We assess your manuscript, goals, and target audience to create a customized publishing roadmap.</p>
        </div>
        <div class="step">
          <div class="step-number">02</div>
          <h4>Content Preparation</h4>
          <p>Professional editing, cover design, and formatting ensure your book meets industry standards.</p>
        </div>
        <div class="step">
          <div class="step-number">03</div>
          <h4>Publishing & Distribution</h4>
          <p>We guide you through publishing on multiple platforms and setting up distribution channels.</p>
        </div>
        <div class="step">
          <div class="step-number">04</div>
          <h4>Marketing & Launch</h4>
          <p>Strategic marketing campaigns and launch events maximize your book's visibility and sales.</p>
        </div>
      </div>
    </div>

    <div class="cta-section fade-up">
      <h2>Ready to Publish Your Book?</h2>
      <p>Join hundreds of successful self-published authors who've transformed their manuscripts into bestselling books.</p>
      <div class="cta-buttons">
        <NuxtLink to="/contact" class="cta-button primary">Start Your Publishing Journey</NuxtLink>
        <NuxtLink to="/values" class="cta-button secondary">Learn About Our Approach</NuxtLink>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
// Book type definition
interface Book {
  id: number
  title: string
  author: string
  genre: string
  cover: string
  description: string
  authorLink: string
  purchaseLink: string
}

// Book data
const recentBooks = [
  {
    id: 1,
    title: "The Digital Revolution",
    author: "Sarah Chen",
    genre: "Technology",
    cover: "https://via.placeholder.com/200x300/123146/ffffff?text=Book+1",
    description: "A comprehensive guide to navigating the digital age and emerging technologies.",
    authorLink: "/write/sarah-chen",
    purchaseLink: "https://amazon.com/book1"
  },
  {
    id: 2,
    title: "Mindful Leadership",
    author: "Marcus Rodriguez",
    genre: "Business",
    cover: "https://via.placeholder.com/200x300/547580/ffffff?text=Book+2",
    description: "Transform your leadership style with mindfulness and emotional intelligence.",
    authorLink: "/write/marcus-rodriguez",
    purchaseLink: "https://amazon.com/book2"
  },
  {
    id: 3,
    title: "Sustainable Futures",
    author: "Dr. Emily Watson",
    genre: "Environment",
    cover: "https://via.placeholder.com/200x300/2d4558/ffffff?text=Book+3",
    description: "Exploring solutions for a sustainable planet and equitable future.",
    authorLink: "/write/emily-watson",
    purchaseLink: "https://amazon.com/book3"
  },
  {
    id: 4,
    title: "Creative Coding",
    author: "Alex Thompson",
    genre: "Programming",
    cover: "https://via.placeholder.com/200x300/241321/ffffff?text=Book+4",
    description: "Unlock your creativity through code and build amazing digital experiences.",
    authorLink: "/write/alex-thompson",
    purchaseLink: "https://amazon.com/book4"
  },
  {
    id: 5,
    title: "The Art of Storytelling",
    author: "Lisa Park",
    genre: "Writing",
    cover: "https://via.placeholder.com/200x300/0a1116/ffffff?text=Book+5",
    description: "Master the craft of storytelling and captivate your audience.",
    authorLink: "/write/lisa-park",
    purchaseLink: "https://amazon.com/book5"
  }
]

// Overlay state
const selectedBook = ref<Book | null>(null)

// Functions
function selectBook(book: Book) {
  selectedBook.value = book
}

function closeOverlay() {
  selectedBook.value = null
}

// Animation setup for fade-up effects
onMounted(() => {
  // Add a class to body to indicate JS is enabled
  document.body.classList.add('js-animation-enabled');
  
  // Set up fade animation with IntersectionObserver
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
        }
      });
    },
    { threshold: 0.1, rootMargin: '0px 0px -50px 0px' }
  );

  // Slightly delay the observation to ensure proper rendering
  setTimeout(() => {
    document.querySelectorAll('.fade-up').forEach((el) => {
      observer.observe(el);
    });
  }, 100);
});
</script>

<style scoped lang="scss">
@use '@/assets/scss/variables.scss' as *;

.author-services-page {
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

  .subtitle {
    font-size: 1.2rem;
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
      background: $primary;
      color: $white;
    }
  }
}

.services-grid {
  display: grid;
  gap: 2rem;
  max-width: 1200px;
  width: 100%;
  margin-bottom: 4rem;

  @media (min-width: 768px) {
    grid-template-columns: repeat(2, 1fr);
  }

  @media (min-width: 1024px) {
    grid-template-columns: repeat(3, 1fr);
  }
}

.service-card {
  background: rgba(255, 255, 255, 0.08);
  border-radius: 14px;
  padding: 2rem 1.5rem;
  text-align: left;
  border: 1px solid rgba(255, 179, 71, 0.25);
  transition: transform 0.3s ease, box-shadow 0.3s ease;

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  }

  .service-icon {
    margin-bottom: 1rem;

    span {
      font-size: 2.5rem;
      color: $primary-light;
    }
  }

  h3 {
    font-size: 1.4rem;
    font-weight: 700;
    margin-bottom: 1rem;
    color: $white;
  }

  p {
    color: #dcecf6;
    line-height: 1.6;
    margin-bottom: 1.5rem;
  }

  ul {
    list-style: none;
    padding: 0;
    margin: 0;

    li {
      color: #e7f7ff;
      margin-bottom: 0.5rem;
      padding-left: 1.5rem;
      position: relative;

      &::before {
        content: '✓';
        position: absolute;
        left: 0;
        color: $primary-light;
        font-weight: bold;
      }
    }
  }
}

.process-section {
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
    gap: 2rem;

    @media (min-width: 768px) {
      grid-template-columns: repeat(2, 1fr);
    }

    @media (min-width: 1024px) {
      grid-template-columns: repeat(4, 1fr);
    }
  }

  .step {
    text-align: center;

    .step-number {
      font-size: 2rem;
      font-weight: 800;
      color: $primary-light;
      margin-bottom: 1rem;
      display: block;
    }

    h4 {
      font-size: 1.2rem;
      font-weight: 700;
      margin-bottom: 1rem;
      color: $white;
    }

    p {
      color: #dcecf6;
      line-height: 1.6;
    }
  }
}

.releases-section {
  max-width: 1200px;
  width: 100%;
  margin-bottom: 4rem;

  h2 {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 2rem;
    text-align: center;
  }

  .book-slideshow {
    display: flex;
    gap: 2rem;
    overflow-x: auto;
    padding: 1rem 0;
    scroll-behavior: smooth;

    &::-webkit-scrollbar {
      height: 8px;
    }

    &::-webkit-scrollbar-track {
      background: rgba(255, 255, 255, 0.1);
      border-radius: 4px;
    }

    &::-webkit-scrollbar-thumb {
      background: $primary-light;
      border-radius: 4px;

      &:hover {
        background: $primary;
      }
    }
  }

  .book-container {
    flex: 0 0 200px;
    cursor: pointer;
    transition: transform 0.3s ease;

    &:hover {
      transform: scale(1.05);
    }

    .book-cover {
      width: 100%;
      height: 300px;
      object-fit: cover;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
      transition: box-shadow 0.3s ease;

      &:hover {
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
      }
    }

    .book-info {
      margin-top: 1rem;
      text-align: center;

      h4 {
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 0.5rem;
        color: $white;
      }

      p {
        font-size: 0.9rem;
        color: #dcecf6;
        margin: 0;
      }
    }
  }
}

.book-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  backdrop-filter: blur(4px);

  .overlay-content {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 16px;
    padding: 2rem;
    max-width: 500px;
    width: 90%;
    max-height: 90vh;
    overflow-y: auto;
    position: relative;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);

    .close-btn {
      position: absolute;
      top: 1rem;
      right: 1rem;
      background: none;
      border: none;
      font-size: 2rem;
      cursor: pointer;
      color: #333;
      width: 40px;
      height: 40px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: background 0.2s ease;

      &:hover {
        background: rgba(0, 0, 0, 0.1);
      }
    }

    .book-details {
      display: flex;
      gap: 1.5rem;
      margin-bottom: 2rem;

      @media (max-width: 600px) {
        flex-direction: column;
        align-items: center;
      }

      .overlay-cover {
        width: 150px;
        height: 225px;
        object-fit: cover;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
      }

      .book-meta {
        flex: 1;

        h3 {
          font-size: 1.5rem;
          font-weight: 700;
          margin-bottom: 0.5rem;
          color: #333;
        }

        .author {
          font-size: 1.1rem;
          color: $primary;
          margin-bottom: 0.5rem;
          font-weight: 600;
        }

        .genre {
          font-size: 0.9rem;
          color: #666;
          margin-bottom: 1rem;
          text-transform: uppercase;
          letter-spacing: 0.5px;
        }

        .description {
          color: #555;
          line-height: 1.6;
        }
      }
    }

    .overlay-actions {
      display: flex;
      gap: 1rem;

      @media (max-width: 480px) {
        flex-direction: column;
      }

      .overlay-btn {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        padding: 1rem 1.5rem;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        transition: all 0.3s ease;
        text-align: center;

        .icon {
          font-size: 1.2rem;
        }

        &.author-btn {
          background: $primary;
          color: white;

          &:hover {
            background: $primary-light;
            transform: translateY(-2px);
          }
        }

        &.book-btn {
          background: $secondary;
          color: white;

          &:hover {
            background: lighten($secondary, 10%);
            transform: translateY(-2px);
          }
        }
      }
    }
  }
}

.cta-section {
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
    color: #e7f7ff;
  }

  .cta-buttons {
    display: flex;
    gap: 1rem;
    justify-content: center;
    flex-wrap: wrap;

    .cta-button {
      padding: 0.75rem 2rem;
      font-weight: 600;
      font-size: 1rem;
      border-radius: 8px;
      text-decoration: none;
      transition: all 0.3s ease;

      &.primary {
        background: $primary-light;
        color: #1a1a1a;

        &:hover {
          background: $primary;
          color: $white;
        }
      }

      &.secondary {
        background: transparent;
        color: $primary-light;
        border: 2px solid $primary-light;

        &:hover {
          background: $primary-light;
          color: #1a1a1a;
        }
      }
    }
  }

// Icon classes for service cards
.icon-book::before { content: '📖'; }
.icon-publish::before { content: '🚀'; }
.icon-edit::before { content: '✏️'; }
.icon-tools::before { content: '🛠️'; }
.icon-marketing::before { content: '📈'; }
.icon-sales::before { content: '💰'; }

// Animation classes
.fade-up {
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}

.fade-up.visible {
  opacity: 1;
  transform: translateY(0);
}

@media (max-width: 767px) {
  .author-services-page {
    padding: 2rem 1rem 3rem;
  }

  .hero h1 {
    font-size: 2.25rem;
  }

  .services-grid {
    grid-template-columns: 1fr;
  }

  .process-section .process-steps {
    grid-template-columns: 1fr;
  }

  .cta-section .cta-buttons {
    flex-direction: column;
    align-items: center;

    .cta-button {
      width: 100%;
      max-width: 300px;
    }
  }

  .releases-section {
    .book-slideshow {
      gap: 1rem;
      padding: 0.5rem 0;
    }

    .book-container {
      flex: 0 0 150px;

      .book-cover {
        height: 225px;
      }

      .book-info {
        h4 {
          font-size: 1rem;
        }

        p {
          font-size: 0.8rem;
        }
      }
    }
  }

  .book-overlay .overlay-content {
    padding: 1.5rem;
    margin: 1rem;

    .book-details {
      gap: 1rem;

      .overlay-cover {
        width: 120px;
        height: 180px;
      }

      .book-meta h3 {
        font-size: 1.3rem;
      }
    }

    .overlay-actions {
      .overlay-btn {
        padding: 0.875rem 1.25rem;
        font-size: 0.9rem;
      }
    }
  }
}
}
    </style>