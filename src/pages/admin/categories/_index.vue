<template>
  <div class="min-h-screen bg-gray-100">
    <div class="py-10">
      <header class="mb-8 bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex justify-between items-center py-6">
            <div>
              <h1 class="text-3xl font-bold leading-tight text-gray-900">Categories</h1>
              <p class="mt-2 text-sm text-gray-600">Manage your post categories</p>
            </div>
            <button 
              @click="openCreateModal"
              class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700"
            >
              <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
              </svg>
              New Category
            </button>
          </div>
        </div>
      </header>

      <main>
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <!-- Categories List -->
          <div class="bg-white shadow-sm rounded-lg divide-y divide-gray-200">
            <div v-for="category in categories" :key="category.id" class="p-6">
              <div class="flex items-center justify-between">
                <div>
                  <h3 class="text-lg font-medium text-gray-900">{{ category.name }}</h3>
                  <p class="mt-1 text-sm text-gray-400">Slug: {{ category.slug }}</p>
                  <p class="mt-1 text-sm text-gray-500">{{ category.description || 'No description' }}</p>
                </div>
                <div class="flex space-x-3">
                  <button 
                    @click="editCategory(category)"
                    class="inline-flex items-center p-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
                  >
                    <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                  </button>
                  <button 
                    @click="deleteCategory(category)"
                    class="inline-flex items-center p-2 border border-gray-300 rounded-md text-sm font-medium text-red-600 bg-white hover:bg-red-50 hover:border-red-500"
                  >
                    <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>

            <!-- Empty State -->
            <div v-if="categories.length === 0" class="p-6 text-center">
              <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16" />
              </svg>
              <h3 class="mt-2 text-sm font-medium text-gray-900">No categories</h3>
              <p class="mt-1 text-sm text-gray-500">Get started by creating a new category.</p>
              <div class="mt-6">
                <button
                  @click="openCreateModal"
                  class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700"
                >
                  <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                  </svg>
                  New Category
                </button>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>

    <!-- Category Modal -->
    <div v-if="showModal" class="fixed z-10 inset-0 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div 
          class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
          aria-hidden="true"
          @click="closeModal"
        ></div>

        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
        <div class="inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6">
          <div class="absolute top-0 right-0 pt-4 pr-4">
            <button
              @click="closeModal"
              class="bg-white rounded-md text-gray-400 hover:text-gray-500"
            >
              <span class="sr-only">Close</span>
              <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <div class="sm:flex sm:items-start">
            <div class="mt-3 text-center sm:mt-0 sm:text-left w-full">
              <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                {{ editingCategory ? 'Edit Category' : 'New Category' }}
              </h3>

              <form @submit.prevent="saveCategory" class="mt-6 space-y-6">
                <div>
                  <label for="name" class="block text-sm font-medium text-gray-700">
                    Name <span class="text-red-500">*</span>
                  </label>
                  <input
                    v-model="categoryForm.name"
                    type="text"
                    name="name"
                    id="name"
                    required
                    class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                    :class="{ 'border-red-300': errors.name }"
                  >
                  <p v-if="errors.name" class="mt-1 text-sm text-red-600">{{ errors.name }}</p>
                </div>

                <div>
                  <label for="slug" class="block text-sm font-medium text-gray-700">
                    Slug <span class="text-red-500">*</span>
                  </label>
                  <div class="mt-1 flex rounded-md shadow-sm">
                    <input
                      v-model="categoryForm.slug"
                      type="text"
                      name="slug"
                      id="slug"
                      required
                      class="block w-full border-gray-300 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                      :class="{ 'border-red-300': errors.slug }"
                    >
                  </div>
                  <p class="mt-1 text-sm text-gray-500">URL-friendly version of the name. Auto-generated but can be edited.</p>
                  <p v-if="errors.slug" class="mt-1 text-sm text-red-600">{{ errors.slug }}</p>
                </div>

                <div>
                  <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
                  <textarea
                    v-model="categoryForm.description"
                    id="description"
                    name="description"
                    rows="3"
                    class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                  ></textarea>
                </div>

                <div class="mt-5 sm:mt-4 sm:flex sm:flex-row-reverse">
                  <button
                    type="submit"
                    :disabled="!isFormValid || isSubmitting"
                    class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-primary-600 text-base font-medium text-white hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 sm:ml-3 sm:w-auto sm:text-sm disabled:opacity-50"
                  >
                    {{ editingCategory ? 'Update' : 'Create' }}
                  </button>
                  <button
                    type="button"
                    @click="closeModal"
                    class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 sm:mt-0 sm:w-auto sm:text-sm"
                  >
                    Cancel
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { supabase } from '../../../lib/supabase'

const categories = ref([])
const showModal = ref(false)
const editingCategory = ref(null)
const isSubmitting = ref(false)
const errors = ref({})

const categoryForm = ref({
  name: '',
  slug: '',
  description: ''
})

const isFormValid = computed(() => {
  return categoryForm.value.name.length >= 2 && 
         categoryForm.value.name.length <= 50 &&
         Object.keys(errors.value).length === 0
})

onMounted(async () => {
  await loadCategories()
})

const loadCategories = async () => {
  const { data, error } = await supabase
    .from('categories')
    .select('*')
    .order('name')

  if (!error) {
    categories.value = data
  }
}

const generateSlug = (name) => {
  return name
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)+/g, '')
}

const validateForm = () => {
  errors.value = {}
  
  if (!categoryForm.value.name) {
    errors.value.name = 'Name is required'
  } else if (categoryForm.value.name.length < 2) {
    errors.value.name = 'Name must be at least 2 characters'
  } else if (categoryForm.value.name.length > 50) {
    errors.value.name = 'Name must be less than 50 characters'
  }
  
  if (!categoryForm.value.slug) {
    errors.value.slug = 'Slug is required'
  } else if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(categoryForm.value.slug)) {
    errors.value.slug = 'Slug must contain only lowercase letters, numbers, and hyphens'
  }

  return Object.keys(errors.value).length === 0
}

const openCreateModal = () => {
  editingCategory.value = null
  categoryForm.value = {
    name: '',
    slug: '',
    description: ''
  }
  showModal.value = true
}

const editCategory = (category) => {
  editingCategory.value = category
  categoryForm.value = {
    name: category.name,
    slug: category.slug,
    description: category.description || ''
  }
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
  editingCategory.value = null
  categoryForm.value = {
    name: '',
    slug: '',
    description: ''
  }
  errors.value = {}
}

const saveCategory = async () => {
  if (!validateForm()) return

  try {
    isSubmitting.value = true
    const categoryData = {
      name: categoryForm.value.name,
      slug: categoryForm.value.slug,
      description: categoryForm.value.description,
    }

    if (editingCategory.value) {
      const { error } = await supabase
        .from('categories')
        .update(categoryData)
        .eq('id', editingCategory.value.id)

      if (error) throw error
    } else {
      const { error } = await supabase
        .from('categories')
        .insert([categoryData])

      if (error) throw error
    }

    await loadCategories()
    closeModal()
  } catch (error) {
    if (error.code === '23505') {
      if (error.message.includes('slug')) {
        errors.value.slug = 'A category with this slug already exists'
      } else {
        errors.value.name = 'A category with this name already exists'
      }
    } else {
      console.error('Error saving category:', error)
    }
  } finally {
    isSubmitting.value = false
  }
}

const deleteCategory = async (category) => {
  if (!confirm(`Are you sure you want to delete "${category.name}"?`)) return

  try {
    const { error } = await supabase
      .from('categories')
      .delete()
      .eq('id', category.id)

    if (error) throw error

    await loadCategories()
  } catch (error) {
    console.error('Error deleting category:', error)
  }
}

// Watch name changes to auto-generate slug
watch(() => categoryForm.value.name, (newName) => {
  if (!editingCategory.value || !categoryForm.value.slug) {
    categoryForm.value.slug = generateSlug(newName)
  }
})
</script>