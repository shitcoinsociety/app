<script>
  const { user } = $props();

  const socialNetworks = {
    github: { label: "GitHub", icon: "i-simple-icons-github", url: (handle) => `https://github.com/${handle}` },
    facebook: { label: "Facebook", icon: "i-simple-icons-facebook", url: (handle) => `https://facebook.com/${handle}` },
    instagram: { label: "Instagram", icon: "i-simple-icons-instagram", url: (handle) => `https://instagram.com/${handle}` },
    x: { label: "X", icon: "i-simple-icons-x", url: (handle) => `https://x.com/${handle}` }
  };

  const socialLinks = $derived(
    Object.entries(user.social_links ?? {})
      .filter(([key, value]) => socialNetworks[key] && value)
      .map(([key, value]) => {
        const { label, icon, url } = socialNetworks[key];
        const href = /^https?:\/\//i.test(value) ? value : url(value);

        return { key, label, icon, href };
      })
  );

  function nl2br(text) {
    if (!text) return "";

    return text
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;")
      .replace(/\r\n?/g, "\n")
      .replace(/\n/g, "<br />");
  }
</script>

<svelte:head>
  <title>{user.handle} ({user.name})</title>
</svelte:head>

<div class="flex">
  <img src={user.profile_image.url} alt={user.name} class="profile_image" />
  <div class="relative">
    <h1 class="text-3xl">{user.name}</h1>
    <p>{@html nl2br(user.bio)}</p>
    {#if socialLinks.length}
      <ul class="social-links">
        {#each socialLinks as link (link.key)}
          <li>
            <a
              href={link.href}
              target="_blank"
              rel="noopener noreferrer"
              class="social-link"
            >
              <span class={link.icon} aria-hidden="true"></span>
              {link.label}
            </a>
          </li>
        {/each}
      </ul>
    {/if}
  </div>
</div>

<h2>
  Invest Together with {user.name}
</h2>

<p>
  This page is still under construction. Check back later.
</p>

<style>
  .social-links {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    padding: 0;
    list-style: none;
  }

  .social-link {
    display: inline-flex;
    align-items: center;
    gap: 0.375rem;
    border: 1px solid #333;
    border-radius: 9999px;
    background: rgb(255 255 255 / 5%);
    padding: 0.25rem 0.75rem;
    color: #fff;
    font-size: 0.875rem;
  }

  .social-link:hover {
    background: rgb(255 255 255 / 10%);
  }

  .profile_image {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    margin-right: 1rem;
  }
</style>