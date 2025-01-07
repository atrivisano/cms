<template>
  <nav class="bg-white shadow">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between h-16">
        <!-- Logo and Main Navigation -->
        <div class="flex">
          <div class="flex-shrink-0 flex items-center">
            <a :href="isAdmin ? '/admin' : '/'" class="text-xl font-bold text-primary-600">
              {{ isAdmin ? 'ModernCMS Admin' : 'ModernCMS' }}
            </a>
          </div>

          <!-- Admin Navigation -->
          <div v-if="isAdmin" class="hidden sm:ml-6 sm:flex sm:space-x-8">
            <a 
              v-for="item in adminNavItems" 
              :key="item.path"
              :href="item.path"
              :class="[
                'inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium',
                isCurrentPath(item.path)
                  ? 'border-primary-500 text-gray-900'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              ]"
            >
              {{ item.name }}
            </a>
          </div>

          <!-- Main Navigation -->
          <div v-else class="hidden sm:ml-6 sm:flex sm:space-x-8">
            <a 
              v-for="item in mainNavItems" 
              :key="item.path"
              :href="item.path"
              :class="[
                'inline-flex items-center px-1 pt-1 text-sm font-medium',
                isCurrentPath(item.path)
                  ? 'text-gray-900'
                  : 'text-gray-500 hover:text-gray-900'
              ]"
            >
              {{ item.name }}
            </a>
          </div>
        </div>

        <!-- Auth Buttons -->
        <div class="hidden sm:ml-6 sm:flex sm:items-center">
          <button 
            v-if="isAuthenticated" 
            @click="handleLogout" 
            class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
          >
            Logout
          </button>
          <a 
            v-else 
            href="/login"
            class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
          >
            Sign in
          </a>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../lib/supabase'

const isAuthenticated = ref(false)
const isAdmin = ref(false)
const currentPath = ref('')

const mainNavItems = [
  { name: 'Home', path: '/' },
  { name: 'Blog', path: '/blog' },
  { name: 'About', path: '/about' }
]

const adminNavItems = [
  { name: 'Dashboard', path: '/admin' },
  { name: 'Posts', path: '/admin/posts' },
  { name: 'Categories', path: '/admin/categories' },
  { name: 'Media', path: '/admin/media' }
]

onMounted(async () => {
  // Check authentication status
  const { data: { session } } = await supabase.auth.getSession()
  isAuthenticated.value = !!session
  
  // Set current path and admin status
  currentPath.value = window.location.pathname
  isAdmin.value = currentPath.value.startsWith('/admin')
})

const isCurrentPath = (path) => {
  if (path === '/') {
    return currentPath.value === path
  }
  return currentPath.value.startsWith(path)
}

const handleLogout = async () => {
  await supabase.auth.signOut()
  window.location.href = '/login'
}
</script>