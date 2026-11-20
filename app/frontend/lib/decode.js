/**
 * Decodes a raw `localStorage` value. Values written by `persistent` are JSON,
 * while raw values written by other code (plain strings) read back as-is.
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
