class CreateBalances < ActiveRecord::Migration[8.1]
  def change
    create_table :balances do |t|
      t.decimal :amount, precision: 36, scale: 18
      t.integer :asset_id
      t.integer :user_id
      t.decimal :locked, precision: 36, scale: 18

      t.timestamps
    end
  end
end
