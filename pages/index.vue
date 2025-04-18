<script setup lang="ts">
definePageMeta({
  middleware: 'auth',
})

const isLoading = ref(true)

onMounted(() => {
  if (!currentUser.value)
    navigateTo('/')
  else
    navigateTo('/home')

  // Simulate loading state
  setTimeout(() => {
    isLoading.value = false
  }, 1000)
})
</script>

<template>
  <div>
    <div v-if="isLoading" class="p-4 text-center">
      <div class="i-ri:loader-2-line animate-spin text-2xl" />
      <p class="mt-2">
        Loading timeline...
      </p>
    </div>
    <div v-else>
      <TimelinePaginator
        v-if="!currentUser.value"
        context="public"
        :server="currentServer"
      />
    </div>
  </div>
</template>
