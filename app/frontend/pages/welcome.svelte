<script>
  const { ico_progress = 0} = $props()
</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>


<img src={"/tothemoon.jpg"} alt="To the moon" class="mt-4" />

<p class="mt-4">
  The Shitcoin Society is a crypto-native <a href="https://github.com/shitcoinsociety" target="_blank" rel="noopener noreferrer">open source</a> investment platform developing its very own decentralized ledger technology.
  Everybody is welcome to join. We have coconuts and drum n bass.
</p>

<h2>Launch progress</h2>
<p>The genesis block is {ico_progress}% complete.
  <a href="/genesis.json" target="_blank" rel="noopener noreferrer">Download snapshot</a>
</p>
<div class="meter-wrap">
  <progress class="progress-meter" value={ico_progress} max="100" aria-label="Genesis block completion">
    {ico_progress}%
  </progress>
  <span class="progress-marker" style={`left: ${ico_progress}%`} aria-hidden="true"></span>
  <span class="progress-current" style={`left: ${ico_progress}%`}>{ico_progress}%</span>
</div>

<style>
  .meter-wrap {
    position: relative;
    padding-bottom: 2rem;
    margin-top: 1rem;
  }
  .progress-meter {
    display: block;
    width: 100%;
    height: 1.25rem;
    margin: 0;
    overflow: hidden;
    appearance: none;
    background: #393943;
    border: 0;
    border-radius: 999px;
  }
  .progress-meter::-webkit-progress-bar {
    background: #393943;
    border-radius: 999px;
  }
  .progress-meter::-webkit-progress-value {
    background: linear-gradient(90deg, #6366f1, #c084fc);
    border-radius: 999px;
    transition: width 300ms ease;
  }
  .progress-meter::-moz-progress-bar {
    background: linear-gradient(90deg, #6366f1, #c084fc);
    border-radius: 999px;
  }
  .progress-marker {
    position: absolute;
    top: 0.625rem;
    width: 1rem;
    height: 1rem;
    box-sizing: border-box;
    background: white;
    border: 3px solid #a78bfa;
    border-radius: 50%;
    transform: translate(0%, -50%);
  }
  .progress-current {
    position: absolute;
    top: 1.75rem;
    color: #c4b5fd;
    font-weight: 700;
    white-space: nowrap;
    transform: translateX(0%);
  }
</style>