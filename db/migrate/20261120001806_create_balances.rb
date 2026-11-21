class CreateBalances < ActiveRecord::Migration[8.1]
  def change
    create_table :balances do |t|
      t.decimal :amount, default: 0, precision: 36, scale: 18
      t.integer :asset_id
      t.integer :user_id
      t.decimal :locked, default: 0, precision: 36, scale: 18

      t.timestamps
    end
  end
end
