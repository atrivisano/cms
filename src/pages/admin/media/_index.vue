<template>
    <div class="min-h-screen flex flex-col gap-10 bg-gray-100 py-10">
        <header class="w-full max-w-7xl mx-auto flex flex-col gap-5 px-4 sm:px-6 lg:px-8">
            <section class="flex justify-between items-center py-6">
                <div>
                    <h1 class="text-3xl font-bold leading-tight text-gray-900">Media Library</h1>
                    <p class="mt-2 text-sm text-gray-600">Manage your images and documents</p>
                </div>
                <div class="flex items-center space-x-4">
                    <ViewButton @toggle-view-mode="toggleView" />
                    <button
                        @click="openUploadModal"
                        class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700"
                    >
                        <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"/>
                        </svg>
                        Upload Files
                    </button>
                </div>
            </section>

            <!-- Filters -->
            <section class="flex flex-col sm:flex-row sm:items-center sm:space-x-4 space-y-4 sm:space-y-0">
                <div class="relative flex-1">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <svg class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24"
                             stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                        </svg>
                    </div>
                    <input
                        v-model="searchQuery"
                        type="text"
                        placeholder="Search files..."
                        class="pl-10 w-full rounded-lg border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500"
                    >
                </div>
                <div class="flex space-x-4">
                    <select
                        v-model="typeFilter"
                        class="rounded-lg border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500"
                    >
                        <option value="">All Types</option>
                        <option value="image">Images</option>
                        <option value="document">Documents</option>
                    </select>
                    <select
                        v-model="sortBy"
                        class="rounded-lg border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500"
                    >
                        <option value="newest">Newest First</option>
                        <option value="oldest">Oldest First</option>
                        <option value="name">Name</option>
                        <option value="size">Size</option>
                    </select>
                </div>
            </section>
        </header>

        <main>
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Grid View -->
                <div v-if="viewMode === 'grid'"
                     class="grid grid-cols-1 gap-6 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
                    <div v-for="file in filteredFiles" :key="file.id" class="relative group">
                        <div
                            class="bg-white rounded-xl shadow-sm overflow-hidden hover:shadow-lg transition-all duration-200 ring-1 ring-gray-100">
                            <div
                                class="aspect-w-10 aspect-h-7 block w-full overflow-hidden bg-gradient-to-br from-gray-50 to-gray-100 cursor-pointer group"
                                @click="previewFile(file)"
                            >
                                <img
                                    v-if="file.type === 'image'"
                                    :src="file.url"
                                    :alt="file.name"
                                    class="object-cover transform group-hover:scale-105 transition-all duration-300 ease-out"
                                    loading="lazy"
                                >
                                <div v-else class="flex items-center justify-center h-full">
                                    <svg class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24"
                                         stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
                                    </svg>
                                </div>
                                <div
                                    class="absolute inset-0 bg-black opacity-0 transition-opacity duration-200"></div>
                            </div>
                            <div class="p-4">
                                <p class="text-sm font-medium text-gray-900 truncate">{{ file.name }}</p>
                                <p class="text-xs text-gray-500 mt-1">{{ formatFileSize(file.size) }}</p>
                                <div class="flex justify-end space-x-2 mt-3 border-t border-gray-50 pt-3">
                                    <button
                                        @click="copyUrl(file)"
                                        class="p-1.5 rounded-lg text-gray-400 hover:text-primary-600 hover:bg-primary-50 transition-all duration-200"
                                        title="Copy URL"
                                    >
                                        <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"/>
                                        </svg>
                                    </button>
                                    <button
                                        @click="deleteFile(file)"
                                        class="p-1.5 rounded-lg text-gray-400 hover:text-red-600 hover:bg-red-50 transition-all duration-200"
                                        title="Delete"
                                    >
                                        <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                        </svg>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- List View -->
                <div v-else class="bg-white shadow-sm rounded-lg">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead>
                        <tr>
                            <th class="px-6 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                File
                            </th>
                            <th class="px-6 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Type
                            </th>
                            <th class="px-6 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Size
                            </th>
                            <th class="px-6 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Uploaded
                            </th>
                            <th class="px-6 py-3 bg-gray-50 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Actions
                            </th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <tr v-for="file in filteredFiles" :key="file.id">
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0 h-10 w-10">
                                        <img v-if="file.type === 'image'" :src="file.url" :alt="file.name"
                                             class="h-10 w-10 rounded object-cover">
                                        <svg v-else class="h-10 w-10 text-gray-400" fill="none" viewBox="0 0 24 24"
                                             stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
                                        </svg>
                                    </div>
                                    <div class="ml-4">
                                        <div class="text-sm font-medium text-gray-900">{{ file.name }}</div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium capitalize"
                          :class="{
                      'bg-blue-100 text-blue-800': file.type === 'image',
                      'bg-purple-100 text-purple-800': file.type === 'document'
                    }">
                      {{ file.type }}
                    </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {{ formatFileSize(file.size) }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {{ formatDate(file.created_at) }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                <div class="flex justify-end space-x-3">
                                    <button
                                        @click="copyUrl(file)"
                                        class="text-gray-400 hover:text-primary-600"
                                        title="Copy URL"
                                    >
                                        <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"/>
                                        </svg>
                                    </button>
                                    <button
                                        @click="deleteFile(file)"
                                        class="text-gray-400 hover:text-red-600"
                                        title="Delete"
                                    >
                                        <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                        </svg>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Empty State -->
                <div v-if="filteredFiles.length === 0" class="text-center py-12">
                    <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24"
                         stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                    </svg>
                    <h3 class="mt-2 text-sm font-medium text-gray-900">No files found</h3>
                    <p class="mt-1 text-sm text-gray-500">Get started by uploading a new file.</p>
                    <div class="mt-6">
                        <button
                            @click="openUploadModal"
                            class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700"
                        >
                            <svg class="-ml-1 mr-2 h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"/>
                            </svg>
                            Upload Files
                        </button>
                    </div>
                </div>
            </div>
        </main>

        <!-- Upload Modal Component -->
        <UploadModal
            v-if="showUploadModal"
            @close="closeUploadModal"
            @file-drop="handleFileDrop"
            @file-select="handleFileSelect"
            :uploading-files="uploadingFiles"
        />
    </div>
</template>

<script setup>
import {ref, computed, onMounted} from 'vue'
import {supabase} from '../../../lib/supabase'
import UploadModal from '../../../components/UploadModal.vue'
import ViewButton from "../../../components/ViewButton.vue";

const viewMode = ref('grid')
const searchQuery = ref('')
const typeFilter = ref('')
const sortBy = ref('newest')
const showUploadModal = ref(false)
const uploadingFiles = ref([])
const files = ref([])
const previewImage = ref(null)

// Fetch files on mount
onMounted(async () => {
    await loadFiles()
})

const previewFile = (file) => {
    if (file.type === 'image') {
        previewImage.value = file
        // Create a modal or lightbox to display the full image
        const img = new Image()
        img.src = file.url
        img.onload = () => {
            const modal = document.createElement('div')
            modal.className = 'fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-75'
            modal.innerHTML = `
        <div class="relative max-w-7xl max-h-[90vh] mx-auto p-4">
          <img src="${file.url}" alt="${file.name}" class="max-h-[85vh] object-contain rounded-lg">
          <button class="absolute top-4 right-4 text-white hover:text-gray-300">
            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      `
            modal.addEventListener('click', (e) => {
                if (e.target === modal) {
                    modal.remove()
                }
            })
            modal.querySelector('button').addEventListener('click', () => modal.remove())
            document.body.appendChild(modal)
        }
    }
}
const loadFiles = async () => {
    const {data: {session}} = await supabase.auth.getSession()
    if (!session) return

    const {data, error} = await supabase
        .from('media')
        .select('*')
        .eq('user_id', session.user.id)
        .order('created_at', {ascending: false})

    if (!error) {
        files.value = data
    }
}

const filteredFiles = computed(() => {
    let result = files.value

    // Apply search filter
    if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase()
        result = result.filter(file =>
            file.name.toLowerCase().includes(query)
        )
    }

    // Apply type filter
    if (typeFilter.value) {
        result = result.filter(file => file.type === typeFilter.value)
    }

    // Apply sorting
    result = [...result].sort((a, b) => {
        switch (sortBy.value) {
            case 'oldest':
                return new Date(a.created_at) - new Date(b.created_at)
            case 'name':
                return a.name.localeCompare(b.name)
            case 'size':
                return b.size - a.size
            default: // newest
                return new Date(b.created_at) - new Date(a.created_at)
        }
    })

    return result
})

const toggleView = (view_mode) => {
    viewMode.value = view_mode.value
}

const openUploadModal = () => {
    showUploadModal.value = true
}

const closeUploadModal = () => {
    showUploadModal.value = false
    uploadingFiles.value = []
}

const formatFileSize = (bytes) => {
    if (bytes === 0) return '0 Bytes'
    const k = 1024
    const sizes = ['Bytes', 'KB', 'MB', 'GB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

const formatDate = (date) => {
    return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    })
}

const handleFileDrop = (e) => {
    const droppedFiles = [...e.dataTransfer.files]
    uploadFiles(droppedFiles)
}

const handleFileSelect = (e) => {
    const selectedFiles = [...e.target.files]
    uploadFiles(selectedFiles)
}

const uploadFiles = async (files) => {
    const {data: {session}} = await supabase.auth.getSession()
    if (!session) return

    for (const file of files) {
        // Validate file type and size
        const isImage = file.type.startsWith('image/')
        const isPDF = file.type === 'application/pdf'

        if (!isImage && !isPDF) {
            alert(`${file.name} is not a supported file type`)
            continue
        }

        if (isImage && file.size > 5 * 1024 * 1024) {
            alert(`${file.name} exceeds the 5MB limit for images`)
            continue
        }

        if (isPDF && file.size > 10 * 1024 * 1024) {
            alert(`${file.name} exceeds the 10MB limit for PDFs`)
            continue
        }

        // Add to uploading files
        const uploadingFile = {
            name: file.name,
            progress: 0
        }
        uploadingFiles.value.push(uploadingFile)

        // Upload to Supabase Storage
        const fileExt = file.name.split('.').pop()
        const fileName = `${Math.random().toString(36).substring(2)}.${fileExt}`
        const filePath = `${session.user.id}/${fileName}`

        const {error: uploadError} = await supabase.storage
            .from('media')
            .upload(filePath, file, {
                upsert: false,
                onUploadProgress: (progress) => {
                    const fileIndex = uploadingFiles.value.findIndex(f => f.name === file.name)
                    if (fileIndex !== -1) {
                        uploadingFiles.value[fileIndex].progress = Math.round((progress.loaded / progress.total) * 100)
                    }
                },
            })

        if (uploadError) {
            alert(`Error uploading ${file.name}`)
            continue
        }

        // Get public URL
        const {data: {publicUrl}} = supabase.storage
            .from('media')
            .getPublicUrl(filePath)

        // Save file metadata to database
        const {error: dbError} = await supabase
            .from('media')
            .insert([{
                name: file.name,
                path: filePath,
                url: publicUrl,
                type: isImage ? 'image' : 'document',
                size: file.size,
                user_id: session.user.id
            }])

        if (dbError) {
            alert(`Error saving ${file.name} metadata`)
        }
    }

    // Refresh file list
    await loadFiles()
}

const copyUrl = async (file) => {
    try {
        await navigator.clipboard.writeText(file.url)
        alert('URL copied to clipboard')
    } catch (err) {
        alert('Failed to copy URL')
    }
}

const deleteFile = async (file) => {
    if (!confirm('Are you sure you want to delete this file?')) return

    const {data: {session}} = await supabase.auth.getSession()
    if (!session) return

    // Delete from storage
    const {error: storageError} = await supabase.storage
        .from('media')
        .remove([file.path])

    if (storageError) {
        alert('Error deleting file from storage')
        return
    }

    // Delete from database
    const {error: dbError} = await supabase
        .from('media')
        .delete()
        .eq('id', file.id)

    if (dbError) {
        alert('Error deleting file metadata')
        return
    }

    // Refresh file list
    await loadFiles()
}
</script>