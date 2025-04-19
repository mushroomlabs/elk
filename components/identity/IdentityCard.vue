<script setup lang="ts">
import type { Account } from 'ap-sdk'

defineProps<{
  identity: Account
}>()
</script>

<template>
  <div class="p-4 border rounded-lg hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer">
    <div class="flex items-center space-x-3">
      <div class="w-10 h-10 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center">
        <span class="text-lg">{{ identity.name?.charAt(0) || '?' }}</span>
      </div>
      <div>
        <p class="font-medium">
          {{ identity.name }}
        </p>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          {{ identity.actorUrl }}
        </p>
      </div>
    </div>
  </div>
</template>
