<script>
  import { balances, currentUserId } from '~/lib/stores.svelte.js'
</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>

<h2>Balances</h2>
{#each $balances as balance}
  
{:else}
  <p>Please sign in to view your balances.</p>
{/each}
