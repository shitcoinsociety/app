<script>
  import "./default.css"
  import { Frame } from "inertiax-svelte"

  const { children } = $props()
</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>

<header class="site-header">
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
    background: linear-gradient(180deg, transparent, rgb(99 102 241 / 6%));
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

  @media (max-width: 560px) {
    .signup-form {
      flex-direction: column;
    }

    .signup-button {
      width: 100%;
    }
  }
</style>