<script>
  import "./default.css"
  const { children } = $props()
</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>

<header>
  <div class="pt-12 container supersonic">
    <h1 class="text-4xl">Shitcoin Society</h1>
  </div>
</header>

<main>
  <div class="container ">
    {@render children()}
  </div>
</main>

<footer>
  <div class="container py-4">
    &copy; {new Date().getFullYear()} Shitcoin Society. All rights reserved. <br />
    <a href="/genesis.json" target="_blank" rel="noopener noreferrer">Download genesis.json</a>
  </div>
</footer>


<style>
  @font-face {
    font-family: "SuperSonic";
    src: url("/fonts/supersonic_rocketship.ttf") format("truetype");
  }

  .supersonic {
    font-family: "SuperSonic", sans-serif;
  }
</style>