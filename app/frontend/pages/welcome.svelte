<script>
  const moonImage = '/tothemoon.jpg'
  const brandLogo = '/favicon.png'
  let signupMessage = $state('')

  function handleSignup(event) {
    event.preventDefault()
    signupMessage = "The list isn't open yet, so your email hasn't been saved."
  }
</script>

<svelte:head>
  <title>Shitcoin Society</title>
</svelte:head>

<h1>Join a community that creates the future. Day by day.</h1>

<p>
  The Shitcoin Society is an open-source, crypto-native MLM community developing its very own decentralized ledger platform.
  Everybody is welcome to join.
</p>

<p>Visit our <a href="https://github.com/shitcoinsociety">GitHub organization</a> for more information and an overview of our repositories.</p>

<style>
  h1 {
    font-size: 2rem;
    font-weight: bold;
  }
</style>