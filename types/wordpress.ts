export interface WordPressImageNode {
  sourceUrl: string
  altText?: string
}

export interface WordPressImage {
  node?: WordPressImageNode
}

export interface WordPressTerm {
  id: string
  name: string
  slug: string
}

export interface WordPressPostListItem {
  id: string
  title: string
  slug: string
  excerpt: string
  date?: string
  featuredImage?: WordPressImage
}

export interface WordPressPost extends WordPressPostListItem {
  content: string
  categories?: { nodes: WordPressTerm[] }
  tags?: { nodes: WordPressTerm[] }
}

export interface WordPressPostsResponse {
  posts: WordPressPostListItem[]
}
