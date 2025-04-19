<script setup lang="ts">
import IdentityCard from './IdentityCard.vue'

const { accounts, isLoading, fetchAccounts } = useAccounts()

onMounted(async () => {
  await fetchAccounts()
})
</script>

<template>
  <div class="identity-panel">
    <div v-if="isLoading" class="p-4 text-center">
      <div class="i-ri:loader-2-line animate-spin text-2xl" />
      <p class="mt-2">
        Loading accounts...
      </p>
    </div>
    <div v-else>
      <div v-if="accounts.length === 0" class="p-4 text-center">
        <p>No accounts found</p>
      </div>
      <div v-else class="space-y-2">
        <IdentityCard
          v-for="identity in accounts"
          :key="identity.actorUrl"
          :identity="identity"
        />
      </div>

      <div class="mt-5 flex items-center justify-center px-2">
        <!-- Settings link -->
        <NuxtLink
          to="/settings/users"
          class="text-sm text-primary hover:underline flex items-center gap-1"
        >
          <span class="i-ri:settings-4-line" />
          <span>Manage accounts</span>
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<style scoped>
.identity-panel {
  @apply w-full max-w-md mx-auto;
}
</style>
