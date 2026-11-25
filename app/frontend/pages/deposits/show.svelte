<script>
  const { deposit, wallet, confirmations_needed } = $props()
  import { formatDate } from '~/lib/utils.js'
  import DepositAmount from '~/lib/DepositAmount.svelte'
  import { deposits } from '~/lib/stores.svelte.js'

  const currentDeposit = $derived($deposits.find((item) => item.id === deposit.id) ?? deposit)
</script>

<section>

  <div class="flex flex-col items-center">
    {#if deposit.asset.icon?.url}
      <img src={deposit.asset.icon.url} class="h-10" alt="" />
    {/if}
    <p class="mt-2">{deposit.asset.name}</p>
    <p class="text-green text-3xl my-4 text-center"><DepositAmount deposit={currentDeposit} /></p>
    <p class="color-muted">{formatDate(deposit.created_at)}</p>
  </div>
  <div class="card mt-4">
    <dl class="deposit-details">
      <div>
        <dt class="color-muted">Transaction hash</dt>
        <dd>{deposit.tx}</dd>
        <a href={deposit.asset.network.explorer_url.replace("%{tx}", deposit.tx)} target="_blank">
          View on explorer
          <span class="i-bitcoin-icons:export-outline" aria-hidden="true"></span>
        </a>
      </div>
      <div>
        <dt class="color-muted">Confirmations</dt>
        <dd class="confirmations">
          {currentDeposit.confirmations}
          / 
          {confirmations_needed}
        </dd>
      </div>
      <div>
        <dt class="color-muted">Receiving wallet address</dt>
        <dd>{wallet.address}</dd>
      </div>
    </dl>
  </div>
</section>

<style>
  .deposit-details {
    display: grid;
    gap: 1rem;
    margin-bottom: 1rem;
  }

  .deposit-details dd {
    overflow-wrap: anywhere;
  }
</style>
