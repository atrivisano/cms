<template>
  <div class="fixed z-10 inset-0 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
      <!-- Background overlay -->
      <div 
        class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" 
        aria-hidden="true"
        @click="$emit('close')"
      ></div>

      <!-- Modal panel -->
      <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
      <div class="inline-block align-bottom bg-white rounded-xl px-4 pt-5 pb-4 text-left overflow-hidden shadow-2xl transform transition-all sm:my-8 sm:align-middle sm:max-w-xl sm:w-full sm:p-8">
        <!-- Close button -->
        <div class="absolute top-0 right-0 pt-4 pr-4">
          <button
            @click="$emit('close')"
            class="bg-white rounded-lg p-1.5 text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all duration-200"
          >
            <span class="sr-only">Close</span>
            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <!-- Content -->
        <div class="sm:flex sm:items-start">
          <div class="mt-3 text-center sm:mt-0 sm:text-left w-full">
            <h3 class="text-xl font-semibold text-gray-900" id="modal-title">
              Upload Files
            </h3>
            <div class="mt-2">
              <p class="text-sm text-gray-600">
                Drag and drop files here or click to select files
              </p>
            </div>

            <!-- Upload area -->
            <div
              class="mt-6 flex justify-center px-8 py-10 border-2 border-gray-300 border-dashed rounded-xl hover:border-primary-500 hover:bg-primary-50/5 transition-all duration-200 group cursor-pointer"
              @dragover.prevent
              @drop.prevent="$emit('file-drop', $event)"
            >
              <div class="space-y-1 text-center">
                <svg class="mx-auto h-14 w-14 text-gray-400 group-hover:text-primary-500 transition-colors duration-200" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                  <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                <div class="flex text-sm text-gray-600">
                  <label class="relative cursor-pointer rounded-md font-medium text-primary-600 hover:text-primary-700 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-primary-500 transition-colors duration-200">
                    <span>Upload a file</span>
                    <input 
                      type="file" 
                      class="sr-only" 
                      multiple 
                      accept="image/*,.pdf"
                      @change="$emit('file-select', $event)"
                    >
                  </label>
                  <p class="pl-1">or drag and drop</p>
                </div>
                <p class="text-xs text-gray-500 mt-2">
                  PNG, JPG, GIF up to 5MB, PDF up to 10MB
                </p>
              </div>
            </div>

            <!-- Upload Progress -->
            <div v-if="uploadingFiles.length > 0" class="mt-6 space-y-3 max-h-60 overflow-y-auto pr-2">
              <div v-for="file in uploadingFiles" :key="file.name" class="relative">
                <div class="flex items-center justify-between text-sm bg-gray-50 p-3 rounded-lg">
                  <div class="w-0 flex-1 flex items-center">
                    <svg class="flex-shrink-0 h-5 w-5 text-gray-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                    </svg>
                    <span class="flex-1 w-0 truncate font-medium text-gray-900">{{ file.name }}</span>
                  </div>
                  <div class="ml-4 flex-shrink-0">
                    <div class="text-primary-600 font-medium">
                      {{ file.progress }}%
                    </div>
                  </div>
                </div>
                <div class="mt-2 h-1.5 w-full bg-gray-200 rounded-full overflow-hidden">
                  <div
                    class="h-full bg-primary-600 rounded-full transition-all duration-200 ease-out"
                    :style="{ width: `${file.progress || 0}%` }"
                  ></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  uploadingFiles: {
    type: Array,
    required: true
  }
})

defineEmits(['close', 'file-drop', 'file-select'])
</script>