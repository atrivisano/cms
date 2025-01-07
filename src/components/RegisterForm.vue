<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div>
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">Create your account</h2>
      </div>
      <form class="mt-8 space-y-6" @submit.prevent="handleRegister">
        <div class="rounded-md shadow-sm -space-y-px">
          <div>
            <label for="name" class="sr-only">Full name</label>
            <input v-model="name" id="name" name="name" type="text" required class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-primary-500 focus:border-primary-500 focus:z-10 sm:text-sm" placeholder="Full name">
          </div>
          <div>
            <label for="email" class="sr-only">Email address</label>
            <input v-model="email" id="email" name="email" type="email" required class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-primary-500 focus:border-primary-500 focus:z-10 sm:text-sm" placeholder="Email address">
          </div>
          <div>
            <label for="password" class="sr-only">Password</label>
            <input v-model="password" id="password" name="password" type="password" required class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-primary-500 focus:border-primary-500 focus:z-10 sm:text-sm" placeholder="Password">
          </div>
        </div>

        <div>
          <button type="submit" class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
            Sign up
          </button>
        </div>

        <div class="text-sm text-center">
          <a href="/login" class="font-medium text-primary-600 hover:text-primary-500">
            Already have an account? Sign in
          </a>
        </div>
      </form>
      
      <p v-if="error" class="mt-2 text-center text-sm text-red-600">
        {{ error }}
      </p>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'
import { supabase } from '../lib/supabase'

export default {
  setup() {
    const name = ref('')
    const email = ref('')
    const password = ref('')
    const error = ref('')

    const handleRegister = async () => {
      try {
        const { data: { user }, error: signUpError } = await supabase.auth.signUp({
          email: email.value,
          password: password.value
        })

        if (signUpError) throw signUpError

        const { error: profileError } = await supabase
          .from('profiles')
          .insert([
            { 
              id: user.id,
              name: name.value
            }
          ])

        if (profileError) throw profileError

        window.location.href = '/admin'
      } catch (e) {
        error.value = e.message
      }
    }

    return {
      name,
      email,
      password,
      error,
      handleRegister
    }
  }
}
</script>