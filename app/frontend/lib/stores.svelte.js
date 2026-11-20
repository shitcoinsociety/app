import { liveQuery } from 'dexie'
import { page } from 'inertiax-svelte'
import { readable } from 'svelte/store'
import db from './dexie.js'
import { persistent } from './persistent.js'

const userIdStore = persistent('currentUserId')
export const currentUserId = { subscribe: userIdStore.subscribe }

if (typeof window !== 'undefined') {
  $effect.root(() => {
    $effect(() => {
      const props = page.props
      const userId = props.current_user_id
      if (!Object.hasOwn(props, 'current_user_id')) return
      userIdStore.set(userId ?? undefined)
    })
  })
}

/**
 * Creates a store that reruns a Dexie query whenever the current user changes.
 *
 * @template T
 * @param {(userId: string | number) => T} query
 */
export function queryWithCurrentUserId(query) {
  return readable([], (set) => {
    let querySubscription
    let queryVersion = 0

    const unsubscribeCurrentUser = currentUserId.subscribe((userId) => {
      const version = ++queryVersion
      querySubscription?.unsubscribe()
      querySubscription = undefined
      set([])

      if (userId == null || typeof indexedDB === 'undefined') return

      querySubscription = liveQuery(() => query(userId)).subscribe({
        next(result) {
          if (version === queryVersion) set(result)
        },
        error(error) {
          if (version !== queryVersion) return
          console.error('Failed to run query for current user', error)
        },
      })
    })

    return () => {
      queryVersion++
      querySubscription?.unsubscribe()
      unsubscribeCurrentUser()
    }
  })
}

export const balances = queryWithCurrentUserId((id) =>
  db.balances.where('user_id').equals(id).toArray()
)

