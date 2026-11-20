import { writable } from 'svelte/store'
import { decode } from './decode.js'

const hasStorage = typeof localStorage !== 'undefined'

/**
 * A store whose value follows an entry in `localStorage`, in both directions:
 * `set`/`update` persist to storage, and changes made elsewhere (other tabs,
 * devtools, other code) update the store.
 *
 * Values are stored as JSON so they keep their type across reloads.
 *
 * @param {string} key
 */
export function persistent(key) {
  const initialValue = hasStorage ? decode(localStorage.getItem(key)) : undefined
  const store = writable(initialValue)
  const { subscribe, set: setStore } = store
  let currentValue = initialValue

  function setIfChanged(value) {
    if (Object.is(currentValue, value)) return
    currentValue = value
    setStore(value)
  }

  function write(value) {
    if (value === undefined || value === null) localStorage.removeItem(key)
    else localStorage.setItem(key, JSON.stringify(value))
  }

  if (hasStorage) {
    window.addEventListener('storage', (event) => {
      if (event.key !== null && event.key !== key) return
      // `event.key === null` means the whole storage area was cleared.
      setIfChanged(decode(event.key === null ? null : event.newValue))
    })
  }

  return {
    subscribe,
    set(value) {
      setIfChanged(value)
      if (hasStorage) write(value)
    },
    update(fn) {
      const next = fn(currentValue)
      setIfChanged(next)
      if (hasStorage) write(next)
    },
  }
}
