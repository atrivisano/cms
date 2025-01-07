<template>
  <div class="min-h-screen bg-gray-100">
    <div class="py-10">
      <header class="mb-8 bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex justify-between items-center py-6">
            <div>
              <h1 class="text-3xl font-bold leading-tight text-gray-900">Posts</h1>
              <p class="mt-2 text-sm text-gray-600">Manage and create your blog posts</p>
            </div>
            <a href="/admin/posts/new" class="inline-flex items-center px-5 py-2.5 border border-transparent text-sm font-medium rounded-lg shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors duration-200">
              <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
              </svg>
              New Post
            </a>
          </div>
        </div>
      </header>
      <main>
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <!-- Filters -->
          <div class="flex flex-col sm:flex-row sm:items-center sm:space-x-4 space-y-4 sm:space-y-0 mb-8 bg-white p-4 rounded-lg shadow-sm">
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
              </div>
              <input
                type="text"
                v-model="searchQuery"
                placeholder="Search posts..."
                class="pl-10 w-full sm:w-72 rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 transition-colors duration-200"
              >
            </div>
            <select
              v-model="statusFilter"
              class="w-full sm:w-auto rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 transition-colors duration-200"
            >
              <option value="">All Status</option>
              <option value="published">Published</option>
              <option value="draft">Draft</option>
            </select>
          </div>

          <!-- Posts Grid -->
          <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            <div v-for="post in filteredPosts" :key="post.id" class="flex flex-col bg-white rounded-lg shadow-sm hover:shadow-lg transition-all duration-200 transform hover:-translate-y-1">
              <div class="relative">
                <img 
                  :src="post.featured_image || 'https://via.placeholder.com/400x250'"
                  :alt="post.title"
                  class="w-full h-48 object-cover rounded-t-lg hover:opacity-90 transition-opacity duration-200"
                >
                <span 
                  :class="[
                    'absolute top-3 right-3 px-3 py-1 text-xs font-semibold rounded-full shadow-sm backdrop-blur-sm',
                    post.status === 'published' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'
                  ]"
                >
                  {{ post.status }}
                </span>
              </div>
              <div class="p-5 flex-1">
                <h3 class="text-lg font-semibold text-gray-900 mb-2">{{ post.title }}</h3>
                <p class="text-sm text-gray-600 mb-4 line-clamp-2">{{ post.excerpt }}</p>
                <div class="flex items-center justify-between text-sm text-gray-500">
                  <div class="flex flex-col space-y-1">
                    <span>{{ formatDate(post.published_at || post.created_at) }}</span>
                    <span class="text-xs text-gray-400">{{ getCategoryNames(post) }}</span>
                  </div>
                  <a 
                    :href="`/admin/posts/${post.id}`" 
                    class="inline-flex items-center text-primary-600 hover:text-primary-900 font-medium transition-colors duration-200"
                  >
                    Edit
                    <svg class="ml-1 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                    </svg>
                  </a>
                </div>
              </div>
            </div>
            
            <!-- Empty State -->
            <div v-if="filteredPosts.length === 0" class="col-span-full text-center py-16 bg-white rounded-lg shadow-sm">
              <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 48 48">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v20c0 4.4 3.6 8 8 8h16c4.4 0 8-3.6 8-8V14m-32 0l4-8h20l4 8m-32 0h32m-18 8v12m4-12v12" />
              </svg>
              <h3 class="mt-2 text-sm font-medium text-gray-900">No posts found</h3>
              <p class="mt-1 text-sm text-gray-500">Get started by creating a new post.</p>
              <div class="mt-6">
                <a href="/admin/posts/new" class="inline-flex items-center px-5 py-2.5 border border-transparent shadow-sm text-sm font-medium rounded-lg text-white bg-primary-600 hover:bg-primary-700 transition-colors duration-200">
                  <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                  </svg>
                  New Post
                </a>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { supabase } from '../../../lib/supabase'

const posts = ref([])
const searchQuery = ref('')
const statusFilter = ref('')
const categories = ref({})

const filteredPosts = computed(() => {
  return posts.value.filter(post => {
    const matchesSearch = !searchQuery.value || 
      post.title.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      post.excerpt?.toLowerCase().includes(searchQuery.value.toLowerCase())
    
    const matchesStatus = !statusFilter.value || post.status === statusFilter.value
    
    return matchesSearch && matchesStatus
  })
})

onMounted(async () => {
  await loadCategories()
  const { data, error } = await supabase
    .from('posts') 
    .select(`
      *,
      posts_categories(
        category_id
      )
    `)
    .order('created_at', { ascending: false })

  if (!error) {
    posts.value = data
  }
})

const loadCategories = async () => {
  const { data } = await supabase
    .from('categories')
    .select('id, name')
  
  if (data) {
    categories.value = data.reduce((acc, cat) => {
      acc[cat.id] = cat.name
      return acc
    }, {})
  }
}

const getCategoryNames = (post) => {
  return post.posts_categories
    ?.map(pc => categories.value[pc.category_id])
    .filter(Boolean)
    .join(', ') || 'Uncategorized'
}

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}
</script>