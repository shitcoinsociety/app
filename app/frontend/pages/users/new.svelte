<script>
  import { useForm } from 'inertiax-svelte'

  const form = useForm({ email: "" })

  const { 
    signedup,
    ico_progress
  } = $props()

  // 1. Discover all installed extensions via EIP-6963
  const wallets = $state([]);
  if (!import.meta.env.SSR) {
    window.addEventListener("eip6963:announceProvider", (event) => {
      wallets.push(event.detail); // { info: { name, icon, rdns }, provider }
    });
    window.dispatchEvent(new Event("eip6963:requestProvider"));
  }

  // 2. Connect & request signature when user clicks a wallet
  async function loginWithWallet(provider) {
    const [address] = await provider.request({ method: "eth_requestAccounts" });
    const signature = await provider.request({
      method: "personal_sign",
      params: ["Shitcoin Society join request", address],
    });
    return { address, signature };
  }

</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>


<img src={"/tothemoon.jpg"} alt="To the moon" class="mt-4" />

<p class="mt-4">
  We are an <a href="https://github.com/shitcoinsociety" target="_blank" rel="noopener noreferrer">open-source</a> crypto-native MLM community developing our very own decentralized ledger technology.
  Everybody is welcome to join. There will be drum n bass.
</p>

<h2>Launch progress</h2>
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

<h2>Join us - it's free</h2>
{#if signedup}
  <p>Thank you for signing up! More info will be on your way soon.</p>
{:else}
  <div class="signup-actions">
    <input type="email" placeholder="Your email address" bind:value={form.email} />
    <button class="btn" onclick={() => form.post("/users")}>Sign up</button>
  </div>
{/if}


<style>
  .meter-wrap {
    position: relative;
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
    top: 1.75rem;
    color: #c4b5fd;
    font-weight: 700;
    white-space: nowrap;
    transform: translateX(0%);
  }
  h1 {
    font-size: 1.4rem;
    font-weight: bold;
  }
  h2 {
    margin-top: 2rem;
    font-size: 1.2rem;
    font-weight: bold;
  }
  .signup-actions {
    display: flex;
    justify-content: flex-start;
    gap: 0.75rem;
    margin-top: 0.5rem;
  }
  .btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.5rem 1rem;
    background-color: #4f46e5;
    color: white;
    border: none;
    border-radius: 0.375rem;
    cursor: pointer;
    font: inherit;
    font-weight: 700;
  }
  input {
    box-sizing: border-box;
    padding: 0.5rem;
    border: 1px solid #d1d5db;
    border-radius: 0.375rem;
    width: 100%;
    max-width: 320px;
  }

  @media (max-width: 480px) {
    .signup-actions {
      flex-direction: column;
    }
    input {
      max-width: none;
    }
  }
</style>