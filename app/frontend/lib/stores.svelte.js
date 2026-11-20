import db from "./dexie.js"

import { liveQuery } from 'dexie'
import { readable } from 'svelte/store'
import { persistent } from './persistent.js'

export const currentUserId = persistent('currentUserId')

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

