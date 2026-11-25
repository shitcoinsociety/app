<script>
  import { balances, currentUserId, deposits } from '~/lib/stores.svelte.js'
  import { formatDate } from '~/lib/utils.js'
  import { modal } from '~/lib/ui'

  const depositsByAsset = $derived.by(() => {
    const grouped = {}
    for (const deposit of $deposits) {
      const assetId = deposit.asset.id
      if (!grouped[assetId]) grouped[assetId] = []
      grouped[assetId].push(deposit)
    }
    return grouped
  })
</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>

<section>
  {#if $currentUserId}
  {#each $balances as balance}
    <div class="balance pt-4">
      <p class="text-center">{balance.asset.name}</p>
      <p class="text-center text-4xl font-bold">{balance.amount}</p>
      <div class="flex mt-8 p-6">
        <a class="inline-flex flex-col items-center" href="/deposits/new?asset_id={balance.asset.id}" use:modal>
          <div class="btn round">
            <div class="i-bitcoin-icons:receive-outline text-4xl"></div>
          </div>
          <div class="color-text text-sm mt-1">Deposit</div>
        </a>
      </div>
    </div>
    <div class="card mt-4">
      {#each depositsByAsset[balance.asset.id] ?? [] as deposit}
        <a href="/deposits/{deposit.id}" use:modal class="flex color-text items-center gap-4">
          <img src={deposit.asset.icon.url} class="h-10"/>
          <div class="grow">
            <p>{deposit.asset.name}</p>
            <p class="color-muted">{formatDate(deposit.created_at)}</p>
          </div>
          <p class="text-green">+{deposit.amount}</p>
        </a>
      {:else}
        No recent activity.
      {/each}
    </div>
  {/each}
  {:else}
    <p>Please log in to view your balances.</p>
  {/if}
</section>

<style>

.btn.round {
  border-radius: 99rem;
  aspect-ratio: 1 / 1;
  cursor: pointer;
  padding: 0.5rem;
}
</style>