<script>
  import tippy from 'tippy.js'

  const { deposit } = $props()

  function pendingTooltip(node) {
    const tooltip = tippy(node, { content: 'Awaiting network confirmations' })
    return { destroy: () => tooltip.destroy() }
  }
</script>

<div class:pending={!deposit['confirmed?']}>
  <p class="font-bold">+{deposit.amount}</p>
  {#if !deposit['confirmed?']}
    <!-- svelte-ignore a11y_no_noninteractive_tabindex (Allow keyboard users to focus the tooltip.) -->
    <p class="flex items-center gap-1" role="img" aria-label="Awaiting network confirmations" tabindex="0" use:pendingTooltip>
      <span class="i-bitcoin-icons:clock-outline" aria-hidden="true"></span>
      arriving soon
    </p>
  {/if}
</div>

<style>
  .pending {
    opacity: 0.5;
  }
</style>
