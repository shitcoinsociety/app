<script>
  import "./default.css"
  import { Frame } from "inertiax-svelte"

  const { children } = $props()

  let headerHeight = $state()

  $effect(() => {
    if (headerHeight === undefined) return
    document.documentElement.style.setProperty("--header-height", `${headerHeight}px`)
  })
</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>

<header class="site-header" bind:clientHeight={headerHeight}>
  <div class="container header-inner">
    <a class="brand supersonic" href="/">
      <h1 class="text-4xl">Shitcoin Society</h1>
    </a>
  </div>
</header>

<main class="container">
  <div class="mt-4">
    {@render children()}
  </div>


  <div scroll-region>
    <Frame src="/users/new" />
  </div>
</main>

<nav>
  <menu>
    <li>
      <a href="/">
        <span class="i-bitcoin-icons:home-outline text-4xl" aria-hidden="true"></span>
        <div>
          Home
        </div>
      </a>
    </li>
  </menu>
</nav>

<footer class="site-footer">
  <div class="container footer-inner">
    <p class="slogan supersonic">Legends never die.</p>
    <div class="footer-meta">
      <span>&copy; {new Date().getFullYear()} Shitcoin Society</span>
      <span class="footer-divider" aria-hidden="true">&middot;</span>
      <a href="https://youtube.com/@shitcoinsociety" target="_blank" rel="noopener noreferrer">YouTube</a>
      <span class="footer-divider" aria-hidden="true">&middot;</span>
      <a href="https://github.com/shitcoinsociety" target="_blank" rel="noopener noreferrer">GitHub</a>
    </div>
  </div>
</footer>


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

  @media (max-width: 640px) {
    header, main, footer {
      padding-inline: 1rem;
    }
  }
  @media (min-width: 640px) {
    nav {
      position: sticky;
      top: var(--header-height);
      bottom: auto;
      menu {
        background: none;
        border: none;
        padding: 0;
        margin: 0;
        margin-top: 1rem;
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

  .site-header {
    position: sticky;
    top: 0;
    z-index: 10;
    border-bottom: 1px solid var(--color-border);
    background: rgb(22 22 24 / 82%);
    backdrop-filter: blur(10px);
  }

  .header-inner {
    display: flex;
    align-items: center;
    padding-block: 1.25rem 0.75rem;
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

  .site-footer {
    margin-top: 3rem;
    border-top: 1px solid var(--color-border);
  }

  .footer-inner {
    display: flex;
    flex-wrap: wrap;
    align-items: flex-end;
    justify-content: space-between;
    gap: 1.5rem;
    padding-block: 2rem;
  }

  .slogan {
    margin: 0;
    font-size: clamp(1.75rem);
    line-height: 1;
    letter-spacing: 0.015em;
    background: linear-gradient(90deg, #f8fafc 0%, #c084fc 55%, #6366f1 100%);
    -webkit-background-clip: text;
    background-clip: text;
    color: transparent;
  }

  .footer-meta {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 0.5rem;
    color: var(--color-muted);
    font-size: 0.875rem;
  }

  .footer-divider {
    color: var(--color-border);
  }
</style>