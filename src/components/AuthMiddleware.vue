<script setup>
import { onMounted } from 'vue'
import { supabase } from '../lib/supabase'

const props = defineProps({
  requireAuth: {
    type: Boolean,
    default: false
  },
  redirectTo: {
    type: String,
    default: '/login'
  }
})

onMounted(async () => {
  const { data: { session } } = await supabase.auth.getSession()
  
  if (props.requireAuth && !session) {
    window.location.href = props.redirectTo
  } else if (!props.requireAuth && session) {
    window.location.href = '/admin'
  }
})
</script>

<template>
  <slot />
</template>