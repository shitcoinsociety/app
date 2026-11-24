<script>
  import { socialLinksFor } from "~/lib/social-links.js";

  const { user } = $props();

  const socialLinks = $derived(socialLinksFor(user));

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

<section>
  <div class="flex">
    <img src={user.profile_image.url} alt={user.name} class="profile_image" />
    <div class="relative">
      <h1 class="text-3xl">{user.name}</h1>
      <p>{@html nl2br(user.description)}</p>
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
</section>

<section>
<p class="mt-4">
  This page is still under construction. Check back later.
</p>


</section>

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