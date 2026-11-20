import db from '~/lib/dexie'
import { subscribe } from 'dexiecable'
import { currentUserId } from '~/lib/stores.svelte'
import { page } from 'inertiax-svelte'

const subscription = subscribe(db)

let stopStream = null

currentUserId.subscribe(() => {
  stopStream?.()
  stopStream = null
  const userToken = page.props.current_user_token
  if (userToken) {
    console.log("Subscribing to userToken", userToken)
    stopStream = subscription.addStream(userToken)
  }
})