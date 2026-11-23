<script>
  import QRCode from "qrcode"
  const { wallet, asset } = $props()

  let qrCode = $state()
  let copied = $state(false)

  $effect(() => {
    QRCode.toDataURL(wallet.address, { width: 512, margin: 1 })
      .then((url) => (qrCode = url))
      .catch((error) => console.error("Could not draw the address as a QR code", error))
  })

  async function copyAddress() {
    try {
      await navigator.clipboard.writeText(wallet.address)
      copied = true
      setTimeout(() => (copied = false), 1500)
    } catch (error) {
      console.error("Could not copy the address", error)
    }
  }
</script>

<nav>
  Deposit {asset.name}
</nav>

<section>

  <p>
    Your deposit address
  </p>
  
  
  <code class="address" title={wallet.address}>{wallet.address}</code>
  
  <button class="btn w-full" type="button" onclick={copyAddress}>
    {copied ? "Copied!" : "Copy address"}
  </button>

  {#if qrCode}
  <img class="qr" src={qrCode} alt="QR code of the deposit address" />
  {/if}

</section>

<style>
   .qr {
    width: 100%;
    max-width: 220px;
    height: auto;
    background: #ffffff;
    border-radius: 12px;
    padding: 8px;
  }

  .address {
    /* Show as much of the address as fits, the rest is one copy away. */
    display: block;
    max-width: 100%;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    font-family: monospace;
    font-size: 14px;
  }

</style>