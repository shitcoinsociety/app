<script>
  import { Frame } from "inertiax-svelte"
  import { onMount } from "svelte"
  import { fly } from "svelte/transition"
  import { shouldIntercept } from "inertiax-core"

  let {
    id,
    children,
    stack = $bindable([])
  } = $props()

  function onClickLink(e) {
    if (!shouldIntercept(e)) return
    const a = e.target.closest('a')
    if (!a) return
    if (a.getAttribute('data-method')) return
    e.preventDefault()
    const href = a.getAttribute('href')
    if (!href) return
    showFrame({ src: href })
  }

  function showFrame(props) {
    const state = history.state || {}
    state[id] ||= []
    state[id].push(props)
    history.pushState(state, undefined)
    updateStackFromState()
  }

  function updateStackFromState() {
    stack = history.state?.[id] || []
  }

  function back() {
    history.back()
  }

  function close() {
    history.go(-stack.length)
  }

  onMount(updateStackFromState)
</script>

<svelte:window onpopstate={updateStackFromState} />

{#if children}
  <div onclickcapture={onClickLink}>
    {@render children()}
  </div>
{/if}

{#each stack as props, index (index)}
  {@const bottom = index == 0 && !children}
  {@const top = index === stack.length - 1}
  <div class="pane" class:top transition:fly={{ x: bottom ? 0 : 200, duration: 300 }}>
    <nav class="start">
      <button class="back" onclick={back} aria-label="Back">
        <div class="i-bitcoin-icons:arrow-left-outline text-2xl"></div>
        <!-- <span>Back</span> -->
      </button>
    </nav>

      <Frame restore {close} {onClickLink} {...props}>
        <div class="spinner"></div>
      </Frame>
  </div>
{/each}

<style>
  :global {
    .pane nav {
      text-align: center;
      padding: var(--padding);
    }
  }
  .pane {
    position: absolute;
    inset: 0;
    overflow: auto;
    grid-template-rows: auto 1fr;
    grid-template-areas: "nav" "main";
    transition: all 0.3s ease-out;
    isolation: isolate;
    opacity: 1;
    display: grid;
  }

  .pane:not(.top) {
    transform: translateX(-50px);
  }

  .back {
    display: flex;
    align-items: center;
    justify-content: flex-start;
    gap: 0.5rem;
    padding: 1rem;
    margin: calc(var(--padding) * -1);
  }

  .spinner {
    position: absolute;
    width: 20px;
    height: 20px;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-top-color: #ffffff;
    border-radius: 50%;
    animation: ivs-spin 0.8s linear infinite;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
  }

  @keyframes ivs-spin {
    to {
      transform: translate(-50%, -50%) rotate(360deg);
    }
  }
</style>
