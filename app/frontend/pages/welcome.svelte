<script>
  import { useForm } from 'inertiax-svelte'

  const form = useForm({ email: "" })

  const { signedup } = $props()

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

<h1>Creating the future that works for everyone. Day by day.</h1>
<img src={"/tothemoon.jpg"} alt="To the moon" class="mt-4" />

<p class="mt-4">
  We are an open-source, crypto-native MLM community developing our very own decentralized ledger infrastructure.
  Everybody is welcome to join.
</p>

<p class="mt-4">Visit our <a href="https://github.com/shitcoinsociety">GitHub organization</a> for more information and an overview of our repositories.</p>

<h2>Start your journey - it's free</h2>

{#if signedup}
  <p>Thank you for signing up! We'll send you more information soon.</p>
{:else}
  <input type="email" placeholder="Your email address" bind:value={form.email} />
  <button class="btn mt-2" onclick={() => form.post("/users")}>Sign up</button>
{/if}

<style>
  .btn {
    display: inline-flex;
    align-items: center;
    padding: 0.5rem 1rem;
    background-color: #4f46e5;
    color: white;
    border: none;
    border-radius: 0.375rem;
    cursor: pointer;
  }
  h1 {
    font-size: 1.4rem;
    font-weight: bold;
  }
  h2 {
    margin-top: 1rem;
    font-size: 1.2rem;
    font-weight: bold;
  }
  input {
    padding: 0.5rem;
    border: 1px solid #d1d5db;
    border-radius: 0.375rem;
    width: 100%;
    max-width: 300px;
  }
</style>