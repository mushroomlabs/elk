import { setup } from 'ap-sdk'

export default defineNuxtPlugin(async () => {
  const accountDatabaseLocation = 'accounts'
  const linkedDataDatabaseLocation = 'linkeddata'

  await setup({
    accountDatabaseLocation,
    linkedDataDatabaseLocation,
    runtimeEnvironment: 'browser',
  })
})
