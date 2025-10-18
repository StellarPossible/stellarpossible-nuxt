<template>
  <div class="wordpress-content-renderer">
    <!-- Content display with direct HTML rendering -->
    <div 
      class="wp-rendered-content" 
      v-html="sanitizedContent"
      ref="contentRef"
    ></div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';

// Define props
const props = defineProps({
  content: {
    type: String,
    required: true
  },
  debug: {
    type: Boolean,
    default: false
  }
});

// Basic sanitization (expand this as needed)
const sanitizedContent = computed(() => {
  if (!props.content) return '';
  
  // Return the original content for now
  // In a real app, you might want to use a proper sanitizer library
  return props.content;
});
</script>

<style scoped lang="scss">
.wordpress-content-renderer {
  width: 100%;
  
  .wp-rendered-content {
    background-color: #fff;
    color: #333;
    padding: 2rem;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    
    /* Allow WordPress content to be displayed properly */
    :deep(p) {
      display: block;
      margin-bottom: 1.5rem;
      line-height: 1.6;
    }
    
    :deep(h1), :deep(h2), :deep(h3), 
    :deep(h4), :deep(h5), :deep(h6) {
      display: block;
      margin-top: 1.5rem;
      margin-bottom: 1rem;
      font-weight: 600;
      color: #222;
    }
    
    :deep(ul), :deep(ol) {
      display: block;
      margin-left: 1.5rem;
      margin-bottom: 1.5rem;
      
      :deep(li) {
        display: list-item;
        margin-bottom: 0.5rem;
      }
    }
    
    :deep(img) {
      max-width: 100%;
      height: auto;
      display: block;
      margin: 1.5rem 0;
    }
    
    :deep(a) {
      color: #0066cc;
      text-decoration: underline;
      
      &:hover {
        color: #004499;
      }
    }
    
    :deep(blockquote) {
      margin: 1.5rem 0;
      padding-left: 1rem;
      border-left: 4px solid #0066cc;
      font-style: italic;
      color: #555;
    }
    
    :deep(pre), :deep(code) {
      background-color: #f5f5f5;
      border-radius: 4px;
      padding: 0.2rem 0.4rem;
      font-family: monospace;
    }
    
    :deep(pre) {
      padding: 1rem;
      overflow-x: auto;
    }
    
    :deep(table) {
      width: 100%;
      border-collapse: collapse;
      margin: 1.5rem 0;
      
      :deep(th), :deep(td) {
        padding: 0.75rem;
        border: 1px solid #ddd;
      }
      
      :deep(th) {
        background-color: #f5f5f5;
        font-weight: bold;
      }
    }
  }
}
</style>