<script>
  import "./default.css"
  const { children } = $props()
</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>

<header class="container pt-6 pb-2">
  <a class="supersonic" href="/">
    <h1 class="text-4xl">Shitcoin Society</h1>
  </a>
</header>

<main class="container">
  <div class="mt-4">
    {@render children()}
  </div>
</main>

<footer class="container py-4">
  &copy; {new Date().getFullYear()} Shitcoin Society 
  &middot;
  <a href="https://youtube.com/@shitcoinsociety" target="_blank" rel="noopener noreferrer">YouTube</a>
  &middot;
  <a href="https://github.com/shitcoinsociety" target="_blank" rel="noopener noreferrer">GitHub</a>
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