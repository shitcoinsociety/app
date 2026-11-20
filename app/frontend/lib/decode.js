/**
 * Decodes a raw `localStorage` value, preserving plain strings written by
 * other code.
 *
 * @param {string | null} raw
 */
export function decode(raw) {
  if (raw === null) return undefined
  try {
    return JSON.parse(raw)
  } catch {
    return raw
  }
}
