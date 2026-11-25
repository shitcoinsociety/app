<script>
  import {Modal} from "~/lib/ui";
  import "./default.css"
  
  const { children } = $props()

  import { currentUser } from '~/lib/stores.svelte.js'

  let headerHeight = $state()

  $effect(() => {
    if (headerHeight === undefined) return
    document.documentElement.style.setProperty("--header-height", `${headerHeight}px`)
  })
</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>

<header bind:clientHeight={headerHeight}>
  <a class="brand supersonic" href="/">
    <h1 class="text-3xl pb-1">Shitcoin Society</h1>
  </a>
</header>

<main class="container">
  <div class="mt-4">
    {@render children()}
  </div>
</main>

<nav>
  <menu>
    <li>
      <a href="/">
        <span class="i-bitcoin-icons:rocket-outline text-4xl" aria-hidden="true"></span>
        <div>
          Home
        </div>
      </a>
    </li>
        <li>
      <a href="/balances">
        <span class="i-bitcoin-icons:bitcoin-outline text-4xl" aria-hidden="true"></span>
        <div>
          Balances
        </div>
      </a>
    </li>
    {#if $currentUser}
    <li>
      <a href="/session" data-method="delete">
        <span class="i-bitcoin-icons:log-out-outline text-4xl" aria-hidden="true"></span>
        <div>
          Log out
        </div>
      </a>
    </li>
    {/if}
  </menu>
</nav>

<footer>
  <section>

    <div class="footer-inner">
      <div>
        &copy; {new Date().getFullYear()} Shitcoin Society.
        <span class="color-muted">
          Legends never die.
        </span>
      </div>
      <div class="footer-meta">
        <a href="https://youtube.com/@shitcoinsociety" target="_blank" rel="noopener noreferrer">YouTube</a>
        <span class="footer-divider" aria-hidden="true">&middot;</span>
        <a href="https://github.com/shitcoinsociety" target="_blank" rel="noopener noreferrer">GitHub</a>
      </div>
    </div>
  </section>
</footer>
<Modal />

<style>
  nav {
    position: sticky;
    bottom: 1rem;
    width: 100%;
    menu {
      margin: 0 auto;
      width: fit-content;
      display: flex;
      justify-content: center;
      gap: 1rem;
      border-radius: 99rem;
      background: rgba(85, 85, 89, 0.22);
      backdrop-filter: blur(10px);
      border: 1px solid #9994;
      padding: 0rem 2rem;
      a {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 0.5rem 0.75rem;
        border-radius: 99rem;
        font-size: 0.75rem;
        color: white;
        text-decoration: none;
      }
    }    
  }

  @media (min-width: 640px) {
    main {
      border-left: 1px solid var(--color-border);
    }
    nav {
      position: sticky;
      top: var(--header-height);
      height: calc(100vh - var(--header-height));
      bottom: auto;

      menu {
        flex-direction: column;
        background: none;
        border: none;
        padding: 0;
        margin: 0;
        margin-top: 1rem;
        gap: 0;
        a {
          flex-direction: row;
          font-size: 1rem;
          padding: 0.5rem 1rem;
          gap: 0.5rem;
        }
      }
    }
  }



  @font-face {
    font-family: "SuperSonic";
    src: url("/fonts/supersonic_rocketship.ttf") format("truetype");
  }

  .supersonic {
    font-family: "SuperSonic", sans-serif;
  }

  header {
    position: sticky;
    top: 0;
    z-index: 1;
    border-bottom: 1px solid var(--color-border);
    background: var(--color-background);
    backdrop-filter: blur(10px);
    padding: 1rem;
    padding-bottom: 0;
  }


  .brand {
    color: inherit;
  }

  .brand:hover {
    text-decoration: none;
  }

  .brand h1 {
    margin: 0;
  }

  footer {
    border-top: 1px solid var(--color-border);
    font-size: 0.875rem;
  }

  .footer-inner {
    display: flex;
    flex-wrap: wrap;
    align-items: flex-end;
    justify-content: space-between;
    gap: 1.5rem;
  }


  .footer-meta {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 0.5rem;
    color: var(--color-muted);
  
  }

  .footer-divider {
    color: var(--color-border);
  }
</style>