<script>
  import { balances, currentUserId } from '~/lib/stores.svelte.js'
</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>

<h2>Balances</h2>
{#if $currentUserId}
  {#each $balances as balance}
    <p>{balance.asset.symbol}: {balance.amount}</p>
  {:else}
    <p>Loading...</p>
  {/each}
{:else}
  <p>Please log in to view your balances.</p>
{/if}