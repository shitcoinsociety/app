import Dexie from 'dexie'

const db = new Dexie("shitcoinsociety");

db.version(1).stores({
  users: "id",
  balances: "id, user_id, asset_id",
})

export default db