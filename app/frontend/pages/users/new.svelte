<script>
  const { user_count, ico_progress = 0, magic_link_sent } = $props()
  
  import { useForm } from 'inertiax-svelte'
  import { currentUserId } from '~/lib/stores.svelte.js'
  
  const form = useForm({ session: { email: "" } })

  function handleSubmit(event) {
    event.preventDefault()
    form.post("/session", { preserveScroll: true })
  }
</script>


<section class="signup-section mb-4" aria-labelledby="signup-heading">
  <p class="text-center mb-4">The era of financial degeneracy is upon us</p>
  <h2 class="text-center text-3xl mb-4">Join <a href="/users">{user_count} other degens</a> on their quest to launch their very own blockchain.</h2>
   {#if $currentUserId}
      <p class="signup-success text-center">You're signed in. <a href="/balances">View your balances</a>.</p>
    {:else if magic_link_sent}
      <p class="signup-success">Check your email for a sign-in link. It expires in 15 minutes.</p>
    {:else}
      <form class="signup-form" onsubmit={handleSubmit}>
        <input
          type="email"
          name="email"
          placeholder="Your email address"
          aria-label="Your email address"
          autocomplete="email"
          required
          bind:value={form.session.email}
        />
        <button class="btn signup-button" type="submit" disabled={form.processing}>
          {form.processing ? "Sending…" : "Send link"}
        </button>
      </form>
      {#if form.errors.email}
        <p class="signup-error">{form.errors.email}</p>
      {/if}
    {/if}
  <div class="card mt-8">
    <h2 id="signup-heading">🚀 Launch status</h2>
    <p>The genesis block is {ico_progress}% complete.
      <a href="/genesis.json" target="_blank" rel="noopener noreferrer">Download snapshot</a>
    </p>
    <div class="meter-wrap">
      <progress class="progress-meter" value={ico_progress} max="100" aria-label="Genesis block completion">
        {ico_progress}%
      </progress>
      <span class="progress-marker" style={`left: ${ico_progress}%`} aria-hidden="true"></span>
      <span class="progress-current" style={`left: ${ico_progress}%`}>{ico_progress}%</span>
    </div>
   
  </div>
</section>

<section>  
  <h2>About the Shitcoin Society</h2>
  
  <p>
    The Shitcoin Society is an in-development <a href="https://github.com/shitcoinsociety" target="_blank" rel="noopener noreferrer">open source</a> investment and trading app launching its very own (still unnamed) blockchain.
    Everybody is welcome to join. We have coconuts and drum n bass.
  </p>
  
  <img src={"/tothemoon.jpg"} alt="To the moon" class="mt-4" />
</section>





  <style>

  .card h2 {
    margin: 0 0 0.5rem;
  }

  .card p {
    max-width: 56ch;
    margin: 0;
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


  .signup-success {
    color: #86efac;
  }

  .signup-error {
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

  .meter-wrap {
    position: relative;
    margin-top: 0.5rem;
    padding-bottom: 2rem;
  }
  .progress-meter {
    display: block;
    width: 100%;
    height: 1.25rem;
    margin: 0;
    overflow: hidden;
    appearance: none;
    background: #393943;
    border: 0;
    border-radius: 999px;
  }
  .progress-meter::-webkit-progress-bar {
    background: #393943;
    border-radius: 999px;
  }
  .progress-meter::-webkit-progress-value {
    background: linear-gradient(90deg, #6366f1, #c084fc);
    border-radius: 999px;
    transition: width 300ms ease;
  }
  .progress-meter::-moz-progress-bar {
    background: linear-gradient(90deg, #6366f1, #c084fc);
    border-radius: 999px;
  }
  .progress-marker {
    position: absolute;
    top: 0.625rem;
    width: 1rem;
    height: 1rem;
    box-sizing: border-box;
    background: white;
    border: 3px solid #a78bfa;
    border-radius: 50%;
    transform: translate(0%, -50%);
  }
  .progress-current {
    position: absolute;
    top: 1.25rem;
    color: #c4b5fd;
    font-weight: 700;
    white-space: nowrap;
    transform: translateX(0%);
  }
</style>