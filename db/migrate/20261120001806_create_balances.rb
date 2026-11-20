class CreateBalances < ActiveRecord::Migration[8.1]
  def change
    create_table :balances do |t|
      t.decimal :amount
      t.integer :asset_id
      t.integer :user_id
      t.decimal :locked

      t.timestamps
    end
  end
end
