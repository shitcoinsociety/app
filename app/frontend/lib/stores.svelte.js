import { liveQuery } from 'dexie'
import { page } from 'inertiax-svelte'
import { readable } from 'svelte/store'
import db from './dexie.js'
import { persistent } from './persistent.js'

export const currentUserId = persistent('currentUserId')

if (typeof window !== 'undefined') {
  $effect.root(() => {
    $effect(() => {
      const props = page.props
      const userId = props.current_user_id
      if (!Object.hasOwn(props, 'current_user_id')) return
      currentUserId.set(userId ?? undefined)
    })
  })
}

/**
 * Creates a store that reruns a Dexie query whenever the current user changes.
 *
 * @template T
 * @param {T} initialValue
 * @param {(userId: string | number) => T | PromiseLike<T>} query
 */
export function queryWithCurrentUserId(initialValue, query) {
  return readable(initialValue, (set) => {
    let querySubscription
    let queryVersion = 0

    const unsubscribeCurrentUser = currentUserId.subscribe((userId) => {
      const version = ++queryVersion
      querySubscription?.unsubscribe()
      querySubscription = undefined
      set(initialValue)

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

export const currentUser = queryWithCurrentUserId(
  null,
  async (id) => (await db.users.where('id').equals(id).first()) ?? null
)

export const balances = queryWithCurrentUserId(
  [],
  (id) => db.balances.where('user_id').equals(id).toArray()
)

