<script setup lang="ts">
import { webfinger } from 'ap-sdk'

const emit = defineEmits(['close', 'registered'])
const { registerAccount } = useAccounts()

const userHandle = ref('')
const isLoading = ref(false)
const error = ref('')
const resolveStatus = ref('')

async function submitForm() {
  if (!userHandle.value) {
    error.value = 'Please enter a user handle'
    return
  }

  error.value = ''
  isLoading.value = true
  resolveStatus.value = 'Resolving handle via webfinger...'

  const actorUrl = await webfinger.resolveActorUrl(userHandle.value)

  if (!actorUrl) {
    error.value = `Could not resolve the handle ${userHandle.value}. Please verify the handle is correct.`
    return
  }

  resolveStatus.value = `Registering account...`

  try {
    await registerAccount(actorUrl, userHandle.value)
    emit('registered')
    emit('close')
  }
  catch (exc) {
    error.value = `Failed to register account: ${exc}`
  }
  finally {
    isLoading.value = false
  }
}
</script>

<template>
  <div flex="~ col" gap-6 p-4>
    <div font-bold text-lg>
      Register New Identity
    </div>

    <form @submit.prevent="submitForm">
      <div class="form-group mb-4">
        <label for="user-handle" class="block mb-2 text-sm font-medium">User Handle</label>
        <input
          id="user-handle"
          v-model="userHandle"
          type="text"
          placeholder="username@domain.tld"
          class="w-full p-2 border rounded-lg bg-base border-base"
          :disabled="isLoading"
        >
        <div v-if="error" class="mt-2 text-sm text-red-500">
          {{ error }}
        </div>
        <div v-if="resolveStatus" class="mt-2 text-sm text-blue-500">
          {{ resolveStatus }}
        </div>

        <div class="mt-2 text-sm text-gray-500 dark:text-gray-400">
          Enter your ActivityPub handle (e.g., username@domain.tld)
        </div>
      </div>

      <div flex justify-end gap-2>
        <button
          type="button"
          btn-text
          :disabled="isLoading"
          @click="emit('close')"
        >
          Cancel
        </button>
        <button
          type="submit"
          btn-solid
          :disabled="isLoading"
        >
          <div v-if="isLoading" class="i-ri:loader-2-line animate-spin text-base" />
          <span v-else>Register</span>
        </button>
      </div>
    </form>
  </div>
</template>
