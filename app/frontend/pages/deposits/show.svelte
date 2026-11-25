<script>
  const { deposit } = $props()
  import { formatDate } from '~/lib/utils.js'
</script>

<section>

  <div class="flex flex-col items-center">
    <img src={deposit.asset.icon.url} class="h-10"/>
    <p class="mt-2">{deposit.asset.name}</p>
    <p class="text-green text-3xl my-4 font-bold">+{deposit.amount}</p>
    <p class="color-muted">{formatDate(deposit.created_at)}</p>
  </div>
  <div class="card mt-4">
    <a href={deposit.asset.network.explorer_url.replace("%{address}", deposit.tx)} target="_blank" class="color-muted">
      View on explorer
    </a>
  </div>
</section>
