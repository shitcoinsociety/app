import { writable } from 'svelte/store'
import { decode } from './decode.js'

const hasStorage = typeof localStorage !== 'undefined'

/**
 * A Svelte store backed by a `localStorage` key and synchronized across tabs.
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
