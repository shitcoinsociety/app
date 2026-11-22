export { default as Modal } from "./Modal.svelte"

export function modal(node) {
  node.addEventListener('click', onClickLink)
  return {
    destroy() {
      node.removeEventListener('click', onClickLink)
    }
  }
}

function onClickLink(e) {
  e.preventDefault()
  const href = e.target.closest('a')?.getAttribute('href')
  if (!href) return
  const state = history.state || {}
  state["modal"] = [{ src: href }]
  history.pushState(state, undefined)
  window.dispatchEvent(new PopStateEvent("popstate", { state }))
}
