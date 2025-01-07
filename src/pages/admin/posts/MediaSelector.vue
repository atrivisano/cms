<template>
  <div class="fixed z-10 inset-0 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
      <!-- Background overlay -->
      <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true" @click="$emit('close')"></div>

      <!-- Modal panel -->
      <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
      <div class="inline-block align-bottom bg-white rounded-xl px-4 pt-5 pb-4 text-left overflow-hidden shadow-2xl transform transition-all sm:my-8 sm:align-middle sm:max-w-5xl sm:w-full sm:p-6">
        <div class="absolute top-0 right-0 pt-4 pr-4">
          <button
            @click="$emit('close')"
            class="bg-white rounded-lg p-1.5 text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
          >
            <span class="sr-only">Close</span>
            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <div class="sm:flex sm:items-start">
          <div class="mt-3 text-center sm:mt-0 sm:text-left w-full">
            <h3 class="text-xl font-semibold text-gray-900" id="modal-title">
              Select Featured Image
            </h3>

            <!-- Search and filters -->
            <div class="mt-4 flex space-x-4">
              <div class="flex-1">
                <input
                  v-model="searchQuery"
                  type="text"
                  placeholder="Search images..."
                  class="w-full rounded-lg border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500"
                >
              </div>
              <button 
                @click="$emit('upload')"
                class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700"
              >
                Upload New
              </button>
            </div>

            <!-- Images grid -->
            <div class="mt-6 grid grid-cols-3 gap-4 max-h-[60vh] overflow-y-auto p-2">
              <div 
                v-for="image in filteredImages" 
                :key="image.id"
                class="relative group cursor-pointer"
                @click="selectImage(image)"
              >
                <div 
                  class="aspect-w-10 aspect-h-7 block w-full overflow-hidden rounded-lg"
                  :class="{ 'ring-2 ring-primary-500': selectedImage?.id === image.id }"
                >
                  <img 
                    :src="image.url" 
                    :alt="image.name"
                    class="object-cover pointer-events-none transform group-hover:scale-105 transition-all duration-200"
                  >
                  <div class="absolute inset-0 bg-black opacity-0 group-hover:opacity-10 transition-opacity duration-200"></div>
                </div>
                <p class="mt-2 block text-sm font-medium text-gray-900 truncate">{{ image.name }}</p>
              </div>
            </div>

            <!-- Action buttons -->
            <div class="mt-6 flex justify-end space-x-3">
              <button 
                @click="$emit('close')"
                class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
              >
                Cancel
              </button>
              <button 
                @click="confirmSelection"
                :disabled="!selectedImage"
                class="px-4 py-2 text-sm font-medium text-white bg-primary-600 border border-transparent rounded-md hover:bg-primary-700 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Select Image
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { supabase } from '../../../lib/supabase'

const props = defineProps({
  currentImage: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['close', 'select', 'upload'])

const images = ref([])
const searchQuery = ref('')
const selectedImage = ref(null)

// Load images on mount
const loadImages = async () => {
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) return

  const { data, error } = await supabase
    .from('media')
    .select('*')
    .eq('type', 'image')
    .order('created_at', { ascending: false })

  if (!error) {
    images.value = data
    if (props.currentImage) {
      selectedImage.value = data.find(img => img.url === props.currentImage)
    }
  }
}

loadImages()

const filteredImages = computed(() => {
  if (!searchQuery.value) return images.value
  const query = searchQuery.value.toLowerCase()
  return images.value.filter(image => 
    image.name.toLowerCase().includes(query)
  )
})

const selectImage = (image) => {
  selectedImage.value = image
}

const confirmSelection = () => {
  if (selectedImage.value) {
    emit('select', selectedImage.value.url)
    emit('close')
  }
}
</script>