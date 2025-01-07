<template>
  <div class="min-h-screen bg-gray-100">
    <div class="py-10">
      <header class="bg-white shadow-sm mb-8">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex justify-between items-center py-6">
            <h1 class="text-3xl font-bold leading-tight text-gray-900">New Post</h1>
            <div class="flex space-x-3">
              <button 
                @click="saveAsDraft" 
                :disabled="!isFormValid || isSubmitting"
                class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
              >
                <span v-if="isSubmitting && status === 'draft'" class="mr-2">
                  <svg class="animate-spin h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                </span>
                Save as Draft
              </button>
              <button 
                @click="publish" 
                :disabled="!isFormValid || isSubmitting"
                class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
              >
                <span v-if="isSubmitting && status === 'published'" class="mr-2">
                  <svg class="animate-spin h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                </span>
                Publish
              </button>
            </div>
          </div>
        </div>
      </header>
      <main>
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="bg-white shadow-sm rounded-lg p-8">
            <form @submit.prevent class="space-y-8 divide-y divide-gray-200">
              <div class="space-y-8 divide-y divide-gray-200">
                <div>
                  <div class="mt-6 grid grid-cols-1 gap-y-8 gap-x-4 sm:grid-cols-6">
                    <div class="sm:col-span-4">
                      <label for="title" class="block text-sm font-semibold text-gray-900">
                        Title <span class="text-red-500">*</span>
                      </label>
                      <div class="mt-1">
                        <input 
                          v-model="post.title" 
                          type="text" 
                          name="title" 
                          id="title" 
                          :class="[
                            'shadow-md block w-full sm:text-sm border-2 border-gray-300 rounded-lg transition-all duration-200 bg-white',
                            'hover:border-gray-400',
                            errors.title ? 'border-red-300 focus:ring-red-500 focus:border-red-500' : 'focus:ring-primary-500 focus:border-primary-500 focus:ring-2'
                          ]"
                          @blur="validateField('title')"
                        >
                        <p v-if="errors.title" class="mt-1 text-sm text-red-600">{{ errors.title }}</p>
                      </div>
                    </div>

                    <div class="sm:col-span-6">
                      <label for="excerpt" class="block text-sm font-semibold text-gray-900">Excerpt</label>
                      <div class="mt-1">
                        <textarea 
                          v-model="post.excerpt" 
                          id="excerpt" 
                          name="excerpt" 
                          rows="3" 
                          class="shadow-md focus:ring-primary-500 focus:border-primary-500 focus:ring-2 block w-full sm:text-sm border-2 border-gray-300 rounded-lg transition-all duration-200 hover:border-gray-400 bg-white"
                          @blur="validateField('excerpt')"
                        ></textarea>
                        <p class="mt-1 text-sm text-gray-500">Brief summary of your post (optional)</p>
                      </div>
                    </div>

                    <div class="sm:col-span-6">
                      <label for="content" class="block text-sm font-semibold text-gray-900">
                        Content <span class="text-red-500">*</span>
                        <span class="text-sm font-normal text-gray-500 ml-2">Supports Markdown syntax</span>
                      </label>
                      <div class="mt-1">
                        <textarea 
                          v-model="post.content" 
                          id="content" 
                          name="content" 
                          rows="20" 
                          :class="[
                            'shadow-md block w-full sm:text-sm border-2 border-gray-300 rounded-lg transition-all duration-200 bg-white',
                            'hover:border-gray-400',
                            errors.content ? 'border-red-300 focus:ring-red-500 focus:border-red-500' : 'focus:ring-primary-500 focus:border-primary-500 focus:ring-2'
                          ]"
                          @blur="validateField('content')"
                          placeholder="Write your content using Markdown syntax...

# Heading 1
## Heading 2

**Bold text** and *italic text*

- Bullet points
- Another point

1. Numbered list
2. Second item

[Link text](https://example.com)

> Blockquote text"
                        ></textarea>
                        <p v-if="errors.content" class="mt-1 text-sm text-red-600">{{ errors.content }}</p>
                        <p class="mt-1 text-sm text-gray-500">Use Markdown for formatting: **bold**, *italic*, # headings, - lists, [links](url)</p>
                      </div>
                    </div>

                    <div class="sm:col-span-6">
                      <label class="block text-sm font-semibold text-gray-900">Featured Image</label>
                      <div class="mt-1 flex items-center space-x-4">
                        <div 
                          class="relative flex-shrink-0 h-32 w-32 rounded-lg border-2 border-gray-300 border-dashed hover:border-primary-500 transition-colors duration-200"
                          :class="{ 'border-solid': post.featured_image }"
                        >
                          <img 
                            v-if="post.featured_image" 
                            :src="post.featured_image" 
                            class="h-full w-full object-cover rounded-lg"
                            alt="Featured image"
                          >
                          <div 
                            v-else 
                            class="absolute inset-0 flex items-center justify-center"
                          >
                            <svg class="h-8 w-8 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                          </div>
                        </div>
                        <button 
                          type="button"
                          @click="showMediaSelector = true"
                          class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                        >
                          {{ post.featured_image ? 'Change Image' : 'Select Image' }}
                        </button>
                        <button 
                          v-if="post.featured_image"
                          type="button"
                          @click="post.featured_image = ''"
                          class="inline-flex items-center p-2 border border-gray-300 rounded-md text-gray-400 hover:text-red-500 hover:border-red-500"
                        >
                          <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                          </svg>
                        </button>
                      </div>
                      <p class="mt-2 text-sm text-gray-500">Recommended size: 1200x630 pixels</p>
                    </div>

                    <div class="sm:col-span-6">
                      <label class="block text-sm font-medium text-gray-700">Categories</label>
                      <div class="mt-2 space-y-2">
                        <div v-for="category in categories" :key="category.id" class="relative flex items-start">
                          <div class="flex items-center h-5">
                            <input
                              :id="'category-' + category.id"
                              :value="category.id"
                              v-model="selectedCategories"
                              type="checkbox"
                              class="h-4 w-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                            >
                          </div>
                          <div class="ml-3 text-sm">
                            <label :for="'category-' + category.id" class="font-medium text-gray-700">{{ category.name }}</label>
                            <p v-if="category.description" class="text-gray-500">{{ category.description }}</p>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div class="sm:col-span-4">
                      <label for="meta-title" class="block text-sm font-semibold text-gray-900">Meta Title</label>
                      <div class="mt-1">
                        <input 
                          v-model="post.meta_title" 
                          type="text" 
                          name="meta-title" 
                          id="meta-title" 
                          class="shadow-md focus:ring-primary-500 focus:border-primary-500 focus:ring-2 block w-full sm:text-sm border-2 border-gray-300 rounded-lg transition-all duration-200 hover:border-gray-400 bg-white"
                        >
                        <p class="mt-1 text-sm text-gray-500">SEO title (optional)</p>
                      </div>
                    </div>

                    <div class="sm:col-span-6">
                      <label for="meta-description" class="block text-sm font-semibold text-gray-900">Meta Description</label>
                      <div class="mt-1">
                        <textarea 
                          v-model="post.meta_description" 
                          id="meta-description" 
                          name="meta-description" 
                          rows="3" 
                          class="shadow-md focus:ring-primary-500 focus:border-primary-500 focus:ring-2 block w-full sm:text-sm border-2 border-gray-300 rounded-lg transition-all duration-200 hover:border-gray-400 bg-white"
                        ></textarea>
                        <p class="mt-1 text-sm text-gray-500">SEO description (optional)</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </form>
            
            <!-- Error Alert -->
            <div v-if="error" class="mt-6 rounded-md bg-red-50 p-4">
              <div class="flex">
                <div class="flex-shrink-0">
                  <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                  </svg>
                </div>
                <div class="ml-3">
                  <h3 class="text-sm font-medium text-red-800">Error</h3>
                  <p class="mt-2 text-sm text-red-700">{{ error }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
  
  <!-- Media Selector Modal -->
  <MediaSelector
    v-if="showMediaSelector"
    :current-image="post.featured_image"
    @close="showMediaSelector = false"
    @select="selectFeaturedImage"
    @upload="showUploadModal = true"
  />

  <!-- Upload Modal -->
  <UploadModal
    v-if="showUploadModal"
    :uploading-files="uploadingFiles"
    @close="closeUploadModal"
    @file-drop="handleFileDrop"
    @file-select="handleFileSelect"
  />
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { supabase } from '../../../lib/supabase'
import MediaSelector from '../../../components/MediaSelector.vue'
import UploadModal from '../../../components/UploadModal.vue'

const categories = ref([])
const selectedCategories = ref([])

const post = ref({
  title: '',
  excerpt: '',
  content: '',
  featured_image: '',
  meta_title: '',
  meta_description: '',
})

onMounted(async () => {
  await loadCategories()
})

const loadCategories = async () => {
  const { data } = await supabase
    .from('categories')
    .select('*')
    .order('name')
  
  if (data) {
    categories.value = data
  }
}

const error = ref('')
const errors = ref({})
const isSubmitting = ref(false)
const status = ref('')
const showMediaSelector = ref(false)
const showUploadModal = ref(false)
const uploadingFiles = ref([])

const validationRules = {
  title: [
    v => !!v || 'Title is required',
    v => v.length >= 3 || 'Title must be at least 3 characters',
    v => v.length <= 100 || 'Title must be less than 100 characters'
  ],
  content: [
    v => !!v || 'Content is required',
    v => v.length >= 10 || 'Content must be at least 10 characters'
  ],
  featured_image: [
    v => !v || isValidUrl(v) || 'Please enter a valid URL'
  ]
}

const isFormValid = computed(() => {
  return !!post.value.title && !!post.value.content && Object.keys(errors.value).length === 0
})

function isValidUrl(string) {
  try {
    new URL(string)
    return true
  } catch (_) {
    return false
  }
}

function validateField(field) {
  const value = post.value[field]
  const rules = validationRules[field]
  
  if (!rules) return true

  for (const rule of rules) {
    const result = rule(value)
    if (result !== true) {
      errors.value[field] = result
      return false
    }
  }

  delete errors.value[field]
  return true
}

function validateForm() {
  let isValid = true
  for (const field in validationRules) {
    if (!validateField(field)) {
      isValid = false
    }
  }
  return isValid
}

const generateSlug = (title) => {
  return title
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)+/g, '')
}

const savePost = async (status) => {
  try {
    if (!validateForm()) {
      throw new Error('Please fix the validation errors before submitting')
    }

    isSubmitting.value = true
    error.value = ''

    const { data: { session }, error: sessionError } = await supabase.auth.getSession()

    if (sessionError || !session) {
      throw new Error('Please sign in to create a post')
    }

    // Check if profile exists, create if it doesn't
    const { data: profile } = await supabase
      .from('profiles')
      .select()
      .eq('id', session.user.id)

    if (!profile || profile.length === 0) {
      const { error: profileError } = await supabase
        .from('profiles')
        .insert([{ id: session.user.id, name: session.user.email }])

      if (profileError) {
        throw new Error('Failed to create user profile')
      }
    }

    const postData = {
      ...post.value,
      slug: generateSlug(post.value.title),
      status,
      author_id: session.user.id,
      content: post.value.content,
      published_at: status === 'published' ? new Date().toISOString() : null
    }

    const { data: newPost, error: insertError } = await supabase
      .from('posts')
      .insert([postData])
      .select()
      .single()
    
    if (insertError) {
      throw new Error(insertError.message)
    }

    // Insert categories
    if (newPost && selectedCategories.value.length > 0) {
      const { error: categoriesError } = await supabase
        .from('posts_categories')
        .insert(
          selectedCategories.value.map(categoryId => ({
            post_id: newPost.id,
            category_id: categoryId
          }))
        )

      if (categoriesError) {
        throw new Error('Failed to add categories')
      }
    }

    window.location.href = '/admin/posts'
  } catch (e) {
    error.value = e.message
  } finally {
    isSubmitting.value = false
  }
}

const saveAsDraft = () => {
  status.value = 'draft'
  savePost('draft')
}

const publish = () => {
  status.value = 'published'
  savePost('published')
}

const selectFeaturedImage = (url) => {
  post.value.featured_image = url
}

const closeUploadModal = () => {
  showUploadModal.value = false
  uploadingFiles.value = []
}

const handleFileDrop = (e) => {
  const droppedFiles = [...e.dataTransfer.files].filter(file => file.type.startsWith('image/'))
  uploadFiles(droppedFiles)
}

const handleFileSelect = (e) => {
  const selectedFiles = [...e.target.files].filter(file => file.type.startsWith('image/'))
  uploadFiles(selectedFiles)
}

const uploadFiles = async (files) => {
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) return

  for (const file of files) {
    if (file.size > 5 * 1024 * 1024) {
      alert(`${file.name} exceeds the 5MB limit`)
      continue
    }

    uploadingFiles.value.push({
      name: file.name,
      progress: 0
    })

    const fileExt = file.name.split('.').pop()
    const fileName = `${Math.random().toString(36).substring(2)}.${fileExt}`
    const filePath = `${session.user.id}/${fileName}`

    const { error: uploadError } = await supabase.storage
      .from('media')
      .upload(filePath, file, {
        upsert: false,
        onUploadProgress: (progress) => {
          const fileIndex = uploadingFiles.value.findIndex(f => f.name === file.name)
          if (fileIndex !== -1) {
            uploadingFiles.value[fileIndex].progress = Math.round((progress.loaded / progress.total) * 100)
          }
        }
      })

    if (uploadError) {
      alert(`Error uploading ${file.name}`)
      continue
    }

    const { data: { publicUrl } } = supabase.storage
      .from('media')
      .getPublicUrl(filePath)

    const { error: dbError } = await supabase
      .from('media')
      .insert([{
        name: file.name,
        path: filePath,
        url: publicUrl,
        type: 'image',
        size: file.size,
        user_id: session.user.id
      }])

    if (dbError) {
      alert(`Error saving ${file.name} metadata`)
    }
  }

  closeUploadModal()
  showMediaSelector.value = true
}
</script>