import { Account } from 'ap-sdk'

export function useAccounts() {
  const accounts = useState<Account[]>('identity-accounts', () => [])
  const isLoading = useState<boolean>('identity-accounts-loading', () => true)

  async function fetchAccounts() {
    try {
      isLoading.value = true
      accounts.value = await Account.list()
    }
    catch (error) {
      console.error('Failed to load accounts:', error)
    }
    finally {
      isLoading.value = false
    }
  }

  async function removeAccount(actorUrl: string) {
    await Account.remove(actorUrl)
    await fetchAccounts()
  }

  async function registerAccount(actorUrl: string, accountName: string) {
    await Account.register(actorUrl, accountName)
    await fetchAccounts()
  }

  return {
    accounts,
    isLoading,
    fetchAccounts,
    removeAccount,
    registerAccount,
  }
}
