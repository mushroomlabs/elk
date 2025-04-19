<script setup lang="ts">
import type { Account } from 'ap-sdk'
import ModalDialog from '../modal/ModalDialog.vue'
import RegisterIdentityModal from './RegisterIdentityModal.vue'

const { accounts, isLoading, fetchAccounts, removeAccount } = useAccounts()
const isConfirmModalOpen = ref(false)
const isRegisterModalOpen = ref(false)
const isRemoving = ref(false)
const selectedAccount = ref<Account | null>(null)

onMounted(async () => {
  await fetchAccounts()
})

function openConfirmModal(account: Account) {
  selectedAccount.value = account
  isConfirmModalOpen.value = true
}

function closeConfirmModal() {
  isConfirmModalOpen.value = false
}

function openRegisterModal() {
  isRegisterModalOpen.value = true
}

function handleRegistered() {
  fetchAccounts()
}

async function handleRemoveAccount() {
  if (!selectedAccount.value)
    return

  try {
    isRemoving.value = true
    await removeAccount(selectedAccount.value.actorUrl.toString())
    closeConfirmModal()
  }
  catch (error) {
    console.error('Failed to remove account:', error)
  }
  finally {
    isRemoving.value = false
    selectedAccount.value = null
  }
}
</script>

<template>
  <div>
    <div class="flex justify-between items-center mb-4">
      <h2 class="text-xl font-bold">
        Manage Accounts
      </h2>
      <button
        class="px-4 py-2 bg-primary hover:bg-primary-600 text-white rounded-lg flex items-center gap-2"
        @click="openRegisterModal"
      >
        <span class="i-ri:add-line" />
        <span>Register New Account</span>
      </button>
    </div>

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

      <div v-else class="space-y-3">
        <div
          v-for="account in accounts"
          :key="account.actorUrl"
          class="p-4 border rounded-lg flex items-center justify-between"
        >
          <div class="flex items-center space-x-3">
            <div class="w-10 h-10 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center">
              <span class="text-lg">{{ account.name?.charAt(0) || '?' }}</span>
            </div>
            <div>
              <p class="font-medium">
                {{ account.name }}
              </p>
              <p class="text-sm text-gray-500 dark:text-gray-400">
                {{ account.actorUrl }}
              </p>
            </div>
          </div>

          <button
            class="text-sm text-red-500 hover:text-red-600 font-medium"
            @click="openConfirmModal(account)"
          >
            Delete
          </button>
        </div>
      </div>
    </div>

    <!-- Confirmation Modal -->
    <ModalDialog v-model="isConfirmModalOpen" py-6 px-6 max-w-md>
      <div class="space-y-4">
        <h3 class="text-lg font-bold">
          Remove Account
        </h3>

        <p>
          Are you sure you want to remove the account
          <strong v-if="selectedAccount">{{ selectedAccount.name }}</strong>?
        </p>
        <p class="text-sm text-gray-500">
          This action cannot be undone.
        </p>

        <div class="flex justify-end space-x-3 mt-6">
          <button
            class="px-4 py-2 border rounded hover:bg-gray-50 dark:hover:bg-gray-800"
            :disabled="isRemoving"
            @click="closeConfirmModal"
          >
            Cancel
          </button>

          <button
            class="px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded flex items-center space-x-2"
            :disabled="isRemoving"
            @click="handleRemoveAccount"
          >
            <span v-if="isRemoving" class="i-ri:loader-2-line animate-spin" />
            <span>{{ isRemoving ? 'Removing...' : 'Remove' }}</span>
          </button>
        </div>
      </div>
    </ModalDialog>

    <ModalDialog v-model="isRegisterModalOpen" py-4 px-0 max-w-125>
      <RegisterIdentityModal @close="isRegisterModalOpen = false" @registered="handleRegistered" />
    </ModalDialog>
  </div>
</template>
