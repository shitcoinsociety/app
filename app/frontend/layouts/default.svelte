<script>
  import "./default.css"
  import { useForm, usePage } from "inertiax-svelte"

  const { children } = $props()

  const page = usePage()
  const form = useForm({ email: "" })

  const signedup = $derived(Boolean(page.props?.signedup))

  function handleSubmit(event) {
    event.preventDefault()
    form.post("/users", { preserveScroll: true })
  }
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

  <section class="signup-section" aria-labelledby="signup-heading">
    <div class="signup-card">
      <h2 id="signup-heading">Join us — it's free</h2>
      {#if signedup}
        <p class="signup-success">Thank you for signing up! More info will be on your way soon.</p>
      {:else}
        <p>Be part of the Shitcoin Society. We'll keep you posted as we count down to the genesis block.</p>
        <form class="signup-form" onsubmit={handleSubmit}>
          <input
            type="email"
            name="email"
            placeholder="Your email address"
            aria-label="Your email address"
            autocomplete="email"
            required
            bind:value={form.email}
          />
          <button class="signup-button" type="submit" disabled={form.processing}>
            {form.processing ? "Signing up…" : "Sign up"}
          </button>
        </form>
        {#if form.errors.email}
          <p class="signup-error">{form.errors.email}</p>
        {/if}
      {/if}
    </div>
  </section>
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

  .signup-section {
    padding-top: 2.5rem;
  }

  .signup-card {
    padding: 1.5rem;
    border: 1px solid rgb(139 92 246 / 35%);
    border-radius: 1rem;
    background: linear-gradient(150deg, rgb(99 102 241 / 16%), rgb(192 132 252 / 6%) 55%, transparent);
    box-shadow: 0 30px 80px -50px rgb(99 102 241 / 90%);
  }

  .signup-card h2 {
    margin: 0 0 0.5rem;
  }

  .signup-card p {
    max-width: 56ch;
    margin: 0;
    color: var(--color-muted);
  }

  .signup-form {
    display: flex;
    gap: 0.75rem;
    margin-top: 1rem;
  }

  .signup-form input {
    flex: 1;
    min-width: 0;
    box-sizing: border-box;
    padding: 0.6rem 0.75rem;
    border: 1px solid var(--color-border);
    border-radius: 0.5rem;
    background: rgb(0 0 0 / 25%);
    color: var(--color-text);
    font: inherit;
  }

  .signup-form input:focus {
    border-color: transparent;
    outline: 2px solid var(--color-accent);
    outline-offset: 1px;
  }

  .signup-button {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.6rem 1.1rem;
    border: none;
    border-radius: 0.5rem;
    background: linear-gradient(135deg, var(--color-accent), var(--color-accent-soft));
    color: white;
    font: inherit;
    font-weight: 700;
    cursor: pointer;
    transition: filter 150ms ease;
  }

  .signup-button:hover {
    filter: brightness(1.1);
  }

  .signup-button:disabled {
    cursor: progress;
    opacity: 0.7;
  }

  .signup-card .signup-success {
    color: #86efac;
  }

  .signup-card .signup-error {
    margin-top: 0.5rem;
    color: #fca5a5;
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