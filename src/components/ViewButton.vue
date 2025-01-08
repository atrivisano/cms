<script setup>
import {ref} from "vue";

const emit = defineEmits(['toggle-view-mode'])

const viewMode = ref('list')

const toggleView = () => {
    viewMode.value = viewMode.value === 'grid' ? 'list' : 'grid';

    emit('toggle-view-mode', viewMode);
}
</script>

<template>
    <button
        @click="toggleView"
        class="inline-flex items-center px-3 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
    >
        <template v-if="viewMode === 'grid'">
            <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M4 6h16M4 10h16M4 14h16M4 18h16"/>
            </svg>
            List View
        </template>
        <template v-else>
            <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"/>
            </svg>
            Grid View
        </template>
    </button>
</template>

<style scoped>

</style>