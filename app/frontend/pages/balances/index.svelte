<script>
  import { balances, currentUserId } from '~/lib/stores.svelte.js'
  import { modal } from '~/lib/ui'
</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>

<h2>Balances</h2>
{#if $currentUserId}
  {#each $balances as balance}
    <div class="card">
      <p>{balance.asset.symbol}: {balance.amount}</p>
      <div class="flex">
        <a class="btn round" href="/deposits/new?asset_id={balance.asset.id}" use:modal>
          <div class="i-bitcoin-icons:receive-outline text-4xl"></div>
        </a>
      </div>
    </div>
  {:else}
    <p>Loading...</p>
  {/each}
{:else}
  <p>Please log in to view your balances.</p>
{/if}

<style>

.btn.round {
  border-radius: 99rem;
  aspect-ratio: 1 / 1;
  cursor: pointer;
  padding: 0.5rem;
}
</style>