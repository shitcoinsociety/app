<script>
  import UserCard from '~/lib/UserCard.svelte'

  const { users } = $props()
</script>

<section>
  <h2>Meet our degens</h2>
  <p class="mb-4">An almanac of fame and honor</p>

  <ul class="user-grid">
    {#each users as user (user.id)}
      <li>
        <UserCard {user} />
      </li>
    {/each}
    <li>
      <a class="card signup-card" href="/users/new">
        <span class="i-lucide:plus signup-card-plus" aria-hidden="true"></span>
        <span>Sign up to become degen #{users.length + 1}</span>
      </a>
    </li>
  </ul>
</section>

<style>
  .user-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 1rem;
    margin: 0;
    padding: 0;
    list-style: none;
  }

  .user-grid > li {
    display: flex;
  }

  .user-grid :global(.user-card) {
    flex: 1;
  }

  .signup-card {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    border: 1px dashed var(--color-border);
    background: transparent;
    color: var(--color-muted);
    text-align: center;
    transition: background 150ms ease, border-color 150ms ease, color 150ms ease;
  }

  .signup-card:hover {
    color: var(--color-text);
    border-color: var(--color-accent);
    background: rgb(255 255 255 / 5%);
    text-decoration: none;
  }

  .signup-card-plus {
    font-size: 2rem;
  }
</style>