<script>
  import "./default.css"
  const { children } = $props()
</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>

<header>
  <div class="p-4 supersonic">
    <h1 class="text-3xl">Shitcoin Society</h1>
  </div>
</header>

<main class="container">
  <div class="mt-4">
    {@render children()}
  </div>
</main>

<footer class="container p-4">
  &copy; {new Date().getFullYear()} Shitcoin Society. All rights reserved. <br />
  <a href="/genesis.json" target="_blank" rel="noopener noreferrer">Download genesis.json</a>
</footer>


<style>
  @font-face {
    font-family: "SuperSonic";
    src: url("/fonts/supersonic_rocketship.ttf") format("truetype");
  }

  header {
    border-bottom: 1px solid var(--color-border);
  }

  .supersonic {
    font-family: "SuperSonic", sans-serif;
  }
</style>