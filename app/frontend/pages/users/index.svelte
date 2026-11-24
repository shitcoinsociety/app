<script>
  import UserCard from '~/lib/UserCard.svelte'

  const { users } = $props()
</script>

<section>
  <h2>Meet our degens</h2>
  <p class="mb-4">An almanac of fame and honor</p>

  {#if users.length}
    <ul class="user-grid">
      {#each users as user (user.id)}
        <li>
          <UserCard {user} />
        </li>
      {/each}
    </ul>
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
</style>