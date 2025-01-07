<template>
    <!-- Side Navigation -->
    <nav class="w-64 bg-white shadow-lg fixed h-full">
        <!-- Logo -->
        <div class="px-6 py-4 border-b border-gray-200">
            <a href="/admin" class="text-xl font-bold text-primary-600">
                ModernCMS
            </a>
        </div>

        <!-- Navigation Items -->
        <div class="px-4 py-6">
            <div class="space-y-1">
                <a
                    v-for="item in adminNavItems"
                    :key="item.path"
                    :href="item.path"
                    :class="[
              'group flex items-center px-3 py-2 text-sm font-medium rounded-md',
              isCurrentPath(item.path)
                ? 'bg-primary-50 text-primary-700'
                : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
            ]"
                >
                    <component
                        :is="item.icon"
                        :class="[
                'flex-shrink-0 -ml-1 mr-3 h-6 w-6',
                isCurrentPath(item.path)
                  ? 'text-primary-500'
                  : 'text-gray-400 group-hover:text-gray-500'
              ]"
                    />
                    {{ item.name }}
                </a>
            </div>
        </div>

        <!-- User Menu -->
        <div class="absolute bottom-0 w-full border-t border-gray-200 bg-white px-4 py-4">
            <button
                v-if="isAuthenticated"
                @click="handleLogout"
                class="w-full flex items-center justify-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
            >
                <svg class="mr-2 h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                </svg>
                Logout
            </button>
        </div>
    </nav>
</template>

<script setup>
import { ref, onMounted, h } from 'vue'
import { supabase } from '../../lib/supabase.js'

const isAuthenticated = ref(false)
const currentPath = ref('')

// Icons as render functions
const DashboardIcon = () => h('svg', {
    fill: 'none',
    viewBox: '0 0 24 24',
    stroke: 'currentColor',
    class: 'h-6 w-6'
}, [
    h('path', {
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
        'stroke-width': '2',
        d: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6'
    })
])

const PostsIcon = () => h('svg', {
    fill: 'none',
    viewBox: '0 0 24 24',
    stroke: 'currentColor',
    class: 'h-6 w-6'
}, [
    h('path', {
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
        'stroke-width': '2',
        d: 'M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9.5a2 2 0 00-2-2h-2'
    })
])

const CategoriesIcon = () => h('svg', {
    fill: 'none',
    viewBox: '0 0 24 24',
    stroke: 'currentColor',
    class: 'h-6 w-6'
}, [
    h('path', {
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
        'stroke-width': '2',
        d: 'M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z'
    })
])

const MediaIcon = () => h('svg', {
    fill: 'none',
    viewBox: '0 0 24 24',
    stroke: 'currentColor',
    class: 'h-6 w-6'
}, [
    h('path', {
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
        'stroke-width': '2',
        d: 'M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z'
    })
])

const adminNavItems = [
    { name: 'Dashboard', path: '/admin', icon: DashboardIcon },
    { name: 'Posts', path: '/admin/posts', icon: PostsIcon },
    { name: 'Categories', path: '/admin/categories', icon: CategoriesIcon },
    { name: 'Media', path: '/admin/media', icon: MediaIcon }
]

onMounted(async () => {
    // Check authentication status
    const { data: { session } } = await supabase.auth.getSession()
    isAuthenticated.value = !!session

    // Set current path
    currentPath.value = window.location.pathname
})

const isCurrentPath = (path) => {
    return currentPath.value === path;
}

const handleLogout = async () => {
    await supabase.auth.signOut()
    window.location.href = '/login'
}
</script>