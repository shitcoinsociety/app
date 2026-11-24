<script>
  const { user } = $props();
</script>

<article class="card user-card">
  {#if user.profile_image?.url}
    <img class="user-card-avatar" src={user.profile_image.url} alt="" loading="lazy" />
  {:else}
    <div class="user-card-avatar user-card-avatar-placeholder" aria-hidden="true">
      {user.name?.charAt(0)?.toUpperCase() || "?"}
    </div>
  {/if}

  <div class="user-card-body">
    <h3 class="user-card-name">
      <a class="user-card-link" href={`/users/${user.id}`}>{user.name}</a>
    </h3>
    {#if user.handle}
      <p class="user-card-handle">@{user.handle}</p>
    {/if}
    {#if user.description}
      <p class="user-card-description">{user.description}</p>
    {/if}
  </div>
</article>

<style>
  .user-card {
    position: relative;
    display: flex;
    align-items: flex-start;
    gap: 1rem;
    transition: background 150ms ease;
  }

  .user-card:hover {
    background: #2b2a2c;
  }

  .user-card-avatar {
    flex: none;
    width: 64px;
    height: 64px;
    border-radius: 50%;
    object-fit: cover;
  }

  .user-card-avatar-placeholder {
    display: grid;
    place-items: center;
    background: var(--color-accent);
    color: var(--color-text);
    font-size: 1.5rem;
    font-weight: bold;
  }

  .user-card-body {
    min-width: 0;
  }

  .user-card-name {
    margin: 0;
    font-size: 1.1rem;
  }

  .user-card-link {
    color: inherit;
  }

  /* Stretch the profile link over the whole card without nesting interactive elements. */
  .user-card-link::after {
    content: "";
    position: absolute;
    inset: 0;
    z-index: 1;
    border-radius: inherit;
  }

  .user-card-link:hover {
    text-decoration: none;
  }

  .user-card-link:focus-visible {
    outline: none;
  }

  .user-card-link:focus-visible::after {
    outline: 2px solid var(--color-accent-soft);
    outline-offset: 2px;
  }

  .user-card-handle {
    margin: 0.125rem 0 0;
    color: var(--color-muted);
    font-size: 0.875rem;
  }

  .user-card-description {
    display: -webkit-box;
    overflow: hidden;
    margin: 0.5rem 0 0;
    color: var(--color-muted);
    -webkit-line-clamp: 3;
    line-clamp: 3;
    -webkit-box-orient: vertical;
  }

  .user-card-socials {
    position: relative;
    z-index: 2;
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    margin: 0.75rem 0 0;
    padding: 0;
    list-style: none;
  }

  .user-card-socials a {
    display: grid;
    place-items: center;
    width: 2rem;
    height: 2rem;
    border: 1px solid var(--color-border);
    border-radius: 50%;
    color: var(--color-text);
  }

  .user-card-socials a:hover {
    background: rgb(255 255 255 / 10%);
  }
</style>
