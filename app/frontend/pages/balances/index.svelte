<script>
  import { balances, currentUserId } from '~/lib/stores.svelte.js'
</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>

<h2>Balances</h2>
{#if $currentUserId}
  {#each $balances as balance}
    
  {:else}
    <p>Under construction. Please check back later.</p>
  {/each}
{:else}
  <p>Please log in to view your balances.</p>
{/if}