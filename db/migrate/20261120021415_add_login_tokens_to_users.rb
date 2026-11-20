class AddLoginTokensToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :login_token_digest, :string
    add_column :users, :login_token_expires_at, :datetime
    add_index :users, :login_token_digest, unique: true, where: "login_token_digest IS NOT NULL"
  end
end
