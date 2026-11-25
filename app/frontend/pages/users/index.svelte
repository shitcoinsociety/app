<script>
  import UserCard from '~/lib/UserCard.svelte'
  import { Link } from 'inertiax-svelte'

  const { users, next_cursor, user_count } = $props()
  let loading = $state(false)
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
        <span>Sign up to become degen #{user_count + 1}</span>
      </a>
    </li>
  </ul>

  {#if next_cursor}
    <div class="load-more">
      <Link
        as="button"
        class="btn"
        href={`/users?after=${next_cursor}`}
        only={['users', 'next_cursor', 'user_count']}
        preserveScroll
        preserveState
        preserveUrl
        disabled={loading}
        onstart={() => loading = true}
        onfinish={() => loading = false}
      >
        {loading ? 'Loading…' : 'Load more'}
      </Link>
    </div>
  {/if}
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

  .load-more {
    margin-top: 1.5rem;
    text-align: center;
  }
</style>