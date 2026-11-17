<script>
  import { useForm } from 'inertiax-svelte'
  
  const form = useForm({ email: "" })

   const { signedup } = $props()

  function handleSubmit(event) {
    event.preventDefault()
    form.post("/users", { preserveScroll: true })
  }
</script>

<section class="signup-section" aria-labelledby="signup-heading">
  <div class="signup-card">
    <h2 id="signup-heading">Join us — it's free</h2>
    {#if signedup}
      <p class="signup-success">Thank you for signing up! More info will be on your way soon.</p>
    {:else}
      <p>Join the Shitcoin Society and secure yourself a slot in the genesis block of our very own blockchain.</p>
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


  <style>
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

  @media (max-width: 560px) {
    .signup-form {
      flex-direction: column;
    }

    .signup-button {
      width: 100%;
    }
  }
</style>